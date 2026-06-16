# =====================================================
# Deploy SSAS Tabular Model from JSON
# Target: 192.168.2.47\SSAS
# Database: Compras_EPSA
# =====================================================

param(
    [string]$Server = "192.168.2.47:2383",
    [string]$ModelFile = "$PSScriptRoot\..\model\database_staging.json",
    [string]$SqlUser = "app_compras",
    [string]$SqlPassword = "",
    [switch]$ProcessFull = $true,
    [switch]$SkipProcess = $false
)

$ErrorActionPreference = "Stop"

# --- Load AMO assemblies ---
$amoPaths = @(
    "$env:ProgramFiles\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll",
    "$env:ProgramFiles\Microsoft SQL Server\*\OLAP\bin\Microsoft.AnalysisServices.Tabular.dll",
    "$env:ProgramFiles\Microsoft SQL Server\*\SDK\Assemblies\Microsoft.AnalysisServices.Tabular.dll",
    "C:\Program Files (x86)\Microsoft SQL Server\*\SDK\Assemblies\Microsoft.AnalysisServices.Tabular.dll"
)

$loaded = $false
foreach ($pattern in $amoPaths) {
    $dll = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | 
        Sort-Object FullName -Descending | Select-Object -First 1
    if ($dll) {
        $amoDir = Split-Path $dll.FullName
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
        $loaded = $true
        break
    }
}

if (-not $loaded) {
    try {
        Add-Type -AssemblyName "Microsoft.AnalysisServices.Tabular" -ErrorAction Stop
        Write-Host "Loaded AMO from GAC" -ForegroundColor Green
    } catch {
        Write-Error "Cannot find AMO assemblies. Install 'SQL Server Analysis Services AMO' client."
        exit 1
    }
}

# --- Read model JSON ---
Write-Host "Reading model: $ModelFile" -ForegroundColor Yellow
$modelJson = Get-Content $ModelFile -Raw -Encoding UTF8
$modelObj = $modelJson | ConvertFrom-Json
$dbName = $modelObj.name
Write-Host "Database name: $dbName" -ForegroundColor Green

# --- Connect to SSAS ---
Write-Host "Connecting to SSAS: $Server" -ForegroundColor Yellow
try {
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server -ErrorAction Stop
    $ssas.Connect("Data Source=$Server")
} catch {
    Write-Error "Failed to connect to SSAS: $_"
    exit 1
}
Write-Host "Connected. Server version: $($ssas.Version)" -ForegroundColor Green

# --- Check if database already exists ---
$existingDb = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
if ($existingDb) {
    Write-Host "Database '$dbName' already exists. Dropping..." -ForegroundColor Yellow
    $existingDb.Drop()
    $ssas.Refresh()
    Write-Host "Dropped existing database." -ForegroundColor Green
}

# --- Deploy database using TMSL createOrReplace ---
Write-Host "Deploying database '$dbName'..." -ForegroundColor Yellow

$tmsl = @"
{
  "createOrReplace": {
    "object": {
      "database": "$dbName"
    },
    "database": $modelJson
  }
}
"@

# Execute TMSL via AMO Server.Execute (string overload)
try {
    $result = $ssas.Execute($tmsl)
    if ($result -and $result.ContainsErrors) {
        foreach ($msg in $result.Messages) {
            Write-Host "TMSL Error: $($msg.Text)" -ForegroundColor Red
        }
        Write-Error "Deployment failed with errors."
        exit 1
    }
} catch {
    Write-Error "TMSL execution failed: $_"
    exit 1
}
Write-Host "Database deployed successfully!" -ForegroundColor Green

# --- Set data source credentials ---
if ($SqlPassword) {
    Write-Host "Setting data source credentials for '$SqlUser'..." -ForegroundColor Yellow
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    if ($db -and $db.Model -and $db.Model.DataSources) {
        foreach ($ds in $db.Model.DataSources) {
            $ds.Credential = New-Object Microsoft.AnalysisServices.Tabular.Credential
            $ds.Credential.AuthenticationKind = "UsernamePassword"
            $ds.Credential.Username = $SqlUser
            $ds.Credential.Password = $SqlPassword
            Write-Host "  Set credentials for: $($ds.Name)" -ForegroundColor Cyan
        }
        $db.Model.SaveChanges()
        Write-Host "Credentials saved." -ForegroundColor Green
    } else {
        Write-Host "  No explicit data sources found (M queries handle their own connections)." -ForegroundColor Yellow
        Write-Host "  Credentials will need to be set via SSMS or TMSL refresh with credentials." -ForegroundColor Yellow
    }
} else {
    Write-Host "No SQL password provided - skipping credential setup." -ForegroundColor Yellow
    Write-Host "You may need to set credentials manually if processing fails." -ForegroundColor Yellow
}

# --- Process the database ---
if (-not $SkipProcess -and $ProcessFull) {
    Write-Host "Processing database (Full)..." -ForegroundColor Yellow
    
    $processTmsl = @"
{
  "refresh": {
    "type": "full",
    "objects": [
      { "database": "$dbName" }
    ]
  }
}
"@
    
    try {
        $processResult = $ssas.Execute($processTmsl)
        if ($processResult -and $processResult.ContainsErrors) {
            foreach ($msg in $processResult.Messages) {
                Write-Host "Process Error: $($msg.Text)" -ForegroundColor Red
            }
            Write-Warning "Processing completed with errors. Some tables may not have loaded data."
        } else {
            Write-Host "Processing completed successfully!" -ForegroundColor Green
        }
    } catch {
        Write-Warning "Processing failed: $_"
    }
}

# --- Validate ---
$ssas.Refresh()
$finalDb = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
if ($finalDb) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "DEPLOYMENT COMPLETE" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Server: $Server"
    Write-Host "Database: $dbName"
    Write-Host "Tables: $($finalDb.Model.Tables.Count)"
    Write-Host "Compatibility: $($finalDb.CompatibilityLevel)"
    Write-Host "State: $($finalDb.State)"
    Write-Host ""
    
    # Row counts per table
    Write-Host "Row counts:" -ForegroundColor Yellow
    foreach ($table in $finalDb.Model.Tables) {
        $partition = $table.Partitions[0]
        if ($partition) {
            Write-Host "  $($table.Name): $($partition.State)" -ForegroundColor Gray
        }
    }
}

$ssas.Disconnect()
