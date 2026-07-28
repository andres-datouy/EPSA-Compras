$pagePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\b2bd7d72b9f9422f8f73\visuals"

$renameMap = @{
    "a1_card_articulos"     = "a1c2d3e4f5a600010001"
    "b1_card_proceso_usd"   = "b1c2d3e4f5a600010002"
    "c1_card_dias_cobertura"= "c1c2d3e4f5a600010003"
    "d1_table_stock"        = "d1c2d3e4f5a600010004"
    "e1_table_proceso"      = "e1c2d3e4f5a600010005"
}

foreach ($entry in $renameMap.GetEnumerator()) {
    $oldPath = Join-Path $pagePath $entry.Key
    $newPath = Join-Path $pagePath $entry.Value
    if (Test-Path $oldPath) {
        # Update the "name" field inside the visual.json
        $jsonFile = Join-Path $oldPath "visual.json"
        if (Test-Path $jsonFile) {
            $content = Get-Content $jsonFile -Raw
            $content = $content.Replace("""$($entry.Key)""", """$($entry.Value)""")
            Set-Content $jsonFile $content -Encoding UTF8
        }
        Rename-Item -Path $oldPath -NewName $entry.Value
        Write-Output "Renamed: $($entry.Key) -> $($entry.Value)"
    } else {
        Write-Output "SKIP: $($entry.Key) not found"
    }
}
Write-Output "Done"
