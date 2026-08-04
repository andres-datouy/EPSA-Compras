# Verifica el acceso de la cuenta generica de lectura en tres planos:
#
#  A) AUTENTICACION desde la estacion de trabajo: logon de red NTLM contra
#     EXLER-SERVER con las mismas credenciales que los usuarios van a tipear en
#     runas /netonly. Se prueba via SMB (IPC$) porque es el unico servicio que
#     acepta credenciales explicitas por linea de comandos; valida usuario+clave
#     contra la SAM del server igual que lo hara MSOLAP.
#
#  B) AUTORIZACION real: se hace LogonUser + impersonacion de bi_compras en el
#     propio server y se consulta el modelo con SU token. Es el test end-to-end:
#     si el rol no existiera o no la tuviera como miembro, MSOLAP rechaza la
#     conexion. (EffectiveUserName no sirve para esto: la instancia responde
#     "The following system error occurred" y ademas no probaria el logon.)
#
#  C) CONTROL NEGATIVO: impersonando la misma cuenta se intenta leer una DMV
#     reservada a administradores. Debe fallar o venir vacia; si devolviera
#     datos, la cuenta tendria mas permisos de los previstos.
$ErrorActionPreference = "Stop"

$envFile = "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = Get-Content $envFile | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$biPass = Get-Content $envFile | Where-Object { $_ -match "^BI_COMPRAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass -or -not $biPass) { throw "Faltan SSAS_PASSWORD o BI_COMPRAS_PASSWORD en .env.local" }

Write-Host "=== A) AUTENTICACION: logon de red como EXLER-SERVER\bi_compras ==="
$null = net use \\192.168.2.47\IPC$ /delete 2>&1
$netOut = net use \\192.168.2.47\IPC$ /user:EXLER-SERVER\bi_compras $biPass 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: el servidor acepto la credencial en un logon de red"
    $null = net use \\192.168.2.47\IPC$ /delete 2>&1
} else {
    Write-Host "FALLO ($LASTEXITCODE): $netOut"
}

Write-Host ""
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($clave)
    $out = @()

    # ADOMD debe cargarse por ruta completa: Add-Type -AssemblyName resuelve a la
    # version 9.0.242.0 (SQL 2005), que no esta instalada.
    $gac = "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_14.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"
    Add-Type -Path $gac

    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32Logon {
    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool LogonUser(string user, string domain, string password,
        int logonType, int logonProvider, out IntPtr token);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr handle);
}
"@

    # Tipo 2 = INTERACTIVE: produce un token con credenciales, necesario para que
    # la conexion a MSOLAP pueda autenticarse hacia afuera. Un token de red (3)
    # no tiene credenciales para negociar SSPI.
    $token = [IntPtr]::Zero
    $ok = [Win32Logon]::LogonUser("bi_compras", "EXLER-SERVER", $clave, 2, 0, [ref]$token)
    if (-not $ok) {
        $err = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        return @("ERROR: LogonUser fallo con codigo Win32 $err")
    }

    $identity = New-Object System.Security.Principal.WindowsIdentity($token)
    $ctx = $identity.Impersonate()
    try {
        $out += "=== B) AUTORIZACION: consulta ejecutada con el token de bi_compras ==="
        $out += "Identidad efectiva del hilo: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"

        $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=Compras_EPSA")
        $conn.Open()
        $out += "Conexion a MSOLAP: ACEPTADA"

        $cmd = $conn.CreateCommand()
        $cmd.CommandText = 'EVALUATE ROW("Articulos", COUNTROWS(dimArticulo), "FilasStock", COUNTROWS(factStockEPSA), "Consumos", COUNTROWS(factConsumoHistoria))'
        $rd = $cmd.ExecuteReader()
        while ($rd.Read()) {
            $campos = @()
            for ($i = 0; $i -lt $rd.FieldCount; $i++) { $campos += "$($rd.GetName($i))=$($rd.GetValue($i))" }
            $out += "LECTURA OK -> $($campos -join ' | ')"
        }
        $rd.Close()

        $out += ""
        $out += "=== C) CONTROL NEGATIVO: DMV de administrador ==="
        try {
            $cmd2 = $conn.CreateCommand()
            $cmd2.CommandText = 'SELECT SESSION_ID FROM $SYSTEM.DISCOVER_SESSIONS'
            $rd2 = $cmd2.ExecuteReader()
            $filas = 0
            while ($rd2.Read()) { $filas++ }
            $rd2.Close()
            $out += if ($filas -eq 0) { "OK: DISCOVER_SESSIONS no devuelve datos (no es administrador)" }
                    else { "ALERTA: DISCOVER_SESSIONS devolvio $filas filas (permisos mayores a los previstos)" }
        } catch {
            $out += "OK: DISCOVER_SESSIONS denegada -> $($_.Exception.Message)"
        }

        $conn.Close()
    } catch {
        $out += "FALLO: $($_.Exception.GetType().Name): $($_.Exception.Message)"
        if ($_.Exception.InnerException) { $out += "  inner: $($_.Exception.InnerException.Message)" }
    } finally {
        $ctx.Undo()
        [Win32Logon]::CloseHandle($token) | Out-Null
    }

    return $out
} -ArgumentList $biPass

Write-Host ($result -join "`n")
