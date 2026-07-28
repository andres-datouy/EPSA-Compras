$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;Integrated Security=True;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()

    # Staging columns: no spaces (OCFecha, OCProveedor, OCPrecioUSD)
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
    ;WITH SupplierBase AS (
        SELECT OCProveedor, OCFecha, RecepcionFecha, OCPrecioUSD,
            DATEDIFF(DAY, OCFecha, RecepcionFecha) AS LeadDays
        FROM dbo.stg_factRecepcionesHistoria
        WHERE OCFecha IS NOT NULL AND RecepcionFecha IS NOT NULL AND OCProveedor IS NOT NULL
            AND DATEDIFF(DAY, OCFecha, RecepcionFecha) >= 0
    ),
    SupplierAvg AS (
        SELECT OCProveedor, AVG(LeadDays * 1.0) AS AvgLT
        FROM SupplierBase GROUP BY OCProveedor
    ),
    SupplierStats AS (
        SELECT 
            sb.OCProveedor AS ProveedorId,
            COUNT(*) AS TotalRecepciones,
            AVG(sb.LeadDays * 1.0) AS AvgLT,
            STDEV(sb.LeadDays) AS StdDevLT,
            SUM(CASE WHEN sb.LeadDays <= sa.AvgLT * 1.2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS OnTimePct,
            CASE WHEN AVG(sb.OCPrecioUSD) > 0 THEN STDEV(sb.OCPrecioUSD) / AVG(sb.OCPrecioUSD) ELSE NULL END AS PriceCV
        FROM SupplierBase sb
        INNER JOIN SupplierAvg sa ON sb.OCProveedor = sa.OCProveedor
        GROUP BY sb.OCProveedor
        HAVING COUNT(*) >= 5
    ),
    ScoredSuppliers AS (
        SELECT *,
            OnTimePct AS ScoreOnTime,
            CASE WHEN AvgLT IS NULL OR StdDevLT IS NULL OR AvgLT = 0 THEN 50
                 WHEN StdDevLT / AvgLT <= 0.3 THEN 100
                 WHEN StdDevLT / AvgLT >= 2.0 THEN 0
                 ELSE 100.0 * (1 - (StdDevLT / AvgLT - 0.3) / 1.7) END AS ScoreLeadTime,
            CASE WHEN PriceCV IS NULL THEN 50
                 WHEN PriceCV <= 0.1 THEN 100
                 WHEN PriceCV >= 1.0 THEN 0
                 ELSE 100.0 * (1 - (PriceCV - 0.1) / 0.9) END AS ScorePrice,
            CASE WHEN TotalRecepciones >= 100 THEN 100
                 WHEN TotalRecepciones >= 50 THEN 80
                 WHEN TotalRecepciones >= 20 THEN 60
                 WHEN TotalRecepciones >= 10 THEN 40
                 ELSE 20 END AS ScoreVolume
        FROM SupplierStats
    ),
    FinalScores AS (
        SELECT *,
            ROUND(ScoreOnTime*0.35 + ScoreLeadTime*0.25 + ScorePrice*0.25 + ScoreVolume*0.15, 1) AS ScoreTotal,
            CASE WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 80 THEN 'A'
                 WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 65 THEN 'B'
                 WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 50 THEN 'C'
                 WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 35 THEN 'D'
                 ELSE 'F' END AS Grade
        FROM ScoredSuppliers
    )
    SELECT TOP 15 ProveedorId, TotalRecepciones, ROUND(AvgLT,0) as LT,
        ROUND(OnTimePct,0) as OnTime, ROUND(ScoreTotal,1) as Score, Grade
    FROM FinalScores ORDER BY ScoreTotal DESC
"@
    $cmd.CommandTimeout = 60
    $reader = $cmd.ExecuteReader()
    Write-Output "=== TOP 15 Suppliers ==="
    Write-Output "Id`tRecs`tLT`tOnTime%`tScore`tGrade"
    while ($reader.Read()) {
        Write-Output "$($reader[0])`t$($reader[1])`t$($reader[2])`t$($reader[3])`t$($reader[4])`t$($reader[5])"
    }
    $reader.Close()

    # Distribution
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = @"
    ;WITH SupplierBase AS (
        SELECT OCProveedor, DATEDIFF(DAY, OCFecha, RecepcionFecha) AS LeadDays, OCPrecioUSD
        FROM dbo.stg_factRecepcionesHistoria
        WHERE OCFecha IS NOT NULL AND RecepcionFecha IS NOT NULL AND OCProveedor IS NOT NULL
            AND DATEDIFF(DAY, OCFecha, RecepcionFecha) >= 0
    ),
    SupplierAvg AS (
        SELECT OCProveedor, AVG(LeadDays*1.0) AS AvgLT FROM SupplierBase GROUP BY OCProveedor
    ),
    SupplierStats AS (
        SELECT sb.OCProveedor, COUNT(*) as N, AVG(sb.LeadDays*1.0) as AvgLT, STDEV(sb.LeadDays) as StdLT,
            SUM(CASE WHEN sb.LeadDays <= sa.AvgLT*1.2 THEN 1 ELSE 0 END)*100.0/COUNT(*) as OTP,
            CASE WHEN AVG(sb.OCPrecioUSD)>0 THEN STDEV(sb.OCPrecioUSD)/AVG(sb.OCPrecioUSD) ELSE NULL END as PCV
        FROM SupplierBase sb JOIN SupplierAvg sa ON sb.OCProveedor=sa.OCProveedor
        GROUP BY sb.OCProveedor HAVING COUNT(*)>=5
    ),
    Scores AS (
        SELECT OTP as S_OT,
            CASE WHEN AvgLT=0 OR StdLT IS NULL THEN 50 WHEN StdLT/AvgLT<=0.3 THEN 100 WHEN StdLT/AvgLT>=2 THEN 0 ELSE 100*(1-(StdLT/AvgLT-0.3)/1.7) END as S_LT,
            CASE WHEN PCV IS NULL THEN 50 WHEN PCV<=0.1 THEN 100 WHEN PCV>=1 THEN 0 ELSE 100*(1-(PCV-0.1)/0.9) END as S_P,
            CASE WHEN N>=100 THEN 100 WHEN N>=50 THEN 80 WHEN N>=20 THEN 60 WHEN N>=10 THEN 40 ELSE 20 END as S_V
        FROM SupplierStats
    )
    SELECT CASE WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=80 THEN 'A'
                WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=65 THEN 'B'
                WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=50 THEN 'C'
                WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=35 THEN 'D' ELSE 'F' END as G,
        COUNT(*) as N
    FROM Scores GROUP BY CASE WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=80 THEN 'A'
        WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=65 THEN 'B'
        WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=50 THEN 'C'
        WHEN S_OT*0.35+S_LT*0.25+S_P*0.25+S_V*0.15>=35 THEN 'D' ELSE 'F' END
    ORDER BY G
"@
    $cmd2.CommandTimeout = 60
    $reader = $cmd2.ExecuteReader()
    Write-Output "`n=== Distribution ==="
    while ($reader.Read()) { Write-Output "Grade $($reader[0]): $($reader[1]) suppliers" }
    $reader.Close()
    $conn.Close()
}
