# Check what Power BI expects and fix PBIP structure
$basePath = "d:\Andres\Dev\EPSA-Compras"
$reportDir = "$basePath\Compras EPSA - Stock.Report"

# Check directory structure
Write-Host "=== Current Report Directory ===" -ForegroundColor Cyan
Get-ChildItem -Path $reportDir -Recurse | ForEach-Object {
    $rel = $_.FullName.Replace($reportDir, "")
    Write-Host "  $rel ($($_.Length) bytes)"
}

# The issue: Power BI expects report.json to be in a specific encoding (UTF-16 LE)
# and the file might need to be named differently or in a subfolder

# Check original PBIX structure for comparison
Write-Host "`n=== Original PBIX Report Structure ===" -ForegroundColor Cyan
$extractedDir = "$basePath\pbix\extracted\Report"
Get-ChildItem -Path $extractedDir -Recurse | ForEach-Object {
    $rel = $_.FullName.Replace($extractedDir, "")
    Write-Host "  $rel ($($_.Length) bytes)"
}

# Check if the Layout file is UTF-16 encoded
$layoutBytes = [System.IO.File]::ReadAllBytes("$extractedDir\Layout")
Write-Host "`n=== Layout File BOM ===" -ForegroundColor Cyan
Write-Host "  First 4 bytes: $($layoutBytes[0..3] -join ',')"
Write-Host "  Is UTF-16 LE: $($layoutBytes[0] -eq 0xFF -and $layoutBytes[1] -eq 0xFE)"

# Check current report.json encoding
$reportBytes = [System.IO.File]::ReadAllBytes("$reportDir\report.json")
Write-Host "`n=== report.json BOM ===" -ForegroundColor Cyan
Write-Host "  First 4 bytes: $($reportBytes[0..3] -join ',')"
Write-Host "  Is UTF-16 LE: $($reportBytes[0] -eq 0xFF -and $reportBytes[1] -eq 0xFE)"
Write-Host "  Is UTF-8 BOM: $($reportBytes[0] -eq 0xEF -and $reportBytes[1] -eq 0xBB -and $reportBytes[2] -eq 0xBF)"
