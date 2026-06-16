$j = Get-Content "$PSScriptRoot\..\model\database_staging.json" -Raw | ConvertFrom-Json
foreach ($t in $j.model.tables) {
    Write-Host "=== $($t.name) ==="
    $cols = @()
    foreach ($c in $t.columns) { $cols += $c.name }
    Write-Host "  $($cols -join ', ')"
}
