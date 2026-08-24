# Deploy del job SQL Agent Staging_Refresh_FactVencimientos
# Hallazgo 2026-08-06: stg_factVencimientos congelada desde 03/07 (sin job agendado)
# 1. Ejecuta 14_vencimientos_job.sql en msdb (crea el job, idempotente)
# 2. (opcional -TestRun) dispara el job y espera el resultado
# Uso: pwsh -File scripts/deploy/deploy_vencimientos_job.ps1 [-TestRun]

param([switch]$TestRun)

$repo = "d:\Andres\Dev\EPSA-Compras"
$e = Get-Content "$repo\.env.local"
$saPass = (($e | Where-Object { $_ -match '^SA_PASSWORD=' }) -split '=', 2)[1]
if (-not $saPass) { $saPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=', 2)[1] }
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=', 2)[1]
if (-not $saPass -or -not $pass) { throw "Faltan credenciales en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$session = New-PSSession -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate
try {
    # --- 1. Crear el job SQL Agent (msdb requiere sysadmin: sa) ---
    $sql = Get-Content "$repo\scripts\sql\ssas_staging\14_vencimientos_job.sql" -Raw -Encoding UTF8
    $sql = $sql -split '(?m)^\s*GO\s*$' | Where-Object { $_.Trim() }
    $connStr = "Server=localhost,1435;Database=msdb;User Id=sa;Password=$saPass;Connect Timeout=10"
    $jobResult = Invoke-Command -Session $session -ScriptBlock {
        param($batches, $cs)
        $conn = New-Object System.Data.SqlClient.SqlConnection($cs)
        $conn.Open()
        $out = @()
        foreach ($b in $batches) {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $b
            $cmd.CommandTimeout = 60
            $r = $cmd.ExecuteReader()
            while ($r.Read()) {
                $row = @()
                for ($i = 0; $i -lt $r.FieldCount; $i++) { $row += "$($r.GetName($i))=$($r.GetValue($i))" }
                $out += ($row -join " | ")
            }
            $r.Close()
        }
        $conn.Close()
        return $out
    } -ArgumentList $sql, $connStr
    Write-Host "OK: job Staging_Refresh_FactVencimientos creado" -ForegroundColor Green
    $jobResult | ForEach-Object { Write-Host "  $_" }

    # --- 2. Test run opcional ---
    if ($TestRun) {
        Write-Host "Disparando job de prueba (sp_start_job)..." -ForegroundColor Cyan
        $testResult = Invoke-Command -Session $session -ScriptBlock {
            param($cs)
            $conn = New-Object System.Data.SqlClient.SqlConnection($cs)
            $conn.Open()
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "EXEC msdb.dbo.sp_start_job N'Staging_Refresh_FactVencimientos';"
            $cmd.ExecuteNonQuery() | Out-Null
            # Poll hasta que termine (max 15 min)
            $runDate = [int](Get-Date -Format 'yyyyMMdd')
            for ($i = 0; $i -lt 30; $i++) {
                Start-Sleep -Seconds 30
                $q = $conn.CreateCommand()
                $q.CommandText = "SELECT TOP 1 h.run_status, h.run_duration, h.message FROM msdb.dbo.sysjobhistory h JOIN msdb.dbo.sysjobs j ON j.job_id=h.job_id WHERE j.name='Staging_Refresh_FactVencimientos' AND h.step_id=0 AND h.run_date = $runDate ORDER BY h.instance_id DESC"
                $r = $q.ExecuteReader()
                if ($r.Read()) {
                    $rs = $r.GetInt32(0)
                    if ($rs -ne 4) {
                        $status = switch ($rs) { 0 {"FAILED"} 1 {"SUCCEEDED"} 2 {"RETRY"} 3 {"CANCELLED"} default {"UNKNOWN($rs)"} }
                        $out = "status=$status duration=$($r.GetValue(1)) message=$($r.GetString(2))"
                        $r.Close()
                        $conn.Close()
                        return $out
                    }
                }
                $r.Close()
            }
            $conn.Close()
            return "status=TIMEOUT (15 min)"
        } -ArgumentList $connStr
        Write-Host "Test run: $testResult" -ForegroundColor $(if ($testResult -match "SUCCEEDED") { "Green" } else { "Red" })
    }
} finally {
    Remove-PSSession $session
}
