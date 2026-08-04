# Lista las copias de la DLL de ADOMD en el server con su version de archivo,
# para elegir la que corresponde a la instancia SSAS instalada (17.0).
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()
    $out += "=== Copias de Microsoft.AnalysisServices.AdomdClient.dll ==="
    foreach ($raiz in @("C:\Program Files\Microsoft SQL Server", "C:\Program Files (x86)\Microsoft SQL Server", "C:\Windows\Microsoft.NET\assembly")) {
        Get-ChildItem $raiz -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | ForEach-Object {
            $out += "$($_.VersionInfo.FileVersion) | $($_.FullName)"
        }
    }
    $out += ""
    $out += "=== Contenido de 170\DTS\Binn (assemblies de AS) ==="
    Get-ChildItem "C:\Program Files\Microsoft SQL Server\170\DTS\Binn" -Filter "Microsoft.AnalysisServices*.dll" -ErrorAction SilentlyContinue | ForEach-Object {
        $out += "$($_.VersionInfo.FileVersion) | $($_.Name)"
    }
    return $out
}
Write-Host ($result -join "`n")
