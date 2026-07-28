$guid = [guid]::NewGuid().ToString("N").Substring(0,20)
Write-Output "Page GUID: $guid"
$basePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\$guid"
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040001" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040002" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040003" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040004" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040005" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\d1e2f3a4b5c600040006" | Out-Null
Write-Output "Created directories for page: $guid"
