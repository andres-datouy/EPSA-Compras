# Deploy del fix Issue #28: job SQL Agent Staging_Process_SSAS
# 1. Copia scripts/powershell/Process_SSAS.ps1 a C:\Scripts\ en 192.168.2.47
# 2. Ejecuta 13_process_ssas_job.sql en el DB Engine (1435) para crear el job
# 3. (opcional -TestRun) dispara el job y espera el resultado
# Uso: pwsh -File scripts/deploy/deploy_process_ssas_job.ps1 [-TestRun]

param([switch]$TestRun)

$repo = "d:\Andres\Dev\EPSA-Compras"
$e = Get-Content "$repo\.env.local"
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=', 2)[1]
$saPass = (($e | Where-Object { $_ -match '^SA_PASSWORD=' }) -split '=', 2)[1]
if (-not $saPass) { $saPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=', 2)[1] }
if (-not $pass -or -not $saPass) { throw "Faltan SSAS_PASSWORD/SA_PASSWORD en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$session = New-PSSession -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate
try {
    # --- 1. Copiar Process_SSAS.ps1 al servidor ---
    Copy-Item "$repo\scripts\powershell\Process_SSAS.ps1" -Destination "C:\Scripts\Process_SSAS.ps1" -ToSession $session -Force
    $chk = Invoke-Command -Session $session -ScriptBlock {
        (Get-Item "C:\Scripts\Process_SSAS.ps1").Length
    }
    Write-Host "OK: Process_SSAS.ps1 copiado al servidor ($chk bytes)" -ForegroundColor Green

    # --- 2. Crear el job SQL Agent (msdb requiere sysadmin: sa; app_compras no tiene permisos en msdb) ---
    $sql = Get-Content "$repo\scripts\sql\ssas_staging\13_process_ssas_job.sql" -Raw -Encoding UTF8
    $sql = $sql -replace [regex]::Escape('{{SSAS_PASSWORD}}'), $pass   # secret del credential del proxy
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
    Write-Host "OK: job Staging_Process_SSAS creado" -ForegroundColor Green
    $jobResult | ForEach-Object { Write-Host "  $_" }

    # --- 3. Test run opcional ---
    if ($TestRun) {
        Write-Host "Disparando job de prueba (sp_start_job)..." -ForegroundColor Cyan
        $testResult = Invoke-Command -Session $session -ScriptBlock {
            param($cs)
            $conn = New-Object System.Data.SqlClient.SqlConnection($cs)
            $conn.Open()
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "EXEC msdb.dbo.sp_start_job N'Staging_Process_SSAS';"
            $cmd.ExecuteNonQuery() | Out-Null
            # Poll hasta que termine (max 30 min)
            $status = "RUNNING"
            $runDate = [int](Get-Date -Format 'yyyyMMdd')
            for ($i = 0; $i -lt 60; $i++) {
                Start-Sleep -Seconds 30
                $q = $conn.CreateCommand()
                $q.CommandText = "SELECT TOP 1 h.run_status, h.run_duration, h.message FROM msdb.dbo.sysjobhistory h JOIN msdb.dbo.sysjobs j ON j.job_id=h.job_id WHERE j.name='Staging_Process_SSAS' AND h.step_id=0 AND h.run_date = $runDate ORDER BY h.instance_id DESC"
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
            return "status=TIMEOUT (30 min)"
        } -ArgumentList $connStr
        Write-Host "Test run: $testResult" -ForegroundColor $(if ($testResult -match "SUCCEEDED") { "Green" } else { "Red" })
    }
} finally {
    Remove-PSSession $session
}
