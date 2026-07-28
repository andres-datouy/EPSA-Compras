# Phase 6: Spending Forecast Measures
# Add 5 new measures:
# - Gasto Mensual USD (monthly spend)
# - Gasto Promedio Mensual USD (avg monthly spend)
# - Gasto YTD USD (YTD spend - alias for Compras Totales USD YTD)
# - Costo Unitario Promedio USD (avg unit cost)
# - Gasto Proyectado Mes (projected next month spend)

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

    # 1. Gasto Mensual USD (already have Gasto Recepciones USD, this is for monthly context)
    # This is essentially the same as Gasto Recepciones USD but used in monthly visual context
    # Let's create Gasto Promedio Mensual USD directly

    # 1. Gasto Promedio Mensual USD
    $m1 = "Gasto Promedio Mensual USD"
    $ex1 = $tblCompras.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = @"
AVERAGEX(
    VALUES(Calendario[Fiscal Month]),
    [Gasto Recepciones USD]
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Promedio de gasto mensual en USD sobre los meses fiscales presentes en los datos."
        $tblCompras.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # 2. Costo Unitario Promedio USD
    $m2 = "Costo Unitario Promedio USD"
    $ex2 = $tblCompras.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
        $newM.Expression = @"
DIVIDE(
    [Gasto Recepciones USD],
    SUM(factRecepcionesHistoria[RecepcionCantidad])
)
"@
        $newM.FormatString = "$#,0.0000"
        $newM.Description = "Costo unitario promedio ponderado en USD. Gasto total / cantidad total recibida."
        $tblCompras.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. Gasto Proyectado Mes
    $m3 = "Gasto Proyectado Mes"
    $ex3 = $tblCompras.Measures | Where-Object { $_.Name -eq $m3 }
    if (-not $ex3) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m3
        $newM.Expression = @"
VAR PromedioMensual = [Gasto Promedio Mensual USD]
VAR Tendencia =
    VAR UltimoMes = [Gasto Recepciones USD]
    RETURN IF(NOT ISBLANK(UltimoMes), DIVIDE(UltimoMes - PromedioMensual, PromedioMensual), 0)
RETURN
PromedioMensual * (1 + Tendencia * 0.5)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Proyeccion de gasto para el proximo mes basada en promedio + tendencia suavizada."
        $tblCompras.Measures.Add($newM)
        $output += "3. ADDED: [$m3]"
    } else {
        $output += "3. SKIP: [$m3] already exists"
    }

    # 4. Recepcion Cantidad Total
    $m4 = "Recepcion Cantidad Total"
    $ex4 = $tblCompras.Measures | Where-Object { $_.Name -eq $m4 }
    if (-not $ex4) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m4
        $newM.Expression = @"
SUM(factRecepcionesHistoria[RecepcionCantidad])
"@
        $newM.FormatString = "#,0.00"
        $newM.Description = "Cantidad total recibida en recepciones. Base para calculo de costo unitario."
        $tblCompras.Measures.Add($newM)
        $output += "4. ADDED: [$m4]"
    } else {
        $output += "4. SKIP: [$m4] already exists"
    }

    # 5. Ticket Promedio USD
    $m5 = "Ticket Promedio USD"
    $ex5 = $tblCompras.Measures | Where-Object { $_.Name -eq $m5 }
    if (-not $ex5) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m5
        $newM.Expression = @"
DIVIDE([Gasto Recepciones USD], [Cantidad Recepciones])
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Valor promedio por recepcion en USD. Indicador de eficiencia de compras."
        $tblCompras.Measures.Add($newM)
        $output += "5. ADDED: [$m5]"
    } else {
        $output += "5. SKIP: [$m5] already exists"
    }

    $model.SaveChanges()
    $output += "`nSaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
