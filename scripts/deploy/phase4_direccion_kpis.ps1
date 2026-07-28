# Phase 4: Direccion KPI Measures
# Add 6 new measures for executive procurement dashboard:
# - Compras Totales USD YTD
# - Compras Totales USD LY
# - Variacion Compras %
# - Proveedor Concentracion %
# - On Time Delivery %
# - Ticket Promedio USD

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tblCompras = $model.Tables | Where-Object { $_.Name -eq "Medidas_Compras" }

    # 1. Gasto Recepciones USD
    $m1 = "Gasto Recepciones USD"
    $ex1 = $tblCompras.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = @"
SUMX(
    factRecepcionesHistoria,
    factRecepcionesHistoria[RecepcionCantidad] * factRecepcionesHistoria[OC PrecioUSD]
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Gasto total en USD de las recepciones. Cantidad recibida x Precio unitario USD."
        $tblCompras.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # 2. Compras Totales USD YTD
    $m2 = "Compras Totales USD YTD"
    $ex2 = $tblCompras.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
        $newM.Expression = @"
CALCULATE(
    [Gasto Recepciones USD],
    DATESYTD(Calendario[Fecha])
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Compras acumuladas en USD del año en curso (Year-to-Date)."
        $tblCompras.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. Compras Totales USD LY
    $m3 = "Compras Totales USD LY"
    $ex3 = $tblCompras.Measures | Where-Object { $_.Name -eq $m3 }
    if (-not $ex3) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m3
        $newM.Expression = @"
CALCULATE(
    [Gasto Recepciones USD],
    SAMEPERIODLASTYEAR(Calendario[Fecha])
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Compras en USD del mismo periodo del año anterior (Last Year). Base de comparacion YoY."
        $tblCompras.Measures.Add($newM)
        $output += "3. ADDED: [$m3]"
    } else {
        $output += "3. SKIP: [$m3] already exists"
    }

    # 4. Variacion Compras %
    $m4 = "Variacion Compras %"
    $ex4 = $tblCompras.Measures | Where-Object { $_.Name -eq $m4 }
    if (-not $ex4) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m4
        $newM.Expression = @"
DIVIDE([Compras Totales USD YTD] - [Compras Totales USD LY], [Compras Totales USD LY])
"@
        $newM.FormatString = "0.0%"
        $newM.Description = "Variacion porcentual de compras YTD vs mismo periodo año anterior."
        $tblCompras.Measures.Add($newM)
        $output += "4. ADDED: [$m4]"
    } else {
        $output += "4. SKIP: [$m4] already exists"
    }

    # 5. Proveedor Concentracion %
    $m5 = "Proveedor Concentracion %"
    $ex5 = $tblCompras.Measures | Where-Object { $_.Name -eq $m5 }
    if (-not $ex5) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m5
        $newM.Expression = @"
VAR TopProveedor =
    MAXX(
        VALUES(dimProveedor[Proveedor Nombre]),
        [Gasto Recepciones USD]
    )
VAR TotalGasto = [Gasto Recepciones USD]
RETURN
DIVIDE(TopProveedor, TotalGasto)
"@
        $newM.FormatString = "0.0%"
        $newM.Description = "Porcentaje de concentracion del proveedor principal sobre el total. Riesgo de dependencia."
        $tblCompras.Measures.Add($newM)
        $output += "5. ADDED: [$m5]"
    } else {
        $output += "5. SKIP: [$m5] already exists"
    }

    # 6. On Time Delivery %
    $m6 = "On Time Delivery %"
    $ex6 = $tblCompras.Measures | Where-Object { $_.Name -eq $m6 }
    if (-not $ex6) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m6
        $newM.Expression = @"
VAR TotalRecep = COUNTROWS(factRecepcionesHistoria)
VAR OnTime =
    COUNTROWS(
        FILTER(
            factRecepcionesHistoria,
            NOT ISBLANK(factRecepcionesHistoria[Lead Time Dias]) &&
            factRecepcionesHistoria[Lead Time Dias] <= factRecepcionesHistoria[plazo]
        )
    )
RETURN
DIVIDE(OnTime, TotalRecep)
"@
        $newM.FormatString = "0.0%"
        $newM.Description = "Porcentaje de recepciones entregadas dentro del plazo acordado. Indicador de confiabilidad del proveedor."
        $tblCompras.Measures.Add($newM)
        $output += "6. ADDED: [$m6]"
    } else {
        $output += "6. SKIP: [$m6] already exists"
    }

    $model.SaveChanges()
    $output += "`nSaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
