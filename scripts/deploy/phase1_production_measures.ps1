# Phase 1: Production Support Measures
# Add 7 new measures for production decision support:
# - Consumo Promedio Diario (daily consumption rate)
# - Dias Cobertura Stock Actual (days of coverage with current stock)
# - Dias Cobertura Necesidad (days of coverage after commitments)
# - Articulos Sin Cobertura Suficiente (articles at risk)
# - Compras En Proceso USD (pending purchases value)
# - Ultima Fecha Consumo (last consumption date - for Phase 3)
# - Consumo Anual Cantidad (annual consumption - for Phase 3)

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tblStock = $model.Tables | Where-Object { $_.Name -eq "Medidas_Stock" }
    $tblConsumo = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    # --- Medidas_Consumo ---

    # 1. Consumo Promedio Diario
    $m1 = "Consumo Promedio Diario"
    $ex1 = $tblConsumo.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = @"
DIVIDE([Consumo Promedio por Mes Activo], 30)
"@
        $newM.FormatString = "#,0.00"
        $newM.Description = "Consumo promedio diario estimado a partir del consumo mensual activo. Base para calculos de cobertura."
        $tblConsumo.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # 2. Ultima Fecha Consumo
    $m2 = "Ultima Fecha Consumo"
    $ex2 = $tblConsumo.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
        $newM.Expression = @"
MAX(factConsumoHistoria[Consumo Fecha])
"@
        $newM.FormatString = "dd/MM/yyyy"
        $newM.Description = "Fecha del ultimo consumo registrado. Util para deteccion de stock muerto."
        $tblConsumo.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. Consumo Anual Cantidad
    $m3 = "Consumo Anual Cantidad"
    $ex3 = $tblConsumo.Measures | Where-Object { $_.Name -eq $m3 }
    if (-not $ex3) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m3
        $newM.Expression = @"
CALCULATE(
    [Sumatoria Movs Consumo Sin Recepciones],
    DATESINPERIOD(Calendario[Fecha], MAX(Calendario[Fecha]), -12, MONTH)
)
"@
        $newM.FormatString = "#,0.00"
        $newM.Description = "Consumo de los ultimos 12 meses. Base para calculo de rotacion de inventario."
        $tblConsumo.Measures.Add($newM)
        $output += "3. ADDED: [$m3]"
    } else {
        $output += "3. SKIP: [$m3] already exists"
    }

    # --- Medidas_Stock ---

    # 4. Dias Cobertura Stock Actual
    $m4 = "Dias Cobertura Stock Actual"
    $ex4 = $tblStock.Measures | Where-Object { $_.Name -eq $m4 }
    if (-not $ex4) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m4
        $newM.Expression = @"
DIVIDE([Stock Existencia], [Consumo Promedio Diario])
"@
        $newM.FormatString = "#,0"
        $newM.Description = "Dias que dura el stock actual al ritmo de consumo promedio diario."
        $tblStock.Measures.Add($newM)
        $output += "4. ADDED: [$m4]"
    } else {
        $output += "4. SKIP: [$m4] already exists"
    }

    # 5. Dias Cobertura Necesidad
    $m5 = "Dias Cobertura Necesidad"
    $ex5 = $tblStock.Measures | Where-Object { $_.Name -eq $m5 }
    if (-not $ex5) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m5
        $newM.Expression = @"
DIVIDE(
    [Stock Existencia] + [Stock Compras] - [Consumo Planificado Cantidad] - [Cantidad Requerida por Demanda Pendiente],
    [Consumo Promedio Diario]
)
"@
        $newM.FormatString = "#,0"
        $newM.Description = "Dias de cobertura despues de descontar consumos comprometidos (planificado + demanda pendiente)."
        $tblStock.Measures.Add($newM)
        $output += "5. ADDED: [$m5]"
    } else {
        $output += "5. SKIP: [$m5] already exists"
    }

    # 6. Articulos Sin Cobertura Suficiente
    $m6 = "Articulos Sin Cobertura Suficiente"
    $ex6 = $tblStock.Measures | Where-Object { $_.Name -eq $m6 }
    if (-not $ex6) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m6
        $newM.Expression = @"
VAR LTMeses = [Lead Time Meses]
RETURN
COUNTX(
    FILTER(
        VALUES(dimArticulo[Articulo Codigo]),
        [Dias Cobertura Necesidad] < LTMeses * 30
    ),
    dimArticulo[Articulo Codigo]
)
"@
        $newM.FormatString = "0"
        $newM.Description = "Cantidad de articulos cuya cobertura es menor al lead time del proveedor. Articulos en riesgo de quiebre de stock."
        $tblStock.Measures.Add($newM)
        $output += "6. ADDED: [$m6]"
    } else {
        $output += "6. SKIP: [$m6] already exists"
    }

    # 7. Compras En Proceso USD
    $m7 = "Compras En Proceso USD"
    $ex7 = $tblStock.Measures | Where-Object { $_.Name -eq $m7 }
    if (-not $ex7) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m7
        $newM.Expression = @"
SUMX(
    factComprasEnProceso,
    VAR Articulo = factComprasEnProceso[CompraEP Articulo Codigo]
    VAR LastPrice =
        CALCULATE(
            AVERAGE(factRecepcionesHistoria[OC PrecioUSD]),
            factRecepcionesHistoria[RecepcionArticulo] = Articulo
        )
    RETURN factComprasEnProceso[CompraEP Cantidad] * LastPrice
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Valor estimado en USD de las compras en proceso. Usa ultimo precio USD conocido del articulo."
        $tblStock.Measures.Add($newM)
        $output += "7. ADDED: [$m7]"
    } else {
        $output += "7. SKIP: [$m7] already exists"
    }

    $model.SaveChanges()
    $output += "`nSaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
