$guid = [guid]::NewGuid().ToString("N").Substring(0,20)
Write-Output "Page GUID: $guid"
$basePath = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages\$guid"
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020001" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020002" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020003" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020004" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020005" | Out-Null
New-Item -ItemType Directory -Force -Path "$basePath\visuals\b1c2d3e4f5a600020006" | Out-Null
Write-Output "Created directories for page: $guid"
