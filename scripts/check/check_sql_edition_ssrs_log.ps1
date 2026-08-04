# Edicion del motor SQL por defecto (ERP) y diagnostico de por que SSRS devuelve 503/500
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()

    $out += "=== EDICION DE CADA INSTANCIA SQL (auth integrada) ==="
    foreach ($inst in @("localhost", "localhost\SSAS")) {
        try {
            $cn = New-Object System.Data.SqlClient.SqlConnection("Server=$inst;Database=master;Integrated Security=SSPI;TrustServerCertificate=True;Connect Timeout=10")
            $cn.Open()
            $cmd = $cn.CreateCommand()
            $cmd.CommandText = "SELECT CAST(SERVERPROPERTY('Edition') AS nvarchar(100)) + ' | ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(50)) + ' | ' + CAST(SERVERPROPERTY('ProductLevel') AS nvarchar(50))"
            $out += "$inst -> $($cmd.ExecuteScalar())"
            $cn.Close()
        } catch {
            $out += "$inst -> ERROR: $($_.Exception.Message)"
        }
    }

    $out += ""
    $out += "=== EDICION DE SSRS (log de arranque) ==="
    $logDir = "C:\Program Files\Microsoft SQL Server Reporting Services\SSRS\LogFiles"
    if (Test-Path $logDir) {
        $log = Get-ChildItem $logDir -Filter "ReportServerService_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        $out += "Log mas reciente: $($log.Name) ($($log.LastWriteTime))"
        $edition = Select-String -Path $log.FullName -Pattern "SKU|Edition|Evaluation|Developer" | Select-Object -First 5
        foreach ($e in $edition) { $out += "  $($e.Line.Trim())" }

        $out += ""
        $out += "=== ULTIMOS ERRORES DEL LOG DE SSRS ==="
        $errs = Select-String -Path $log.FullName -Pattern "ERROR|Exception|expired|Cannot" | Select-Object -Last 12
        foreach ($e in $errs) { $out += "  $($e.Line.Trim().Substring(0, [Math]::Min(220, $e.Line.Trim().Length)))" }
    } else {
        $out += "No existe $logDir"
    }

    return $out
}

$result | ForEach-Object { Write-Host $_ }
