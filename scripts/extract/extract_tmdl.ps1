# =====================================================
# Extract SSAS Tabular Model from Power BI Desktop
# Usage: 
#   1. Open the PBIX in Power BI Desktop
#   2. Run this script (it auto-detects the local SSAS port)
#   3. Output: model/ folder with database.json
# =====================================================

param(
    [string]$OutputFolder = "$PSScriptRoot\..\model",
    [int]$Port = 0  # If 0, auto-detect
)

$ErrorActionPreference = "Stop"

# --- Load AMO assemblies ---
$amoPath = (Get-ChildItem -Path "$env:ProgramFiles\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue | 
    Sort-Object { $_.FullName.Length } | Select-Object -First 1).FullName

if (-not $amoPath) {
    # Try common SSAS client paths
    $amoPath = (Get-ChildItem -Path "C:\Program Files (x86)\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue | 
        Sort-Object { $_.FullName.Length } | Select-Object -First 1).FullName
}

if (-not $amoPath) {
    # Try loading from GAC or NuGet
    try {
        Add-Type -AssemblyName "Microsoft.AnalysisServices.Tabular" -ErrorAction Stop
        Write-Host "Loaded AMO from GAC" -ForegroundColor Green
    } catch {
        Write-Error "Cannot find Microsoft.AnalysisServices.Tabular.dll. Install SSAS client libraries."
        exit 1
    }
} else {
    # Load all required AMO assemblies from the same directory
    $amoDir = Split-Path $amoPath
    $deps = @(
        "Microsoft.AnalysisServices.Core.dll",
        "Microsoft.AnalysisServices.Tabular.dll",
        "Microsoft.AnalysisServices.Tabular.Json.dll"
    )
    foreach ($dep in $deps) {
        $depPath = Join-Path $amoDir $dep
        if (Test-Path $depPath) {
            try { Add-Type -Path $depPath -ErrorAction SilentlyContinue } catch {}
        }
    }
    Write-Host "Loaded AMO from: $amoDir" -ForegroundColor Green
}

# --- Find Power BI Desktop local SSAS port ---
function Find-PBIDPort {
    # Method 1: Check msmdsrv.log in temp folders
    $tempPaths = @(
        "$env:LOCALAPPDATA\Microsoft\Power BI Desktop\AnalysisServicesWorkspaces",
        "$env:TEMP\AnalysisServicesWorkspaces"
    )
    
    foreach ($basePath in $tempPaths) {
        if (Test-Path $basePath) {
            $logFiles = Get-ChildItem -Path $basePath -Recurse -Filter "msmdsrv.log" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($logFiles) {
                $content = Get-Content $logFiles.FullName -Tail 50
                $portMatch = $content | Select-String -Pattern "Now listening on port (\d+)" | Select-Object -First 1
                if ($portMatch) {
                    return [int]$portMatch.Matches[0].Groups[1].Value
                }
            }
        }
    }
    
    # Method 2: Check running msmdsrv processes with open ports
    $process = Get-Process -Name "msmdsrv" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -eq "" } |  # PBID's msmdsrv has no window
        Sort-Object StartTime -Descending | Select-Object -First 1
    
    if ($process) {
        $tcpConnections = Get-NetTCPConnection -OwningProcess $process.Id -State Listen -ErrorAction SilentlyContinue
        if ($tcpConnections) {
            return $tcpConnections[0].LocalPort
        }
    }
    
    return $null
}

if ($Port -eq 0) {
    Write-Host "Searching for Power BI Desktop local SSAS port..." -ForegroundColor Yellow
    $Port = Find-PBIDPort
    if (-not $Port) {
        Write-Error @"
Cannot find Power BI Desktop's local SSAS instance.
Make sure:
  1. Power BI Desktop is running with the PBIX file open
  2. The model has finished loading
  
Alternative: specify the port manually:
  .\extract_tmdl.ps1 -Port <PORT_NUMBER>
  
To find the port: open Task Manager > find msmdsrv.exe > check PID > 
  run: Get-NetTCPConnection -OwningProcess <PID> -State Listen
"@
        exit 1
    }
}

Write-Host "Using SSAS port: $Port" -ForegroundColor Green

# --- Connect and extract model ---
$connectionString = "Data Source=localhost:$Port"
Write-Host "Connecting to: $connectionString" -ForegroundColor Yellow

$server = New-Object Microsoft.AnalysisServices.Tabular.Server
$server.Connect($connectionString)

$database = $server.Databases[0]
Write-Host "Found database: $($database.Name) (Compatibility: $($database.CompatibilityLevel))" -ForegroundColor Green

# --- Export as JSON (database.json / BIM format) ---
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}

# Method: Serialize to JSON using TMSL
$jsonDef = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::SerializeDatabase($database)
$outputFile = Join-Path $OutputFolder "database.json"
$jsonDef | Out-File -FilePath $outputFile -Encoding UTF8
Write-Host "Exported database.json to: $outputFile" -ForegroundColor Green

# Also export individual components for readability
$tablesFolder = Join-Path $OutputFolder "tables"
if (-not (Test-Path $tablesFolder)) {
    New-Item -ItemType Directory -Path $tablesFolder -Force | Out-Null
}

foreach ($table in $database.Model.Tables) {
    $tableJson = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::SerializeObject($table)
    $safeName = $table.Name -replace '[^\w\-]', '_'
    $tableFile = Join-Path $tablesFolder "$safeName.json"
    $tableJson | Out-File -FilePath $tableFile -Encoding UTF8
}
Write-Host "Exported $($database.Model.Tables.Count) table definitions to: $tablesFolder" -ForegroundColor Green

# Export relationships
$relsFolder = Join-Path $OutputFolder "relationships"
if (-not (Test-Path $relsFolder)) {
    New-Item -ItemType Directory -Path $relsFolder -Force | Out-Null
}

$relIndex = 0
foreach ($rel in $database.Model.Relationships) {
    $relJson = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::SerializeObject($rel)
    $relFile = Join-Path $relsFolder "relationship_$relIndex.json"
    $relJson | Out-File -FilePath $relFile -Encoding UTF8
    $relIndex++
}
Write-Host "Exported $($database.Model.Relationships.Count) relationships" -ForegroundColor Green

# Export data sources
$dsFolder = Join-Path $OutputFolder "datasources"
if (-not (Test-Path $dsFolder)) {
    New-Item -ItemType Directory -Path $dsFolder -Force | Out-Null
}

$dsIndex = 0
foreach ($ds in $database.Model.DataSources) {
    $dsJson = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::SerializeObject($ds)
    $dsFile = Join-Path $dsFolder "datasource_$dsIndex.json"
    $dsJson | Out-File -FilePath $dsFile -Encoding UTF8
    $dsIndex++
}
Write-Host "Exported $($database.Model.DataSources.Count) data sources" -ForegroundColor Green

# --- Summary ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "EXTRACTION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Output folder: $OutputFolder"
Write-Host "Tables: $($database.Model.Tables.Count)"
Write-Host "Measures: $(($database.Model.Tables | ForEach-Object { $_.Measures.Count } | Measure-Object -Sum).Sum)"
Write-Host "Relationships: $($database.Model.Relationships.Count)"
Write-Host "Data Sources: $($database.Model.DataSources.Count)"
Write-Host ""
Write-Host "Next step: Review model/database.json and modify data sources (Task 2)" -ForegroundColor Yellow

$server.Disconnect()
