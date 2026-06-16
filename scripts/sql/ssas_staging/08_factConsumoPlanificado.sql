-- ============================================================
-- Task 8: Migrate factConsumoPlanificado (Full Replace)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[EPSA_BI].[dbo].[vw_ComprasBI_factConsumoPlanificadoEPSA]
-- Refresh: FULL REPLACE (truncate + load, volatile data)
-- Schedule: Daily 6:00 AM
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factConsumoPlanificado', 'U') IS NOT NULL DROP TABLE dbo.stg_factConsumoPlanificado;
GO

CREATE TABLE dbo.stg_factConsumoPlanificado (
    [Consumo Planificado Articulo]          NVARCHAR(50) NOT NULL,
    [Consumo Planificado Cantidad]          FLOAT,
    [Consumo Planificado Fecha Planificacion] DATE,
    [Consumo Planificado Orden]             NVARCHAR(50),
    [Consumo Planificado N Paso Orden]      INT,
    [Consumo Planificado Tipo Orden]        NVARCHAR(50)
);
GO

CREATE CLUSTERED INDEX IX_stg_factConsPlan_Articulo 
    ON dbo.stg_factConsumoPlanificado([Consumo Planificado Articulo]);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factConsumoPlanificado
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factConsumoPlanificado', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_factConsumoPlanificado;

        INSERT INTO dbo.stg_factConsumoPlanificado (
            [Consumo Planificado Articulo], [Consumo Planificado Cantidad],
            [Consumo Planificado Fecha Planificacion],
            [Consumo Planificado Orden], [Consumo Planificado N Paso Orden],
            [Consumo Planificado Tipo Orden]
        )
        SELECT 
            cod_articulo, Cantidad_Requerida,
            CAST(Fecha_Planificacion AS DATE),
            nro_orden, nro_pasoprod, OrdenTipo
        FROM [BI_SOURCE].[EPSA_BI].[dbo].[vw_ComprasBI_factConsumoPlanificadoEPSA];

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factConsumoPlanificado refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
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
EXEC dbo.sp_refresh_factConsumoPlanificado;
GO

-- 4. Validation
SELECT 'stg_factConsumoPlanificado' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factConsumoPlanificado;
GO
