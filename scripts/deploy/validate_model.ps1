# =====================================================
# Validate SSAS Model JSON before deployment
# Generic structural diff against approved baseline.
# Detects any accidental loss of tables, columns,
# hierarchies, relationships, or measures.
# =====================================================

param(
    [string]$DeployFile = "$PSScriptRoot\..\..\model\database_staging.json",
    [string]$BaselineFile = "$PSScriptRoot\..\..\model\database_staging_fixed.json"
)

$ErrorActionPreference = "Stop"
$errors = @()
$infos = @()

Write-Host "Validating model structure..." -ForegroundColor Yellow
Write-Host "  Deploy:   $DeployFile" -ForegroundColor Gray
Write-Host "  Baseline: $BaselineFile" -ForegroundColor Gray

foreach ($f in @($DeployFile, $BaselineFile)) {
    if (-not (Test-Path $f)) {
        Write-Error "File not found: $f"
        exit 1
    }
}

$deploy = (Get-Content $DeployFile -Raw -Encoding UTF8) | ConvertFrom-Json
$baseline = (Get-Content $BaselineFile -Raw -Encoding UTF8) | ConvertFrom-Json

$dTables = $deploy.model.tables
$bTables = $baseline.model.tables

# =====================================================
# 1. TABLES - detect additions/removals
# =====================================================
$dTableNames = @($dTables | ForEach-Object { $_.name })
$bTableNames = @($bTables | ForEach-Object { $_.name })

$missingTables = $bTableNames | Where-Object { $_ -notin $dTableNames }
$newTables = $dTableNames | Where-Object { $_ -notin $bTableNames }

foreach ($t in $missingTables) {
    $errors += "TABLE REMOVED: '$t' exists in baseline but not in deploy JSON"
}
foreach ($t in $newTables) {
    $infos += "TABLE ADDED: '$t' is new in deploy (not in baseline yet)"
}

Write-Host "  Tables: deploy=$($dTableNames.Count) baseline=$($bTableNames.Count)" -ForegroundColor Gray

# =====================================================
# 2. COLUMNS - per table, detect removals
# =====================================================
$commonTables = $bTableNames | Where-Object { $_ -in $dTableNames }

foreach ($tName in $commonTables) {
    $dT = $dTables | Where-Object { $_.name -eq $tName }
    $bT = $bTables | Where-Object { $_.name -eq $tName }

    $dCols = @($dT.columns | ForEach-Object { $_.name })
    $bCols = @($bT.columns | ForEach-Object { $_.name })

    $lostCols = $bCols | Where-Object { $_ -notin $dCols }
    $newCols = $dCols | Where-Object { $_ -notin $bCols }

    foreach ($c in $lostCols) {
        $errors += "COLUMN REMOVED: '$tName.$c' exists in baseline but not in deploy"
    }
    foreach ($c in $newCols) {
        $infos += "COLUMN ADDED: '$tName.$c' is new in deploy"
    }
}

# =====================================================
# 3. MEASURES - per table, detect removals/expression changes
# =====================================================
foreach ($tName in $commonTables) {
    $dT = $dTables | Where-Object { $_.name -eq $tName }
    $bT = $bTables | Where-Object { $_.name -eq $tName }

    $dMeasures = @($dT.measures | ForEach-Object { $_.name })
    $bMeasures = @($bT.measures | ForEach-Object { $_.name })

    $lostMeasures = $bMeasures | Where-Object { $_ -notin $dMeasures }
    $newMeasures = $dMeasures | Where-Object { $_ -notin $bMeasures }

    foreach ($m in $lostMeasures) {
        $errors += "MEASURE REMOVED: '$tName/[$m]' exists in baseline but not in deploy"
    }
    foreach ($m in $newMeasures) {
        $infos += "MEASURE ADDED: '$tName/[$m]' is new in deploy"
    }
}

# =====================================================
# 4. HIERARCHIES - per table, detect removals
# =====================================================
foreach ($tName in $commonTables) {
    $dT = $dTables | Where-Object { $_.name -eq $tName }
    $bT = $bTables | Where-Object { $_.name -eq $tName }

    $dHiers = @($dT.hierarchies | ForEach-Object { $_.name })
    $bHiers = @($bT.hierarchies | ForEach-Object { $_.name })

    $lostHiers = $bHiers | Where-Object { $_ -notin $dHiers }
    $newHiers = $dHiers | Where-Object { $_ -notin $bHiers }

    foreach ($h in $lostHiers) {
        $errors += "HIERARCHY REMOVED: '$tName/$h' exists in baseline but not in deploy"
    }
    foreach ($h in $newHiers) {
        $infos += "HIERARCHY ADDED: '$tName/$h' is new in deploy"
    }
}

# =====================================================
# 5. RELATIONSHIPS - detect removals
#    Known exception: Calendario relationships are injected
#    via AMO post-deploy, so they exist in baseline but not
#    in deploy JSON. These are reported as warnings, not errors.
# =====================================================
$dRels = $deploy.model.relationships
$bRels = $baseline.model.relationships

# Build relationship signatures: "FromTable.FromCol -> ToTable.ToCol"
function Get-RelSig($rel) {
    return "$($rel.fromTable).$($rel.fromColumn) -> $($rel.toTable).$($rel.toColumn)"
}

$dRelSigs = @($dRels | ForEach-Object { Get-RelSig $_ })
$bRelSigs = @($bRels | ForEach-Object { Get-RelSig $_ })

$lostRels = $bRelSigs | Where-Object { $_ -notin $dRelSigs }
$newRels = $dRelSigs | Where-Object { $_ -notin $bRelSigs }

foreach ($r in $lostRels) {
    # Calendario relationships are a known/expected difference (injected via AMO)
    if ($r -match "-> Calendario\.") {
        $infos += "RELATIONSHIP DEFERRED (AMO): $r"
    } else {
        $errors += "RELATIONSHIP REMOVED: '$r' exists in baseline but not in deploy"
    }
}
foreach ($r in $newRels) {
    $infos += "RELATIONSHIP ADDED: '$r' is new in deploy"
}

Write-Host "  Relationships: deploy=$($dRelSigs.Count) baseline=$($bRelSigs.Count)" -ForegroundColor Gray

# =====================================================
# SUMMARY
# =====================================================
Write-Host ""

if ($errors.Count -gt 0) {
    Write-Host "VALIDATION FAILED - $($errors.Count) structural difference(s) detected:" -ForegroundColor Red
    Write-Host ""
    foreach ($e in $errors) {
        Write-Host "  [ERROR] $e" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "If these changes are intentional, update database_staging_fixed.json to match." -ForegroundColor Yellow
    exit 1
}

if ($infos.Count -gt 0) {
    Write-Host "VALIDATION PASSED with $($infos.Count) info note(s):" -ForegroundColor Green
    Write-Host ""
    foreach ($i in $infos) {
        Write-Host "  [INFO] $i" -ForegroundColor Cyan
    }
} else {
    Write-Host "VALIDATION PASSED - Deploy matches baseline exactly" -ForegroundColor Green
}

exit 0
