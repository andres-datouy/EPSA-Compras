# =====================================================
# Update date column format strings on existing SSAS model
# Only updates formatString property, no data reprocessing
# Target: 192.168.2.47:2383 / Compras_EPSA
# =====================================================

param(
    [string]$Server = "192.168.2.47:2383",
    [string]$Database = "Compras_EPSA"
)

$ErrorActionPreference = "Stop"

# --- Load AMO ---
$amoPaths = @(
    "$env:TEMP\amo_v2\lib\net8.0\Microsoft.AnalysisServices.Tabular.dll",
    "$env:TEMP\amo_v2\lib\net472\Microsoft.AnalysisServices.Tabular.dll",
    "$env:TEMP\amo_latest\lib\net45\Microsoft.AnalysisServices.Tabular.dll",
    "$env:ProgramFiles\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll",
    "$env:ProgramFiles\Microsoft SQL Server\160\Setup Bootstrap\SQL2022\x64\Microsoft.AnalysisServices.Tabular.DLL",
    "$env:ProgramFiles\Microsoft SQL Server\*\OLAP\bin\Microsoft.AnalysisServices.Tabular.dll",
    "$env:ProgramFiles\Microsoft SQL Server\*\SDK\Assemblies\Microsoft.AnalysisServices.Tabular.dll"
)

$loaded = $false
foreach ($pattern in $amoPaths) {
    $dll = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue |
        Sort-Object FullName -Descending | Select-Object -First 1
    if ($dll) {
        $amoDir = Split-Path $dll.FullName
        foreach ($dep in @("Microsoft.AnalysisServices.Core.dll","Microsoft.AnalysisServices.Tabular.dll","Microsoft.AnalysisServices.Tabular.Json.dll")) {
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
        $loaded = $true
    } catch {
        Write-Error "Cannot load AMO. Install SSAS AMO client."
        exit 1
    }
}

# --- Connect ---
Write-Host "Connecting to: $Server" -ForegroundColor Yellow
$ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
$ssas.Connect("Data Source=$Server")
Write-Host "Connected. Version: $($ssas.Version)" -ForegroundColor Green

$db = $ssas.Databases | Where-Object { $_.Name -eq $Database }
if (-not $db) {
    Write-Error "Database '$Database' not found on server."
    $ssas.Disconnect()
    exit 1
}
Write-Host "Database: $Database (Compatibility: $($db.CompatibilityLevel))" -ForegroundColor Green

# --- Date columns to update ---
$dateFixes = @(
    @{ Table = "Calendario";                          Column = "Fecha";                                    Format = "dd/MM/yyyy" },
    @{ Table = "DateAutoTemplate";                    Column = "Date";                                     Format = "dd/MM/yyyy" },
    @{ Table = "factConsumoHistoria";                 Column = "Consumo Fecha";                            Format = "dd/MM/yyyy" },
    @{ Table = "factComprasEnProceso";                Column = "CompraEP Fecha Ultima Modificacion";       Format = "dd/MM/yyyy" },
    @{ Table = "factComprasEnProceso";                Column = "CompraEP Ultima Fecha Entrega";            Format = "dd/MM/yyyy" },
    @{ Table = "factRecepcionesHistoria";             Column = "RecepcionFecha";                           Format = "dd/MM/yyyy" },
    @{ Table = "factRecepcionesHistoria";             Column = "OC Fecha";                                 Format = "dd/MM/yyyy" },
    @{ Table = "factRecepcionesHistoria";             Column = "SolicitudFecha";                           Format = "dd/MM/yyyy" },
    @{ Table = "factRecepcionesHistoria";             Column = "Compra Fecha";                             Format = "dd/MM/yyyy" },
    @{ Table = "factRecepcionesHistoria";             Column = "Compra Fecha Inicio Proceso Interno Desde Solicitud"; Format = "dd/MM/yyyy" },
        @{ Table = "factRecepcionesHistoria";             Column = "Compra Fecha Inicio Proceso Con Proveedor";        Format = "dd/MM/yyyy" },
    @{ Table = "factConsumoPlanificado";              Column = "Consumo Planificado Fecha Planificacion";  Format = "dd/MM/yyyy" },
    @{ Table = "factStockEPSA";                       Column = "Stock Fecha_Corte";                        Format = "dd/MM/yyyy" }
)

# Also fix measures
$measureFixes = @(
    @{ Table = "Medidas_Compras"; Measure = "Ultima Recepcion Fecha"; Format = "dd/MM/yyyy" }
)

$updated = 0
$errors = 0

# --- Update columns ---
foreach ($fix in $dateFixes) {
    $table = $db.Model.Tables | Where-Object { $_.Name -eq $fix.Table }
    if (-not $table) {
        Write-Host "  [SKIP] Table not found: $($fix.Table)" -ForegroundColor DarkYellow
        continue
    }
    $col = $table.Columns | Where-Object { $_.Name -eq $fix.Column }
    if (-not $col) {
        Write-Host "  [SKIP] Column not found: $($fix.Table).$($fix.Column)" -ForegroundColor DarkYellow
        continue
    }
    $oldFormat = $col.FormatString
    if ($oldFormat -eq $fix.Format) {
        Write-Host "  [OK]   $($fix.Table).$($fix.Column) already '$($fix.Format)'" -ForegroundColor Gray
        continue
    }
    $col.FormatString = $fix.Format
    Write-Host "  [FIX]  $($fix.Table).$($fix.Column): '$oldFormat' -> '$($fix.Format)'" -ForegroundColor Cyan
    $updated++
}

# --- Update measures ---
foreach ($fix in $measureFixes) {
    $table = $db.Model.Tables | Where-Object { $_.Name -eq $fix.Table }
    if (-not $table) {
        Write-Host "  [SKIP] Table not found: $($fix.Table)" -ForegroundColor DarkYellow
        continue
    }
    $measure = $table.Measures | Where-Object { $_.Name -eq $fix.Measure }
    if (-not $measure) {
        Write-Host "  [SKIP] Measure not found: $($fix.Table).$($fix.Measure)" -ForegroundColor DarkYellow
        continue
    }
    $oldFormat = $measure.FormatString
    if ($oldFormat -eq $fix.Format) {
        Write-Host "  [OK]   $($fix.Table).[$($fix.Measure)] already '$($fix.Format)'" -ForegroundColor Gray
        continue
    }
    $measure.FormatString = $fix.Format
    Write-Host "  [FIX]  $($fix.Table).[$($fix.Measure)]: '$oldFormat' -> '$($fix.Format)'" -ForegroundColor Cyan
    $updated++
}

# --- Save changes ---
if ($updated -gt 0) {
    Write-Host ""
    Write-Host "Saving $updated changes to SSAS..." -ForegroundColor Yellow
    try {
        $db.Model.SaveChanges()
        Write-Host "Changes saved successfully!" -ForegroundColor Green
    } catch {
        Write-Error "Failed to save changes: $_"
        $errors++
    }
} else {
    Write-Host ""
    Write-Host "No changes needed - all formats already correct." -ForegroundColor Green
}

$ssas.Disconnect()

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Updated: $updated columns/measures"
Write-Host "Errors:  $errors"
Write-Host ""

if ($errors -gt 0) { exit 1 }
