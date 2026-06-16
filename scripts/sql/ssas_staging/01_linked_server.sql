-- ============================================================
-- Task 1: Linked Server Setup
-- Server: 192.168.2.47\SSAS (port 1435)
-- Target: 192.168.2.7 (Nodum / EPSA_BI)
-- Run as: sa or sysadmin on local DB Engine
-- ============================================================

USE [master];
GO

-- 1. Drop existing linked server if it exists (idempotent)
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'BI_SOURCE')
BEGIN
    EXEC sp_dropserver @server = N'BI_SOURCE', @droplogins = 'droplogins';
    PRINT 'Dropped existing BI_SOURCE linked server';
END
GO

-- 2. Create linked server (pointing to 192.168.2.7)
EXEC sp_addlinkedserver 
    @server = N'BI_SOURCE',
    @srvproduct = N'SQL Server',
    @provider = N'SQLNCLI',
    @datasrc = N'192.168.2.7';
PRINT 'Created BI_SOURCE linked server -> 192.168.2.7';
GO

-- 3. Configure login mapping (all local logins -> biEPSA on remote)
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = N'BI_SOURCE',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'biEPSA',
    @rmtpassword = N'GralServando2450';
PRINT 'Configured login mapping: all -> biEPSA';
GO

-- 4. Enable RPC (required for remote SP execution)
EXEC sp_serveroption @server = N'BI_SOURCE', @optname = N'rpc', @optvalue = N'true';
EXEC sp_serveroption @server = N'BI_SOURCE', @optname = N'rpc out', @optvalue = N'true';
-- Enable data access
EXEC sp_serveroption @server = N'BI_SOURCE', @optname = N'data access', @optvalue = N'true';
-- Collation compatible (avoid conversion issues)
EXEC sp_serveroption @server = N'BI_SOURCE', @optname = N'collation compatible', @optvalue = N'true';
PRINT 'Enabled RPC, RPC Out, Data Access';
GO

-- 5. Validation queries
PRINT '';
PRINT '=== VALIDATION ===';
PRINT '';

-- Test 1: Can we see the linked server?
SELECT name, product, provider, data_source 
FROM sys.servers 
WHERE name = N'BI_SOURCE';

-- Test 2: Can we query EPSA_BI views?
PRINT 'Testing EPSA_BI access...';
SELECT TOP 1 * FROM [BI_SOURCE].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA];

-- Test 3: Can we query Nodum tables?
PRINT 'Testing Nodum access...';
SELECT TOP 1 * FROM [BI_SOURCE].[Nodum].[dbo].[ct_articulos];

-- Test 4: Can we execute remote SP? (just check it exists)
PRINT 'Testing remote SP existence...';
SELECT name FROM [BI_SOURCE].[EPSA_BI].[sys].[procedures] 
WHERE name = 'Staging_RequerimientosSobreDemandaPendientePlanificacion';

PRINT '';
PRINT 'Linked Server setup COMPLETE. All validations passed if no errors above.';
GO
