# Diagnostico de plataforma de publicacion disponible en el server (solo lectura)
# Responde: que edicion de SQL Server hay (licenciamiento SSRS vs Power BI Report Server),
# si hay Reporting Services / Power BI Report Server / IIS instalados, y capacidad de hosting.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()

    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem
    $out += "=== SERVIDOR ==="
    $out += "OS          : $($os.Caption) ($($os.Version))"
    $out += "CPU logicos : $($cs.NumberOfLogicalProcessors)"
    $out += "RAM total   : $([math]::Round($cs.TotalPhysicalMemory/1GB,1)) GB"
    $out += "RAM libre   : $([math]::Round($os.FreePhysicalMemory/1MB,1)) GB"

    $out += ""
    $out += "=== SERVICIOS SQL / REPORTING / WEB ==="
    $svc = Get-Service | Where-Object { $_.Name -match "MSSQL|MSOLAP|ReportServer|PowerBIReportServer|SQLSERVERAGENT|W3SVC" }
    if ($svc) { foreach ($s in $svc) { $out += "$($s.Name) | Status=$($s.Status) | StartType=$($s.StartType) | $($s.DisplayName)" } }
    else { $out += "(ninguno)" }

    $out += ""
    $out += "=== INSTANCIAS Y COMPONENTES REGISTRADOS ==="
    $keys = @(
        "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL",
        "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\OLAP",
        "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\RS"
    )
    foreach ($k in $keys) {
        $label = ($k -split "\\")[-1]
        if (Test-Path $k) {
            $p = Get-ItemProperty $k
            $names = $p.PSObject.Properties | Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object { "$($_.Name)=$($_.Value)" }
            $out += "$label : $($names -join ' ; ')"
        } else {
            $out += "$label : (no registrado)"
        }
    }

    $out += ""
    $out += "=== POWER BI REPORT SERVER / SSRS STANDALONE ==="
    $rsKeys = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Reporting Services" -ErrorAction SilentlyContinue
    if ($rsKeys) { foreach ($k in $rsKeys) { $out += "SSRS key: $($k.PSChildName)" } } else { $out += "SSRS standalone: no instalado" }
    $pbirs = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft Power BI Report Server" -ErrorAction SilentlyContinue
    if ($pbirs) { foreach ($k in $pbirs) { $out += "PBIRS key: $($k.PSChildName)" } } else { $out += "Power BI Report Server: no instalado" }

    $out += ""
    $out += "=== IIS / HOSTING WEB ==="
    $iis = Get-Service W3SVC -ErrorAction SilentlyContinue
    $out += if ($iis) { "IIS (W3SVC): $($iis.Status)" } else { "IIS: no instalado" }
    $out += "msmdpump.dll (HTTP access a SSAS):"
    $pumps = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "msmdpump.dll" -ErrorAction SilentlyContinue |
             Select-Object -First 5 -ExpandProperty FullName
    if ($pumps) { foreach ($p in $pumps) { $out += "  $p" } } else { $out += "  (no encontrado)" }

    $out += ""
    $out += "=== RUNTIMES DISPONIBLES ==="
    $dotnet = & where.exe dotnet 2>$null
    $out += if ($dotnet) { "dotnet CLI: $dotnet" } else { "dotnet CLI: no instalado" }
    $py = & where.exe python 2>$null
    $out += if ($py) { "python: $py" } else { "python: no instalado" }
    $node = & where.exe node 2>$null
    $out += if ($node) { "node: $node" } else { "node: no instalado" }
    $ndp = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue
    if ($ndp) { $out += ".NET Framework: $($ndp.Version)" }

    return $out
}

$result | ForEach-Object { Write-Host $_ }

# Edicion/version del motor SQL (define el licenciamiento de SSRS vs Power BI Report Server)
Write-Host ""
Write-Host "=== EDICION DEL MOTOR SQL (192.168.2.47:1435) ==="
$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
try {
    $cn = New-Object System.Data.SqlClient.SqlConnection("Server=192.168.2.47,1435;Database=master;User Id=sa;Password=$sqlPass;TrustServerCertificate=True")
    $cn.Open()
    $cmd = $cn.CreateCommand()
    $cmd.CommandText = @"
SELECT
    SERVERPROPERTY('ProductVersion')      AS ProductVersion,
    SERVERPROPERTY('ProductLevel')        AS ProductLevel,
    SERVERPROPERTY('Edition')             AS Edition,
    SERVERPROPERTY('EngineEdition')       AS EngineEdition,
    SERVERPROPERTY('ProductUpdateLevel')  AS UpdateLevel
"@
    $r = $cmd.ExecuteReader()
    while ($r.Read()) {
        for ($i = 0; $i -lt $r.FieldCount; $i++) { Write-Host ("{0,-15}: {1}" -f $r.GetName($i), $r.GetValue($i)) }
    }
    $r.Close()
    $cn.Close()
} catch {
    Write-Host "ERROR consultando el motor SQL: $($_.Exception.Message)"
}

# Edicion de SSAS
Write-Host ""
Write-Host "=== EDICION DE SSAS (192.168.2.47:2383) ==="
try {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction Stop
} catch {
    $amo = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($amo) { Add-Type -Path $amo.FullName }
}
try {
    $srv = New-Object Microsoft.AnalysisServices.Tabular.Server
    $srv.Connect("Data Source=192.168.2.47:2383")
    Write-Host ("Version        : {0}" -f $srv.Version)
    Write-Host ("Edition        : {0}" -f $srv.Edition)
    Write-Host ("ProductLevel   : {0}" -f $srv.ProductLevel)
    Write-Host ("ServerMode     : {0}" -f $srv.ServerMode)
    $srv.Disconnect()
} catch {
    Write-Host "ERROR consultando SSAS: $($_.Exception.Message)"
}
