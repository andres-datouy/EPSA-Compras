# Dual Lead Time Implementation:
# 1. Rename "Compra Fecha Inicio Proceso" -> "Compra Fecha Inicio Proceso Interno Desde Solicitud"
# 2. Add new column "Compra Fecha Inicio Proceso Con Proveedor" = MIN(OC Fecha, Compra Fecha)
# 3. Update "Lead Time Dias" to reference "Con Proveedor"
# 4. Add measure "Lead Time Proceso Interno Dias"
# 5. Add factComprasEnProceso measures: Dias Transcurridos, Dias Hasta Entrega

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tblRecep = $model.Tables | Where-Object { $_.Name -eq "factRecepcionesHistoria" }
    $tblCP = $model.Tables | Where-Object { $_.Name -eq "factComprasEnProceso" }

    # 1. Rename existing column
    $col = $tblRecep.Columns | Where-Object { $_.Name -eq "Compra Fecha Inicio Proceso" }
    if ($col) {
        $col.Name = "Compra Fecha Inicio Proceso Interno Desde Solicitud"
        $output += "1. RENAMED column -> Compra Fecha Inicio Proceso Interno Desde Solicitud"
    } else {
        $output += "1. SKIP: column already renamed or not found"
    }

    # 2. Add new calculated column "Compra Fecha Inicio Proceso Con Proveedor"
    $newColName = "Compra Fecha Inicio Proceso Con Proveedor"
    $existingNewCol = $tblRecep.Columns | Where-Object { $_.Name -eq $newColName }
    if (-not $existingNewCol) {
        $newCol = New-Object Microsoft.AnalysisServices.Tabular.CalculatedColumn
        $newCol.Name = $newColName
        $newCol.DataType = [Microsoft.AnalysisServices.Tabular.DataType]::DateTime
        $newCol.Expression = @"
VAR FechaMin =
    MINX(
        {
            factRecepcionesHistoria[OC Fecha],
            factRecepcionesHistoria[Compra Fecha]
        },
        [Value]
    )
RETURN
    FechaMin
"@
        $newCol.FormatString = "dd/MM/yyyy"
        $tblRecep.Columns.Add($newCol)
        $output += "2. ADDED column: $newColName"
    } else {
        $output += "2. SKIP: $newColName already exists"
    }

    # 3. Update "Lead Time Dias" to reference "Con Proveedor"
    $ltCol = $tblRecep.Columns | Where-Object { $_.Name -eq "Lead Time Dias" }
    if ($ltCol) {
        $ltCol.Expression = @"
VAR FechaInicio = factRecepcionesHistoria[Compra Fecha Inicio Proceso Con Proveedor]
VAR FechaRecepcion = factRecepcionesHistoria[RecepcionFecha]
RETURN
IF(
    NOT ISBLANK ( FechaInicio ) && NOT ISBLANK ( FechaRecepcion ),
    DATEDIFF ( FechaInicio, FechaRecepcion, DAY )
)
"@
        $output += "3. UPDATED Lead Time Dias -> uses Compra Fecha Inicio Proceso Con Proveedor"
    } else {
        $output += "3. SKIP: Lead Time Dias column not found"
    }

    # 4. Add measure "Lead Time Proceso Interno Dias" in Medidas_Compras
    $tblMedidas = $model.Tables | Where-Object { $_.Name -eq "Medidas_Compras" }
    $mName4 = "Lead Time Proceso Interno Dias"
    $existing4 = $tblMedidas.Measures | Where-Object { $_.Name -eq $mName4 }
    if (-not $existing4) {
        $m4 = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m4.Name = $mName4
        $m4.Expression = @"
AVERAGEX(
    factRecepcionesHistoria,
    VAR FechaInicio = factRecepcionesHistoria[Compra Fecha Inicio Proceso Interno Desde Solicitud]
    VAR FechaRecepcion = factRecepcionesHistoria[RecepcionFecha]
    RETURN IF(NOT ISBLANK(FechaInicio) && NOT ISBLANK(FechaRecepcion), DATEDIFF(FechaInicio, FechaRecepcion, DAY))
)
"@
        $m4.FormatString = "0"
        $m4.Description = "Promedio de dias desde solicitud interna hasta recepcion. Lead time total del proceso de compras interno."
        $tblMedidas.Measures.Add($m4)
        $output += "4. ADDED measure: [$mName4]"
    } else {
        $output += "4. SKIP: [$mName4] already exists"
    }

    # 5. Add factComprasEnProceso measures in Medidas_Compras
    # 5a. Dias Transcurridos En Proceso (avg days since OC for pending orders)
    $m5a = "Dias Transcurridos En Proceso Promedio"
    $ex5a = $tblMedidas.Measures | Where-Object { $_.Name -eq $m5a }
    if (-not $ex5a) {
        $newM5a = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM5a.Name = $m5a
        $newM5a.Expression = @"
AVERAGEX(
    factComprasEnProceso,
    VAR FechaOC = factComprasEnProceso[CompraEP Fecha Ultima Modificacion]
    RETURN IF(NOT ISBLANK(FechaOC), DATEDIFF(FechaOC, TODAY(), DAY))
)
"@
        $newM5a.FormatString = "0"
        $newM5a.Description = "Promedio de dias transcurridos desde la fecha de OC para compras aun en proceso sin recepcionar."
        $tblMedidas.Measures.Add($newM5a)
        $output += "5a. ADDED measure: [$m5a]"
    } else {
        $output += "5a. SKIP: [$m5a] already exists"
    }

    # 5b. Dias Hasta Fecha Entrega Promedio (avg days until expected delivery)
    $m5b = "Dias Hasta Fecha Entrega Promedio"
    $ex5b = $tblMedidas.Measures | Where-Object { $_.Name -eq $m5b }
    if (-not $ex5b) {
        $newM5b = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM5b.Name = $m5b
        $newM5b.Expression = @"
AVERAGEX(
    factComprasEnProceso,
    VAR FechaEntrega = factComprasEnProceso[CompraEP Ultima Fecha Entrega]
    RETURN IF(NOT ISBLANK(FechaEntrega), DATEDIFF(TODAY(), FechaEntrega, DAY))
)
"@
        $newM5b.FormatString = "0"
        $newM5b.Description = "Promedio de dias restantes hasta la fecha de entrega esperada. Positivo = aun no vencio. Negativo = vencida."
        $tblMedidas.Measures.Add($newM5b)
        $output += "5b. ADDED measure: [$m5b]"
    } else {
        $output += "5b. SKIP: [$m5b] already exists"
    }

    # 5c. Compras En Proceso Vencidas (count of overdue pending orders)
    $m5c = "Compras En Proceso Vencidas"
    $ex5c = $tblMedidas.Measures | Where-Object { $_.Name -eq $m5c }
    if (-not $ex5c) {
        $newM5c = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM5c.Name = $m5c
        $newM5c.Expression = @"
CALCULATE(
    COUNTROWS(factComprasEnProceso),
    factComprasEnProceso[CompraEP Ultima Fecha Entrega] < TODAY()
)
"@
        $newM5c.FormatString = "0"
        $newM5c.Description = "Cantidad de ordenes de compra en proceso cuya fecha de entrega esperada ya paso."
        $tblMedidas.Measures.Add($newM5c)
        $output += "5c. ADDED measure: [$m5c]"
    } else {
        $output += "5c. SKIP: [$m5c] already exists"
    }

    $model.SaveChanges()
    $output += "`nSaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
