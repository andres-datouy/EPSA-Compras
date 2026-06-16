-- ============================================================
-- Task 11: SQL Agent Jobs for Scheduled Refresh
-- Server: 192.168.2.47\SSAS (port 1435)
-- Creates 3 jobs with staggered schedules
-- ============================================================

USE [msdb];
GO

-- ============================================================
-- Job 1: Dimensions + Volatile Facts (Daily 6:00 AM)
-- ============================================================
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'EPSA - Refresh Dimensions')
    EXEC msdb.dbo.sp_delete_job @job_name = N'EPSA - Refresh Dimensions';
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'EPSA - Refresh Dimensions',
    @description = N'Daily 6AM: Refresh dimensions (dimArticulo, dimProveedor) and volatile facts (stock, consumo planificado, compras en proceso)',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'sa';
GO

-- Step 1: dimArticulo
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Dimensions',
    @step_name = N'Refresh dimArticulo',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_dimArticulo;',
    @on_success_action = 3,  -- Go to next step
    @on_fail_action = 3;     -- Continue on failure (log and proceed)
GO

-- Step 2: dimProveedor
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Dimensions',
    @step_name = N'Refresh dimProveedor',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_dimProveedor;',
    @on_success_action = 3,
    @on_fail_action = 3;
GO

-- Step 3: factStockEPSA
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Dimensions',
    @step_name = N'Refresh factStockEPSA',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factStockEPSA;',
    @on_success_action = 3,
    @on_fail_action = 3;
GO

-- Step 4: factConsumoPlanificado
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Dimensions',
    @step_name = N'Refresh factConsumoPlanificado',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factConsumoPlanificado;',
    @on_success_action = 3,
    @on_fail_action = 3;
GO

-- Step 5: factComprasEnProceso
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Dimensions',
    @step_name = N'Refresh factComprasEnProceso',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factComprasEnProceso;',
    @on_success_action = 1,  -- Quit with success
    @on_fail_action = 2;     -- Quit with failure
GO

-- Schedule: Daily 6:00 AM
EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'EPSA - Refresh Dimensions',
    @name = N'Daily 6AM',
    @freq_type = 4,          -- Daily
    @freq_interval = 1,      -- Every day
    @active_start_time = 60000; -- 6:00 AM
GO

-- Add to local server
EXEC msdb.dbo.sp_add_jobserver @job_name = N'EPSA - Refresh Dimensions';
GO

-- ============================================================
-- Job 2: Incremental History (Daily 7:00 AM)
-- ============================================================
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'EPSA - Refresh History (Incremental)')
    EXEC msdb.dbo.sp_delete_job @job_name = N'EPSA - Refresh History (Incremental)';
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'EPSA - Refresh History (Incremental)',
    @description = N'Daily 7AM: Incremental append of historical data (consumo, recepciones)',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'sa';
GO

-- Step 1: factConsumoHistoria
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh History (Incremental)',
    @step_name = N'Incremental factConsumoHistoria',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factConsumoHistoria;',
    @on_success_action = 3,
    @on_fail_action = 3;
GO

-- Step 2: factRecepcionesHistoria
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh History (Incremental)',
    @step_name = N'Incremental factRecepcionesHistoria',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factRecepcionesHistoria;',
    @on_success_action = 1,
    @on_fail_action = 2;
GO

-- Schedule: Daily 7:00 AM
EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'EPSA - Refresh History (Incremental)',
    @name = N'Daily 7AM',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 70000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'EPSA - Refresh History (Incremental)';
GO

-- ============================================================
-- Job 3: BOM Explosion (Daily 8:00 AM)
-- ============================================================
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'EPSA - Refresh DemandaPendiente (BOM)')
    EXEC msdb.dbo.sp_delete_job @job_name = N'EPSA - Refresh DemandaPendiente (BOM)';
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'EPSA - Refresh DemandaPendiente (BOM)',
    @description = N'Daily 8AM: Execute remote BOM explosion SP and pull results',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'sa';
GO

-- Step 1: Execute remote SP + pull
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh DemandaPendiente (BOM)',
    @step_name = N'Refresh factDemandaPendiente',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factDemandaPendiente;',
    @on_success_action = 1,
    @on_fail_action = 2;
GO

-- Schedule: Daily 8:00 AM
EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'EPSA - Refresh DemandaPendiente (BOM)',
    @name = N'Daily 8AM',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 80000;
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'EPSA - Refresh DemandaPendiente (BOM)';
GO

-- ============================================================
-- Job 4: Volatile Facts Refresh (Every 4 hours, 10:00-22:00)
-- Additional refresh of stock and compras en proceso during work hours
-- ============================================================
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'EPSA - Refresh Volatile (4h)')
    EXEC msdb.dbo.sp_delete_job @job_name = N'EPSA - Refresh Volatile (4h)';
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'EPSA - Refresh Volatile (4h)',
    @description = N'Every 4h (10-22): Refresh stock and compras en proceso',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'sa';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Volatile (4h)',
    @step_name = N'Refresh factStockEPSA',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factStockEPSA;',
    @on_success_action = 3,
    @on_fail_action = 3;
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'EPSA - Refresh Volatile (4h)',
    @step_name = N'Refresh factComprasEnProceso',
    @subsystem = N'TSQL',
    @database_name = N'staging_compras',
    @command = N'EXEC dbo.sp_refresh_factComprasEnProceso;',
    @on_success_action = 1,
    @on_fail_action = 2;
GO

-- Schedule: Every 4 hours (10:00, 14:00, 18:00, 22:00)
EXEC msdb.dbo.sp_add_jobschedule
    @job_name = N'EPSA - Refresh Volatile (4h)',
    @name = N'Every 4h work hours',
    @freq_type = 4,           -- Daily
    @freq_interval = 1,
    @freq_subday_type = 8,    -- Hours
    @freq_subday_interval = 4,
    @active_start_time = 100000,  -- 10:00 AM
    @active_end_time = 220000;    -- 10:00 PM
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = N'EPSA - Refresh Volatile (4h)';
GO

-- ============================================================
-- Validation: List all created jobs
-- ============================================================
SELECT j.name AS JobName, 
       s.name AS ScheduleName,
       CASE s.freq_type 
           WHEN 4 THEN 'Daily' 
           ELSE CAST(s.freq_type AS VARCHAR) 
       END AS Frequency,
       RIGHT('000000' + CAST(s.active_start_time AS VARCHAR), 6) AS StartTime
FROM msdb.dbo.sysjobs j
LEFT JOIN msdb.dbo.sysjobschedules js ON j.job_id = js.job_id
LEFT JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
WHERE j.name LIKE 'EPSA - Refresh%'
ORDER BY s.active_start_time;
GO

PRINT 'SQL Agent Jobs setup COMPLETE.';
GO
