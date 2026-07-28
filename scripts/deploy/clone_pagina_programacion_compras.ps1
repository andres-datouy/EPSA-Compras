# Clona la pagina 'Stock Minimo Vs Lead Time' como 'Programacion Compras Exterior'
# Genera IDs nuevos para pagina y visuales, y registra la pagina en pages.json
$ErrorActionPreference = "Stop"
$pagesDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages"
$srcPage = "052225f7ed5a4eabddaf"
$newDisplayName = "Programacion Compras Exterior"

function New-HexId([int]$len = 20) {
    -join ((1..$len) | ForEach-Object { "{0:x}" -f (Get-Random -Maximum 16) })
}

# Evitar duplicados si se corre dos veces
$existing = Get-ChildItem "$pagesDir\*\page.json" | Where-Object {
    (Get-Content $_.FullName -Raw | ConvertFrom-Json).displayName -eq $newDisplayName
}
if ($existing) { Write-Host "YA EXISTE: $($existing.Directory.Name)"; exit 0 }

$newPageId = New-HexId
Copy-Item "$pagesDir\$srcPage" "$pagesDir\$newPageId" -Recurse

# page.json: nuevo name + displayName
$pageJsonPath = "$pagesDir\$newPageId\page.json"
$pageJson = Get-Content $pageJsonPath -Raw
$pageJson = $pageJson.Replace("`"name`": `"$srcPage`"", "`"name`": `"$newPageId`"")
$pageJson = $pageJson.Replace('"displayName": "Stock Mínimo Vs Lead Time"', "`"displayName`": `"$newDisplayName`"")
[System.IO.File]::WriteAllText($pageJsonPath, $pageJson, (New-Object System.Text.UTF8Encoding($false)))

# visuales: renombrar carpeta y campo name con IDs nuevos
$map = @{}
foreach ($vDir in Get-ChildItem "$pagesDir\$newPageId\visuals" -Directory) {
    $oldId = $vDir.Name
    $newId = New-HexId ($oldId.Length)
    $map[$oldId] = $newId
    $vPath = Join-Path $vDir.FullName "visual.json"
    $vJson = Get-Content $vPath -Raw
    $vJson = $vJson.Replace("`"name`": `"$oldId`"", "`"name`": `"$newId`"")
    [System.IO.File]::WriteAllText($vPath, $vJson, (New-Object System.Text.UTF8Encoding($false)))
    Rename-Item $vDir.FullName $newId
}

# referencias cruzadas entre visuales (grupos/sync) dentro de la pagina nueva
foreach ($vDir in Get-ChildItem "$pagesDir\$newPageId\visuals" -Directory) {
    $vPath = Join-Path $vDir.FullName "visual.json"
    $vJson = Get-Content $vPath -Raw
    $changed = $false
    foreach ($k in $map.Keys) {
        if ($vJson.Contains($k)) { $vJson = $vJson.Replace($k, $map[$k]); $changed = $true }
    }
    if ($changed) { [System.IO.File]::WriteAllText($vPath, $vJson, (New-Object System.Text.UTF8Encoding($false))) }
}

# pages.json: insertar despues de la pagina origen
$pagesJsonPath = "$pagesDir\pages.json"
$pages = Get-Content $pagesJsonPath -Raw | ConvertFrom-Json
$order = [System.Collections.ArrayList]$pages.pageOrder
$idx = $order.IndexOf($srcPage)
$order.Insert($idx + 1, $newPageId)
$pages.pageOrder = $order.ToArray()
$pages | ConvertTo-Json -Depth 5 | Set-Content $pagesJsonPath -Encoding UTF8

Write-Host "PAGINA CLONADA: $newPageId ($newDisplayName)"
Write-Host "Mapa de visuales:"
$map.GetEnumerator() | ForEach-Object { Write-Host "  $($_.Key) -> $($_.Value)" }
