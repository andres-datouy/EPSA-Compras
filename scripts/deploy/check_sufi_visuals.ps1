$pageDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\b2bd7d72b9f9422f8f73\visuals"

Write-Output "=== Visual directories on Suficiencia Stock Produccion ==="
$dirs = Get-ChildItem $pageDir -Directory
foreach ($d in $dirs) {
    $jsonPath = Join-Path $d.FullName "visual.json"
    if (Test-Path $jsonPath) {
        $json = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $title = $json.visual.modernVisualConfigurationObject.title
        $vtype = $json.visual.visualType
        
        # Get query references
        $refs = @()
        $qobjs = $json.visual.query.queryState
        foreach ($prop in $qobjs.PSObject.Properties) {
            $queryRefs = $prop.Value.projections
            foreach ($qr in $queryRefs) {
                $ref = $qr.queryRef
                if ($ref) { $refs += $ref }
            }
        }
        $refStr = ($refs -join ", ")
        Write-Output "$($d.Name) | $vtype | $title | Refs: $refStr"
    }
}
