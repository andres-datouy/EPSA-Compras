# =====================================================
# Validate SSAS Model JSON before deployment
# Checks that critical structural elements are present
# to prevent accidental loss of approved changes.
# =====================================================

param(
    [string]$ModelFile = "$PSScriptRoot\..\..\model\database_staging.json",
    [switch]$Strict = $false  # Also check Calendario relationships (not expected in deploy JSON)
)

$ErrorActionPreference = "Stop"
$errors = @()
$warnings = @()

Write-Host "Validating model: $ModelFile" -ForegroundColor Yellow

if (-not (Test-Path $ModelFile)) {
    Write-Error "Model file not found: $ModelFile"
    exit 1
}

$json = Get-Content $ModelFile -Raw -Encoding UTF8
$model = $json | ConvertFrom-Json

# --- Required tables ---
$requiredTables = @(
    "factConsumoHistoria", "dimArticulo", "factStockEPSA",
    "factConsumoPlanificado", "factDemandaPendientePlanificacion",
    "factRecepcionesHistoria", "dimProveedor", "factComprasEnProceso",
    "Calendario", "Medidas_Stock", "Medidas_Consumo",
    "Medidas_Consumo_Planificado", "Medidas_DemandaPendiente", "Medidas_Compras"
)

$tableNames = $model.model.tables | ForEach-Object { $_.name }
foreach ($t in $requiredTables) {
    if ($t -notin $tableNames) {
        $errors += "MISSING TABLE: $t"
    }
}
Write-Host "  Tables: $($tableNames.Count) found, $($requiredTables.Count) required" -ForegroundColor Gray

# --- Required hierarchies on Calendario ---
$calTable = $model.model.tables | Where-Object { $_.name -eq "Calendario" }
$requiredHierarchies = @("Fiscal Year-Quarter", "Fiscal Year-Month")

if ($calTable.hierarchies) {
    $hierNames = $calTable.hierarchies | ForEach-Object { $_.name }
    foreach ($h in $requiredHierarchies) {
        if ($h -notin $hierNames) {
            $errors += "MISSING HIERARCHY: Calendario/$h"
        }
    }
    Write-Host "  Hierarchies: $($hierNames.Count) found ($($hierNames -join ', '))" -ForegroundColor Gray
} else {
    $errors += "MISSING HIERARCHIES: Calendario has no hierarchies defined"
}

# --- Required relationships (base only, Calendario rels injected via AMO) ---
$requiredRels = @(
    @{ From="factConsumoHistoria"; FromCol=$null; To="dimArticulo" },
    @{ From="factStockEPSA"; FromCol=$null; To="dimArticulo" },
    @{ From="factConsumoPlanificado"; FromCol=$null; To="dimArticulo" },
    @{ From="factDemandaPendientePlanificacion"; FromCol=$null; To="dimArticulo" },
    @{ From="factRecepcionesHistoria"; FromCol=$null; To="dimArticulo" },
    @{ From="factRecepcionesHistoria"; FromCol=$null; To="dimProveedor" },
    @{ From="factComprasEnProceso"; FromCol=$null; To="dimArticulo" }
)

$rels = $model.model.relationships
$relCount = if ($rels) { $rels.Count } else { 0 }
Write-Host "  Relationships: $relCount found" -ForegroundColor Gray

foreach ($rr in $requiredRels) {
    $found = $false
    foreach ($r in $rels) {
        if ($r.fromTable -eq $rr.From -and $r.toTable -eq $rr.To) {
            if ($rr.FromCol -and $r.fromColumn -ne $rr.FromCol) { continue }
            $found = $true
            break
        }
    }
    if (-not $found) {
        $colInfo = if ($rr.FromCol) { " ($($rr.FromCol))" } else { "" }
        $errors += "MISSING RELATIONSHIP: $($rr.From)$colInfo -> $($rr.To)"
    }
}

# --- Critical measure check ---
$consumoTable = $model.model.tables | Where-Object { $_.name -eq "Medidas_Consumo" }
$sumatoriaMeasure = $consumoTable.measures | Where-Object { $_.name -eq "Sumatoria Movs Consumo Sin Recepciones" }
if ($sumatoriaMeasure) {
    if ($sumatoriaMeasure.expression -notmatch '\+ 0') {
        $warnings += "MEASURE: 'Sumatoria Movs Consumo Sin Recepciones' missing '+ 0' (should return 0 instead of BLANK)"
    }
    Write-Host "  Measure 'Sumatoria Movs': found" -ForegroundColor Gray
} else {
    $errors += "MISSING MEASURE: Medidas_Consumo/Sumatoria Movs Consumo Sin Recepciones"
}

# --- Calendario relationships check (always warn - injected via AMO) ---
$calRels = $rels | Where-Object { $_.toTable -eq "Calendario" }
$expectedCalRels = 4
if ($calRels.Count -lt $expectedCalRels) {
    $warnings += "CALENDARIO RELS: $($calRels.Count)/$expectedCalRels Calendario relationships in JSON (remaining injected via AMO post-deploy)"
}

# --- Summary ---
Write-Host ""
if ($errors.Count -gt 0) {
    Write-Host "VALIDATION FAILED - $($errors.Count) error(s):" -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host "  [ERROR] $e" -ForegroundColor Red
    }
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host "VALIDATION PASSED with $($warnings.Count) warning(s):" -ForegroundColor Yellow
    foreach ($w in $warnings) {
        Write-Host "  [WARN] $w" -ForegroundColor Yellow
    }
} else {
    Write-Host "VALIDATION PASSED - All checks OK" -ForegroundColor Green
}

exit 0
