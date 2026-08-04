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
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($PbixPath)
$entries = $zip.Entries | ForEach-Object { $_.FullName }

$reportOk  = ($entries | Where-Object { $_ -match "^Report/Layout" }) -ne $null
$modelOk   = ($entries | Where-Object { $_ -eq "DataModelSchema" }) -ne $null
$contentOk = ($entries | Where-Object { $_ -eq "[Content_Types].xml" }) -ne $null
Write-Host ""
Write-Host "2) Estructura ZIP: Report/Layout=$reportOk | DataModelSchema=$modelOk | Content_Types=$contentOk"
if (-not ($reportOk -and $modelOk -and $contentOk)) {
    Write-Host "   FALLA: estructura incompleta"
    $fails++
} else {
    Write-Host "   OK"
}

# --- 3. Conexion live al SSAS productivo ---
$dm = $null
$entry = $zip.Entries | Where-Object { $_.FullName -eq "DataModelSchema" }
if ($entry) {
    $sr = New-Object System.IO.StreamReader($entry.Open())
    $dm = $sr.ReadToEnd()
    $sr.Close()
}
Write-Host ""
Write-Host "3) Conexion embebida:"
if ($dm -match "192\.168\.2\.47" -and $dm -match "Compras_EPSA") {
    Write-Host "   OK: apunta a 192.168.2.47 / Compras_EPSA (Live Connection)"
} else {
    Write-Host "   AVISO: no se encontro la cadena '192.168.2.47' + 'Compras_EPSA' en DataModelSchema."
    Write-Host "          Abrir el PBIX manualmente y verificar que diga 'Conectado en vivo'."
}

# --- 4. Sin credenciales embebidas ---
if ($dm -and ($dm -match "Password=" -or $dm -match "pwd=")) {
    Write-Host "   FALLA: hay una contrasena embebida en DataModelSchema. NO publicar este archivo."
    $fails++
} else {
    Write-Host "   OK: sin credenciales embebidas (la autenticacion es Windows integrada del usuario)"
}
$zip.Dispose()

# --- 5. Paginas del reporte presentes en el Layout ---
$zip = [System.IO.Compression.ZipFile]::OpenRead($PbixPath)
$layoutEntry = $zip.Entries | Where-Object { $_.FullName -eq "Report/Layout" }
if ($layoutEntry) {
    $sr = New-Object System.IO.StreamReader($layoutEntry.Open())
    $layout = $sr.ReadToEnd()
    $sr.Close()
    $paginas = ([regex]::Matches($layout, '"name"\s*:\s*"[^"]*"')).Count
    $decision = $layout -match "Programacion Compras Exterior"
    Write-Host ""
    Write-Host "5) Contenido del reporte: referencias de nombre=$paginas | pagina 'Programacion Compras Exterior'=$decision"
    if (-not $decision) {
        Write-Host "   AVISO: la pagina del flujo comprador no aparece en el Layout. Verificar antes de publicar."
        $fails++
    }
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
