# Prueba de humo del PBIX distribuible bajo la identidad de red del area:
# lanza Power BI Desktop con la credencial EXLER-SERVER\bi_compras usando la misma
# semantica que 'runas /netonly' (LOGON_NETCREDENTIALS_ONLY: la identidad local no
# cambia; la credencial solo se usa al conectar contra el SSAS).
# La contrasena sale de .env.local (BI_COMPRAS_PASSWORD), nunca se escribe en pantalla.

$ErrorActionPreference = "Stop"

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class NetOnlyLaunch {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct STARTUPINFO {
        public int cb;
        public string lpReserved;
        public string lpDesktop;
        public string lpTitle;
        public int dwX, dwY, dwXSize, dwYSize;
        public int dwXCountChars, dwYCountChars, dwFillAttribute;
        public int dwFlags;
        public short wShowWindow;
        public short cbReserved2;
        public IntPtr lpReserved2;
        public IntPtr hStdInput, hStdOutput, hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION {
        public IntPtr hProcess;
        public IntPtr hThread;
        public int dwProcessId;
        public int dwThreadId;
    }

    const uint LOGON_NETCREDENTIALS_ONLY = 0x00000002;

    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool CreateProcessWithLogonW(
        string userName, string domain, string password, uint logonFlags,
        string applicationName, string commandLine, uint creationFlags,
        IntPtr environment, string currentDirectory,
        ref STARTUPINFO startupInfo, out PROCESS_INFORMATION processInformation);

    [DllImport("kernel32.dll")]
    static extern bool CloseHandle(IntPtr handle);

    public static int Launch(string domain, string user, string password, string exe, string args) {
        STARTUPINFO si = new STARTUPINFO();
        si.cb = Marshal.SizeOf(si);
        PROCESS_INFORMATION pi;
        bool ok = CreateProcessWithLogonW(user, domain, password, LOGON_NETCREDENTIALS_ONLY,
            exe, "\"" + exe + "\" " + args, 0, IntPtr.Zero, null, ref si, out pi);
        if (!ok) {
            throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
        }
        CloseHandle(pi.hThread);
        CloseHandle(pi.hProcess);
        return pi.dwProcessId;
    }
}
"@

# --- Credencial desde .env.local ---
$envFile = "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = Get-Content $envFile | Where-Object { $_ -match "^BI_COMPRAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "No se encontro BI_COMPRAS_PASSWORD en .env.local" }

$exe  = "C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
$pbix = "d:\Andres\Dev\EPSA-Compras\export\EPSA-Compras v202608.pbix"
if (-not (Test-Path $pbix)) { throw "No existe el PBIX: $pbix" }

Write-Host "Lanzando PBIDesktop con credenciales de red de EXLER-SERVER\bi_compras (netonly)..."
$pid2 = [NetOnlyLaunch]::Launch("EXLER-SERVER", "bi_compras", $pass, $exe, "`"$pbix`"")
Write-Host "PID lanzado: $pid2"

# --- Esperar la ventana ---
$ok = $false
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 5
    $p = Get-Process -Name PBIDesktop -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle }
    if ($p) {
        Write-Host "Ventana: '$($p.MainWindowTitle)' | PID $($p.Id) | RAM $([math]::Round($p.WorkingSet64/1MB)) MB"
        $ok = $true
        break
    }
}
if (-not $ok) { Write-Host "Sin ventana principal todavia (puede estar mostrando un dialogo)" }

# --- Fallback: si el dialogo 'Failed to Decrypt Credentials' (credenciales cacheadas
#     ilegibles tras un update) se trago el argumento del archivo, el broker de
#     instancia unica lo abre igual lanzando el PBIX por shell ---
Start-Sleep -Seconds 5
$p = Get-Process -Name PBIDesktop -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle }
if ($p -and $p.MainWindowTitle -match "Untitled") {
    Write-Host "La instancia quedo vacia (probable dialogo de credenciales). Reenviando apertura por shell..."
    Start-Process $pbix
    Start-Sleep -Seconds 15
    # Si el shell levanto una segunda instancia sin netonly, cerrarla: la prueba vale la de netonly
    $procs = Get-Process -Name PBIDesktop -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle }
    if (@($procs).Count -gt 1) {
        $procs | Sort-Object StartTime -Descending | Select-Object -First 1 | Stop-Process -Force
        Write-Host "Cerrada la instancia duplicada sin netonly"
    }
}
Write-Host ""
Write-Host "CHECK VISUAL: el reporte debe mostrar DATOS (tabla de decision con alertas PEDIR/Atencion/OK)."
Write-Host "Si aparece error de credenciales, la contrasena de .env.local no coincide con la del servidor."
