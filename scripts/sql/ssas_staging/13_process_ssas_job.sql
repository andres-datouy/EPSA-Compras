-- =====================================================
-- SSAS Staging: Job de processing del modelo tabular (Issue #28 / GitHub #14)
-- Run on: 192.168.2.47:1435 (DB Engine) - msdb
--
-- Los jobs Staging_Refresh_* mantienen staging_compras al dia, pero el modelo
-- SSAS Compras_EPSA (import) quedaba congelado hasta el ultimo process manual.
-- Este job procesa el modelo full 2x por dia, tras cada ciclo de staging:
--   09:30 (tras el ciclo 05:00-05:50) y 14:15 (tras el incremental 13:00-13:10).
--
-- Pattern (mismo esquema que 11_agent_jobs.sql):
--   Step 1: Process_SSAS.ps1 (CmdExec) — TMSL refresh full via ADOMD + verificacion de frescura
--   Step 2: Alert Teams Success (solo si step 1 OK)
--   Step 3: Alert Teams Fail (si step 1 falla; sale con failure para marcar el job)
--
-- Nota: usa TMSL "refresh" (DML) que funciona aunque el motor TMSL DDL este
-- degradado (issue #30 / GitHub #15). No depende de AMO: solo ADOMD del GAC.
--
-- Permisos: el step de process corre bajo un PROXY con la credencial de
-- EXLER-SERVER\schaaf_ssas (admin SSAS). La cuenta de servicio del Agent no
-- puede hacer refresh (ve "database cannot be found" sin permisos de process).
-- El secret del credential se inyecta en el deploy (placeholder {{SSAS_PASSWORD}}).
-- =====================================================

USE [msdb];
GO

-- Credential + proxy (idempotente)
IF NOT EXISTS (SELECT 1 FROM sys.credentials WHERE name = N'cred_schaaf_ssas')
    CREATE CREDENTIAL cred_schaaf_ssas WITH IDENTITY = N'EXLER-SERVER\schaaf_ssas', SECRET = N'{{SSAS_PASSWORD}}';
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysproxies WHERE name = N'Proxy_SSAS_Process')
    EXEC msdb.dbo.sp_delete_proxy @proxy_name = N'Proxy_SSAS_Process';
GO

EXEC msdb.dbo.sp_add_proxy
    @proxy_name = N'Proxy_SSAS_Process',
    @credential_name = N'cred_schaaf_ssas',
    @enabled = 1,
    @description = N'Proxy para procesamiento SSAS (identidad EXLER-SERVER\schaaf_ssas)';
GO

EXEC msdb.dbo.sp_grant_proxy_to_subsystem
    @proxy_name = N'Proxy_SSAS_Process',
    @subsystem_id = 3;  -- CmdExec
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Staging_Process_SSAS')
    EXEC msdb.dbo.sp_delete_job @job_name = N'Staging_Process_SSAS', @delete_unused_schedule = 1;
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Process_SSAS',
    @enabled = 1,
    @description = N'Process full del modelo SSAS Compras_EPSA 2x diario (09:30 y 14:15), tras los ciclos de refresh de staging';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Process_SSAS',
    @step_name = N'Process Compras_EPSA',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Process_SSAS.ps1',
    @proxy_name = N'Proxy_SSAS_Process',
    @on_success_action = 3,   -- Go to next step (success alert)
    @on_fail_action = 4,      -- Go to step ID indicado
    @on_fail_step_id = 3,     -- Alert Teams Fail (se crea a continuacion)
    @retry_attempts = 1,
    @retry_interval = 5;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Process_SSAS',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Process_SSAS" -Message "Modelo Compras_EPSA procesado correctamente" -Color "00FF00"',
    @on_success_action = 1;   -- Quit with success
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Process_SSAS',
    @step_name = N'Alert Teams Fail',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "FAIL: Staging_Process_SSAS" -Message "Fallo el processing del modelo Compras_EPSA. Ver historial del job y scripts/check/check_frescura_datos.ps1" -Color "FF0000"',
    @on_success_action = 2;   -- Quit reporting failure
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Process_SSAS',
    @name = N'Daily_09_30',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 93000;
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Process_SSAS',
    @name = N'Daily_14_15',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 141500;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Process_SSAS';
GO

-- VERIFY
SELECT j.name AS JobName,
       COUNT(DISTINCT js.step_id) AS Steps,
       STRING_AGG(s.name, ', ') AS Schedules,
       CASE j.enabled WHEN 1 THEN 'ENABLED' ELSE 'DISABLED' END AS Status
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id
LEFT JOIN msdb.dbo.sysjobschedules jsc ON j.job_id = jsc.job_id
LEFT JOIN msdb.dbo.sysschedules s ON jsc.schedule_id = s.schedule_id
WHERE j.name = 'Staging_Process_SSAS'
GROUP BY j.name, j.enabled;
GO
