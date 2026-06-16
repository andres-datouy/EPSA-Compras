# init_perfil_prdimport.ps1
# Initializes articulo_perfil_compra table for PrdImport profile
# Combines 6 criteria into a single deduplicated INSERT script
# Must run with: powershell.exe -ExecutionPolicy Bypass -File init_perfil_prdimport.ps1

$ErrorActionPreference = "Stop"
$projectRoot = "d:\Andres\Dev\EPSA-Compras"
$outputDir = "$projectRoot\docs\deliverables"
$outputSQL = "$projectRoot\scripts\sql\INSERT_articulo_perfil_compra_PrdImport.sql"

# Ensure output dirs exist
if (-not (Test-Path "$projectRoot\scripts\sql")) { New-Item -ItemType Directory -Path "$projectRoot\scripts\sql" -Force | Out-Null }

#region ADOMD Connection
Write-Host "=== Connecting to Power BI Model ===" -ForegroundColor Cyan
Add-Type -Path "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_15.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"

$connStr = "Data Source=localhost:63515;Catalog=''"
$conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($connStr)
$conn.Open()
Write-Host "  Connected to Power BI Desktop" -ForegroundColor Green

function Invoke-Dax {
    param([string]$Query)
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $Query
    $reader = $cmd.ExecuteReader()
    $results = @()
    while ($reader.Read()) {
        $row = @()
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $row += $reader.GetValue($i)
        }
        $results += ,@($row)
    }
    $reader.Close()
    return $results
}
#endregion

#region Criterion 1: Rosana's Excel (328 articles)
Write-Host "`n=== Criterion 1: Rosana's Excel ===" -ForegroundColor Yellow
$rosanaCsv = "$outputDir\sheet2_foreign.csv"  # We'll use Rosana's actual Excel
# Read Rosana's Excel codes from the deliverables
$rosanaExcelPath = "$projectRoot\docs\excel\Pedidos a exterior 2026.04.09.xlsx"
# Use COM to get article codes
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$wb = $excel.Workbooks.Open($rosanaExcelPath)
$ws = $wb.Sheets.Item(1)
$lastRow = $ws.UsedRange.Rows.Count
$rosanaCodes = @()
# Column B = Codigo (based on previous analysis)
for ($r = 2; $r -le $lastRow; $r++) {
    $val = $ws.Cells.Item($r, 2).Text.Trim()
    if ($val -match '^\d{6,}') { $rosanaCodes += $val }
}
$wb.Close($false)
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
Write-Host "  Rosana Excel: $($rosanaCodes.Count) articles" -ForegroundColor Green
#endregion

#region Criterion 2: Foreign + Active Consumption (737) - from existing CSV
Write-Host "`n=== Criterion 2: Foreign + Consumption ===" -ForegroundColor Yellow
$foreignCsv = "$outputDir\sheet2_foreign.csv"
if (Test-Path $foreignCsv) {
    $foreignData = Import-Csv $foreignCsv
    $foreignCodes = @($foreignData | ForEach-Object { $_.Codigo.Trim() })
} else {
    # Fallback DAX query
    $dax2 = @"
EVALUATE
SUMMARIZECOLUMNS(
    'dimArticulo'[Artículo Código],
    FILTER(ALL('dimArticulo'), 'dimArticulo'[ProveedorPais] <> "UY" && 'dimArticulo'[ProveedorPais] <> ""),
    "Consumo", CALCULATE(SUM(factConsumoHistoria[Consumo Cantidad]))
)
"@
    $dt2 = Invoke-Dax $dax2
    $foreignCodes = @()
    foreach ($row in $dt2.Rows) {
        if ([double]$row[1] -ne 0) { $foreignCodes += $row[0].ToString().Trim() }
    }
}
Write-Host "  Foreign + Consumption: $($foreignCodes.Count) articles" -ForegroundColor Green
#endregion

#region Criterion 3: Stock Minimo > 0 - from existing CSV
Write-Host "`n=== Criterion 3: Stock Minimo > 0 ===" -ForegroundColor Yellow
$stockMinCsv = "$outputDir\sheet1_stockmin.csv"
if (Test-Path $stockMinCsv) {
    $stockMinData = Import-Csv $stockMinCsv
    $stockMinCodes = @($stockMinData | ForEach-Object { $_.Codigo.Trim() })
} else {
    $dax3 = @"
EVALUATE
SUMMARIZECOLUMNS(
    'dimArticulo'[Artículo Código],
    FILTER(ALL('dimArticulo'), 'dimArticulo'[Artículo Stock Mínimo] > 0 && 'dimArticulo'[Tipo Artículo Código] <> "bienuso")
)
"@
    $dt3 = Invoke-Dax $dax3
    $stockMinCodes = @()
    foreach ($row in $dt3.Rows) { $stockMinCodes += $row[0].ToString().Trim() }
}
Write-Host "  Stock Minimo > 0: $($stockMinCodes.Count) articles" -ForegroundColor Green
#endregion

#region Criterion 4: Production formula components (since 2025)
Write-Host "`n=== Criterion 4: Production Formula Components ===" -ForegroundColor Yellow
$dax4 = @"
EVALUATE
SUMMARIZECOLUMNS(
    'dimArticulo'[Artículo Código],
    FILTER(ALL('factConsumoPlanificado'),
        'factConsumoPlanificado'[Consumo Planificado Fecha Planificacion] >= DATE(2025,1,1))
)
"@
$rows4 = Invoke-Dax $dax4
$formulaCodes = @()
foreach ($row in $rows4) { $formulaCodes += $row[0].ToString().Trim() }
Write-Host "  Formula Components (2025+): $($formulaCodes.Count) articles" -ForegroundColor Green
#endregion

#region Criterion 5: Imported spare parts/supplies with StockMin
Write-Host "`n=== Criterion 5: Imported Spare Parts/Supplies with StockMin ===" -ForegroundColor Yellow
$dax5 = @"
EVALUATE
VAR _arts = SUMMARIZE(
    FILTER(factConsumoHistoria, factConsumoHistoria[Consumo Fecha] >= DATE(2024,1,1)),
    'dimArticulo'[Artículo Código],
    'dimArticulo'[ProveedorPais],
    'dimArticulo'[Tipo Artículo Código],
    'dimArticulo'[Artículo Stock Mínimo]
)
RETURN
SELECTCOLUMNS(
    FILTER(_arts,
        'dimArticulo'[ProveedorPais] <> "UY" && 'dimArticulo'[ProveedorPais] <> ""
        && 'dimArticulo'[Tipo Artículo Código] IN {"rep", "consu", "herr"}
        && 'dimArticulo'[Artículo Stock Mínimo] > 0
    ),
    "Codigo", 'dimArticulo'[Artículo Código]
)
"@
$rows5 = Invoke-Dax $dax5
$spareCodes = @()
foreach ($row in $rows5) { $spareCodes += $row[0].ToString().Trim() }
Write-Host "  Imported Spares/Supplies with StockMin: $($spareCodes.Count) articles" -ForegroundColor Green
#endregion

#region Criterion 6: Imported production consumables with frequent consumption
Write-Host "`n=== Criterion 6: Imported Production Consumables ===" -ForegroundColor Yellow
$dax6 = @"
EVALUATE
VAR _arts = SUMMARIZE(
    FILTER(factConsumoHistoria,
        factConsumoHistoria[Consumo Fecha] >= DATE(2024,1,1)
        && factConsumoHistoria[Consumo Formulario] IN {
            "TprdEntregaSoli2", "TprdEntregaSoli1", "TprdConsMat",
            "TprdOrden", "TprdConsumoMat"
        }
    ),
    'dimArticulo'[Artículo Código],
    'dimArticulo'[ProveedorPais],
    'dimArticulo'[Tipo Artículo Código],
    'dimArticulo'[Clase Nombre]
)
RETURN
SELECTCOLUMNS(
    FILTER(_arts,
        'dimArticulo'[ProveedorPais] <> "UY" && 'dimArticulo'[ProveedorPais] <> ""
        && 'dimArticulo'[Tipo Artículo Código] IN {"consu", "herr"}
        && NOT('dimArticulo'[Clase Nombre] IN {
            "REPUESTOS BOMBAS", "Insumo para mantenimiento",
            "Repuestos", "REP MOTORES&MAQUINAS"
        })
    ),
    "Codigo", 'dimArticulo'[Artículo Código]
)
"@
$rows6 = Invoke-Dax $dax6
$consuCodes = @()
foreach ($row in $rows6) { $consuCodes += $row[0].ToString().Trim() }
Write-Host "  Imported Production Consumables: $($consuCodes.Count) articles" -ForegroundColor Green
#endregion

#region Close connection
$conn.Close()
Write-Host "`n  ADOMD Connection closed" -ForegroundColor Gray
#endregion

#region Combine and deduplicate with source tags
Write-Host "`n=== Combining All Criteria ===" -ForegroundColor Cyan

# Build a hashtable: code -> list of criteria met
$allArticles = @{}

foreach ($code in $rosanaCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    $allArticles[$code] += "Excel"
}
foreach ($code in $foreignCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    if ("Foreign" -notin $allArticles[$code]) { $allArticles[$code] += "Foreign" }
}
foreach ($code in $stockMinCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    if ("StockMin" -notin $allArticles[$code]) { $allArticles[$code] += "StockMin" }
}
foreach ($code in $formulaCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    if ("Formula" -notin $allArticles[$code]) { $allArticles[$code] += "Formula" }
}
foreach ($code in $spareCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    if ("RepStkMin" -notin $allArticles[$code]) { $allArticles[$code] += "RepStkMin" }
}
foreach ($code in $consuCodes) {
    if (-not $allArticles.ContainsKey($code)) { $allArticles[$code] = @() }
    if ("ConsuProd" -notin $allArticles[$code]) { $allArticles[$code] += "ConsuProd" }
}

Write-Host "  Total unique articles: $($allArticles.Count)" -ForegroundColor Green

# Stats
$stats = @{Excel=0; Foreign=0; StockMin=0; Formula=0; RepStkMin=0; ConsuProd=0}
foreach ($tags in $allArticles.Values) {
    foreach ($t in $tags) { $stats[$t]++ }
}
Write-Host "  Breakdown:" -ForegroundColor Gray
foreach ($k in $stats.Keys | Sort-Object) { Write-Host "    $k : $($stats[$k])" }
#endregion

#region Generate SQL INSERT script
Write-Host "`n=== Generating SQL INSERT ===" -ForegroundColor Cyan

$today = Get-Date -Format "yyyy-MM-dd"
$sqlLines = @()
$sqlLines += "-- ==================================================================="
$sqlLines += "-- INSERT articulo_perfil_compra for profile PrdImport"
$sqlLines += "-- Generated: $today"
$sqlLines += "-- Total articles: $($allArticles.Count)"
$sqlLines += "-- Criteria: Excel($($stats['Excel'])), Foreign($($stats['Foreign'])), StockMin($($stats['StockMin'])), Formula($($stats['Formula'])), RepStkMin($($stats['RepStkMin'])), ConsuProd($($stats['ConsuProd']))"
$sqlLines += "-- ==================================================================="
$sqlLines += ""
$sqlLines += "BEGIN TRANSACTION;"
$sqlLines += ""
$sqlLines += "-- Delete existing PrdImport assignments (clean reload)"
$sqlLines += "DELETE FROM articulo_perfil_compra WHERE cod_emp = 'EPSA' AND perfil_compra_id = 'PrdImport';"
$sqlLines += ""

$lineNum = 0
foreach ($entry in $allArticles.GetEnumerator() | Sort-Object Key) {
    $lineNum++
    $code = $entry.Key
    $tags = ($entry.Value -join ",")
    $obs = "Crit: $tags"
    if ($obs.Length -gt 100) { $obs = $obs.Substring(0, 100) }
    
    $sqlLines += "INSERT INTO articulo_perfil_compra (cod_emp, cod_articulo, perfil_compra_id, activo, observacion, formulario, seccion, bloque, linea, usuario_mod, fecha_mod, terminal_mod, operacion_mod, estado_registro)"
    $sqlLines += "VALUES ('EPSA', '$code', 'PrdImport', 'S', '$obs', 'FrmArtPrf', 'General', '', $lineNum, 'batch', '$today', 'SRV', 'alta_batch', 'A');"
}

$sqlLines += ""
$sqlLines += "COMMIT;"
$sqlLines += ""
$sqlLines += "-- Verify"
$sqlLines += "SELECT COUNT(*) AS TotalInserted FROM articulo_perfil_compra WHERE cod_emp = 'EPSA' AND perfil_compra_id = 'PrdImport' AND activo = 'S';"

# Write SQL file
$sqlContent = $sqlLines -join "`r`n"
[System.IO.File]::WriteAllText($outputSQL, $sqlContent, [System.Text.Encoding]::UTF8)
Write-Host "  SQL script: $outputSQL" -ForegroundColor Green
Write-Host "  Total INSERT statements: $($allArticles.Count)" -ForegroundColor Green

# Also export summary CSV for reference
$summaryPath = "$outputDir\perfil_prdimport_articles.csv"
$summaryData = foreach ($entry in $allArticles.GetEnumerator() | Sort-Object Key) {
    [PSCustomObject]@{
        Codigo = $entry.Key
        Criterios = ($entry.Value -join ",")
        CantCriterios = $entry.Value.Count
    }
}
$summaryData | Export-Csv -Path $summaryPath -NoTypeInformation -Encoding UTF8
Write-Host "  Summary CSV: $summaryPath" -ForegroundColor Green
#endregion

Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "  Unique articles for PrdImport: $($allArticles.Count)"
Write-Host "  SQL file ready at: $outputSQL"
Write-Host "  Review and execute in SQL Server when ready."
