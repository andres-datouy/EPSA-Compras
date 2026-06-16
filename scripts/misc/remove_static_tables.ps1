# Remove M-based static tables that SSAS can't handle
$json = Get-Content "$PSScriptRoot\..\model\database_staging.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$removeNames = @('Medidas_Consumo', 'Medidas_Stock', 'Medidas_Compras', 'Medidas_Consumo_Planificado', 'Medidas_DemandaPendiente', 'Medidas_HistoriaCompra')

$originalCount = $json.model.tables.Count
$tablesToKeep = @()
foreach ($table in $json.model.tables) {
    if ($table.name -in $removeNames) {
        Write-Host "REMOVING: $($table.name)" -ForegroundColor Red
    } else {
        $tablesToKeep += $table
    }
}
$json.model.tables = $tablesToKeep

# Also remove any relationships that reference removed tables
if ($json.model.relationships) {
    $relsToKeep = @()
    foreach ($rel in $json.model.relationships) {
        $fromTable = $rel.fromTable
        $toTable = $rel.toTable
        if ($fromTable -in $removeNames -or $toTable -in $removeNames) {
            Write-Host "REMOVING relationship: $($rel.name)" -ForegroundColor DarkRed
        } else {
            $relsToKeep += $rel
        }
    }
    $json.model.relationships = $relsToKeep
}

Write-Host "`nTables: $originalCount -> $($json.model.tables.Count)" -ForegroundColor Cyan
$json | ConvertTo-Json -Depth 100 | Set-Content "$PSScriptRoot\..\model\database_staging.json" -Encoding UTF8
Write-Host "Saved." -ForegroundColor Green
