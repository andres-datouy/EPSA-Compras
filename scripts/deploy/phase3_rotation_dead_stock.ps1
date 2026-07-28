# Phase 3: Inventory Rotation and Dead Stock Measures
# Add 6 new measures:
# - Rotacion Inventario (turnover ratio)
# - Dias Sin Consumo (days since last consumption)
# - Stock Valor Total USD (total inventory value)
# - Stock Muerto USD (dead stock value)
# - Articulos Stock Muerto (dead stock count)
# - % Stock Muerto sobre Total (dead stock % of total)

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

    # 1. Dias Sin Consumo
    $m1 = "Dias Sin Consumo"
    $ex1 = $tblConsumo.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = @"
DATEDIFF([Ultima Fecha Consumo], TODAY(), DAY)
"@
        $newM.FormatString = "0"
        $newM.Description = "Dias transcurridos desde la ultima fecha de consumo hasta hoy. Util para detectar stock muerto."
        $tblConsumo.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # --- Medidas_Stock ---

    # 2. Rotacion Inventario
    $m2 = "Rotacion Inventario"
    $ex2 = $tblStock.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
        $newM.Expression = @"
DIVIDE([Consumo Anual Cantidad], [Stock Existencia])
"@
        $newM.FormatString = "0.00"
        $newM.Description = "Indice de rotacion = consumo anual / stock actual. Mayor = mas rapida rotacion."
        $tblStock.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. Stock Valor Total USD
    $m3 = "Stock Valor Total USD"
    $ex3 = $tblStock.Measures | Where-Object { $_.Name -eq $m3 }
    if (-not $ex3) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m3
        $newM.Expression = @"
SUMX(
    factStockEPSA,
    factStockEPSA[Stock Cantidad] *
    CALCULATE(
        AVERAGE(factRecepcionesHistoria[OC PrecioUSD]),
        TOPN(1, factRecepcionesHistoria, factRecepcionesHistoria[RecepcionFecha], DESC)
    )
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Valor total del stock en USD usando el ultimo precio de compra conocido por articulo."
        $tblStock.Measures.Add($newM)
        $output += "3. ADDED: [$m3]"
    } else {
        $output += "3. SKIP: [$m3] already exists"
    }

    # 4. Articulos Stock Muerto
    $m4 = "Articulos Stock Muerto"
    $ex4 = $tblStock.Measures | Where-Object { $_.Name -eq $m4 }
    if (-not $ex4) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m4
        $newM.Expression = @"
VAR DiasLimite = 180
RETURN
COUNTX(
    FILTER(
        VALUES(dimArticulo[Artículo Código]),
        [Stock Existencia] > 0 && (ISBLANK([Ultima Fecha Consumo]) || [Dias Sin Consumo] > DiasLimite)
    ),
    dimArticulo[Artículo Código]
)
"@
        $newM.FormatString = "0"
        $newM.Description = "Cantidad de articulos con stock pero sin consumo en mas de 180 dias. Stock muerto potencial."
        $tblStock.Measures.Add($newM)
        $output += "4. ADDED: [$m4]"
    } else {
        $output += "4. SKIP: [$m4] already exists"
    }

    # 5. Stock Muerto USD
    $m5 = "Stock Muerto USD"
    $ex5 = $tblStock.Measures | Where-Object { $_.Name -eq $m5 }
    if (-not $ex5) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m5
        $newM.Expression = @"
VAR DiasLimite = 180
RETURN
SUMX(
    FILTER(
        VALUES(dimArticulo[Artículo Código]),
        [Stock Existencia] > 0 && (ISBLANK([Ultima Fecha Consumo]) || [Dias Sin Consumo] > DiasLimite)
    ),
    [Stock Existencia] *
    CALCULATE(
        AVERAGE(factRecepcionesHistoria[OC PrecioUSD]),
        TOPN(1, factRecepcionesHistoria, factRecepcionesHistoria[RecepcionFecha], DESC)
    )
)
"@
        $newM.FormatString = "$#,0.00"
        $newM.Description = "Valor en USD del stock muerto (articulos con stock pero sin consumo > 180 dias)."
        $tblStock.Measures.Add($newM)
        $output += "5. ADDED: [$m5]"
    } else {
        $output += "5. SKIP: [$m5] already exists"
    }

    # 6. % Stock Muerto sobre Total
    $m6 = "% Stock Muerto sobre Total"
    $ex6 = $tblStock.Measures | Where-Object { $_.Name -eq $m6 }
    if (-not $ex6) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m6
        $newM.Expression = @"
DIVIDE([Stock Muerto USD], [Stock Valor Total USD])
"@
        $newM.FormatString = "0.0%"
        $newM.Description = "Porcentaje del valor total del inventario que corresponde a stock muerto."
        $tblStock.Measures.Add($newM)
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
