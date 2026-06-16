# Execute sp_refresh_factStockEPSA on the staging server
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=30"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $output = @("Connected to staging_compras")
    
    # Check if linked server BI_SOURCE exists
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT name FROM sys.servers WHERE name = 'BI_SOURCE'"
    try {
        $r = $cmd.ExecuteReader()
        if ($r.Read()) {
            $output += "Linked server BI_SOURCE: EXISTS ($($r[0]))"
        } else {
            $output += "Linked server BI_SOURCE: NOT FOUND"
            # List available linked servers
            $r.Close()
            $cmd2 = $conn.CreateCommand()
            $cmd2.CommandText = "SELECT name, product, data_source FROM sys.servers WHERE server_id > 0"
            $r2 = $cmd2.ExecuteReader()
            $output += "Available linked servers:"
            while ($r2.Read()) { $output += "  $($r2[0]) | $($r2[1]) | $($r2[2])" }
            $r2.Close()
        }
        $r.Close()
    } catch {
        $output += "Error checking linked servers: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
    }
    
    # Try executing the SP
    $output += "`nExecuting sp_refresh_factStockEPSA..."
    $cmd3 = $conn.CreateCommand()
    $cmd3.CommandText = "EXEC dbo.sp_refresh_factStockEPSA"
    $cmd3.CommandTimeout = 120
    try {
        $cmd3.ExecuteNonQuery() | Out-Null
        $output += "SP executed successfully"
    } catch {
        $err = $_.Exception.Message
        if ($err.Length -gt 300) { $err = $err.Substring(0, 300) }
        $output += "SP ERROR: $err"
    }
    
    # Check row count
    $cmd4 = $conn.CreateCommand()
    $cmd4.CommandText = "SELECT COUNT(*) FROM dbo.stg_factStockEPSA"
    $count = $cmd4.ExecuteScalar()
    $output += "stg_factStockEPSA rows: $count"
    
    # Check refresh log
    $cmd5 = $conn.CreateCommand()
    $cmd5.CommandText = "SELECT TOP 1 table_name, status, rows_affected, error_message, start_time, end_time FROM dbo.stg_refresh_log WHERE table_name='stg_factStockEPSA' ORDER BY start_time DESC"
    try {
        $r5 = $cmd5.ExecuteReader()
        if ($r5.Read()) {
            $output += "Last refresh: status=$($r5[1]), rows=$($r5[2]), error=$($r5[3])"
            $output += "  Time: $($r5[4]) -> $($r5[5])"
        }
        $r5.Close()
    } catch {}
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
