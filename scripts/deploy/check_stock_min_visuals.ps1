$pageDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\3ddaa8599b32826c6cd8\visuals"

$dirs = Get-ChildItem $pageDir -Directory
foreach ($d in $dirs) {
    $jsonPath = Join-Path $d.FullName "visual.json"
    if (Test-Path $jsonPath) {
        $raw = Get-Content $jsonPath -Raw -Encoding UTF8
        $json = $raw | ConvertFrom-Json
        $vtype = $json.visual.visualType
        $posY = $json.position.y
        $posX = $json.position.x
        $w = $json.position.width
        $h = $json.position.height
        
        # Get query references
        $refs = @()
        $qobjs = $json.visual.query.queryState
        if ($qobjs) {
            foreach ($prop in $qobjs.PSObject.Properties) {
                $queryRefs = $prop.Value.projections
                if ($queryRefs) {
                    foreach ($qr in $queryRefs) {
                        $ref = $qr.queryRef
                        if ($ref) { $refs += $ref }
                    }
                }
            }
        }
        $refStr = ($refs -join ", ")
        Write-Output "$($d.Name) | $vtype | pos($posX,$posY) ${w}x${h} | Refs: $refStr"
    }
}
