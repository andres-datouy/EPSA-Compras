# Check the current model JSON for issues
$file = "$PSScriptRoot\..\model\database_staging.json"
$content = Get-Content $file -Raw -Encoding UTF8

Write-Host "File size: $($content.Length) bytes" -ForegroundColor Yellow

# Check first 500 chars (structure)
Write-Host "`n=== First 500 chars ===" -ForegroundColor Cyan
Write-Host $content.Substring(0, [Math]::Min(500, $content.Length))

# Check a partition source section
$idx = $content.IndexOf('"source"')
if ($idx -gt 0) {
    Write-Host "`n=== First partition source (at pos $idx) ===" -ForegroundColor Cyan
    Write-Host $content.Substring($idx, [Math]::Min(200, $content.Length - $idx))
}

# Check dataSources
$dsIdx = $content.IndexOf('"dataSources"')
if ($dsIdx -gt 0) {
    Write-Host "`n=== dataSources (at pos $dsIdx) ===" -ForegroundColor Cyan
    Write-Host $content.Substring($dsIdx, [Math]::Min(500, $content.Length - $dsIdx))
}

# Check if there are any problematic patterns
Write-Host "`n=== Checking for issues ===" -ForegroundColor Yellow
$problemCount = ([regex]::Matches($content, '"Count":\s*\d+')).Count
Write-Host "Count properties (artifact): $problemCount"

$syncRootCount = ([regex]::Matches($content, '"SyncRoot"')).Count
Write-Host "SyncRoot properties (artifact): $syncRootCount"
