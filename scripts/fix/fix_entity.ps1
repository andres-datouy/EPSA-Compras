# Fix the one dimArticulos (plural) reference
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$path = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\report.json"
$content = [System.IO.File]::ReadAllText($path, $utf8NoBom)

# Find context around dimArticulos
$idx = $content.IndexOf("dimArticulos")
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 50)
    $end = [Math]::Min($content.Length, $idx + 80)
    Write-Host "Context: ...$($content.Substring($start, $end - $start))..." -ForegroundColor Yellow
    
    # Replace dimArticulos with dimArticulo (but not dimArticulo[...])
    $newContent = $content.Replace("dimArticulos", "dimArticulo")
    [System.IO.File]::WriteAllText($path, $newContent, $utf8NoBom)
    Write-Host "Fixed! Replaced dimArticulos -> dimArticulo" -ForegroundColor Green
} else {
    Write-Host "No dimArticulos found" -ForegroundColor Green
}
