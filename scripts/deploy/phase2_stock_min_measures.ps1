# Phase 2: Stock Minimum Control Measures
# Add 5 new measures for stock minimum monitoring:
# - Articulos Debajo Minimo (count below SM)
# - Total Articulos Activos (active catalog)
# - % Articulos Debajo Minimo
# - Brecha Stock Minimo USD (investment needed)
# - Articulos Sin SM Configurado (need SM setup)

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

    # --- Medidas_Stock ---

    # 1. Articulos Debajo Minimo
    $m1 = "Articulos Debajo Minimo"
    $ex1 = $tblStock.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = @"
COUNTX(
    FILTER(VALUES(dimArticulo[Artículo Código]), [Gap Stock] < 0),
    dimArticulo[Artículo Código]
)
"@
        $newM.FormatString = "0"
        $newM.Description = "Cantidad de articulos cuyo stock actual esta por debajo del stock minimo definido."
        $tblStock.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # 2. Total Articulos Activos
    $m2 = "Total Articulos Activos"
    $ex2 = $tblStock.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
        $newM.Expression = @"
CALCULATE(
    DISTINCTCOUNT(factConsumoHistoria[Consumo Artículo Código]),
    DATESINPERIOD(Calendario[Fecha], MAX(Calendario[Fecha]), -12, MONTH)
)
"@
        $newM.FormatString = "0"
        $newM.Description = "Cantidad de articulos distintos con consumo en los ultimos 12 meses. Catalogo activo."
        $tblStock.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. % Articulos Debajo Minimo
    $m3 = "% Articulos Debajo Minimo"
    $ex3 = $tblStock.Measures | Where-Object { $_.Name -eq $m3 }
    if (-not $ex3) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m3
        $newM.Expression = @"
DIVIDE([Articulos Debajo Minimo], [Total Articulos Activos])
"@
        $newM.FormatString = "0.0%"
        $newM.Description = "Porcentaje del catalogo activo que se encuentra por debajo del stock minimo."
        $tblStock.Measures.Add($newM)
        $output += "3. ADDED: [$m3]"
    } else {
        $output += "3. SKIP: [$m3] already exists"
    }

    # 4. Brecha Stock Minimo USD
    $m4 = "Brecha Stock Minimo USD"
    $ex4 = $tblStock.Measures | Where-Object { $_.Name -eq $m4 }
    if (-not $ex4) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m4
        $newM.Expression = @"
SUMX(
    FILTER(VALUES(dimArticulo[Artículo Código]), [Gap Stock] < 0),
    ABS([Gap Stock]) *
    CALCULATE(
        AVERAGE(factRecepcionesHistoria[OC PrecioUSD]),
        TOPN(1, factRecepcionesHistoria, factRecepcionesHistoria[RecepcionFecha], DESC)
    )
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Inversion estimada en USD necesaria para llevar todos los articulos por debajo del minimo hasta su nivel de stock minimo. Usa ultimo precio USD."
        $tblStock.Measures.Add($newM)
        $output += "4. ADDED: [$m4]"
    } else {
        $output += "4. SKIP: [$m4] already exists"
    }

    # 5. Articulos Sin SM Configurado
    $m5 = "Articulos Sin SM Configurado"
    $ex5 = $tblConsumo.Measures | Where-Object { $_.Name -eq $m5 }
    if (-not $ex5) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m5
        $newM.Expression = @"
COUNTX(
    FILTER(
        VALUES(dimArticulo[Artículo Código]),
        (ISBLANK([Stock Mínimo]) || [Stock Mínimo] = 0) && [Consumo Cantidad] > 0
    ),
    dimArticulo[Artículo Código]
)
"@
        $newM.FormatString = "0"
        $newM.Description = "Articulos con consumo pero sin stock minimo configurado. Requieren definicion de SM."
        $tblConsumo.Measures.Add($newM)
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
