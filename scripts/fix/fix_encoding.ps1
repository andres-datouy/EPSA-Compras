$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$files = @(
    "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\version.json",
    "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\report.json"
)
foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f)
    $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    if ($hasBom) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($f, $content, $utf8NoBom)
        Write-Host "FIXED BOM: $f" -ForegroundColor Yellow
    } else {
        Write-Host "OK: $f ($($bytes.Length) bytes)" -ForegroundColor Green
    }
}
