-- ============================================================
-- Task 3: Migrate dimArticulo (Full Replace)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [192.168.2.7].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA]
-- Refresh: FULL REPLACE (truncate + load)
-- Schedule: Daily 6:00 AM
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table (matches actual view output from 2025-05-18)
IF OBJECT_ID('dbo.stg_dimArticulo', 'U') IS NOT NULL DROP TABLE dbo.stg_dimArticulo;
GO

CREATE TABLE dbo.stg_dimArticulo (
    [Articulo Codigo]               NVARCHAR(50) NOT NULL PRIMARY KEY,
    [Articulo Nombre]               NVARCHAR(200),
    [Articulo Catalogo]             NVARCHAR(50),
    [Tipo Articulo Codigo]          NVARCHAR(50),
    [Tipo Articulo Nombre]          NVARCHAR(100),
    [Tipo Artículo]                 NVARCHAR(20),
    [Marca Codigo]                  NVARCHAR(50),
    [Marca Descripcion]             NVARCHAR(100),
    [Clase Codigo]                  NVARCHAR(50),
    [Clase Nombre]                  NVARCHAR(100),
    [Familia Codigo]                NVARCHAR(50),
    [Familia Nombre]                NVARCHAR(100),
    [Subfamilia Codigo]             NVARCHAR(50),
    [SubFamilia Nombre]             NVARCHAR(100),
    [Unidad Stock]                  NVARCHAR(20),
    [Grupo Contable de Venta Codigo] NVARCHAR(50),
    [Grupo]                         NVARCHAR(50),
    [Grupo Articulo Nombre]         NVARCHAR(100),
    [Uso Codigo]                    NVARCHAR(50),
    [Uso Nombre]                    NVARCHAR(100),
    [Articulo Stock Minimo]         FLOAT,
    [Plazo]                         FLOAT,
    [Lote Minimo Compra]            FLOAT,
    [Proveedor Articulo]            NVARCHAR(50),
    [Proveedor Articulo Nombre]     NVARCHAR(200),
    [Proveedor Pais]                NVARCHAR(50),
    [Proveedor Pais Nombre]         NVARCHAR(100),
    [Proveedores]                   INT,
    [TipoComponente]                NVARCHAR(50)
);
GO

-- 2. Create refresh stored procedure
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
            [Articulo Codigo], [Articulo Nombre], [Articulo Catalogo],
            [Tipo Articulo Codigo], [Tipo Articulo Nombre], [Tipo Artículo],
            [Marca Codigo], [Marca Descripcion],
            [Clase Codigo], [Clase Nombre],
            [Familia Codigo], [Familia Nombre],
            [Subfamilia Codigo], [SubFamilia Nombre],
            [Unidad Stock],
            [Grupo Contable de Venta Codigo], [Grupo], [Grupo Articulo Nombre],
            [Uso Codigo], [Uso Nombre],
            [Articulo Stock Minimo], [Plazo], [Lote Minimo Compra],
            [Proveedor Articulo], [Proveedor Articulo Nombre],
            [Proveedor Pais], [Proveedor Pais Nombre],
            [Proveedores], [TipoComponente]
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
            Proveedores,
            TipoComponente
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

-- 3. Initial load
EXEC dbo.sp_refresh_dimArticulo;
GO

-- 4. Validation
SELECT 'stg_dimArticulo' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_dimArticulo;
SELECT TOP 5 [Articulo Codigo], [Articulo Nombre], [Tipo Artículo], 
    [Proveedor Articulo], [Proveedor Articulo Nombre], [Proveedores]
FROM dbo.stg_dimArticulo;

-- Compare with source
SELECT 'SOURCE' AS Location, COUNT(*) AS RowCount 
FROM [192.168.2.7].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA];
GO
