# build_excel.ps1 - Assemble final Excel with 3 sheets using ImportExcel (PowerShell 7)
# Sheet 1: StockMin > 0 (not pt/prvta) - from CSV
# Sheet 2: Foreign + Active Consumption - from CSV
# Sheet 3: Rosana's 329 articles with cross-reference columns

Import-Module ImportExcel -ErrorAction Stop

$baseDir = "d:\Andres\Dev\EPSA-Compras\docs\deliverables"
$excelSource = "d:\Andres\Dev\EPSA-Compras\docs\excel\Pedidos a exterior 2026.04.09.xlsx"
$outputFile = Join-Path $baseDir "EPSA_Compras_Exterior_Conciliacion.xlsx"

# Remove existing file
if (Test-Path $outputFile) { Remove-Item $outputFile -Force }

Write-Host "Reading CSVs..."
$sheet1Data = Import-Csv (Join-Path $baseDir "sheet1_stockmin.csv")
$sheet2Data = Import-Csv (Join-Path $baseDir "sheet2_foreign.csv")

Write-Host "Sheet 1 rows: $($sheet1Data.Count)"
Write-Host "Sheet 2 rows: $($sheet2Data.Count)"

# Build lookup sets for cross-reference
$codesSheet1 = @{}
foreach ($row in $sheet1Data) { $codesSheet1[$row.Codigo] = $true }

$codesSheet2 = @{}
foreach ($row in $sheet2Data) { $codesSheet2[$row.Codigo] = $true }

# Read Rosana's Excel (sheet 1)
Write-Host "Reading Rosana's Excel..."
$rosanaData = Import-Excel -Path $excelSource -WorksheetName (Get-ExcelSheetInfo $excelSource)[0].Name

# Identify the article code column in Rosana's Excel
$firstRow = $rosanaData[0]
$props = $firstRow.PSObject.Properties.Name
Write-Host "Rosana Excel columns: $($props -join ', ')"

# Find the code column (likely contains numeric codes)
$codeCol = $null
foreach ($p in $props) {
    $val = "$($firstRow.$p)"
    if ($val -match '^\d{6,}') {
        $codeCol = $p
        break
    }
}

if (-not $codeCol) {
    # Fallback: try common names
    $candidates = @("Codigo", "Código", "cod_articulo", "Articulo", "ARTICULO", "Art")
    foreach ($c in $candidates) {
        if ($c -in $props) { $codeCol = $c; break }
    }
}

if (-not $codeCol) {
    Write-Host "WARNING: Could not identify code column. Using first column: $($props[0])"
    $codeCol = $props[0]
}

Write-Host "Using code column: $codeCol"
Write-Host "Rosana Excel rows: $($rosanaData.Count)"

# Add cross-reference columns to Rosana's data
$sheet3Data = foreach ($row in $rosanaData) {
    $code = "$($row.$codeCol)".Trim()
    $inStockMin = if ($codesSheet1.ContainsKey($code)) { "SI" } else { "NO" }
    $inForeign = if ($codesSheet2.ContainsKey($code)) { "SI" } else { "NO" }
    
    $row | Add-Member -NotePropertyName "En_StockMin_NoPtPrvta" -NotePropertyValue $inStockMin -PassThru -Force |
           Add-Member -NotePropertyName "En_Foreign_Consumption" -NotePropertyValue $inForeign -PassThru -Force
}

$sheet3Array = @($sheet3Data)
Write-Host "Sheet 3 rows: $($sheet3Array.Count)"

# Count cross-references
$inBoth = ($sheet3Array | Where-Object { $_.En_StockMin_NoPtPrvta -eq "SI" -and $_.En_Foreign_Consumption -eq "SI" }).Count
$inS1Only = ($sheet3Array | Where-Object { $_.En_StockMin_NoPtPrvta -eq "SI" }).Count
$inS2Only = ($sheet3Array | Where-Object { $_.En_Foreign_Consumption -eq "SI" }).Count
Write-Host "Cross-ref: In StockMin=$inS1Only, In Foreign=$inS2Only, In Both=$inBoth"

# Export Sheet 1
Write-Host "Writing Sheet 1..."
$sheet1Data | Export-Excel -Path $outputFile -WorksheetName "StockMin_NoPtPrvta" -AutoSize -FreezeTopRow -BoldTopRow -TableName "StockMin"

# Export Sheet 2
Write-Host "Writing Sheet 2..."
$sheet2Data | Export-Excel -Path $outputFile -WorksheetName "Foreign_Consumption" -AutoSize -FreezeTopRow -BoldTopRow -TableName "Foreign"

# Export Sheet 3
Write-Host "Writing Sheet 3..."
$sheet3Array | Export-Excel -Path $outputFile -WorksheetName "Excel329_Rosana" -AutoSize -FreezeTopRow -BoldTopRow -TableName "Rosana329"

Write-Host "`nDone! Output: $outputFile"
$fi = Get-Item $outputFile
Write-Host "File size: $([math]::Round($fi.Length/1KB, 1)) KB"
