# Extract table names from the original Power BI model
$modelJson = Get-Content "d:\Andres\Dev\EPSA-Compras\pbix\model_export.json" -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host "=== Original PBIX Model Tables ===" -ForegroundColor Cyan
foreach ($table in $modelJson.model.tables) {
    $type = "data"
    if ($table.columns.Count -eq 0 -and $table.measures.Count -gt 0) { $type = "MEASURES" }
    elseif ($table.partitions.Count -eq 0 -and $table.columns.Count -eq 0) { $type = "empty" }
    Write-Host "  $($table.name) [$type]" -ForegroundColor $(if ($type -eq "MEASURES") { "Yellow" } else { "Gray" })
}
