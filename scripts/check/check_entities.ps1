# Check entity references in report.json (single-line file)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$content = [System.IO.File]::ReadAllText("d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\report.json", $utf8NoBom)

Write-Host "File size: $($content.Length) chars" -ForegroundColor Cyan

# Look for various entity/table reference patterns
$patterns = @(
    @{ Name = "Entity"; Pattern = '"Entity"\s*:\s*"([^"]+)"' }
    @{ Name = "entity"; Pattern = '"entity"\s*:\s*"([^"]+)"' }
    @{ Name = "QueryRefSet"; Pattern = '"QueryRefSet"' }
    @{ Name = "From"; Pattern = '"From"\s*:\s*\[\s*\{\s*"Name"\s*:\s*"([^"]+)"' }
    @{ Name = "Property"; Pattern = '"Property"\s*:\s*"([^"]+)"' }
    @{ Name = "Table"; Pattern = '"Table"\s*:\s*"([^"]+)"' }
)

foreach ($p in $patterns) {
    $matches = [regex]::Matches($content, $p.Pattern)
    Write-Host "`n$($p.Name): $($matches.Count) matches" -ForegroundColor Yellow
    if ($matches.Count -gt 0 -and $matches.Count -le 30) {
        $uniqueValues = $matches | ForEach-Object { $_.Groups[$_.Groups.Count - 1].Value } | Sort-Object -Unique
        $uniqueValues | ForEach-Object { Write-Host "  $_" }
    } elseif ($matches.Count -gt 30) {
        $uniqueValues = $matches | ForEach-Object { $_.Groups[$_.Groups.Count - 1].Value } | Sort-Object -Unique | Select-Object -First 20
        $uniqueValues | ForEach-Object { Write-Host "  $_" }
        Write-Host "  ... ($(($matches | ForEach-Object { $_.Groups[$_.Groups.Count - 1].Value } | Sort-Object -Unique).Count) unique total)"
    }
}

# Also check for specific table names
Write-Host "`n=== Direct table name search ===" -ForegroundColor Cyan
$tableNames = @("dimArticulo", "dimArticulos", "dimProveedor", "Calendario", "factStock", "factConsumo", "Medidas")
foreach ($t in $tableNames) {
    $count = ([regex]::Matches($content, [regex]::Escape($t))).Count
    if ($count -gt 0) {
        Write-Host "  '$t' found $count times" -ForegroundColor Green
    }
}
