# generate_word_docs.ps1
# Converts markdown files to properly formatted Word documents using Word COM automation
# Fixes: table rendering, list formatting, heading hierarchy

$ErrorActionPreference = "Stop"
$projectRoot = "d:\Andres\Dev\EPSA-Compras"
$outputDir = "$projectRoot\docs\deliverables"

function Convert-MarkdownToHtml {
    param([string]$MarkdownPath)
    
    $mdContent = Get-Content -Path $MarkdownPath -Raw -Encoding UTF8
    $lines = $mdContent -split "`r?`n"
    
    $html = @"
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<style>
body { font-family: Calibri, sans-serif; font-size: 11pt; line-height: 1.4; margin: 1cm 1cm 2cm 1.5cm; color: #333; }
h1 { font-size: 18pt; color: #1F3864; border-bottom: 2px solid #2F5496; padding-bottom: 6px; margin-top: 24pt; }
h2 { font-size: 14pt; color: #2F5496; margin-top: 18pt; border-bottom: 1px solid #D6DCE4; padding-bottom: 4px; }
h3 { font-size: 12pt; color: #4472C4; margin-top: 14pt; }
table { border-collapse: collapse; width: 100%; margin: 10px 0 16px 0; font-size: 9pt; table-layout: fixed; word-wrap: break-word; }
th { background-color: #4472C4; color: white; font-weight: bold; padding: 5px 6px; text-align: left; border: 1px solid #3060A0; font-size: 8.5pt; }
td { padding: 4px 6px; border: 1px solid #D6DCE4; vertical-align: top; font-size: 8.5pt; overflow: hidden; }
tr:nth-child(even) td { background-color: #F2F6FC; }
code { background-color: #F4F4F4; padding: 2px 5px; font-family: Consolas, monospace; font-size: 9.5pt; border-radius: 3px; }
pre { background-color: #F8F8F8; border: 1px solid #E0E0E0; padding: 12px; font-family: Consolas, monospace; font-size: 9.5pt; overflow-x: auto; margin: 10px 0; }
blockquote { border-left: 4px solid #4472C4; padding: 8px 12px; margin: 10px 0; color: #555; background-color: #F8FAFD; font-style: italic; }
ul, ol { margin: 6px 0; padding-left: 24px; }
li { margin-bottom: 4px; }
hr { border: none; border-top: 1px solid #D6DCE4; margin: 20px 0; }
.checkbox { font-family: 'Segoe UI Symbol'; }
strong { color: #1F3864; }
</style></head><body>
"@
    
    $inTable = $false
    $inCodeBlock = $false
    $inList = $false
    $listType = ""  # "ul" or "ol"
    $tableRowIndex = 0
    $inBlockquote = $false
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        
        # Code blocks
        if ($line -match '^```') {
            if ($inCodeBlock) {
                $html += "</pre>`n"
                $inCodeBlock = $false
            } else {
                $html += "<pre>"
                $inCodeBlock = $true
            }
            continue
        }
        if ($inCodeBlock) {
            $escaped = $line.Replace("&","&amp;").Replace("<","&lt;").Replace(">","&gt;")
            $html += "$escaped`n"
            continue
        }
        
        # Close list if we're no longer in a list item
        if ($inList -and $line -notmatch '^(\s*[-*]|\s*\d+\.\s|\s*- \[)') {
            $html += "</$listType>`n"
            $inList = $false
        }
        
        # Close blockquote
        if ($inBlockquote -and $line -notmatch '^>') {
            $html += "</blockquote>`n"
            $inBlockquote = $false
        }
        
        # Tables
        if ($line -match '^\|.*\|$') {
            if (-not $inTable) {
                $inTable = $true
                $tableRowIndex = 0
                $html += "<table>`n"
            }
            # Skip separator row
            if ($line -match '^\|[\s\-:|]+\|$') { continue }
            
            $cells = ($line -split '\|') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
            
            if ($tableRowIndex -eq 0) {
                $html += "<tr>"
                foreach ($cell in $cells) {
                    $cell = Apply-InlineFormatting $cell
                    $html += "<th>$cell</th>"
                }
                $html += "</tr>`n"
            } else {
                $html += "<tr>"
                foreach ($cell in $cells) {
                    $cell = Apply-InlineFormatting $cell
                    $html += "<td>$cell</td>"
                }
                $html += "</tr>`n"
            }
            $tableRowIndex++
            continue
        } elseif ($inTable) {
            $html += "</table>`n"
            $inTable = $false
            $tableRowIndex = 0
        }
        
        # Headings
        if ($line -match '^#### (.+)') { $html += "<h4>$(Apply-InlineFormatting $Matches[1])</h4>`n"; continue }
        if ($line -match '^### (.+)') { $html += "<h3>$(Apply-InlineFormatting $Matches[1])</h3>`n"; continue }
        if ($line -match '^## (.+)') { $html += "<h2>$(Apply-InlineFormatting $Matches[1])</h2>`n"; continue }
        if ($line -match '^# (.+)') { $html += "<h1>$(Apply-InlineFormatting $Matches[1])</h1>`n"; continue }
        
        # Horizontal rule
        if ($line -match '^---+\s*$') { $html += "<hr>`n"; continue }
        
        # Blockquote
        if ($line -match '^> (.*)') {
            if (-not $inBlockquote) {
                $html += "<blockquote>`n"
                $inBlockquote = $true
            }
            $html += "<p>$(Apply-InlineFormatting $Matches[1])</p>`n"
            continue
        }
        
        # Checkbox list items
        if ($line -match '^- \[(.)\] (.+)') {
            if (-not $inList) { $html += "<ul>`n"; $inList = $true; $listType = "ul" }
            $check = if ($Matches[1] -eq 'x') { "&#9745;" } else { "&#9744;" }
            $html += "<li><span class='checkbox'>$check</span> $(Apply-InlineFormatting $Matches[2])</li>`n"
            continue
        }
        
        # Unordered list
        if ($line -match '^\s*[-*] (.+)') {
            if (-not $inList) { $html += "<ul>`n"; $inList = $true; $listType = "ul" }
            $html += "<li>$(Apply-InlineFormatting $Matches[1])</li>`n"
            continue
        }
        
        # Ordered list
        if ($line -match '^\s*(\d+)\.\s+(.+)') {
            if (-not $inList) { $html += "<ol>`n"; $inList = $true; $listType = "ol" }
            $html += "<li>$(Apply-InlineFormatting $Matches[2])</li>`n"
            continue
        }
        
        # Empty line
        if ($line.Trim() -eq '') { continue }
        
        # Regular paragraph
        $html += "<p>$(Apply-InlineFormatting $line)</p>`n"
    }
    
    # Close any open elements
    if ($inTable) { $html += "</table>`n" }
    if ($inList) { $html += "</$listType>`n" }
    if ($inBlockquote) { $html += "</blockquote>`n" }
    if ($inCodeBlock) { $html += "</pre>`n" }
    
    $html += "</body></html>"
    return $html
}

function Apply-InlineFormatting {
    param([string]$text)
    # Bold + italic
    $text = $text -replace '\*\*\*(.+?)\*\*\*', '<strong><em>$1</em></strong>'
    # Bold
    $text = $text -replace '\*\*(.+?)\*\*', '<strong>$1</strong>'
    # Italic
    $text = $text -replace '\*(.+?)\*', '<em>$1</em>'
    # Inline code
    $text = $text -replace '`([^`]+)`', '<code>$1</code>'
    # Links
    $text = $text -replace '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>'
    return $text
}

# --- Main ---
Write-Host "=== Generating Word Documents ===" -ForegroundColor Cyan

$mdFiles = @(
    @{ Source = "$projectRoot\docs\propuesta_alcance_monitoreo.md"; Output = "$outputDir\Propuesta_Alcance_Monitoreo.docx" },
    @{ Source = "$projectRoot\docs\reglas_negocio_compras_exterior.md"; Output = "$outputDir\Reglas_Negocio_Compras_Exterior.docx" }
)

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    
    foreach ($doc in $mdFiles) {
        Write-Host "  Converting: $($doc.Source | Split-Path -Leaf)" -ForegroundColor Yellow
        
        # Convert MD to HTML
        $html = Convert-MarkdownToHtml -MarkdownPath $doc.Source
        
        # Write temp HTML
        $tempHtml = Join-Path $env:TEMP "md_to_word_$(Get-Random).html"
        [System.IO.File]::WriteAllText($tempHtml, $html, [System.Text.Encoding]::UTF8)
        
        # Open in Word
        $wordDoc = $word.Documents.Open($tempHtml, $false, $true)
        
        # Set margins: left 1.5cm, right 1cm for maximum printable width
        $wordDoc.PageSetup.TopMargin = $word.CentimetersToPoints(2)
        $wordDoc.PageSetup.BottomMargin = $word.CentimetersToPoints(2)
        $wordDoc.PageSetup.LeftMargin = $word.CentimetersToPoints(1.5)
        $wordDoc.PageSetup.RightMargin = $word.CentimetersToPoints(1)
        
        # Auto-fit all tables to window/page width at 92%
        $tables = $wordDoc.Tables
        for ($t = 1; $t -le $tables.Count; $t++) {
            $tbl = $tables.Item($t)
            $tbl.AutoFitBehavior(2)  # wdAutoFitWindow = 2 (fit to page width)
            $tbl.PreferredWidthType = 2  # wdPreferredWidthPercent
            $tbl.PreferredWidth = 92
        }
        
        # Save as docx
        if (Test-Path $doc.Output) { Remove-Item $doc.Output -Force }
        $wordDoc.SaveAs2([ref]$doc.Output, [ref]16)  # 16 = wdFormatDocumentDefault
        $wordDoc.Close([ref]$false)
        
        Remove-Item $tempHtml -Force -ErrorAction SilentlyContinue
        
        $size = [math]::Round((Get-Item $doc.Output).Length / 1KB, 1)
        Write-Host "    -> $($doc.Output | Split-Path -Leaf) ($size KB)" -ForegroundColor Green
    }
    
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
    
} catch {
    Write-Error "Word COM automation failed: $_"
    if ($word) { try { $word.Quit() } catch {} }
}

Write-Host "`nDone!" -ForegroundColor Green
