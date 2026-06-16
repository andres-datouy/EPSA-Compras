# generate_deliverables.ps1
# Generates Excel (3 sheets) and Word documents for team session
# Requires: ImportExcel module

#region Setup
$ErrorActionPreference = "Stop"
$projectRoot = "d:\Andres\Dev\EPSA-Compras"
$outputDir = "$projectRoot\docs\deliverables"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

# Install ImportExcel if needed
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "Installing ImportExcel module..." -ForegroundColor Yellow
    Install-Module ImportExcel -Force -Scope CurrentUser
}
Import-Module ImportExcel

#endregion

#region Data Sources - CSV paths from Power BI MCP queries
$csvSheet1 = "C:\Users\Andres\AppData\Local\Temp\PowerBIModelingMCP\QueryResults\dax_query_result_20260525_121857_085.csv"
$csvSheet2 = "C:\Users\Andres\AppData\Local\Temp\PowerBIModelingMCP\QueryResults\dax_query_result_20260525_121918_349.csv"
$excelRosana = "$projectRoot\docs\excel\Pedidos a exterior 2026.04.09.xlsx"

# Verify files exist
foreach ($f in @($csvSheet1, $csvSheet2, $excelRosana)) {
    if (-not (Test-Path $f)) { Write-Warning "File not found: $f" }
}
#endregion

#region Sheet 1: Stock Minimo > 0, not pt/prvta (729 articles)
Write-Host "`n=== Sheet 1: Stock Minimo (729 articles) ===" -ForegroundColor Cyan

$dataSheet1 = Import-Csv -Path $csvSheet1 | Select-Object @(
    @{N='Codigo';E={$_.'dimArticulo[Artículo Código]'}},
    @{N='Nombre';E={$_.'dimArticulo[Artículo Nombre]'}},
    @{N='TipoArticulo';E={$_.'dimArticulo[Tipo Artículo Código]'}},
    @{N='Clase';E={$_.'dimArticulo[Clase Nombre]'}},
    @{N='TipoComponente';E={$_.'dimArticulo[TipoComponente]'}},
    @{N='Proveedor';E={$_.'dimArticulo[Proveedor Nombre]'}},
    @{N='ProveedorPais';E={$_.'dimArticulo[ProveedorPais]'}},
    @{N='StockMinimo';E={[double]$_.'dimArticulo[Artículo Stock Mínimo]'}},
    @{N='Plazo';E={$_.'dimArticulo[plazo]'}},
    @{N='UnidadStock';E={$_.'dimArticulo[Unidad Stock]'}},
    @{N='ConsumoPromedio';E={if($_.'[ConsumoPromedio]'){[math]::Round([double]$_.'[ConsumoPromedio]',2)}else{$null}}},
    @{N='StockExistencia';E={if($_.'[StockExistencia]'){[math]::Round([double]$_.'[StockExistencia]',2)}else{$null}}},
    @{N='AlertaCobertura';E={$_.'[AlertaCobertura]'}},
    @{N='CoberturaMeses';E={if($_.'[CoberturaMeses]'){[math]::Round([double]$_.'[CoberturaMeses]',1)}else{$null}}}
)
Write-Host "  Loaded $($dataSheet1.Count) articles" -ForegroundColor Green
#endregion

#region Sheet 2: Foreign + Active Consumption (737 articles)
Write-Host "`n=== Sheet 2: Foreign + Consumo Activo (737 articles) ===" -ForegroundColor Cyan

$dataSheet2 = Import-Csv -Path $csvSheet2 | Select-Object @(
    @{N='Codigo';E={$_.'dimArticulo[Artículo Código]'}},
    @{N='Nombre';E={$_.'dimArticulo[Artículo Nombre]'}},
    @{N='TipoArticulo';E={$_.'dimArticulo[Tipo Artículo Código]'}},
    @{N='Clase';E={$_.'dimArticulo[Clase Nombre]'}},
    @{N='TipoComponente';E={$_.'dimArticulo[TipoComponente]'}},
    @{N='Proveedor';E={$_.'dimArticulo[Proveedor Nombre]'}},
    @{N='ProveedorPais';E={$_.'dimArticulo[ProveedorPais]'}},
    @{N='StockMinimo';E={[double]$_.'dimArticulo[Artículo Stock Mínimo]'}},
    @{N='Plazo';E={$_.'dimArticulo[plazo]'}},
    @{N='UnidadStock';E={$_.'dimArticulo[Unidad Stock]'}},
    @{N='ConsumoPromedio';E={if($_.'[ConsumoPromedio]'){[math]::Round([double]$_.'[ConsumoPromedio]',2)}else{$null}}},
    @{N='StockExistencia';E={if($_.'[StockExistencia]'){[math]::Round([double]$_.'[StockExistencia]',2)}else{$null}}},
    @{N='AlertaCobertura';E={$_.'[AlertaCobertura]'}},
    @{N='CoberturaMeses';E={if($_.'[CoberturaMeses]'){[math]::Round([double]$_.'[CoberturaMeses]',1)}else{$null}}}
)
Write-Host "  Loaded $($dataSheet2.Count) articles" -ForegroundColor Green
#endregion

#region Sheet 3: Rosana's Excel (329 articles) with category columns
Write-Host "`n=== Sheet 3: Excel Rosana (329 articles) ===" -ForegroundColor Cyan

# Read first sheet ("actual") from Rosana's Excel
$rosanaData = Import-Excel -Path $excelRosana -WorksheetName "actual"

# Get article codes from sheets 1 and 2 for cross-reference
$codesSheet1 = @{}
$dataSheet1 | ForEach-Object { $codesSheet1[$_.Codigo] = $true }
$codesSheet2 = @{}
$dataSheet2 | ForEach-Object { $codesSheet2[$_.Codigo] = $true }

# Add cross-reference columns - detect the article code column name
$codeColName = ($rosanaData[0].PSObject.Properties | Where-Object { $_.Name -match 'cod|codigo|art' } | Select-Object -First 1).Name
if (-not $codeColName) {
    # Try to find it by checking column names
    $codeColName = ($rosanaData[0].PSObject.Properties.Name | Where-Object { $_ -match 'cod|Cod|COD' } | Select-Object -First 1)
}
Write-Host "  Using article code column: '$codeColName'" -ForegroundColor Yellow
Write-Host "  Loaded $($rosanaData.Count) rows from Rosana's Excel" -ForegroundColor Green

# Add category flags
$dataSheet3 = $rosanaData | Select-Object *, @{
    N='En_StockMinimo_729'
    E={
        $code = $_.$codeColName
        if ($code -and $codesSheet1.ContainsKey($code.ToString().Trim())) { "SI" } else { "NO" }
    }
}, @{
    N='En_Foreign_Consumo_737'
    E={
        $code = $_.$codeColName
        if ($code -and $codesSheet2.ContainsKey($code.ToString().Trim())) { "SI" } else { "NO" }
    }
}
#endregion

#region Generate Excel
$excelPath = "$outputDir\EPSA_Compras_Exterior_Conciliacion.xlsx"
Write-Host "`n=== Generating Excel: $excelPath ===" -ForegroundColor Cyan

# Remove existing file
if (Test-Path $excelPath) { Remove-Item $excelPath -Force }

# Sheet 1
$dataSheet1 | Export-Excel -Path $excelPath -WorksheetName "StockMin_729" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium2

# Sheet 2
$dataSheet2 | Export-Excel -Path $excelPath -WorksheetName "Foreign_Consumo_737" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium6

# Sheet 3
$dataSheet3 | Export-Excel -Path $excelPath -WorksheetName "Excel_Rosana_329" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium9

Write-Host "  Excel generated successfully!" -ForegroundColor Green
#endregion

#region Generate Word Documents using pandoc (if available) or simple HTML->Word
Write-Host "`n=== Generating Word Documents ===" -ForegroundColor Cyan

$mdFiles = @(
    @{ Source = "$projectRoot\docs\propuesta_alcance_monitoreo.md"; Output = "$outputDir\Propuesta_Alcance_Monitoreo.docx" },
    @{ Source = "$projectRoot\docs\reglas_negocio_compras_exterior.md"; Output = "$outputDir\Reglas_Negocio_Compras_Exterior.docx" }
)

# Check if pandoc is available
$pandocAvailable = Get-Command pandoc -ErrorAction SilentlyContinue

if ($pandocAvailable) {
    foreach ($doc in $mdFiles) {
        Write-Host "  Converting: $($doc.Source | Split-Path -Leaf)" -ForegroundColor Yellow
        pandoc $doc.Source -o $doc.Output --from markdown --to docx --reference-doc="" 2>$null
        if (-not $?) {
            # Try without reference-doc
            pandoc $doc.Source -o $doc.Output --from markdown --to docx
        }
        Write-Host "    -> $($doc.Output | Split-Path -Leaf)" -ForegroundColor Green
    }
} else {
    Write-Host "  pandoc not found. Attempting Word COM automation..." -ForegroundColor Yellow
    
    try {
        $word = New-Object -ComObject Word.Application
        $word.Visible = $false
        
        foreach ($doc in $mdFiles) {
            Write-Host "  Converting: $($doc.Source | Split-Path -Leaf)" -ForegroundColor Yellow
            
            # Read markdown content
            $mdContent = Get-Content -Path $doc.Source -Raw -Encoding UTF8
            
            # Create a temp HTML file (Word can open HTML)
            $tempHtml = [System.IO.Path]::GetTempFileName() + ".html"
            
            # Simple markdown to HTML conversion
            $html = "<html><head><meta charset='utf-8'><style>body{font-family:Calibri;font-size:11pt} table{border-collapse:collapse;width:100%} th,td{border:1px solid #ddd;padding:6px;text-align:left} th{background-color:#4472C4;color:white} h1{color:#2F5496} h2{color:#2F5496} h3{color:#4472C4} code{background-color:#f4f4f4;padding:2px 4px;font-family:Consolas}</style></head><body>"
            
            # Basic markdown conversion
            $lines = $mdContent -split "`n"
            $inTable = $false
            $inCode = $false
            
            foreach ($line in $lines) {
                if ($line -match '^```') {
                    if ($inCode) { $html += "</pre>"; $inCode = $false }
                    else { $html += "<pre style='background:#f4f4f4;padding:10px;'>"; $inCode = $true }
                    continue
                }
                if ($inCode) { $html += "$line`n"; continue }
                
                if ($line -match '^\|.*\|$') {
                    if (-not $inTable) { $html += "<table>"; $inTable = $true }
                    if ($line -match '^\|[-: |]+\|$') { continue }  # Skip separator
                    $cells = ($line -split '\|' | Where-Object { $_ -ne '' }) | ForEach-Object { $_.Trim() }
                    $tag = if ($html -notmatch '<tr>') { "th" } else { "td" }
                    $html += "<tr>" + ($cells | ForEach-Object { "<$tag>$_</$tag>" }) -join '' + "</tr>"
                    continue
                } elseif ($inTable) {
                    $html += "</table>"; $inTable = $false
                }
                
                if ($line -match '^### (.+)') { $html += "<h3>$($Matches[1])</h3>" }
                elseif ($line -match '^## (.+)') { $html += "<h2>$($Matches[1])</h2>" }
                elseif ($line -match '^# (.+)') { $html += "<h1>$($Matches[1])</h1>" }
                elseif ($line -match '^- \[.\] (.+)') { $html += "<p>&#9744; $($Matches[1])</p>" }
                elseif ($line -match '^- (.+)') { $html += "<li>$($Matches[1])</li>" }
                elseif ($line -match '^> (.+)') { $html += "<blockquote style='border-left:3px solid #4472C4;padding-left:10px;color:#666'>$($Matches[1])</blockquote>" }
                elseif ($line -match '^\*\*(.+)\*\*') { $html += "<p><strong>$($Matches[1])</strong></p>" }
                elseif ($line.Trim() -eq '---') { $html += "<hr>" }
                elseif ($line.Trim() -ne '') { $html += "<p>$line</p>" }
            }
            if ($inTable) { $html += "</table>" }
            $html += "</body></html>"
            
            Set-Content -Path $tempHtml -Value $html -Encoding UTF8
            
            # Open in Word and save as docx
            $wordDoc = $word.Documents.Open($tempHtml)
            $wordDoc.SaveAs2($doc.Output, 16)  # 16 = wdFormatDocumentDefault (.docx)
            $wordDoc.Close()
            Remove-Item $tempHtml -Force
            
            Write-Host "    -> $($doc.Output | Split-Path -Leaf)" -ForegroundColor Green
        }
        
        $word.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
    } catch {
        Write-Warning "Word COM failed: $_"
        Write-Host "  Falling back to plain copy of .md files to output directory" -ForegroundColor Yellow
        foreach ($doc in $mdFiles) {
            $txtOutput = $doc.Output -replace '\.docx$', '.md'
            Copy-Item $doc.Source $txtOutput
            Write-Host "    -> $($txtOutput | Split-Path -Leaf) (markdown copy)" -ForegroundColor Yellow
        }
    }
}
#endregion

#region Summary
Write-Host "`n" + "="*60 -ForegroundColor Green
Write-Host "  DELIVERABLES GENERATED" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Green
Write-Host ""
Get-ChildItem $outputDir | ForEach-Object {
    Write-Host "  $($_.Name) ($([math]::Round($_.Length/1KB,1)) KB)" -ForegroundColor White
}
Write-Host ""
Write-Host "Output directory: $outputDir" -ForegroundColor Cyan
#endregion
