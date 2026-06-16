-- =====================================================
-- SSAS Staging: SQL Agent Jobs with Teams Alerts
-- Run on: 192.168.2.47:1435 (DB Engine) - staging_compras
-- 
-- Pattern: Each job has 2 steps
--   Step 1: Run the refresh SP (quit with failure if it fails)
--   Step 2: Post SUCCESS alert to Teams (only runs if step 1 succeeded)
--   If step 1 fails, SQL Agent logs the failure + job shows as Failed
--   We use the SQL Agent Alert system for failure notification separately
-- =====================================================

USE [msdb];
GO

-- Clean slate: delete existing staging jobs
DECLARE @jobs TABLE (name NVARCHAR(200));
INSERT INTO @jobs VALUES 
    ('Staging_Refresh_Dimensions'),
    ('Staging_Refresh_FactStock'),
    ('Staging_Refresh_FactConsumo'),
    ('Staging_Refresh_FactRecepciones'),
    ('Staging_Refresh_FactConsumoPlanificado'),
    ('Staging_Refresh_FactComprasEnProceso'),
    ('Staging_Refresh_FactDemandaPendiente');

DECLARE @jname NVARCHAR(200);
DECLARE cur CURSOR FOR SELECT name FROM @jobs;
OPEN cur;
FETCH NEXT FROM cur INTO @jname;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jname)
        EXEC msdb.dbo.sp_delete_job @job_name = @jname, @delete_unused_schedule = 1;
    FETCH NEXT FROM cur INTO @jname;
END
CLOSE cur;
DEALLOCATE cur;
GO

-- =====================================================
-- JOB 1: Refresh_Dimensions (daily 05:00)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_Dimensions',
    @enabled = 1,
    @description = N'Refresh dimArticulo + dimProveedor daily';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_Dimensions',
    @step_name = N'Refresh Dimensions',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_dimArticulo; EXEC dbo.sp_refresh_dimProveedor;',
    @on_success_action = 3,   -- Go to next step (success alert)
    @on_fail_action = 1;      -- Quit reporting failure
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_Dimensions',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_Dimensions" -Message "Dimensions refreshed successfully" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_Dimensions',
    @name = N'Daily_05_00',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 50000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_Dimensions';
GO

-- =====================================================
-- JOB 2: Refresh_FactStock (daily 05:10)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactStock',
    @enabled = 1,
    @description = N'Refresh factStockEPSA daily snapshot';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactStock',
    @step_name = N'Refresh factStockEPSA',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factStockEPSA;',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactStock',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactStock" -Message "Stock snapshot refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactStock',
    @name = N'Daily_05_10',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 51000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactStock';
GO

-- =====================================================
-- JOB 3: Refresh_FactConsumo (2x daily: 05:20 + 13:00)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactConsumo',
    @enabled = 1,
    @description = N'Refresh factConsumo 2x daily (incremental)';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactConsumo',
    @step_name = N'Refresh factConsumo',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factConsumo @mode = ''INCREMENTAL'';',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactConsumo',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactConsumo" -Message "Consumption data refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactConsumo',
    @name = N'Daily_05_20',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 52000;
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactConsumo',
    @name = N'Daily_13_00',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 130000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactConsumo';
GO

-- =====================================================
-- JOB 4: Refresh_FactRecepciones (daily 05:30)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactRecepciones',
    @enabled = 1,
    @description = N'Incremental append of receipt history';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactRecepciones',
    @step_name = N'Refresh factRecepcionesHistoria',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factRecepcionesHistoria @mode = ''INCREMENTAL'';',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactRecepciones',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactRecepciones" -Message "Receipt history updated" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactRecepciones',
    @name = N'Daily_05_30',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 53000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactRecepciones';
GO

-- =====================================================
-- JOB 5: Refresh_FactConsumoPlanificado (daily 05:40)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactConsumoPlanificado',
    @enabled = 1,
    @description = N'Refresh planned work orders daily';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactConsumoPlanificado',
    @step_name = N'Refresh factConsumoPlanificado',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factConsumoPlanificado;',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactConsumoPlanificado',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactConsumoPlanificado" -Message "Planned consumption refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactConsumoPlanificado',
    @name = N'Daily_05_40',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 54000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactConsumoPlanificado';
GO

-- =====================================================
-- JOB 6: Refresh_FactComprasEnProceso (2x daily: 05:50 + 13:10)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactComprasEnProceso',
    @enabled = 1,
    @description = N'Refresh active POs/requests 2x daily';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactComprasEnProceso',
    @step_name = N'Refresh factComprasEnProceso',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factComprasEnProceso;',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactComprasEnProceso',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactComprasEnProceso" -Message "Active purchases refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactComprasEnProceso',
    @name = N'Daily_05_50',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 55000;
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactComprasEnProceso',
    @name = N'Daily_13_10',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 131000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactComprasEnProceso';
GO

-- =====================================================
-- JOB 7: Refresh_FactDemandaPendiente (daily 02:00)
-- =====================================================
EXEC msdb.dbo.sp_add_job
    @job_name = N'Staging_Refresh_FactDemandaPendiente',
    @enabled = 1,
    @description = N'Refresh pending demand (heavy recursive BOM) daily early';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactDemandaPendiente',
    @step_name = N'Refresh factDemandaPendiente',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factDemandaPendiente;',
    @on_success_action = 3,
    @on_fail_action = 1;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Staging_Refresh_FactDemandaPendiente',
    @step_name = N'Alert Teams Success',
    @subsystem = N'CmdExec',
    @command = N'powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "OK: Staging_Refresh_FactDemandaPendiente" -Message "Pending demand BOM refreshed" -Color "00FF00"';
GO

EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'Staging_Refresh_FactDemandaPendiente',
    @name = N'Daily_02_00',
    @freq_type = 4, @freq_interval = 1, @active_start_time = 20000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Staging_Refresh_FactDemandaPendiente';
GO

-- =====================================================
-- VERIFY ALL JOBS
-- =====================================================
SELECT j.name AS JobName, 
       COUNT(DISTINCT js.step_id) AS Steps,
       STRING_AGG(s.name, ', ') AS Schedules,
       CASE j.enabled WHEN 1 THEN 'ENABLED' ELSE 'DISABLED' END AS Status
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id
LEFT JOIN msdb.dbo.sysjobschedules jsc ON j.job_id = jsc.job_id
LEFT JOIN msdb.dbo.sysschedules s ON jsc.schedule_id = s.schedule_id
WHERE j.name LIKE 'Staging_Refresh%'
GROUP BY j.name, j.enabled
ORDER BY j.name;
GO
