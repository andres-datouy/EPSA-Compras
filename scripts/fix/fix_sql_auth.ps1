# Fix dimArticulo: remove broken calculated column and process
$file = "$PSScriptRoot\..\model\database_staging.json"
$content = Get-Content $file -Raw -Encoding UTF8

# Replace the broken expression with BLANK()
$content = $content.Replace(
    'dimArticulo[Proveedor Articulo] \u0026 \"- \" \u0026 dimArticulo[ProveedorArticuloNombre]',
    'BLANK()'
)
# Also try with different escaping
$content = $content.Replace(
    'dimArticulo[Proveedor Articulo] & "-" & dimArticulo[ProveedorArticuloNombre]',
    'BLANK()'
)

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "Fixed Proveedor Artículo Full expression" -ForegroundColor Green

# Copy to server
Copy-Item $file '\\192.168.2.47\C$\temp\ssas_deploy\database_staging.json' -Force
Write-Host "Copied to server" -ForegroundColor Green
