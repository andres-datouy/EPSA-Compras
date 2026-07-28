# =====================================================
# Build SSAS-compatible model from Power BI export
# Transforms database_staging.json for SSAS Tabular deployment
# =====================================================
param(
    [string]$InputFile = "$PSScriptRoot\..\model\database_staging.json",
    [string]$OutputFile = "$PSScriptRoot\..\model\database_staging.json"
)

$ErrorActionPreference = "Stop"
Write-Host "=== Building SSAS-compatible model ===" -ForegroundColor Cyan
Write-Host "Input: $InputFile" -ForegroundColor Gray

$raw = Get-Content $InputFile -Raw -Encoding UTF8
$json = $raw | ConvertFrom-Json

# --- 1. Remove Power BI-specific properties ---
Write-Host "`n[1/7] Removing Power BI properties..." -ForegroundColor Yellow
if ($json.model.PSObject.Properties['defaultPowerBIDataSourceVersion']) {
    $json.model.PSObject.Properties.Remove('defaultPowerBIDataSourceVersion')
    Write-Host "  Removed defaultPowerBIDataSourceVersion"
}

# --- 2. Set compatibility level at root ---
Write-Host "[2/7] Setting compatibility level..." -ForegroundColor Yellow
if (-not $json.PSObject.Properties['compatibilityLevel']) {
    $json | Add-Member -NotePropertyName 'compatibilityLevel' -NotePropertyValue 1600
}
Write-Host "  compatibilityLevel: 1600"

# --- 3. Convert M-based partitions to SQL query type ---
Write-Host "[3/7] Converting M partitions to SQL queries..." -ForegroundColor Yellow
foreach ($table in $json.model.tables) {
    if (-not $table.partitions) { continue }
    foreach ($p in $table.partitions) {
        if ($p.source.type -ne "m") { continue }
        $mExpr = $p.source.expression
        if ($mExpr -match '\[Schema="([^"]+)",Item="([^"]+)"\]') {
            $schema = $Matches[1]
            $item = $Matches[2]
            $sqlQuery = "SELECT * FROM [$schema].[$item]"
            
            $p.source.type = "query"
            $p.source.PSObject.Properties.Remove('expression')
            $p.source | Add-Member -NotePropertyName 'query' -NotePropertyValue $sqlQuery -Force
            $p.source | Add-Member -NotePropertyName 'dataSource' -NotePropertyValue 'staging_compras' -Force
            Write-Host "  $($table.name): $sqlQuery" -ForegroundColor Green
        } else {
            Write-Host "  SKIP $($table.name) (non-SQL M expression)" -ForegroundColor DarkGray
        }
    }
}

# --- 4. Remove incompatible tables ---
Write-Host "[4/7] Removing incompatible tables..." -ForegroundColor Yellow
$removeNames = @(
    'Medidas_Consumo', 'Medidas_Stock', 'Medidas_Compras',
    'Medidas_Consumo_Planificado', 'Medidas_DemandaPendiente',
    'Medidas_HistoriaCompra', 'Calendario'
)
$tablesToKeep = @()
foreach ($table in $json.model.tables) {
    if ($table.name -in $removeNames) {
        Write-Host "  REMOVED: $($table.name)" -ForegroundColor Red
    } else {
        $tablesToKeep += $table
    }
}
$json.model.tables = $tablesToKeep

# --- 5. Remove relationships referencing removed tables ---
Write-Host "[5/7] Cleaning relationships..." -ForegroundColor Yellow
if ($json.model.relationships) {
    $relsToKeep = @()
    foreach ($rel in $json.model.relationships) {
        if ($rel.fromTable -in $removeNames -or $rel.toTable -in $removeNames) {
            Write-Host "  REMOVED: $($rel.fromTable)->$($rel.toTable)" -ForegroundColor DarkRed
        } else {
            $relsToKeep += $rel
        }
    }
    $json.model.relationships = $relsToKeep
}

# --- 6. Fix hierarchy references ---
Write-Host "[6/7] Fixing hierarchy references..." -ForegroundColor Yellow
# Replace broken column references via text (after JSON serialization)

# --- 7. Set up data source ---
Write-Host "[7/7] Configuring data source..." -ForegroundColor Yellow
# Data source will be set via text replacement after serialization

# --- Serialize and apply text-level fixes ---
$output = $json | ConvertTo-Json -Depth 100

# Fix hierarchy: Trimestre del año fiscal -> Trimestre
$output = $output.Replace('Trimestre del año fiscal', 'Trimestre')

# Replace dataSources block with proper SSAS format
$dsPattern = '(?s)"dataSources":\s*\[[^\]]*\]'
$newDS = @'
"dataSources": [
    {
      "name": "staging_compras",
      "type": "provider",
      "connectionString": "Data Source=192.168.2.47,1435;Initial Catalog=staging_compras;Provider=SQLNCLI11;Integrated Security=SSPI;Persist Security Info=false",
      "impersonationMode": "impersonateServiceAccount",
      "account": "app_compras",
      "password": "__SQL_PASSWORD__"
    }
  ]
'@
$output = [regex]::Replace($output, $dsPattern, $newDS)

# If no dataSources exist, add it after "model": {
if ($output -notmatch '"dataSources"') {
    $output = $output -replace '("model":\s*\{)', "`$1`n  $newDS,"
}

# Remove model.expressions (M-based shared expressions)
$output = [regex]::Replace($output, '(?s),?\s*"expressions":\s*\[.*?\]\s*(?=,|\})', '')

[System.IO.File]::WriteAllText($OutputFile, $output, [System.Text.Encoding]::UTF8)

Write-Host "`n=== Build Complete ===" -ForegroundColor Cyan
Write-Host "Output: $OutputFile" -ForegroundColor Gray
Write-Host "Tables: $($tablesToKeep.Count)" -ForegroundColor Gray
Write-Host "Ready for SSAS deployment." -ForegroundColor Green
