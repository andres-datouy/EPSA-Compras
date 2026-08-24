-- =====================================================
-- SSAS Staging: SQL Agent Job Staging_Refresh_FactVencimientos
-- Run on: 192.168.2.47:1435 (DB Engine) - msdb
--
-- Hallazgo (2026-08-06, check_frescura_datos.ps1): stg_factVencimientos
-- congelada desde 2026-07-03 porque sp_refresh_factVencimientos se corrio
-- manualmente al incorporar la tabla y nunca se agendo.
--
-- Pattern: 2 steps (igual que 11_agent_jobs.sql)
--   Step 1: EXEC sp_refresh_factVencimientos (quit with failure si falla)
--   Step 2: alerta Teams verde (solo corre si step 1 OK)
-- Schedule: Daily 06:00 (tras el ultimo refresh de staging 05:50 y
--           antes del process SSAS de 09:30 del job Staging_Process_SSAS)
-- Idempotente: si el job existe, se borra y recrea.
-- =====================================================

USE [msdb];
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Staging_Refresh_FactVencimientos')
    EXEC msdb.dbo.sp_delete_job @job_name = N'Staging_Refresh_FactVencimientos', @delete_unused_schedule = 1;
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactVencimientos',
    @enabled = 1,
    @description = N'Refresh stg_factVencimientos daily (FULL REPLACE de lotes con stock desde Nodum)';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactVencimientos',
    @step_name = N'Refresh factVencimientos',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factVencimientos;',
    @on_success_action = 3,   -- Go to next step (success alert)
    @on_fail_action = 1;      -- Quit reporting failure
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactVencimientos',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactVencimientos" -Message "Lot expiry data refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactVencimientos',
    @name = N'Daily_06_00',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 60000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactVencimientos';
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
WHERE j.name = 'Staging_Refresh_FactVencimientos'
GROUP BY j.name, j.enabled;
GO
