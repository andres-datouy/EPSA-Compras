-- ============================================================
-- Task 2: Create staging_compras Database
-- Server: 192.168.2.47\SSAS (port 1435)
-- Run as: sa or sysadmin on local DB Engine
-- ============================================================

USE [master];
GO

-- 1. Create database (idempotent)
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'staging_compras')
BEGIN
    CREATE DATABASE [staging_compras];
    PRINT 'Created staging_compras database';
END
ELSE
BEGIN
    PRINT 'Database staging_compras already exists';
END
GO

-- 2. Set recovery model to Simple (staging doesn't need log backups)
ALTER DATABASE [staging_compras] SET RECOVERY SIMPLE;
GO

-- 3. Set database options
ALTER DATABASE [staging_compras] SET AUTO_SHRINK OFF;
ALTER DATABASE [staging_compras] SET AUTO_CREATE_STATISTICS ON;
ALTER DATABASE [staging_compras] SET AUTO_UPDATE_STATISTICS ON;
GO

-- 4. Create refresh log table
USE [staging_compras];
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'stg_refresh_log')
BEGIN
    CREATE TABLE dbo.stg_refresh_log (
        log_id          INT IDENTITY(1,1) PRIMARY KEY,
        table_name      NVARCHAR(100) NOT NULL,
        refresh_type    NVARCHAR(20) NOT NULL,   -- 'FULL' or 'INCREMENTAL'
        start_time      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        end_time        DATETIME2 NULL,
        rows_affected   INT NULL,
        status          NVARCHAR(20) NULL,       -- 'SUCCESS', 'ERROR'
        error_message   NVARCHAR(MAX) NULL
    );
    PRINT 'Created stg_refresh_log table';
END
GO

-- 5. Validation
SELECT name, recovery_model_desc, state_desc 
FROM sys.databases 
WHERE name = N'staging_compras';

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = 'staging_compras';

PRINT '';
PRINT 'staging_compras database setup COMPLETE.';
GO
