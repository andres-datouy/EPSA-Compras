# Verify schaaf_ssas credentials via SMB (fastest way to test Windows auth)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$user = "schaaf_ssas"

# Test 1: SMB access to C$ share
Write-Host "=== Test 1: SMB with EXLER-SERVER\schaaf_ssas ===" -ForegroundColor Cyan
$net = New-Object -ComObject WScript.Network
try {
    $net.MapNetworkDrive("Z:", "\\192.168.2.47\C$", $false, "EXLER-SERVER\$user", $pass)
    Write-Host "OK - Credentials valid!" -ForegroundColor Green
    $net.RemoveNetworkDrive("Z:", $true, $true)
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Try with IP prefix
Write-Host "`n=== Test 2: SMB with 192.168.2.47\schaaf_ssas ===" -ForegroundColor Cyan
try {
    $net.MapNetworkDrive("Z:", "\\192.168.2.47\C$", $false, "192.168.2.47\$user", $pass)
    Write-Host "OK - Credentials valid with IP prefix!" -ForegroundColor Green
    $net.RemoveNetworkDrive("Z:", $true, $true)
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Check if hostname resolves
Write-Host "`n=== Test 3: Hostname resolution ===" -ForegroundColor Cyan
try {
    $resolved = [System.Net.Dns]::GetHostEntry("192.168.2.47")
    Write-Host "Reverse DNS: $($resolved.HostName)"
} catch {
    Write-Host "No reverse DNS for 192.168.2.47"
}

try {
    $resolved = [System.Net.Dns]::GetHostEntry("EXLER-SERVER")
    Write-Host "EXLER-SERVER resolves to: $($resolved.AddressList[0])"
} catch {
    Write-Host "EXLER-SERVER does not resolve via DNS (may need hosts file or NetBIOS)"
}
