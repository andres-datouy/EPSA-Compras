-- ============================================================
-- Task 7: Migrate factRecepcionesHistoria (Incremental + Full Reload)
-- Server: 192.168.2.47 (port 1435)
-- Source: [192.168.2.7].[EPSA_BI].[dbo].[vw_ComprasBI_HistoriaRecepciones]
-- Refresh: INCREMENTAL (daily) or FULL (one-time reload)
-- Schedule: Daily 8:30 AM
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table (matches source view columns exactly)
IF OBJECT_ID('dbo.stg_factRecepcionesHistoria', 'U') IS NOT NULL DROP TABLE dbo.stg_factRecepcionesHistoria;
GO

CREATE TABLE dbo.stg_factRecepcionesHistoria (
    [Empresa]                     CHAR(10),
    [RecepcionFecha]              DATETIME,
    [RecepcionArticulo]           CHAR(30),
    [RecepcionCantidad]            NUMERIC(18,4),
    [RecepcionOCDocumento]        CHAR(10),
    [RecepcionOCNumero]           INT,
    [RecepcionArticuloTipo]       CHAR(10),
    [OCDocumento]                 CHAR(10),
    [OCNumero]                    INT,
    [OCProveedor]                 CHAR(15),
    [OCFecha]                     DATETIME,
    [OCTotalMO]                   NUMERIC(18,2),
    [OCTotalTR]                   NUMERIC(18,2),
    [OCMoneda]                    CHAR(3),
    [OCArticuloCodigo]            CHAR(30),
    [OCPrecioMO]                  NUMERIC(18,4),
    [OCPrecioUSD]                 NUMERIC(18,4),
    [SolicitudDocumento]          CHAR(10),
    [SolicitudNumero]             INT,
    [SolicitudFecha]              DATETIME,
    [CompraDocumento]             CHAR(10),
    [CompraNumero]                VARCHAR(20),
    [CompraFecha]                 DATETIME,
    [CompraOCDoc]                 CHAR(10),
    [CompraOCNumero]              INT
);
GO

CREATE CLUSTERED INDEX IX_stg_factRecepciones_Articulo 
    ON dbo.stg_factRecepcionesHistoria([RecepcionArticulo]);
CREATE INDEX IX_stg_factRecepciones_Fecha 
    ON dbo.stg_factRecepcionesHistoria([RecepcionFecha]);
GO

-- 2. Create refresh stored procedure (supports FULL and INCREMENTAL modes)
--    FULL: Truncates and reloads ALL history (for initial load or one-time reload)
--    INCREMENTAL: Deletes from last date and re-inserts (handles partial-day corrections)
CREATE OR ALTER PROC dbo.sp_refresh_factRecepcionesHistoria 
    @mode NVARCHAR(20) = 'INCREMENTAL'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;
    DECLARE @maxDate DATE = ISNULL(
        (SELECT MAX(RecepcionFecha) FROM dbo.stg_factRecepcionesHistoria), 
        '2020-01-01');

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factRecepcionesHistoria', @mode, @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        IF @mode = 'FULL'
        BEGIN
            TRUNCATE TABLE dbo.stg_factRecepcionesHistoria;
            SET @maxDate = '1900-01-01';
        END
        ELSE
        BEGIN
            -- Delete rows from the last known date to re-process partial days
            DELETE FROM dbo.stg_factRecepcionesHistoria 
            WHERE RecepcionFecha >= @maxDate;
        END

        INSERT INTO dbo.stg_factRecepcionesHistoria
        SELECT * FROM [192.168.2.7].[EPSA_BI].[dbo].[vw_ComprasBI_HistoriaRecepciones]
        WHERE RecepcionFecha >= @maxDate;

        SET @rowCount = @@ROWCOUNT;
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            rows_affected = @rowCount, status = 'SUCCESS' WHERE log_id = @logId;
        PRINT 'factRecepcionesHistoria: ' + CAST(@rowCount AS VARCHAR) + ' rows (' + @mode + ')';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            status = 'ERROR', error_message = ERROR_MESSAGE() WHERE log_id = @logId;
        THROW;
    END CATCH
END
GO

-- 3. Initial full load (all history)
EXEC dbo.sp_refresh_factRecepcionesHistoria @mode = 'FULL';
GO

-- 4. Validation
SELECT 'stg_factRecepcionesHistoria' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factRecepcionesHistoria;
SELECT MIN([RecepcionFecha]) AS EarliestDate, MAX([RecepcionFecha]) AS LatestDate FROM dbo.stg_factRecepcionesHistoria;
GO
