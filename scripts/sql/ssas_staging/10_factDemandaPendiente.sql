-- ============================================================
-- Task 10: Migrate factDemandaPendientePlanificacion (Full Replace)
-- Server: 192.168.2.47\SSAS (port 1435)
-- Source: [BI_SOURCE].[EPSA_BI].[dbo].[stg_RequerimientosSobreDemandaPendientePlanificacion]
-- Note: Remote SP must execute first to populate the staging table
-- Refresh: FULL REPLACE (execute remote SP + pull results)
-- Schedule: Daily 8:00 AM (after other refreshes)
-- ============================================================

USE [staging_compras];
GO

-- 1. Create staging table
IF OBJECT_ID('dbo.stg_factDemandaPendiente', 'U') IS NOT NULL DROP TABLE dbo.stg_factDemandaPendiente;
GO

CREATE TABLE dbo.stg_factDemandaPendiente (
    [Demanda Pendiente Componente Codigo]            NVARCHAR(50) NOT NULL,
    [Demanda Pendiente Componente Cantidad Requerida] FLOAT,
    [Demanda Pendiente Formula]                      INT,
    [Demanda Pendiente Componente Formula]           INT,
    [Demanda Pendiente Componente Nivel]             INT,
    [Demanda Pendiente Componente Tipo]              NVARCHAR(50),
    [Tipo Ficha]                                     NVARCHAR(50),
    [Producto]                                       NVARCHAR(200),
    [NomProducto]                                    NVARCHAR(200),
    [Articulo Pedido x Cliente]                      NVARCHAR(200),
    [NodoID_Hex]                                     NVARCHAR(100),
    [NodoPadreID_Hex]                                NVARCHAR(100),
    [TrazaComposicion]                               NVARCHAR(500),
    [Obligatorio]                                    NVARCHAR(5),
    [LoteMinFabricacion]                             INT
);
GO

CREATE CLUSTERED INDEX IX_stg_factDemanda_Componente 
    ON dbo.stg_factDemandaPendiente([Demanda Pendiente Componente Codigo]);
GO

-- 2. Create refresh stored procedure
CREATE OR ALTER PROC dbo.sp_refresh_factDemandaPendiente
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId INT, @startTime DATETIME2 = SYSUTCDATETIME(), @rowCount INT;

    INSERT INTO dbo.stg_refresh_log (table_name, refresh_type, start_time)
    VALUES ('stg_factDemandaPendiente', 'FULL', @startTime);
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        -- Step 1: Execute remote SP to populate the staging table on 192.168.2.7
        PRINT 'Executing remote BOM explosion SP...';
        EXEC [BI_SOURCE].[EPSA_BI].[dbo].[Staging_RequerimientosSobreDemandaPendientePlanificacion];
        PRINT 'Remote SP completed.';

        -- Step 2: Pull results to local staging
        TRUNCATE TABLE dbo.stg_factDemandaPendiente;

        INSERT INTO dbo.stg_factDemandaPendiente
        SELECT *
        FROM [BI_SOURCE].[EPSA_BI].[dbo].[stg_RequerimientosSobreDemandaPendientePlanificacion];

        SET @rowCount = @@ROWCOUNT;

        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), rows_affected = @rowCount, status = 'SUCCESS'
        WHERE log_id = @logId;

        PRINT 'factDemandaPendiente refreshed: ' + CAST(@rowCount AS VARCHAR) + ' rows';
    END TRY
    BEGIN CATCH
        UPDATE dbo.stg_refresh_log 
        SET end_time = SYSUTCDATETIME(), status = 'ERROR', error_message = ERROR_MESSAGE()
        WHERE log_id = @logId;
        THROW;
    END CATCH
END
GO

-- 3. Initial load (may take several minutes due to BOM explosion)
EXEC dbo.sp_refresh_factDemandaPendiente;
GO

-- 4. Validation
SELECT 'stg_factDemandaPendiente' AS TableName, COUNT(*) AS RowCount FROM dbo.stg_factDemandaPendiente;
SELECT [Demanda Pendiente Componente Nivel], COUNT(*) AS Cnt 
FROM dbo.stg_factDemandaPendiente 
GROUP BY [Demanda Pendiente Componente Nivel] 
ORDER BY [Demanda Pendiente Componente Nivel];
GO
