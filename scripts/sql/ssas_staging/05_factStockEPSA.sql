-- ============================================================
-- Task 5: Migrate factStockEPSA (Full Replace, Volatile)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[EPSA_BI].[dbo].[vw_ComprasBI_factStockEPSA]
-- Refresh: FULL REPLACE (truncate + load)
-- Schedule: Every 4 hours
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factStockEPSA', 'U') IS NOT NULL DROP TABLE dbo.stg_factStockEPSA;
GO

CREATE TABLE dbo.stg_factStockEPSA (
    [Stock Articulo Codigo]  NVARCHAR(50) NOT NULL,
    [Stock Cantidad]         FLOAT,
    [Stock Deposito]         NVARCHAR(50),
    [Stock Estado]           NVARCHAR(50),
    [Stock Estado Tipo]      NVARCHAR(50),
    [Stock Fecha_Corte]      DATE
);
GO

CREATE CLUSTERED INDEX IX_stg_factStockEPSA_Articulo 
    ON dbo.stg_factStockEPSA([Stock Articulo Codigo]);
CREATE INDEX IX_stg_factStockEPSA_Fecha 
    ON dbo.stg_factStockEPSA([Stock Fecha_Corte]);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factStockEPSA
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factStockEPSA', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_factStockEPSA;

        INSERT INTO dbo.stg_factStockEPSA (
            [Stock Articulo Codigo], [Stock Cantidad], [Stock Deposito],
            [Stock Estado], [Stock Estado Tipo], [Stock Fecha_Corte]
        )
        SELECT 
            [cod_articulo], [Cantidad], [Deposito],
            [Estado], [EstadoTipo], [Fecha_Corte]
        FROM [BI_SOURCE].[EPSA_BI].[dbo].[vw_ComprasBI_factStockEPSA];

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factStockEPSA refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), status = 'ERROR', error_message = ERROR_MESSAGE()
        WHERE log_id = @logId;
        THROW;
    END CATCH
END
GO

-- 3. Initial load
EXEC dbo.sp_refresh_factStockEPSA;
GO

-- 4. Validation
SELECT 'stg_factStockEPSA' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factStockEPSA;
SELECT MAX([Stock Fecha_Corte]) AS LatestDate FROM dbo.stg_factStockEPSA;
GO
