-- ============================================================
-- Task 4: Migrate dimProveedor (Full Replace)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[Nodum] - Multi-table join
-- Refresh: FULL REPLACE (truncate + load)
-- Schedule: Daily 6:00 AM
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_dimProveedor', 'U') IS NOT NULL DROP TABLE dbo.stg_dimProveedor;
GO

CREATE TABLE dbo.stg_dimProveedor (
    [Proveedor Id]                  NVARCHAR(50) NOT NULL PRIMARY KEY,
    [Proveedor Nombre]              NVARCHAR(200),
    [Proveedor Direccion]           NVARCHAR(300),
    [Proveedor Ciudad]              NVARCHAR(50),
    [Proveedor Ciudad Nombre]       NVARCHAR(100),
    [Proveedor Departamento]        NVARCHAR(50),
    [Proveedor Nombre Departamento] NVARCHAR(100),
    [Pais Codigo]                   NVARCHAR(10),
    [Pais Nombre]                   NVARCHAR(100),
    [Proveedor Telefono]            NVARCHAR(50),
    [Proveedor Email]               NVARCHAR(200),
    [Proveedor Origen]              NVARCHAR(20),
    [Proveedor Clase Id]            NVARCHAR(50),
    [Proveedor Clase Nombre]        NVARCHAR(100),
    [Proveedor Forma de Pago]       NVARCHAR(50),
    [Proveedor Forma de Pago Nombre] NVARCHAR(100),
    [Proveedor RUT]                 NVARCHAR(50),
    [Proveedor Status]              NVARCHAR(20)
);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_dimProveedor
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_dimProveedor', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_dimProveedor;

        INSERT INTO dbo.stg_dimProveedor (
            [Proveedor Id], [Proveedor Nombre], [Proveedor Direccion],
            [Proveedor Ciudad], [Proveedor Ciudad Nombre],
            [Proveedor Departamento], [Proveedor Nombre Departamento],
            [Pais Codigo], [Pais Nombre],
            [Proveedor Telefono], [Proveedor Email], [Proveedor Origen],
            [Proveedor Clase Id], [Proveedor Clase Nombre],
            [Proveedor Forma de Pago], [Proveedor Forma de Pago Nombre],
            [Proveedor RUT], [Proveedor Status]
        )
        SELECT 
            p.cod_tit, p.nom_tit, p.dir_tit,
            p.ciudad_tit, ciu.nom_ciudad,
            p.cod_provincia, prov.nom_provincia,
            p.cod_pais, pais.nom_pais,
            p.tel_tit, p.email_tit, p.origen_tit,
            p.cod_clase_prov, cp.nom_clase_prov,
            p.cod_fpago, fp.nom_fpago,
            p.nro_dgi, p.status_prov
        FROM [BI_SOURCE].[Nodum].[dbo].[ct_proveedores] p
        LEFT JOIN [BI_SOURCE].[Nodum].[dbo].[ct_paises] pais 
            ON pais.cod_pais = p.cod_pais
        LEFT JOIN [BI_SOURCE].[Nodum].[dbo].[ct_provincias] prov 
            ON prov.cod_provincia = p.cod_provincia AND prov.cod_pais = p.cod_pais
        LEFT JOIN [BI_SOURCE].[Nodum].[dbo].[ct_ciudades] ciu 
            ON ciu.ciudad_tit = p.ciudad_tit AND ciu.cod_provincia = p.cod_provincia AND ciu.cod_pais = p.cod_pais
        LEFT JOIN [BI_SOURCE].[Nodum].[dbo].[ct_clasesprov] cp 
            ON cp.cod_clase_prov = p.cod_clase_prov
        LEFT JOIN [BI_SOURCE].[Nodum].[dbo].[ct_fpagos] fp 
            ON fp.cod_fpago = p.cod_fpago
        WHERE EXISTS (
            SELECT 1 FROM [BI_SOURCE].[EPSA_BI].[dbo].[vw_ComprasBI_RecepcionesHistoria] h 
            WHERE h.OCProveedor = p.cod_tit
        );

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'dimProveedor refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
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
EXEC dbo.sp_refresh_dimProveedor;
GO

-- 4. Validation
SELECT 'stg_dimProveedor' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_dimProveedor;
SELECT TOP 5 [Proveedor Id], [Proveedor Nombre], [Pais Nombre] FROM dbo.stg_dimProveedor;
GO
