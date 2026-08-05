# Valida el PBIX distribuible generado desde el PBIP (Live Connection a SSAS).
# La generacion es MANUAL (la instalacion MSI de Desktop en esta maquina no registra
# el objeto COM PowerBI.Application, asi que no hay automatizacion posible):
#   1. Abrir EPSA-Compras.pbip en Power BI Desktop
#   2. Archivo -> Guardar como -> tipo "Archivo de Power BI (*.pbix)"
#   3. Nombre: "Compras EPSA - Compradores v<AAAA.MM>.pbix" en la carpeta export/
#   4. Ejecutar este script para validar el artefacto antes de publicarlo en SharePoint
#
# Uso:
#   .\validar_pbix_generado.ps1                         # valida el .pbix mas reciente de export/
#   .\validar_pbix_generado.ps1 -PbixPath "ruta\archivo.pbix"

param([string]$PbixPath = "")

$ErrorActionPreference = "Stop"

if (-not $PbixPath) {
    $exportDir = Join-Path $PSScriptRoot "..\..\export"
    $latest = Get-ChildItem $exportDir -Filter "*.pbix" -ErrorAction SilentlyContinue |
              Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $latest) {
        Write-Host "No hay ningun .pbix en export/. Generarlo primero (ver comentario al inicio de este script)."
        exit 1
    }
    $PbixPath = $latest.FullName
}
if (-not (Test-Path $PbixPath)) { throw "No existe: $PbixPath" }

Write-Host "Validando: $PbixPath"
$fails = 0

# --- 1. Tamano ---
$size = (Get-Item $PbixPath).Length
Write-Host ""
Write-Host ("1) Tamano: {0:N0} bytes ({1:N2} MB)" -f $size, ($size / 1MB))
if ($size -lt 100KB) {
    Write-Host "   FALLA: PBIX demasiado chico (<100KB). La definicion del reporte probablemente no quedo embebida."
    $fails++
} else {
    Write-Host "   OK"
}

# --- 2. Estructura interna (el PBIX es un ZIP) ---
# Dos formatos posibles segun version de Desktop:
#   LEGACY : Report/Layout (monolitico) + DataModelSchema (ahi vive la conexion)
#   NATIVO : Report/definition/pages/** (PBIR embebido) + Connections (Desktop >= 2.154, jul-2026+)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($PbixPath)
$entries = $zip.Entries | ForEach-Object { $_.FullName }

$layoutNative = (@($entries | Where-Object { $_ -match "^Report/definition/pages/" })).Count -gt 0
$layoutLegacy = (@($entries | Where-Object { $_ -match "^Report/Layout" })).Count -gt 0
$modelLegacy  = (@($entries | Where-Object { $_ -eq "DataModelSchema" })).Count -gt 0
$connections  = (@($entries | Where-Object { $_ -eq "Connections" })).Count -gt 0
$contentOk    = (@($entries | Where-Object { $_ -eq "[Content_Types].xml" })).Count -gt 0

if ($layoutNative) { $formato = "NATIVO (PBIR embebido)" } elseif ($layoutLegacy) { $formato = "LEGACY" } else { $formato = "DESCONOCIDO" }
Write-Host ""
Write-Host "2) Estructura ZIP: formato=$formato | pages=$($layoutNative -or $layoutLegacy) | DataModelSchema=$modelLegacy | Connections=$connections | Content_Types=$contentOk"
$estructuraOk = $contentOk -and (($layoutNative -and $connections) -or ($layoutLegacy -and $modelLegacy))
if (-not $estructuraOk) {
    Write-Host "   FALLA: estructura incompleta"
    $fails++
} else {
    Write-Host "   OK"
}

# --- 3. Conexion live al SSAS productivo (segun formato) ---
$conn = $null
if ($layoutNative) {
    $entry = $zip.Entries | Where-Object { $_.FullName -eq "Connections" }
    if ($entry) {
        $sr = New-Object System.IO.StreamReader($entry.Open())
        $conn = $sr.ReadToEnd()
        $sr.Close()
    }
} else {
    $entry = $zip.Entries | Where-Object { $_.FullName -eq "DataModelSchema" }
    if ($entry) {
        $sr = New-Object System.IO.StreamReader($entry.Open())
        $conn = $sr.ReadToEnd()
        $sr.Close()
    }
}
Write-Host ""
Write-Host "3) Conexion embebida:"
if ($conn -match "192\.168\.2\.47" -and $conn -match "Compras_EPSA" -and $conn -match "analysisServicesDatabaseLive") {
    Write-Host "   OK: Live Connection a 192.168.2.47 / Compras_EPSA"
} elseif ($conn -match "192\.168\.2\.47" -and $conn -match "Compras_EPSA") {
    Write-Host "   OK: apunta a 192.168.2.47 / Compras_EPSA (verificar tipo live manualmente)"
} else {
    Write-Host "   AVISO: no se encontro la cadena '192.168.2.47' + 'Compras_EPSA'."
    Write-Host "          Abrir el PBIX manualmente y verificar que diga 'Conectado en vivo'."
}

# --- 4. Sin credenciales embebidas ---
if ($conn -and ($conn -match "Password=" -or $conn -match "pwd=")) {
    Write-Host "   FALLA: hay una contrasena embebida. NO publicar este archivo."
    $fails++
} else {
    Write-Host "   OK: sin credenciales embebidas (la autenticacion es Windows integrada del usuario)"
}
$zip.Dispose()

# --- 5. Pagina del flujo comprador presente ---
$zip = [System.IO.Compression.ZipFile]::OpenRead($PbixPath)
$entries = $zip.Entries | ForEach-Object { $_.FullName }
$paginaFlujo = (@($entries | Where-Object { $_ -match "e244718f235796748fbf" })).Count -gt 0
$paginasTotal = (@($entries | Where-Object { $_ -match "/page\.json$" })).Count
Write-Host ""
Write-Host "5) Contenido del reporte: paginas=$paginasTotal | pagina 'Programacion Compras Exterior' (e244718f235796748fbf)=$paginaFlujo"
if (-not $paginaFlujo) {
    Write-Host "   FALLA: la pagina del flujo comprador no aparece en el PBIX. Verificar antes de publicar."
    $fails++
} else {
    Write-Host "   OK"
}
$zip.Dispose()

Write-Host ""
if ($fails -eq 0) {
    Write-Host "RESULTADO: PBIX VALIDO para publicar en SharePoint (ver docs/publicacion_pbix_sharepoint.md)"
    exit 0
} else {
    Write-Host "RESULTADO: $fails punto(s) a resolver antes de publicar"
    exit 1
}
