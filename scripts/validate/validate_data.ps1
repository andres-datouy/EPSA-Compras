# Comprehensive data validation: SSAS model row counts + measures
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $output = @()
    
    # === DIMENSION TABLE ROW COUNTS ===
    $output += "=== DIMENSIONS ==="
    $dimQueries = @(
        @{ Name = "dimArticulo"; Dax = "EVALUATE ROW(""count"", COUNTROWS(dimArticulo))" }
        @{ Name = "dimProveedor"; Dax = "EVALUATE ROW(""count"", COUNTROWS(dimProveedor))" }
        @{ Name = "Calendario"; Dax = "EVALUATE ROW(""count"", COUNTROWS(Calendario))" }
    )
    foreach ($q in $dimQueries) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $q.Dax
            $r = $cmd.ExecuteReader()
            if ($r.Read()) { $output += "  $($q.Name): $($r[0]) rows" }
            $r.Close()
        } catch { $output += "  $($q.Name): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length)))" }
    }
    
    # === FACT TABLE ROW COUNTS ===
    $output += "`n=== FACTS ==="
    $factQueries = @(
        @{ Name = "factComprasEnProceso"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factComprasEnProceso))" }
        @{ Name = "factConsumoHistoria"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factConsumoHistoria))" }
        @{ Name = "factConsumoPlanificado"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factConsumoPlanificado))" }
        @{ Name = "factDemandaPendientePlanificacion"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factDemandaPendientePlanificacion))" }
        @{ Name = "factRecepcionesHistoria"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factRecepcionesHistoria))" }
        @{ Name = "factStockEPSA"; Dax = "EVALUATE ROW(""count"", COUNTROWS(factStockEPSA))" }
    )
    foreach ($q in $factQueries) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $q.Dax
            $r = $cmd.ExecuteReader()
            if ($r.Read()) { $output += "  $($q.Name): $($r[0]) rows" }
            $r.Close()
        } catch { $output += "  $($q.Name): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length)))" }
    }
    
    # === KEY MEASURES ===
    $output += "`n=== MEASURES ==="
    $measureQueries = @(
        @{ Name = "Stock Existencia"; Dax = "EVALUATE {[Stock Existencia]}" }
        @{ Name = "Stock Compras"; Dax = "EVALUATE {[Stock Compras]}" }
        @{ Name = "Stock Mínimo"; Dax = "EVALUATE {[Stock Mínimo]}" }
        @{ Name = "Sumatoria Consumo"; Dax = "EVALUATE {[Sumatoria Movs Consumo Sin Recepciones]}" }
        @{ Name = "Consumos (count)"; Dax = "EVALUATE {[Consumos]}" }
        @{ Name = "Cobertura Meses"; Dax = "EVALUATE {[Cobertura Meses sobre Existencia]}" }
        @{ Name = "E+C-CP-CD-SM"; Dax = "EVALUATE {[E + C - CP - CD - SM]}" }
        @{ Name = "Gap Stock"; Dax = "EVALUATE {[Gap Stock]}" }
    )
    foreach ($q in $measureQueries) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $q.Dax
            $r = $cmd.ExecuteReader()
            if ($r.Read()) { $output += "  $($q.Name): $($r[0])" }
            $r.Close()
        } catch { $output += "  $($q.Name): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length)))" }
    }
    
    # === DATE RANGE VALIDATION ===
    $output += "`n=== DATE RANGES ==="
    $dateQueries = @(
        @{ Name = "Calendario min date"; Dax = "EVALUATE ROW(""min"", MIN(Calendario[Fecha]))" }
        @{ Name = "Calendario max date"; Dax = "EVALUATE ROW(""max"", MAX(Calendario[Fecha]))" }
        @{ Name = "factConsumo min date"; Dax = "EVALUATE ROW(""min"", MIN(factConsumoHistoria[Consumo Fecha]))" }
        @{ Name = "factConsumo max date"; Dax = "EVALUATE ROW(""max"", MAX(factConsumoHistoria[Consumo Fecha]))" }
        @{ Name = "factStock min date"; Dax = "EVALUATE ROW(""min"", MIN(factStockEPSA[Stock Fecha_Corte]))" }
        @{ Name = "factStock max date"; Dax = "EVALUATE ROW(""max"", MAX(factStockEPSA[Stock Fecha_Corte]))" }
    )
    foreach ($q in $dateQueries) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $q.Dax
            $r = $cmd.ExecuteReader()
            if ($r.Read()) { $output += "  $($q.Name): $($r[0])" }
            $r.Close()
        } catch { $output += "  $($q.Name): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length)))" }
    }
    
    $conn.Close()
    return $output
}

Write-Host "`n$($result -join "`n")" -ForegroundColor White
