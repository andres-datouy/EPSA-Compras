# Final validation: Source vs Staging vs SSAS for all tables
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # === STAGING COUNTS ===
    $stgConn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=10")
    $stgConn.Open()
    
    $stagingTables = @(
        @{ Name = "stg_dimArticulo"; Table = "dbo.stg_dimArticulo" }
        @{ Name = "stg_dimProveedor"; Table = "dbo.stg_dimProveedor" }
        @{ Name = "stg_factComprasEnProceso"; Table = "dbo.stg_factComprasEnProceso" }
        @{ Name = "stg_factConsumo"; Table = "dbo.stg_factConsumo" }
        @{ Name = "stg_factConsumoPlanificado"; Table = "dbo.stg_factConsumoPlanificado" }
        @{ Name = "stg_factDemandaPendiente"; Table = "dbo.stg_factDemandaPendiente" }
        @{ Name = "stg_factRecepcionesHistoria"; Table = "dbo.stg_factRecepcionesHistoria" }
        @{ Name = "stg_factStockEPSA"; Table = "dbo.stg_factStockEPSA" }
    )
    
    $stagingData = @{}
    foreach ($t in $stagingTables) {
        $cmd = $stgConn.CreateCommand()
        $cmd.CommandText = "SELECT COUNT(*) FROM $($t.Table)"
        $stagingData[$t.Name] = $cmd.ExecuteScalar()
    }
    $stgConn.Close()
    
    # === SSAS COUNTS ===
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    
    $ssasConn = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA")
    $ssasConn.Open()
    
    $ssasTables = @(
        @{ Name = "dimArticulo"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimArticulo'))" }
        @{ Name = "dimProveedor"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimProveedor'))" }
        @{ Name = "factComprasEnProceso"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factComprasEnProceso'))" }
        @{ Name = "factConsumoHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoHistoria'))" }
        @{ Name = "factConsumoPlanificado"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoPlanificado'))" }
        @{ Name = "factDemandaPendientePlanificacion"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factDemandaPendientePlanificacion'))" }
        @{ Name = "factRecepcionesHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factRecepcionesHistoria'))" }
        @{ Name = "factStockEPSA"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factStockEPSA'))" }
    )
    
    $ssasData = @{}
    foreach ($t in $ssasTables) {
        try {
            $cmd = $ssasConn.CreateCommand()
            $cmd.CommandText = $t.DAX
            $r = $cmd.ExecuteReader()
            if ($r.Read()) { $ssasData[$t.Name] = $r[0] }
            $r.Close()
        } catch {
            $ssasData[$t.Name] = "ERR"
        }
    }
    $ssasConn.Close()
    
    # === OUTPUT ===
    $mapping = @(
        @{ Stg = "stg_dimArticulo"; SSAS = "dimArticulo" }
        @{ Stg = "stg_dimProveedor"; SSAS = "dimProveedor" }
        @{ Stg = "stg_factComprasEnProceso"; SSAS = "factComprasEnProceso" }
        @{ Stg = "stg_factConsumo"; SSAS = "factConsumoHistoria" }
        @{ Stg = "stg_factConsumoPlanificado"; SSAS = "factConsumoPlanificado" }
        @{ Stg = "stg_factDemandaPendiente"; SSAS = "factDemandaPendientePlanificacion" }
        @{ Stg = "stg_factRecepcionesHistoria"; SSAS = "factRecepcionesHistoria" }
        @{ Stg = "stg_factStockEPSA"; SSAS = "factStockEPSA" }
    )
    
    $output += "=== FINAL VALIDATION: Staging vs SSAS ==="
    $output += ""
    $output += "{0,-35} {1,10} {2,10} {3,8}" -f "Table", "Staging", "SSAS", "Match"
    $output += ("-" * 67)
    $allMatch = $true
    foreach ($m in $mapping) {
        $stg = $stagingData[$m.Stg]
        $ssas = $ssasData[$m.SSAS]
        if ($ssas -eq "ERR") { $match = "N/A" }
        elseif ($stg -eq $ssas) { $match = "YES" }
        else { $match = "NO"; $allMatch = $false }
        $output += "{0,-35} {1,10} {2,10} {3,8}" -f $m.SSAS, $stg, $ssas, $match
    }
    
    # Recepciones date range
    $output += "`n=== factRecepcionesHistoria Date Range ==="
    $stgConn2 = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=10")
    $stgConn2.Open()
    $cmd = $stgConn2.CreateCommand()
    $cmd.CommandText = "SELECT MIN(RecepcionFecha), MAX(RecepcionFecha) FROM dbo.stg_factRecepcionesHistoria"
    $r = $cmd.ExecuteReader()
    if ($r.Read()) {
        $output += "  Staging: $($r[0]) to $($r[1])"
    }
    $r.Close()
    $stgConn2.Close()
    
    $ssasConn2 = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA")
    $ssasConn2.Open()
    $cmd2 = $ssasConn2.CreateCommand()
    $cmd2.CommandText = "EVALUATE ROW(""min"", MINX('factRecepcionesHistoria', [RecepcionFecha]), ""max"", MAXX('factRecepcionesHistoria', [RecepcionFecha]))"
    $r2 = $cmd2.ExecuteReader()
    if ($r2.Read()) {
        $output += "  SSAS:    $($r2[0]) to $($r2[1])"
    }
    $r2.Close()
    $ssasConn2.Close()
    
    $output += ""
    if ($allMatch) { $output += "ALL TABLES MATCH - Staging and SSAS are fully synchronized!" }
    else { $output += "SOME MISMATCHES FOUND" }
    
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
