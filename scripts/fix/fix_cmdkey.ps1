# Fix cmdkey credentials for SSAS deployment
$user = "EXLER-SERVER\schaaf_ssas"
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$target = "EXLER-SERVER"

# Remove old entry if exists
& cmdkey "/delete:$target" 2>$null

# Add with correct password - use Start-Process to avoid shell escaping issues
$proc = Start-Process -FilePath "cmdkey" -ArgumentList "/add:$target","/U:$user","/pass:$pass" -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\cmdkey_out.txt" -RedirectStandardError "$env:TEMP\cmdkey_err.txt"

Get-Content "$env:TEMP\cmdkey_out.txt" -ErrorAction SilentlyContinue
Get-Content "$env:TEMP\cmdkey_err.txt" -ErrorAction SilentlyContinue

if ($proc.ExitCode -eq 0) {
    Write-Host "cmdkey updated successfully for $target" -ForegroundColor Green
} else {
    Write-Host "cmdkey failed (exit code: $($proc.ExitCode))" -ForegroundColor Red
    # List existing credentials
    Write-Host "`nExisting credentials:" -ForegroundColor Yellow
    & cmdkey /list
}
