# Extract entity references from all visual.json files
$pagesDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages"
$allContent = ""

Get-ChildItem $pagesDir -Recurse -Filter "visual.json" | ForEach-Object {
    $allContent += (Get-Content $_.FullName -Raw) + "`n"
}

# Also include page.json files
Get-ChildItem $pagesDir -Recurse -Filter "page.json" | ForEach-Object {
    $allContent += (Get-Content $_.FullName -Raw) + "`n"
}

# Find all Entity references
$entities = [regex]::Matches($allContent, '"Entity"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host "=== Entities referenced in report visuals ===" -ForegroundColor Cyan
foreach ($e in $entities) { Write-Host "  $e" -ForegroundColor White }

# Find Property references (column names within table)
$properties = [regex]::Matches($allContent, '"Property"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host "`n=== Column/Property references ===" -ForegroundColor Cyan
foreach ($p in $properties) { Write-Host "  $p" -ForegroundColor White }

# Find measure references (NativeReferenceName)
$measureRefs = [regex]::Matches($allContent, '"NativeReferenceName"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host "`n=== NativeReferenceName (measures) ===" -ForegroundColor Cyan
foreach ($m in $measureRefs) { Write-Host "  $m" -ForegroundColor White }
