# Clean up any remaining M-based model properties
$file = "$PSScriptRoot\..\model\database_staging.json"
$json = Get-Content $file -Raw -Encoding UTF8 | ConvertFrom-Json

# Remove model.expressions (M-based shared expressions)
if ($json.model.PSObject.Properties['expressions']) {
    $json.model.PSObject.Properties.Remove('expressions')
    Write-Host "Removed model.expressions" -ForegroundColor Green
}

$json | ConvertTo-Json -Depth 100 | Set-Content $file -Encoding UTF8
Write-Host "Cleanup done." -ForegroundColor Cyan
