# Check refresh log and investigate RecepcionesHistoria gap
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=30"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $output = @()
    
    # Refresh log
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
SELECT TOP 30 table_name, refresh_type, rows_affected, status, 
    CONVERT(VARCHAR, start_time, 120) as start_time,
    CONVERT(VARCHAR, end_time, 120) as end_time,
    LEFT(ISNULL(error_message,''), 80) as error_msg
FROM dbo.stg_refresh_log 
ORDER BY log_id DESC
"@
    $r = $cmd.ExecuteReader()
    $output += "=== REFRESH LOG (last 30 entries) ==="
    $output += "{0,-38} {1,-10} {2,10} {3,-8} {4,-20}" -f "Table", "Type", "Rows", "Status", "Start Time"
    $output += ("-" * 90)
    while ($r.Read()) {
        $output += "{0,-38} {1,-10} {2,10} {3,-8} {4,-20}" -f $r[0], $r[1], $r[2], $r[3], $r[4]
    }
    $r.Close()
    
    # Check min/max dates in Recepciones staging
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT MIN([RecepcionFecha]), MAX([RecepcionFecha]), COUNT(*) FROM dbo.stg_factRecepcionesHistoria"
    $r2 = $cmd2.ExecuteReader()
    $output += "`n=== RecepcionesHistoria staging ==="
    if ($r2.Read()) {
        $output += "  Min date: $($r2[0])"
        $output += "  Max date: $($r2[1])"
        $output += "  Count: $($r2[2])"
    }
    $r2.Close()
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
