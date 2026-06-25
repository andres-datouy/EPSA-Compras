-- Supplier Performance Scoring (ML-5 Quick Win)
-- Calculates a 0-100 score per supplier based on:
--   1. On-Time Delivery % (weight: 35%)
--   2. Lead Time Consistency (weight: 25%)
--   3. Price Stability (weight: 25%)
--   4. Order Volume Reliability (weight: 15%)
--
-- Target: staging_compras.dbo.stg_factSupplierScore
-- Refresh: FULL, after factRecepcionesHistoria refresh

SET NOCOUNT ON;

-- Step 1: Create scoring table if not exists
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'stg_factSupplierScore')
BEGIN
    CREATE TABLE dbo.stg_factSupplierScore (
        ProveedorId NVARCHAR(50) NOT NULL,
        ProveedorNombre NVARCHAR(200),
        PaisNombre NVARCHAR(100),
        TotalRecepciones INT,
        LeadTimePromedio INT,
        LeadTimeStdDev FLOAT,
        LeadTimeCV FLOAT,
        OnTimePct FLOAT,
        PriceStabilityCV FLOAT,
        ScoreOnTime FLOAT,
        ScoreLeadTime FLOAT,
        ScorePrice FLOAT,
        ScoreVolume FLOAT,
        ScoreTotal FLOAT,
        ScoreGrade NVARCHAR(10),
        ScoreFechaCalculo DATETIME2,
        CONSTRAINT PK_stg_factSupplierScore PRIMARY KEY (ProveedorId)
    );
END

-- Step 2: Calculate scores
DECLARE @AvgLT_Global FLOAT;
SELECT @AvgLT_Global = AVG(DATEDIFF(DAY, [OC Fecha], RecepcionFecha))
FROM dbo.stg_factRecepcionesHistoria
WHERE [OC Fecha] IS NOT NULL AND RecepcionFecha IS NOT NULL;

;WITH SupplierStats AS (
    SELECT
        rh.[OC Proveedor] AS ProveedorId,
        COUNT(*) AS TotalRecepciones,
        AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS AvgLT,
        STDEV(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS StdDevLT,
        -- On-Time: received within 120% of their own average
        SUM(CASE WHEN DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha) <= 
            AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) OVER (PARTITION BY rh.[OC Proveedor]) * 1.2 
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS OnTimePct,
        -- Price stability: CV of unit price per supplier
        CASE WHEN AVG(rh.[OC PrecioUSD]) > 0 
            THEN STDEV(rh.[OC PrecioUSD]) / AVG(rh.[OC PrecioUSD]) 
            ELSE NULL END AS PriceCV
    FROM dbo.stg_factRecepcionesHistoria rh
    WHERE rh.[OC Fecha] IS NOT NULL 
        AND rh.RecepcionFecha IS NOT NULL
        AND rh.[OC Proveedor] IS NOT NULL
    GROUP BY rh.[OC Proveedor]
    HAVING COUNT(*) >= 5  -- minimum 5 receptions for reliable scoring
),
ScoredSuppliers AS (
    SELECT
        s.ProveedorId,
        s.TotalRecepciones,
        s.AvgLT,
        s.StdDevLT,
        CASE WHEN s.AvgLT > 0 THEN s.StdDevLT / s.AvgLT ELSE NULL END AS LeadTimeCV,
        s.OnTimePct,
        s.PriceCV,
        -- Score On-Time (0-100): 100% on-time = 100, 0% = 0
        s.OnTimePct AS ScoreOnTime,
        -- Score Lead Time Consistency (0-100): CV < 0.3 = 100, CV > 2 = 0
        CASE 
            WHEN s.AvgLT IS NULL OR s.StdDevLT IS NULL THEN 50
            WHEN s.StdDevLT / s.AvgLT <= 0.3 THEN 100
            WHEN s.StdDevLT / s.AvgLT >= 2.0 THEN 0
            ELSE 100 * (1 - (s.StdDevLT / s.AvgLT - 0.3) / 1.7)
        END AS ScoreLeadTime,
        -- Score Price Stability (0-100): CV < 0.1 = 100, CV > 1 = 0
        CASE 
            WHEN s.PriceCV IS NULL THEN 50  -- no price data
            WHEN s.PriceCV <= 0.1 THEN 100
            WHEN s.PriceCV >= 1.0 THEN 0
            ELSE 100 * (1 - (s.PriceCV - 0.1) / 0.9)
        END AS ScorePrice,
        -- Score Volume (0-100): >100 orders = 100, 5 orders = 20
        CASE 
            WHEN s.TotalRecepciones >= 100 THEN 100
            WHEN s.TotalRecepciones >= 50 THEN 80
            WHEN s.TotalRecepciones >= 20 THEN 60
            WHEN s.TotalRecepciones >= 10 THEN 40
            ELSE 20
        END AS ScoreVolume
    FROM SupplierStats s
),
FinalScores AS (
    SELECT
        fs.*,
        -- Weighted total: OnTime 35% + LT 25% + Price 25% + Volume 15%
        ROUND(fs.ScoreOnTime * 0.35 + fs.ScoreLeadTime * 0.25 + fs.ScorePrice * 0.25 + fs.ScoreVolume * 0.15, 1) AS ScoreTotal,
        CASE 
            WHEN fs.ScoreOnTime * 0.35 + fs.ScoreLeadTime * 0.25 + fs.ScorePrice * 0.25 + fs.ScoreVolume * 0.15 >= 80 THEN 'A'
            WHEN fs.ScoreOnTime * 0.35 + fs.ScoreLeadTime * 0.25 + fs.ScorePrice * 0.25 + fs.ScoreVolume * 0.15 >= 65 THEN 'B'
            WHEN fs.ScoreOnTime * 0.35 + fs.ScoreLeadTime * 0.25 + fs.ScorePrice * 0.25 + fs.ScoreVolume * 0.15 >= 50 THEN 'C'
            WHEN fs.ScoreOnTime * 0.35 + fs.ScoreLeadTime * 0.25 + fs.ScorePrice * 0.25 + fs.ScoreVolume * 0.15 >= 35 THEN 'D'
            ELSE 'F'
        END AS ScoreGrade
    FROM ScoredSuppliers fs
)
SELECT * FROM FinalScores ORDER BY ScoreTotal DESC;
