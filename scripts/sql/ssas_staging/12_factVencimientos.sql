-- ============================================================
-- Phase 5: factVencimientos (Lot/Batch Expiry Tracking)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [192.168.2.7].[Nodum].[dbo].{sa_stocklote, ct_articulos, cpt_lote}
-- Refresh: FULL REPLACE (truncate + load)
-- Schedule: SQL Agent job Staging_Refresh_FactVencimientos (daily 06:00, 14_vencimientos_job.sql)
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factVencimientos', 'U') IS NOT NULL DROP TABLE dbo.stg_factVencimientos;
GO

CREATE TABLE dbo.stg_factVencimientos (
    [cod_articulo]     NVARCHAR(50) NOT NULL,
    [nro_lote]         NVARCHAR(50) NOT NULL,
    [cantidad]         FLOAT NOT NULL,
    [fec_venc]         DATE
);
GO

CREATE CLUSTERED INDEX IX_stg_factVencimientos_Articulo 
    ON dbo.stg_factVencimientos([cod_articulo]);
CREATE INDEX IX_stg_factVencimientos_FecVenc 
    ON dbo.stg_factVencimientos([fec_venc]);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factVencimientos
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factVencimientos', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_factVencimientos;

        INSERT INTO dbo.stg_factVencimientos (
            [cod_articulo], [nro_lote], [cantidad], [fec_venc]
        )
        SELECT 
            s.cod_articulo, 
            s.nro_lote, 
            s.cantidad, 
            l.fec_venc
        FROM [192.168.2.7].[Nodum].[dbo].[sa_stocklote] s
        INNER JOIN [192.168.2.7].[Nodum].[dbo].[ct_articulos] a 
            ON a.cod_articulo = s.cod_articulo
        INNER JOIN [192.168.2.7].[Nodum].[dbo].[cpt_lote] l 
            ON l.cod_articulo = s.cod_articulo 
            AND l.nro_lote = s.nro_lote 
            AND l.cod_emp = 'epsa'
        WHERE s.cod_emp = 'epsa'
          AND s.cantidad > 0
          AND a.cod_tipoart NOT IN ('pt','semi','tubos','prvta')
          AND s.cod_estado = 'existencia';

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factVencimientos refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
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
EXEC dbo.sp_refresh_factVencimientos;
GO

-- 4. Validation
SELECT 'stg_factVencimientos' AS TableName, COUNT(*) AS [Rows] FROM dbo.stg_factVencimientos;
SELECT MIN([fec_venc]) AS EarliestExpiry, MAX([fec_venc]) AS LatestExpiry FROM dbo.stg_factVencimientos;
SELECT 
    CASE 
        WHEN fec_venc < CAST(GETDATE() AS DATE) THEN 'Vencido'
        WHEN fec_venc <= DATEADD(DAY, 30, GETDATE()) THEN 'Por vencer 30d'
        WHEN fec_venc <= DATEADD(DAY, 90, GETDATE()) THEN 'Por vencer 90d'
        ELSE 'Vigente'
    END AS Estado,
    COUNT(*) AS Lotes,
    SUM(cantidad) AS Cantidad
FROM dbo.stg_factVencimientos
GROUP BY 
    CASE 
        WHEN fec_venc < CAST(GETDATE() AS DATE) THEN 'Vencido'
        WHEN fec_venc <= DATEADD(DAY, 30, GETDATE()) THEN 'Por vencer 30d'
        WHEN fec_venc <= DATEADD(DAY, 90, GETDATE()) THEN 'Por vencer 90d'
        ELSE 'Vigente'
    END
ORDER BY Estado;
GO
