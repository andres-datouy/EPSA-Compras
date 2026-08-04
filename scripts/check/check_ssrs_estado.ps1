# SSRS: version, URLs del portal, base de datos del report server y contenido publicado
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()

    $out += "=== VERSION DEL BINARIO SSRS ==="
    $exe = "C:\Program Files\Microsoft SQL Server Reporting Services\SSRS\ReportServer\bin\ReportingServicesService.exe"
    if (Test-Path $exe) {
        $v = (Get-Item $exe).VersionInfo
        $out += "ProductName    : $($v.ProductName)"
        $out += "ProductVersion : $($v.ProductVersion)"
        $out += "FileVersion    : $($v.FileVersion)"
    } else {
        $out += "No se encontro el binario en la ruta esperada; buscando..."
        Get-ChildItem "C:\Program Files\Microsoft SQL Server Reporting Services" -Recurse -Filter "ReportingServicesService.exe" -ErrorAction SilentlyContinue |
            Select-Object -First 3 | ForEach-Object { $out += "  $($_.FullName) -> $($_.VersionInfo.ProductVersion)" }
    }

    $out += ""
    $out += "=== ESTADO VIA WMI (RS Admin) ==="
    try {
        $ns = Get-CimInstance -Namespace "root\Microsoft\SqlServer\ReportServer\RS_SSRS\v15\Admin" -ClassName MSReportServer_ConfigurationSetting -ErrorAction Stop
    } catch {
        $nsPath = Get-CimInstance -Namespace "root\Microsoft\SqlServer\ReportServer" -ClassName __NAMESPACE -ErrorAction SilentlyContinue
        $out += "Namespaces RS disponibles: $(($nsPath | ForEach-Object { $_.Name }) -join ', ')"
        $ns = $null
        foreach ($n in ($nsPath | ForEach-Object { $_.Name })) {
            foreach ($v in @("v15","v14","v13")) {
                try {
                    $ns = Get-CimInstance -Namespace "root\Microsoft\SqlServer\ReportServer\$n\$v\Admin" -ClassName MSReportServer_ConfigurationSetting -ErrorAction Stop
                    $out += "Encontrado en: root\Microsoft\SqlServer\ReportServer\$n\$v\Admin"
                    break
                } catch { }
            }
            if ($ns) { break }
        }
    }
    if ($ns) {
        $out += "InstanceName        : $($ns.InstanceName)"
        $out += "Version             : $($ns.Version)"
        $out += "EditionName         : $($ns.EditionName)"
        $out += "IsInitialized       : $($ns.IsInitialized)"
        $out += "DatabaseServerName  : $($ns.DatabaseServerName)"
        $out += "DatabaseName        : $($ns.DatabaseName)"
        $out += "VirtualDirectoryReportServer  : $($ns.VirtualDirectoryReportServer)"
        $out += "VirtualDirectoryReportManager : $($ns.VirtualDirectoryReportManager)"
        try {
            $urls = $ns | Invoke-CimMethod -MethodName ListReservedUrls
            for ($i = 0; $i -lt $urls.UrlString.Count; $i++) {
                $out += "URL reservada: $($urls.Application[$i]) -> $($urls.UrlString[$i])"
            }
        } catch { $out += "ListReservedUrls fallo: $($_.Exception.Message)" }
    } else {
        $out += "No se pudo consultar la configuracion por WMI"
    }

    $out += ""
    $out += "=== PRUEBA HTTP LOCAL DEL PORTAL ==="
    foreach ($u in @("http://localhost/Reports", "http://localhost/ReportServer")) {
        try {
            $r = Invoke-WebRequest -Uri $u -UseDefaultCredentials -UseBasicParsing -TimeoutSec 15
            $out += "$u -> HTTP $($r.StatusCode)"
        } catch {
            $code = $_.Exception.Response.StatusCode.value__
            $out += "$u -> ERROR $code $($_.Exception.Message)"
        }
    }

    return $out
}

$result | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "=== BASES DE DATOS EN LA INSTANCIA POR DEFECTO (MSSQLSERVER) ==="
$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
foreach ($srv in @("192.168.2.47", "192.168.2.47,1435")) {
    Write-Host "--- $srv ---"
    try {
        $cn = New-Object System.Data.SqlClient.SqlConnection("Server=$srv;Database=master;User Id=sa;Password=$sqlPass;TrustServerCertificate=True;Connect Timeout=10")
        $cn.Open()
        $cmd = $cn.CreateCommand()
        $cmd.CommandText = "SELECT name FROM sys.databases WHERE name NOT IN ('master','tempdb','model','msdb') ORDER BY name"
        $r = $cmd.ExecuteReader()
        while ($r.Read()) { Write-Host "   $($r.GetString(0))" }
        $r.Close(); $cn.Close()
    } catch { Write-Host "   ERROR: $($_.Exception.Message)" }
}
