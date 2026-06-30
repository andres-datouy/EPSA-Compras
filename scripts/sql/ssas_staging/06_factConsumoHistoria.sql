-- ============================================================
-- Task 6: Refresh factConsumo (Full / Incremental)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [192.168.2.7].[Nodum].[dbo].[cpf_stockaux] + ct_articulos + ct_prdcomponente
-- Refresh: FULL (truncate+load) or INCREMENTAL (delete recent + append)
-- Schedule: SQL Agent job Staging_Refresh_FactConsumo (2x daily)
-- ============================================================
-- NOTE: The Obligatorio column was added to stg_factConsumo and is now
-- computed natively by this SP. Block A inserts 'S' (obligatory articles),
-- Block B inserts 'N' (non-obligatory + no-componente articles).
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table (if not exists)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stg_factConsumo')
BEGIN
    CREATE TABLE dbo.stg_factConsumo (
        [FuenteConsumo]             NVARCHAR(50),
        [formulario]                NVARCHAR(50),
        [nro_trans]                 INT,
        [nro_docum]                 NVARCHAR(50),
        [fec_doc]                   DATE,
        [cod_tit]                   NVARCHAR(50),
        [cod_estado]                NVARCHAR(50),
        [cod_articulo]              NVARCHAR(50),
        [nom_articulo]              NVARCHAR(200),
        [cod_tipoart]               NVARCHAR(50),
        [cantidad]                  FLOAT,
        [Articulo_TipoComponente]   NVARCHAR(50),
        [Obligatorio]               NVARCHAR(5)
    );
    PRINT 'Created stg_factConsumo table';
END
GO

-- 2. Create/alter refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factConsumo 
    @mode NVARCHAR(20) = 'FULL'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;
    DECLARE @cutoffDate DATE = '2020-01-01';

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factConsumo', @mode, @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        IF @mode = 'FULL'
            TRUNCATE TABLE dbo.stg_factConsumo;
        ELSE
            -- INCREMENTAL: delete the entire rolling window to prevent duplicates
            DELETE FROM dbo.stg_factConsumo WHERE fec_doc >= @cutoffDate;

        -- =============================================
        -- A) OBLIGATORY: consumption from production parts
        -- =============================================
        INSERT INTO dbo.stg_factConsumo 
            (FuenteConsumo, formulario, nro_trans, nro_docum, fec_doc,
             cod_tit, cod_estado, cod_articulo, nom_articulo, cod_tipoart,
             cantidad, Articulo_TipoComponente, Obligatorio)
        SELECT 
            'Produccion' AS FuenteConsumo,
            s.formulario, s.nro_trans, s.nro_docum, s.fec_doc,
            s.cod_tit, s.cod_estado,
            s.cod_articulo, a.nom_articulo, a.cod_tipoart,
            (s.cantidad * s.signo) * -1 AS cantidad,
            'Obligatorio' AS Articulo_TipoComponente,
            'S' AS Obligatorio
        FROM [192.168.2.7].[Nodum].[dbo].[cpf_stockaux] s
        INNER JOIN [192.168.2.7].[Nodum].[dbo].[ct_articulos] a ON s.cod_articulo = a.cod_articulo
        WHERE s.cod_emp = 'EPSA'
          AND s.cod_estado = 'procesoprod'
          AND s.fec_doc >= @cutoffDate
          AND s.cod_docum IN ('parteprd', 'partecon', 'partprd')
          AND a.cod_tipoart NOT IN ('pt', 'prvta')
          AND EXISTS (
              SELECT 1 FROM [192.168.2.7].[Nodum].[dbo].[ct_prdcomponente] c
              JOIN [192.168.2.7].[Nodum].[dbo].[ct_prdproducto] p ON p.nro_formula = c.nro_formula
              WHERE c.cod_articulo = s.cod_articulo 
                AND c.es_obligatorio = 'S'
                AND p.activo = 'S'
          );

        -- =============================================
        -- B) NON-OBLIGATORY + NO_COMPONENTE: from stock movements
        -- =============================================
        INSERT INTO dbo.stg_factConsumo 
            (FuenteConsumo, formulario, nro_trans, nro_docum, fec_doc,
             cod_tit, cod_estado, cod_articulo, nom_articulo, cod_tipoart,
             cantidad, Articulo_TipoComponente, Obligatorio)
        SELECT 
            'Existencia' AS FuenteConsumo,
            s.formulario, s.nro_trans, s.nro_docum, s.fec_doc,
            s.cod_tit, s.cod_estado,
            s.cod_articulo, a.nom_articulo, a.cod_tipoart,
            (s.cantidad * s.signo) AS cantidad,
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM [192.168.2.7].[Nodum].[dbo].[ct_prdcomponente] c
                    JOIN [192.168.2.7].[Nodum].[dbo].[ct_prdproducto] p ON p.nro_formula = c.nro_formula
                    WHERE c.cod_articulo = s.cod_articulo AND p.activo = 'S'
                ) THEN 'No_Obligatorio'
                ELSE 'No_Componente'
            END AS Articulo_TipoComponente,
            'N' AS Obligatorio
        FROM [192.168.2.7].[Nodum].[dbo].[cpf_stockaux] s
        INNER JOIN [192.168.2.7].[Nodum].[dbo].[ct_articulos] a ON s.cod_articulo = a.cod_articulo
        WHERE s.cod_emp = 'EPSA'
          AND s.cod_estado = 'existencia'
          AND s.fec_doc >= @cutoffDate
          AND s.cod_docum NOT IN ('recepi')
          AND a.cod_tipoart NOT IN ('prvta', 'pt', 'semi', 'tubos')
          AND NOT EXISTS (
              SELECT 1 FROM [192.168.2.7].[Nodum].[dbo].[ct_prdcomponente] c
              JOIN [192.168.2.7].[Nodum].[dbo].[ct_prdproducto] p ON p.nro_formula = c.nro_formula
              WHERE c.cod_articulo = s.cod_articulo 
                AND c.es_obligatorio = 'S'
                AND p.activo = 'S'
          );

        SET @rowCount = @@ROWCOUNT;
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            rows_affected = @rowCount, status = 'SUCCESS' WHERE log_id = @logId;
        PRINT 'factConsumo: ' + CAST(@rowCount AS VARCHAR) + ' rows (' + @mode + ')';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log SET end_time = SYSUTCDATETIME(), 
            status = 'ERROR', error_message = ERROR_MESSAGE() WHERE log_id = @logId;
        THROW;
    END CATCH
END
GO

-- 3. Validation
SELECT 'stg_factConsumo' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factConsumo;
SELECT Obligatorio, COUNT(*) AS RowCount FROM dbo.stg_factConsumo GROUP BY Obligatorio;
GO
