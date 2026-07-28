-- ============================================================
-- Migration: Add Comentarios column to stg_dimArticulo + update SP
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [192.168.2.7].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA]
-- Run AFTER the view has been updated with the Comentarios field
-- Column names verified against live server 2026-05-18
-- ============================================================

USE [staging_compras];
GO

-- 1. Add column to staging table (idempotent)
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.stg_dimArticulo') 
      AND name = 'Comentarios'
)
BEGIN
    ALTER TABLE dbo.stg_dimArticulo 
    ADD Comentarios NVARCHAR(MAX) NULL;
    PRINT 'Column [Comentarios] added to stg_dimArticulo';
END
ELSE
    PRINT 'Column [Comentarios] already exists';
GO

-- 2. Update the refresh SP (column names match live table exactly)
CREATE OR ALTER PROC dbo.sp_refresh_dimArticulo
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_dimArticulo', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_dimArticulo;

        INSERT INTO dbo.stg_dimArticulo (
            cod_articulo, nom_articulo, catalogo,
            cod_tipoart, nom_tipoart, [Tipo Artículo],
            cod_marca, marca_dsc,
            cod_clasifart, nom_clasifart,
            cod_familia_art, nom_familia_art,
            cod_subfam_art, nom_subfam_art,
            cod_uni_stk,
            cod_grcontvta, Grupo, nom_grupoart,
            cod_uso, nom_usofinal,
            stock_minimo, plazo, lote_min_cpra,
            ProveedorArticulo, ProveedorArticuloNombre,
            ProveedorPais, ProveedorPaisNombre,
            Proveedores, TipoComponente,
            Comentarios
        )
        SELECT 
            cod_articulo, nom_articulo, catalogo,
            cod_tipoart, nom_tipoart, [Tipo Artículo],
            cod_marca, marca_dsc,
            cod_clasifart, nom_clasifart,
            cod_familia_art, nom_familia_art,
            cod_subfam_art, nom_subfam_art,
            cod_uni_stk,
            cod_grcontvta, Grupo, nom_grupoart,
            cod_uso, nom_usofinal,
            stock_minimo, plazo, lote_min_cpra,
            ProveedorArticulo, ProveedorArticuloNombre,
            ProveedorPais, ProveedorPaisNombre,
            Proveedores, TipoComponente,
            Comentarios
        FROM [192.168.2.7].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA];

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'dimArticulo refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), status = 'ERROR', 
            error_message = ERROR_MESSAGE()
        WHERE log_id = @logId;

        THROW;
    END CATCH
END
GO

-- 3. Execute refresh to load Comentarios data
EXEC dbo.sp_refresh_dimArticulo;
GO

-- 4. Validate
SELECT TOP 10 cod_articulo, nom_articulo, Comentarios
FROM dbo.stg_dimArticulo
WHERE Comentarios IS NOT NULL AND Comentarios <> '';
GO
