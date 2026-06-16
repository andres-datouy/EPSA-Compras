-- ============================================================
-- Task 9: Migrate factComprasEnProceso (Full Replace, Volatile)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[Nodum] - 3-way UNION query
-- Refresh: FULL REPLACE (truncate + load, volatile)
-- Schedule: Every 4 hours
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factComprasEnProceso', 'U') IS NOT NULL DROP TABLE dbo.stg_factComprasEnProceso;
GO

CREATE TABLE dbo.stg_factComprasEnProceso (
    [CompraEP Tipo]                     NVARCHAR(30) NOT NULL,
    [CompraEP Proveedor]                NVARCHAR(50),
    [CompraEP Doc]                      NVARCHAR(50),
    [CompraEP Serie]                    NVARCHAR(10),
    [CompraEP Numero]                   BIGINT,
    [CompraEP Articulo Codigo]          NVARCHAR(50),
    [cod_tipoart]                       NVARCHAR(20),
    [CompraEP Cantidad]                 FLOAT,
    [CompraEP Fecha Ultima Modificacion] DATETIME,
    [CompraEP Ultima Fecha Entrega]      DATETIME
);
GO

CREATE CLUSTERED INDEX IX_stg_factComprasEP_Articulo 
    ON dbo.stg_factComprasEnProceso([CompraEP Articulo Codigo]);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factComprasEnProceso
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factComprasEnProceso', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        TRUNCATE TABLE dbo.stg_factComprasEnProceso;

        INSERT INTO dbo.stg_factComprasEnProceso (
            [CompraEP Tipo], [CompraEP Proveedor], [CompraEP Doc],
            [CompraEP Serie], [CompraEP Numero], [CompraEP Articulo Codigo],
            [cod_tipoart], [CompraEP Cantidad],
            [CompraEP Fecha Ultima Modificacion], [CompraEP Ultima Fecha Entrega]
        )
        -- SOLICITUDES
        SELECT 'Solicitud', s.cod_tit, s.cod_doca, s.serie_doca, s.nro_doca,
               s.cod_articulo, a.cod_tipoart, SUM(cantidad*signo),
               MAX(s.fecha_mod), MAX(s.fec_entrega)
        FROM [BI_SOURCE].[Nodum].[dbo].[cps_solicitudes] s
        JOIN [BI_SOURCE].[Nodum].[dbo].[ct_articulos] a ON a.cod_articulo = s.cod_articulo
        WHERE s.cod_emp = 'epsa'
            AND a.cod_tipoart NOT IN ('pt', 'prvta', 'semi', 'tubos', 'servta')
        GROUP BY s.cod_tit, s.cod_doca, s.serie_doca, s.nro_doca, s.cod_articulo, a.cod_tipoart
        HAVING SUM(cantidad*signo) > 0 AND YEAR(MAX(s.fecha_mod)) >= YEAR(GETDATE())-5

        UNION ALL

        -- ORDENES DE COMPRA
        SELECT 'Orden de Compra', o.cod_tit, o.cod_doca, o.serie_doca, o.nro_doca,
               o.cod_articulo, a.cod_tipoart, SUM(cantidad*signo),
               MAX(o.fecha_mod), MAX(o.fec_entrega)
        FROM [BI_SOURCE].[Nodum].[dbo].[cps_ocompras] o
        JOIN [BI_SOURCE].[Nodum].[dbo].[ct_articulos] a ON a.cod_articulo = o.cod_articulo
        WHERE o.cod_emp = 'epsa'
            AND a.cod_tipoart NOT IN ('pt', 'prvta', 'semi', 'tubos', 'servta')
        GROUP BY o.cod_tit, o.cod_doca, o.serie_doca, o.nro_doca, o.cod_articulo, a.cod_tipoart
        HAVING SUM(cantidad*signo) > 0 AND YEAR(MAX(o.fecha_mod)) >= YEAR(GETDATE())-5

        UNION ALL

        -- CARPETAS DE IMPORTACION
        SELECT 'Carpeta Import', o.cod_tit, o.cod_doca, o.serie_doca, o.nro_doca,
               o.cod_articulo, a.cod_tipoart, SUM(cantidad*signo),
               MAX(o.fecha_mod), MAX(ent.fec_entrega)
        FROM [BI_SOURCE].[Nodum].[dbo].[cpf_stockaux] o
        JOIN [BI_SOURCE].[Nodum].[dbo].[ct_articulos] a ON a.cod_articulo = o.cod_articulo
        OUTER APPLY (
            SELECT MAX(fec_entrega) AS fec_entrega
            FROM [BI_SOURCE].[Nodum].[dbo].[cpp_importacione] i
            WHERE i.cod_docum = o.cod_doca AND i.nro_docum = o.nro_doca AND i.cod_articulo = o.cod_articulo
        ) AS ent
        WHERE o.cod_emp = 'epsa'
            AND a.cod_tipoart NOT IN ('pt', 'prvta', 'semi', 'tubos', 'servta')
            AND o.cod_estado IN ('compras')
            AND NOT EXISTS (
                SELECT 1 FROM [BI_SOURCE].[Nodum].[dbo].[cps_ocompras] oc
                JOIN [BI_SOURCE].[Nodum].[dbo].[ct_articulos] a2 ON a2.cod_articulo = oc.cod_articulo
                WHERE oc.cod_emp = o.cod_emp
                    AND a2.cod_tipoart NOT IN ('pt', 'prvta', 'semi', 'tubos', 'servta')
                    AND a2.cod_articulo = o.cod_articulo
                    AND oc.cod_tit = o.cod_tit AND oc.cod_doca = o.cod_doca AND oc.serie_doca = o.serie_doca
                    AND oc.nro_doca = o.nro_doca
                GROUP BY oc.cod_tit, oc.cod_doca, oc.serie_doca, oc.nro_doca, oc.cod_articulo, a2.cod_tipoart
                HAVING SUM(cantidad*signo) > 0
            )
        GROUP BY o.cod_tit, o.cod_doca, o.serie_doca, o.nro_doca, o.cod_articulo, a.cod_tipoart
        HAVING SUM(cantidad*signo) > 0 AND YEAR(MAX(o.fecha_mod)) >= YEAR(GETDATE())-5;

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factComprasEnProceso refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
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
EXEC dbo.sp_refresh_factComprasEnProceso;
GO

-- 4. Validation
SELECT 'stg_factComprasEnProceso' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factComprasEnProceso;
SELECT [CompraEP Tipo], COUNT(*) AS Cnt FROM dbo.stg_factComprasEnProceso GROUP BY [CompraEP Tipo];
GO
