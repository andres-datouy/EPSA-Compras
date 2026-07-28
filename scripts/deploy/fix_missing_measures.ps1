$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    # 1. % Stock Muerto
    $tblStock = $model.Tables | Where-Object { $_.Name -eq "Medidas_Stock" }
    $m1 = "% Stock Muerto"
    $ex1 = $tblStock.Measures | Where-Object { $_.Name -eq $m1 }
    if (-not $ex1) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m1
        $newM.Expression = "DIVIDE([Stock Muerto USD], [Stock Valor Total USD])"
        $newM.FormatString = "0.0%"
        $newM.Description = "Porcentaje del valor total del inventario que corresponde a stock muerto (sin consumo en 180+ dias)."
        $tblStock.Measures.Add($newM)
        $output += "1. ADDED: [$m1]"
    } else {
        $output += "1. SKIP: [$m1] already exists"
    }

    # 2. Valor Stock Existencia USD
    $m2 = "Valor Stock Existencia USD"
    $ex2 = $tblStock.Measures | Where-Object { $_.Name -eq $m2 }
    if (-not $ex2) {
        $newM = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $newM.Name = $m2
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
        $newM.FormatString = "`$#,0.00"
        $newM.Description = "Valor estimado en USD del stock actual. Usa la cantidad en stock x ultimo precio USD conocido."
        $tblStock.Measures.Add($newM)
        $output += "2. ADDED: [$m2]"
    } else {
        $output += "2. SKIP: [$m2] already exists"
    }

    # 3. Check Fiscal Year-Month hierarchy
    $tblCal = $model.Tables | Where-Object { $_.Name -eq "Calendario" }
    $hier = $tblCal.Hierarchies | Where-Object { $_.Name -eq "Fiscal Year-Month" }
    if ($hier) {
        $output += "3. Hierarchy 'Fiscal Year-Month' EXISTS with $($hier.Levels.Count) levels"
        foreach ($lvl in $hier.Levels) {
            $output += "   Level: $($lvl.Name)"
        }
    } else {
        $output += "3. MISSING: Hierarchy 'Fiscal Year-Month'"
        $allHiers = ($tblCal.Hierarchies | ForEach-Object { $_.Name }) -join ", "
        $output += "   Available hierarchies: $allHiers"
    }

    $model.SaveChanges()
    $output += "`nSaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
