$json = Get-Content "$PSScriptRoot\..\model\database_staging.json" -Raw | ConvertFrom-Json
$cal = $json.model.tables | Where-Object { $_.name -eq 'Calendario' }

Write-Host "=== Calendario Columns ===" -ForegroundColor Green
$cal.columns | ForEach-Object { Write-Host "  $($_.name) [type=$($_.dataType)]" }

Write-Host "`n=== Calendario Hierarchies ===" -ForegroundColor Yellow
foreach ($h in $cal.hierarchies) {
    Write-Host "Hierarchy: $($h.name)"
    foreach ($level in $h.levels) {
        Write-Host "  Level: $($level.name) -> Column: $($level.column)"
    }
}
