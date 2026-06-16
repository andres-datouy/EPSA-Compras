# Fix report structure: move report.json to correct location for PBIR-Legacy
$basePath = "d:\Andres\Dev\EPSA-Compras"
$reportDir = "$basePath\EPSA-Compras.Report"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# 1. Move report.json from definition/ to Report root (PBIR-Legacy location)
$srcReport = "$reportDir\definition\report.json"
$dstReport = "$reportDir\report.json"
if (Test-Path $srcReport) {
    Move-Item $srcReport $dstReport -Force
    Write-Host "Moved definition\report.json -> report.json (root level)" -ForegroundColor Green
}

# 2. Ensure pages/ folder exists (required by version 2.0.0)
$pagesDir = "$reportDir\definition\pages"
if (-not (Test-Path $pagesDir)) {
    New-Item -ItemType Directory -Path $pagesDir -Force | Out-Null
    Write-Host "Recreated pages/ folder" -ForegroundColor Yellow
}

# 3. Ensure pages.json exists
$pagesJson = "$pagesDir\pages.json"
if (-not (Test-Path $pagesJson)) {
    $pagesContent = '{"$schema":"https://developer.microsoft.com/json-schemas/fabric/item/report/definition/pages/1.0.0/schema.json","pageOrder":[],"pages":[]}'
    [System.IO.File]::WriteAllText($pagesJson, $pagesContent, $utf8NoBom)
    Write-Host "Created empty pages.json" -ForegroundColor Yellow
}

# 4. Verify encoding
foreach ($f in @($dstReport, "$reportDir\definition\version.json", $pagesJson)) {
    if (Test-Path $f) {
        $bytes = [System.IO.File]::ReadAllBytes($f)
        $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
        if ($hasBom) {
            $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
            [System.IO.File]::WriteAllText($f, $content, $utf8NoBom)
            Write-Host "FIXED BOM: $f" -ForegroundColor Yellow
        }
    }
}

# 5. Show final structure
Write-Host "`n=== Final structure ===" -ForegroundColor Cyan
Get-ChildItem "$reportDir" -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Replace($reportDir, "")
    Write-Host "  $rel ($($_.Length) bytes)"
}
