# Transform database_staging.json: convert M-based data sources to structured SQL for SSAS
param(
    [string]$InputFile = "$PSScriptRoot\..\model\database_staging.json",
    [string]$OutputFile = "$PSScriptRoot\..\model\database_staging.json"
)

$ErrorActionPreference = "Stop"
Write-Host "Transforming model for SSAS compatibility..." -ForegroundColor Yellow

$raw = Get-Content $InputFile -Raw -Encoding UTF8
$json = $raw | ConvertFrom-Json

# SQL Server connection info
$sqlServer = "192.168.2.47,1435"
$sqlDatabase = "staging_compras"

# Add structured data source to model
$dataSource = @{
    name = "staging_compras"
    type = "structured"
    connectionDetails = @{
        protocol = "tds"
        address = @{
            server = $sqlServer
            database = $sqlDatabase
        }
        authentication = @{
            kind = "UsernamePassword"
        }
        query = ""
    }
    credential = @{
        AuthenticationKind = "UsernamePassword"
        kind = "UsernamePassword"
        path = "$sqlServer;$sqlDatabase"
        Username = "app_compras"
    }
}

# Check if dataSource already exists, if not add it
if (-not $json.model.dataSources) {
    $json.model | Add-Member -NotePropertyName "dataSources" -NotePropertyValue @() -Force
}
$json.model.dataSources = @($dataSource)

# Transform each M-based partition
foreach ($table in $json.model.tables) {
    if (-not $table.partitions) { continue }
    foreach ($partition in $table.partitions) {
        if ($partition.source.type -ne "m") { continue }
        
        $mExpr = $partition.source.expression
        $tableName = $table.name
        
        # Extract Schema and Item from M expression
        # Pattern: Source{[Schema="xxx",Item="yyy"]}[Data]
        if ($mExpr -match '\[Schema="([^"]+)",Item="([^"]+)"\]') {
            $schema = $Matches[1]
            $item = $Matches[2]
            $sqlQuery = "SELECT * FROM [$schema].[$item]"
            
            # Check if there are column renames
            if ($mExpr -match 'Table\.RenameColumns') {
                # Extract rename pairs: {"old", "new"}
                $renames = @()
                $renamePattern = '\{"([^"]+)",\s*"([^"]+)"\}'
                $renameMatches = [regex]::Matches($mExpr, $renamePattern)
                foreach ($rm in $renameMatches) {
                    $renames += @{ old = $rm.Groups[1].Value; new = $rm.Groups[2].Value }
                }
                # Build SQL with aliases (only rename, not select specific columns)
                # Actually for SSAS it's easier to just use SELECT * and let column mappings handle it
            }
        } elseif ($mExpr -match 'Table\.FromRows\(Json\.Document') {
            # Static data table (like Medidas_* tables) - keep as calculated or use M still?
            # SSAS doesn't support M, so we need to handle this differently
            # For now, skip these and mark them
            Write-Host "  SKIP (static data): $tableName" -ForegroundColor DarkGray
            continue
        } else {
            Write-Host "  SKIP (unknown pattern): $tableName" -ForegroundColor DarkGray
            Write-Host "    Expression: $($mExpr.Substring(0, [Math]::Min(80, $mExpr.Length)))..." -ForegroundColor DarkGray
            continue
        }
        
        # Convert partition to query type
        $partition.source.type = "query"
        # Remove 'expression' property (only for M/calculated types)
        $partition.source.PSObject.Properties.Remove('expression')
        # Add 'query' property with SQL
        $partition.source | Add-Member -NotePropertyName "query" -NotePropertyValue $sqlQuery -Force
        
        # Add dataSource reference
        $partition.source | Add-Member -NotePropertyName "dataSource" -NotePropertyValue "staging_compras" -Force
        
        Write-Host "  OK: $tableName -> $sqlQuery" -ForegroundColor Green
    }
}

# Remove the model.expressions if it contains M-based shared expressions
if ($json.model.expressions) {
    Write-Host "`nRemoving M-based expressions..." -ForegroundColor Yellow
    $json.model.expressions = @()
}

# Save transformed model
$json | ConvertTo-Json -Depth 100 | Set-Content $OutputFile -Encoding UTF8
Write-Host "`nModel saved to: $OutputFile" -ForegroundColor Green
Write-Host "Transformation complete." -ForegroundColor Cyan
