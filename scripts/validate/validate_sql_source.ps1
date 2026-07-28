$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# List tables in staging_compras and get row counts
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    # Use the same credentials as SSAS data source (app_compras with schaaf_ssas password per model config)
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$using:sqlPass;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    try {
        $conn.Open()
        $output += "Connected to staging_compras (app_compras with SSAS password)"
    } catch {
        # Try with actual SQL password
        $connStr2 = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=GralServando2450;Connect Timeout=10"
        $conn = New-Object System.Data.SqlClient.SqlConnection($connStr2)
        try {
            $conn.Open()
            $output += "Connected to staging_compras (app_compras with SQL password)"
        } catch {
            # Try schaaf_ssas as SQL login
            $connStr3 = "Server=localhost,1435;Database=staging_compras;User Id=schaaf_ssas;Password=$using:sqlPass;Connect Timeout=10"
            $conn = New-Object System.Data.SqlClient.SqlConnection($connStr3)
            try {
                $conn.Open()
                $output += "Connected to staging_compras (schaaf_ssas)"
            } catch {
                $output += "ALL CONNECTIONS FAILED"
                return $output
            }
        }
    }
    
    # List all tables
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT TABLE_SCHEMA + '.' + TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME"
    $r = $cmd.ExecuteReader()
    $output += "`n=== Tables in staging_compras ==="
    $tables = @()
    while ($r.Read()) { $tables += $r[0].ToString(); $output += "  $($r[0])" }
    $r.Close()
    
    # Get row counts for stg_ tables
    $output += "`n=== Row Counts ==="
    foreach ($t in $tables) {
        try {
            $cmd2 = $conn.CreateCommand()
            $cmd2.CommandText = "SELECT COUNT(*) FROM [$($t.Split('.')[0])].[$($t.Split('.')[1])]"
            $count = $cmd2.ExecuteScalar()
            $output += "  $t : $count"
        } catch {
            $output += "  $t : ERROR"
        }
    }
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
