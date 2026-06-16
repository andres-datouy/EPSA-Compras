# Test sa connectivity to both instances
Write-Host "=== Testing sa connectivity ===" -ForegroundColor Yellow

# Default instance (1433)
try {
    $c = New-Object System.Data.SqlClient.SqlConnection
    $c.ConnectionString = "Data Source=192.168.2.47,1433;User Id=sa;Password=Saas 244050@;TrustServerCertificate=True;Encrypt=False"
    $c.Open()
    Write-Host "  Default instance (1433): SUCCESS" -ForegroundColor Green
    $c.Close()
} catch {
    Write-Host "  Default instance (1433): FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

# SSAS instance (1435)
try {
    $c = New-Object System.Data.SqlClient.SqlConnection
    $c.ConnectionString = "Data Source=192.168.2.47,1435;User Id=sa;Password=Saas 244050@;TrustServerCertificate=True;Encrypt=False"
    $c.Open()
    Write-Host "  SSAS instance (1435): SUCCESS" -ForegroundColor Green
    $c.Close()
} catch {
    Write-Host "  SSAS instance (1435): FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

# WinRM test
Write-Host "`n=== Testing WinRM ===" -ForegroundColor Yellow
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))
try {
    $r = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock { whoami }
    Write-Host "  WinRM: SUCCESS (running as $r)" -ForegroundColor Green
} catch {
    Write-Host "  WinRM: FAILED - $($_.Exception.Message)" -ForegroundColor Red
}
