# Fix entity name mismatches in report.json
$reportPath = "d:\Andres\Dev\EPSA-Compras\Compras EPSA - Stock.Report\report.json"
$text = [System.IO.File]::ReadAllText($reportPath, [System.Text.Encoding]::UTF8)

# Count before
$dimArticulosCount = ([regex]::Matches($text, 'dimArticulos')).Count
Write-Host "Found $dimArticulosCount occurrences of 'dimArticulos'" -ForegroundColor Yellow

# Fix: dimArticulos -> dimArticulo (but not dimArticulo itself)
# Need to be careful not to replace "dimArticulo" that's already correct
# "dimArticulos" appears as an entity reference in DAX queries
$text = $text -replace '"dimArticulos"', '"dimArticulo"'
$text = $text -replace 'dimArticulos\.', 'dimArticulo.'

# Also check for other potential mismatches
# The model uses "Clase" as a calculated column but might also reference it differently
$text = $text -replace '"Proveedor Artículo Full"', '"Proveedor Artículo Full"'

$afterCount = ([regex]::Matches($text, 'dimArticulos')).Count
Write-Host "After fix: $afterCount occurrences remaining" -ForegroundColor Green

# Save back
[System.IO.File]::WriteAllText($reportPath, $text, [System.Text.Encoding]::UTF8)
Write-Host "Saved report.json" -ForegroundColor Green
