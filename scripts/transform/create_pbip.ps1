# Create PBIP project structure with live connection to SSAS
$ErrorActionPreference = "Stop"

$basePath = "d:\Andres\Dev\EPSA-Compras"
$pbipName = "Compras EPSA - Stock"
$reportDir = "$basePath\$pbipName.Report"

# Create directory structure
$dirs = @(
    $reportDir,
    "$reportDir\StaticResources",
    "$reportDir\StaticResources\SharedResources",
    "$reportDir\StaticResources\SharedResources\BaseThemes",
    "$reportDir\StaticResources\SharedResources\BuiltInThemes"
)
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
}

# 1. Create .pbip file
$pbip = @{
    version = 4
    artifacts = @(
        @{
            path = "$pbipName.Report"
            type = "report"
        }
    )
    settings = @{
        enableAutomaticDeployment = $false
    }
} | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText("$basePath\$pbipName.pbip", $pbip, [System.Text.Encoding]::UTF8)
Write-Host "Created: $pbipName.pbip" -ForegroundColor Green

# 2. Create definition.pbir (live connection to SSAS)
$pbir = @{
    version = 4
    datasetReference = @{
        byConnection = @{
            connectionString = "Data Source=192.168.2.47\SSAS;Initial Catalog=Compras_EPSA"
            type = "AnalysisServices"
            pbiServiceModel = $null
        }
        byPath = $null
    }
} | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText("$reportDir\definition.pbir", $pbir, [System.Text.Encoding]::UTF8)
Write-Host "Created: definition.pbir" -ForegroundColor Green

# 3. Convert Layout (UTF-16LE) to report.json (UTF-8 with BOM)
$layoutBytes = [System.IO.File]::ReadAllBytes("$basePath\pbix\extracted\Report\Layout")
$layoutText = [System.Text.Encoding]::Unicode.GetString($layoutBytes)
# Write as UTF-8 with BOM (Power BI Desktop expects this)
$utf8Bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText("$reportDir\report.json", $layoutText, $utf8Bom)
Write-Host "Created: report.json ($($layoutText.Length) chars)" -ForegroundColor Green

# 4. Copy theme files
$themeSrc = "$basePath\pbix\extracted\Report\StaticResources\SharedResources"
$themeDst = "$reportDir\StaticResources\SharedResources"
if (Test-Path "$themeSrc\BaseThemes\CY25SU11.json") {
    Copy-Item "$themeSrc\BaseThemes\CY25SU11.json" "$themeDst\BaseThemes\" -Force
    Write-Host "Copied: BaseThemes/CY25SU11.json" -ForegroundColor Green
}
if (Test-Path "$themeSrc\BuiltInThemes\Innovate.json") {
    Copy-Item "$themeSrc\BuiltInThemes\Innovate.json" "$themeDst\BuiltInThemes\" -Force
    Write-Host "Copied: BuiltInThemes/Innovate.json" -ForegroundColor Green
}

# 5. Create report.json if needed (minimal)
# Actually the Layout IS the report content, which we already converted

Write-Host "`n=== PBIP Structure ===" -ForegroundColor Cyan
Get-ChildItem "$basePath\$pbipName*" -Recurse | ForEach-Object {
    $rel = $_.FullName.Replace($basePath, ".")
    $size = if (-not $_.PSIsContainer) { " ($($_.Length) bytes)" } else { "" }
    Write-Host "  $rel$size" -ForegroundColor Gray
}

Write-Host "`nDone! Open '$pbipName.pbip' in Power BI Desktop to verify." -ForegroundColor Yellow
