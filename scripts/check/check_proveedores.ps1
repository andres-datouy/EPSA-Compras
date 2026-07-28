$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Check SQL source columns for dimArticulo
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$using:sqlPass;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    
    $output = @()
    
    # Check stg_dimArticulo columns
    $output += "=== stg_dimArticulo columns ==="
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='stg_dimArticulo' ORDER BY ORDINAL_POSITION"
    $r = $cmd.ExecuteReader()
    while ($r.Read()) { $output += "  $($r[0]) ($($r[1]))" }
    $r.Close()
    
    # Check if Proveedores column exists
    $output += "`n=== Sample Proveedores values ==="
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT TOP 5 [Proveedores] FROM [dbo].[stg_dimArticulo] WHERE [Proveedores] IS NOT NULL"
    try {
        $r2 = $cmd2.ExecuteReader()
        $count = 0
        while ($r2.Read()) { $count++; $output += "  $($r2[0])" }
        $r2.Close()
        if ($count -eq 0) { $output += "  (no non-null values found)" }
    } catch {
        $output += "  ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length)))"
    }
    
    # Also check stg_factRecepcionesHistoria for Proveedores
    $output += "`n=== stg_factRecepcionesHistoria Proveedores? ==="
    $cmd3 = $conn.CreateCommand()
    $cmd3.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='stg_factRecepcionesHistoria' AND COLUMN_NAME LIKE '%Provee%'"
    $r3 = $cmd3.ExecuteReader()
    if ($r3.Read()) { $output += "  Found: $($r3[0])" } else { $output += "  No Proveedores column" }
    $r3.Close()
    
    $conn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
