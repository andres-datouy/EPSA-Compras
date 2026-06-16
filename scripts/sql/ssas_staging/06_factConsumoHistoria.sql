-- ============================================================
-- Task 6: Migrate factConsumoHistoria (Incremental Append)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[Nodum].[dbo].[cpf_stockaux] + ct_articulos
-- Refresh: INCREMENTAL APPEND (only new rows since last load)
-- Schedule: Daily 7:00 AM
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factConsumoHistoria', 'U') IS NOT NULL DROP TABLE dbo.stg_factConsumoHistoria;
GO

CREATE TABLE dbo.stg_factConsumoHistoria (
    [Consumo Articulo Codigo]  NVARCHAR(50) NOT NULL,
    [Consumo Cantidad]         FLOAT,
    [Consumo Deposito]         NVARCHAR(50),
    [Consumo Documento]        NVARCHAR(50),
    [Consumo Estado]           NVARCHAR(50),
    [Consumo Fecha]            DATE,
    [Consumo Formulario]       NVARCHAR(50),
    [Consumo N Documento]      BIGINT,
    [Consumo Obligatorio]      NVARCHAR(5),
    [Consumo Transaccion]      BIGINT
);
GO

CREATE CLUSTERED INDEX IX_stg_factConsumo_Articulo 
    ON dbo.stg_factConsumoHistoria([Consumo Articulo Codigo]);
CREATE INDEX IX_stg_factConsumo_Fecha 
    ON dbo.stg_factConsumoHistoria([Consumo Fecha]);
GO

-- 2. Create refresh stored procedure (INCREMENTAL)
CREATE OR ALTER PROC dbo.sp_refresh_factConsumoHistoria
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;
    DECLARE @maxDate DATE;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factConsumoHistoria', 'INCREMENTAL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        -- Determine last loaded date (or initial date for first load)
        SELECT @maxDate = ISNULL(MAX([Consumo Fecha]), '2020-02-01') 
        FROM dbo.stg_factConsumoHistoria;

        PRINT 'Loading consumo since: ' + CONVERT(VARCHAR, @maxDate, 120);

        -- Incremental append: only rows with fec_doc > last loaded date
        INSERT INTO dbo.stg_factConsumoHistoria (
            [Consumo Articulo Codigo], [Consumo Cantidad], [Consumo Deposito],
            [Consumo Documento], [Consumo Estado], [Consumo Fecha],
            [Consumo Formulario], [Consumo N Documento],
            [Consumo Obligatorio], [Consumo Transaccion]
        )
        SELECT 
            s.cod_articulo,
            (s.cantidad * s.signo),
            s.cod_tit,
            s.cod_docum,
            s.cod_estado,
            CAST(s.fec_doc AS DATE),
            s.formulario,
            s.nro_docum,
            ISNULL((SELECT CASE WHEN (SELECT COUNT(*) FROM [BI_SOURCE].[Nodum].[dbo].[ct_prdcomponente] WHERE cod_articulo = s.cod_articulo AND es_obligatorio = 'S') > 0 THEN 'S' ELSE 'N' END), 'N'),
            s.nro_trans
        FROM [BI_SOURCE].[Nodum].[dbo].[cpf_stockaux] s
        JOIN [BI_SOURCE].[Nodum].[dbo].[ct_articulos] a ON s.cod_articulo = a.cod_articulo
        WHERE s.cod_emp = 'EPSA'
            AND s.cod_estado IN ('existencia')
            AND s.fec_doc > @maxDate
            AND s.cod_docum NOT IN ('recepi')
            AND a.cod_tipoart NOT IN ('prvta', 'pt', 'semi', 'tubos');

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factConsumoHistoria appended: ' + CAST(@rowCount AS VARCHAR) + ' new rows';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), status = 'ERROR', error_message = ERROR_MESSAGE()
        WHERE log_id = @logId;
        THROW;
    END CATCH
END
GO

-- 3. Initial load (first run loads full history from 2020-02-01)
EXEC dbo.sp_refresh_factConsumoHistoria;
GO

-- 4. Validation
SELECT 'stg_factConsumoHistoria' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factConsumoHistoria;
SELECT MIN([Consumo Fecha]) AS EarliestDate, MAX([Consumo Fecha]) AS LatestDate FROM dbo.stg_factConsumoHistoria;
GO
