$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Check actual SP names and column names
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$using:sqlPass;Connect Timeout=30"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    $output = @()
    
    # List all SPs
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT name FROM sys.procedures WHERE name LIKE '%refresh%' OR name LIKE '%sp_%' ORDER BY name"
    $r = $cmd.ExecuteReader()
    $output += "=== STORED PROCEDURES ==="
    while ($r.Read()) { $output += "  $($r[0])" }
    $r.Close()
    
    # Columns of stg_factConsumo
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'stg_factConsumo' ORDER BY ORDINAL_POSITION"
    $r2 = $cmd2.ExecuteReader()
    $output += "`n=== stg_factConsumo columns ==="
    while ($r2.Read()) { $output += "  $($r2[0])" }
    $r2.Close()
    
    # SP definition for the consumo one
    $cmd3 = $conn.CreateCommand()
    $cmd3.CommandText = "SELECT name, OBJECT_DEFINITION(object_id) FROM sys.procedures WHERE name LIKE '%Consumo%' OR name LIKE '%consumo%'"
    $r3 = $cmd3.ExecuteReader()
    $output += "`n=== Consumo SP definitions ==="
    while ($r3.Read()) {
        $output += "SP: $($r3[0])"
        $def = if ($r3[1]) { $r3[1].ToString().Substring(0, [Math]::Min(1500, $r3[1].ToString().Length)) } else { "NULL - no permission to view" }
        $output += $def
        $output += "---"
    }
    $r3.Close()
    
    # Check date range using first column
    $cmd4 = $conn.CreateCommand()
    $cmd4.CommandText = "SELECT TOP 1 * FROM dbo.stg_factConsumo"
    $r4 = $cmd4.ExecuteReader()
    $output += "`n=== stg_factConsumo sample row ==="
    if ($r4.Read()) {
        for ($i = 0; $i -lt $r4.FieldCount; $i++) {
            $output += "  $($r4.GetName($i)): $($r4[$i])"
        }
    }
    $r4.Close()
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
