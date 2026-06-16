# Check SQL instances on the server
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # List SQL services
    $output += "=== SQL Services ==="
    $services = Get-Service | Where-Object { $_.DisplayName -like "*SQL*" } | Select-Object Name, DisplayName, Status
    foreach ($s in $services) {
        $output += "  $($s.Status) | $($s.DisplayName) [$($s.Name)]"
    }
    
    # List SQL instances via registry
    $output += "`n=== SQL Instances (Registry) ==="
    $instances = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" -ErrorAction SilentlyContinue
    if ($instances) {
        foreach ($prop in $instances.Property) {
            $output += "  Instance: $prop"
        }
    } else {
        $output += "  (No instances found in registry)"
    }
    
    # Try connecting to default instance
    $output += "`n=== Testing connections ==="
    foreach ($inst in @("localhost", "localhost\STAGING", "localhost\MSSQLSERVER")) {
        try {
            $connStr = "Server=$inst;Integrated Security=True;Connect Timeout=5"
            $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
            $conn.Open()
            $output += "  OK: $inst -> $($conn.DatabaseServerVersion)"
            $conn.Close()
        } catch {
            $output += "  FAIL: $inst -> $($_.Exception.Message.Substring(0, [Math]::Min(60, $_.Exception.Message.Length)))"
        }
    }
    
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
