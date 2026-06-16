# Read report layout and extract key structure
$layout = [System.IO.File]::ReadAllText("d:\Andres\Dev\EPSA-Compras\pbix\extracted\Report\Layout", [System.Text.Encoding]::Unicode)
Write-Host "Layout length: $($layout.Length)"

$json = $layout | ConvertFrom-Json

Write-Host "`n=== Report Structure ===" -ForegroundColor Cyan
Write-Host "ID: $($json.id)"
Write-Host "ResourcePackages: $($json.resourcePackages.Count)"

# Sections (pages)
Write-Host "`n=== Report Pages ===" -ForegroundColor Cyan
foreach ($section in $json.sections) {
    $visCount = if ($section.visualContainers) { $section.visualContainers.Count } else { 0 }
    Write-Host "  Page: $($section.displayName) ($visCount visuals)" -ForegroundColor Yellow
    if ($section.visualContainers) {
        foreach ($vc in $section.visualContainers | Select-Object -First 5) {
            $config = $vc.config | ConvertFrom-Json -ErrorAction SilentlyContinue
            $visType = if ($config.singleVisual.visualType) { $config.singleVisual.visualType } else { "unknown" }
            Write-Host "    - $visType" -ForegroundColor Gray
        }
        if ($visCount -gt 5) {
            Write-Host "    ... and $($visCount - 5) more visuals" -ForegroundColor Gray
        }
    }
}

# Data sources (connections)
Write-Host "`n=== Data Model Connection ===" -ForegroundColor Cyan
if ($json.modelSettings) {
    Write-Host "  $($json.modelSettings | ConvertTo-Json -Depth 2 -Compress)"
}
