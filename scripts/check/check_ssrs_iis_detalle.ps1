# Verificacion focalizada: SSRS realmente instalado? que sirve IIS? msmdpump configurado?
# (el chequeo anterior uso nombres de servicio/registro incompletos)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()

    $out += "=== SERVICIOS CON 'Report' O 'Reporting' EN EL NOMBRE ==="
    $svc = Get-Service | Where-Object { $_.Name -match "Report" -or $_.DisplayName -match "Report" }
    if ($svc) { foreach ($s in $svc) { $out += "$($s.Name) | Status=$($s.Status) | StartType=$($s.StartType) | $($s.DisplayName)" } }
    else { $out += "(ninguno)" }

    $out += ""
    $out += "=== REGISTRO SSRS ==="
    foreach ($k in @("HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\SSRS",
                     "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\RS")) {
        if (Test-Path $k) {
            $out += "$k : EXISTE"
            Get-ChildItem $k -ErrorAction SilentlyContinue | ForEach-Object { $out += "   subkey: $($_.PSChildName)" }
        } else { $out += "$k : no existe" }
    }
    $rsSetup = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\SSRS\Setup" -ErrorAction SilentlyContinue
    if ($rsSetup) {
        $out += "SSRS Setup -> Version=$($rsSetup.Version) ; Edition=$($rsSetup.Edition) ; InstallRoot=$($rsSetup.InstallRootDirectory)"
    }

    $out += ""
    $out += "=== IIS: SITIOS Y APLICACIONES ==="
    try {
        Import-Module WebAdministration -ErrorAction Stop
        foreach ($site in (Get-ChildItem IIS:\Sites)) {
            $binds = ($site.Bindings.Collection | ForEach-Object { $_.bindingInformation }) -join " , "
            $out += "SITIO: $($site.Name) | State=$($site.State) | Path=$($site.PhysicalPath) | Bind=$binds"
            Get-WebApplication -Site $site.Name -ErrorAction SilentlyContinue | ForEach-Object {
                $out += "   APP: $($_.Path) -> $($_.PhysicalPath) (pool=$($_.ApplicationPool))"
            }
        }
        $out += ""
        $out += "App pools:"
        Get-ChildItem IIS:\AppPools | ForEach-Object { $out += "   $($_.Name) | $($_.State) | .NET=$($_.ManagedRuntimeVersion)" }
    } catch {
        $out += "No se pudo leer IIS via WebAdministration: $($_.Exception.Message)"
        if (Test-Path "C:\inetpub\wwwroot") {
            $out += "Contenido de C:\inetpub\wwwroot:"
            Get-ChildItem "C:\inetpub\wwwroot" | Select-Object -First 15 | ForEach-Object { $out += "   $($_.Name)" }
        }
    }

    $out += ""
    $out += "=== msmdpump: hay virtual dir configurado? ==="
    $olapDirs = Get-ChildItem "C:\inetpub" -Recurse -Filter "msmdpump.ini" -ErrorAction SilentlyContinue | Select-Object -First 5
    if ($olapDirs) { foreach ($d in $olapDirs) { $out += "  configurado en: $($d.FullName)" } }
    else { $out += "  no hay msmdpump.ini bajo C:\inetpub -> HTTP access a SSAS NO configurado" }

    $out += ""
    $out += "=== LICENCIAMIENTO WINDOWS ==="
    $lic = Get-CimInstance SoftwareLicensingProduct -Filter "PartialProductKey IS NOT NULL AND Name LIKE 'Windows%'" -ErrorAction SilentlyContinue |
           Select-Object -First 1
    if ($lic) { $out += "Windows: $($lic.Name) | LicenseStatus=$($lic.LicenseStatus)" }
    $out += "Limite de conexiones IIS en Windows 10 Pro: 10 simultaneas (limite del SO cliente)"

    $out += ""
    $out += "=== DOTNET SDK/RUNTIMES ==="
    $out += (& "C:\Program Files\dotnet\dotnet.exe" --list-runtimes 2>&1 | Select-Object -First 12)
    $out += "--- SDKs ---"
    $out += (& "C:\Program Files\dotnet\dotnet.exe" --list-sdks 2>&1 | Select-Object -First 8)

    return $out
}

$result | ForEach-Object { Write-Host $_ }
