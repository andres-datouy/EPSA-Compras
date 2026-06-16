# Verify Proveedores column works via DAX
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $output = @()
    
    # Check Proveedores distinct count
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "EVALUATE ROW(""DistinctCount"", DISTINCTCOUNT(dimArticulo[Proveedores]))"
    try {
        $r = $cmd.ExecuteReader()
        if ($r.Read()) { $output += "Proveedores distinct values: $($r[0])" }
        $r.Close()
    } catch { $output += "ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))" }
    
    # Sample values
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "EVALUATE TOPN(5, DISTINCT(dimArticulo[Proveedores]))"
    try {
        $r2 = $cmd2.ExecuteReader()
        $output += "`nSample Proveedores values:"
        while ($r2.Read()) { $output += "  '$($r2[0])'" }
        $r2.Close()
    } catch { $output += "ERROR getting samples: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))" }
    
    # Check factStockEPSA
    $cmd3 = $conn.CreateCommand()
    $cmd3.CommandText = "EVALUATE ROW(""count"", COUNTROWS(factStockEPSA))"
    try {
        $r3 = $cmd3.ExecuteReader()
        if ($r3.Read()) { $output += "`nfactStockEPSA rows: $($r3[0])" }
        $r3.Close()
    } catch { $output += "factStockEPSA ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))" }
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
