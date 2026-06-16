# Remove Calendario table and its relationships for now
$file = "$PSScriptRoot\..\model\database_staging.json"
$json = Get-Content $file -Raw -Encoding UTF8 | ConvertFrom-Json

# Remove Calendario from tables
$tablesToKeep = @()
foreach ($table in $json.model.tables) {
    if ($table.name -eq 'Calendario') {
        Write-Host "REMOVING table: Calendario" -ForegroundColor Red
    } else {
        $tablesToKeep += $table
    }
}
$json.model.tables = $tablesToKeep

# Remove all relationships referencing Calendario
if ($json.model.relationships) {
    $relsToKeep = @()
    foreach ($rel in $json.model.relationships) {
        if ($rel.fromTable -eq 'Calendario' -or $rel.toTable -eq 'Calendario') {
            Write-Host "REMOVING relationship: $($rel.name) ($($rel.fromTable)->$($rel.toTable))" -ForegroundColor DarkRed
        } else {
            $relsToKeep += $rel
        }
    }
    $json.model.relationships = $relsToKeep
}

$json | ConvertTo-Json -Depth 100 | Set-Content $file -Encoding UTF8
Write-Host "`nTables remaining: $($json.model.tables.Count)" -ForegroundColor Cyan
Write-Host "Relationships remaining: $($json.model.relationships.Count)" -ForegroundColor Cyan

# Copy to server
Copy-Item $file '\\192.168.2.47\C$\temp\ssas_deploy\database_staging.json' -Force
Write-Host "Copied to server." -ForegroundColor Green
