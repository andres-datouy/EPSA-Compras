$guid = [guid]::NewGuid().ToString("N").Substring(0,20)
Write-Output "Page GUID: $guid"
$basePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\$guid"
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030001" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030002" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030003" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030004" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030005" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030006" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\c1d2e3f4a5b600030007" | Out-Null
Write-Output "Created directories for page: $guid"
