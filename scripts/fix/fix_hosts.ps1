# Add EXLER-SERVER-VM to local hosts file for name resolution
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$content = Get-Content $hostsFile -Raw

# Check if already present
if ($content -match "EXLER-SERVER") {
    Write-Host "Already has EXLER-SERVER entry:" -ForegroundColor Yellow
    $content -split "`n" | Where-Object { $_ -match "EXLER" } | ForEach-Object { Write-Host "  $_" }
} else {
    Write-Host "Adding EXLER-SERVER-VM to hosts file..." -ForegroundColor Cyan
    $newEntry = "`n192.168.2.47    EXLER-SERVER-VM EXLER-SERVER EXLER-SERVER-VM.EPSA.local"
    Add-Content -Path $hostsFile -Value $newEntry
    Write-Host "Added! Verifying..." -ForegroundColor Green
    
    # Test resolution
    try {
        $resolved = [System.Net.Dns]::GetHostEntry("EXLER-SERVER-VM")
        Write-Host "EXLER-SERVER-VM now resolves to: $($resolved.AddressList[0])" -ForegroundColor Green
    } catch {
        Write-Host "Still not resolving (may need to flush DNS cache)" -ForegroundColor Yellow
        ipconfig /flushdns | Out-Null
        try {
            $resolved = [System.Net.Dns]::GetHostEntry("EXLER-SERVER-VM")
            Write-Host "EXLER-SERVER-VM resolved after DNS flush: $($resolved.AddressList[0])" -ForegroundColor Green
        } catch {
            Write-Host "FAILED to resolve even after flush" -ForegroundColor Red
        }
    }
}
