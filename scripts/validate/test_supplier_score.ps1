$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;Integrated Security=True;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()

    # Check staging table column names
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
    SELECT TOP 1 * FROM dbo.stg_factRecepcionesHistoria
"@
    $cmd.CommandTimeout = 10
    $reader = $cmd.ExecuteReader()
    $schemaTable = $reader.GetSchemaTable()
    Write-Output "=== stg_factRecepcionesHistoria columns ==="
    foreach ($row in $schemaTable.Rows) {
        Write-Output "  $($row['ColumnName']) ($($row['DataType']))"
    }
    $reader.Close()

    # Run supplier scoring query
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = @"
    ;WITH SupplierStats AS (
        SELECT
            rh.[OC Proveedor] AS ProveedorId,
            COUNT(*) AS TotalRecepciones,
            AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS AvgLT,
            STDEV(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS StdDevLT,
            SUM(CASE WHEN DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha) <= 
                AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) OVER (PARTITION BY rh.[OC Proveedor]) * 1.2 
                THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS OnTimePct,
            CASE WHEN AVG(rh.[OC PrecioUSD]) > 0 
                THEN STDEV(rh.[OC PrecioUSD]) / AVG(rh.[OC PrecioUSD]) 
                ELSE NULL END AS PriceCV
        FROM dbo.stg_factRecepcionesHistoria rh
        WHERE rh.[OC Fecha] IS NOT NULL 
            AND rh.RecepcionFecha IS NOT NULL
            AND rh.[OC Proveedor] IS NOT NULL
        GROUP BY rh.[OC Proveedor]
        HAVING COUNT(*) >= 5
    ),
    ScoredSuppliers AS (
        SELECT *,
            CASE WHEN AvgLT > 0 THEN StdDevLT / AvgLT ELSE NULL END AS LeadTimeCV,
            OnTimePct AS ScoreOnTime,
            CASE 
                WHEN AvgLT IS NULL OR StdDevLT IS NULL THEN 50
                WHEN StdDevLT / AvgLT <= 0.3 THEN 100
                WHEN StdDevLT / AvgLT >= 2.0 THEN 0
                ELSE 100 * (1 - (StdDevLT / AvgLT - 0.3) / 1.7)
            END AS ScoreLeadTime,
            CASE 
                WHEN PriceCV IS NULL THEN 50
                WHEN PriceCV <= 0.1 THEN 100
                WHEN PriceCV >= 1.0 THEN 0
                ELSE 100 * (1 - (PriceCV - 0.1) / 0.9)
            END AS ScorePrice,
            CASE 
                WHEN TotalRecepciones >= 100 THEN 100
                WHEN TotalRecepciones >= 50 THEN 80
                WHEN TotalRecepciones >= 20 THEN 60
                WHEN TotalRecepciones >= 10 THEN 40
                ELSE 20
            END AS ScoreVolume
        FROM SupplierStats
    ),
    FinalScores AS (
        SELECT *,
            ROUND(ScoreOnTime * 0.35 + ScoreLeadTime * 0.25 + ScorePrice * 0.25 + ScoreVolume * 0.15, 1) AS ScoreTotal,
            CASE 
                WHEN ScoreOnTime * 0.35 + ScoreLeadTime * 0.25 + ScorePrice * 0.25 + ScoreVolume * 0.15 >= 80 THEN 'A'
                WHEN ScoreOnTime * 0.35 + ScoreLeadTime * 0.25 + ScorePrice * 0.25 + ScoreVolume * 0.15 >= 65 THEN 'B'
                WHEN ScoreOnTime * 0.35 + ScoreLeadTime * 0.25 + ScorePrice * 0.25 + ScoreVolume * 0.15 >= 50 THEN 'C'
                WHEN ScoreOnTime * 0.35 + ScoreLeadTime * 0.25 + ScorePrice * 0.25 + ScoreVolume * 0.15 >= 35 THEN 'D'
                ELSE 'F'
            END AS ScoreGrade
        FROM ScoredSuppliers
    )
    SELECT TOP 20 ProveedorId, TotalRecepciones, 
        ROUND(AvgLT,0) as AvgLT, ROUND(OnTimePct,1) as OnTimePct,
        ROUND(ScoreOnTime,1) as S_OnTime, ROUND(ScoreLeadTime,1) as S_LT,
        ROUND(ScorePrice,1) as S_Price, ROUND(ScoreVolume,1) as S_Vol,
        ScoreTotal, ScoreGrade
    FROM FinalScores ORDER BY ScoreTotal DESC
"@
    $cmd2.CommandTimeout = 60
    $reader = $cmd2.ExecuteReader()
    Write-Output "`n=== TOP 20 Suppliers by Score ==="
    Write-Output "Id`tRecs`tLT`tOnTime%`tS_OT`tS_LT`tS_Pr`tS_Vol`tTotal`tGrade"
    while ($reader.Read()) {
        $vals = @()
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $v = $reader[$i]
            if ($v -is [double] -or $v -is [decimal]) { $v = [math]::Round($v, 1) }
            $vals += "$v"
        }
        Write-Output ($vals -join "`t")
    }
    $reader.Close()

    # Count by grade
    $cmd3 = $conn.CreateCommand()
    $cmd3.CommandText = @"
    ;WITH SupplierStats AS (
        SELECT rh.[OC Proveedor] AS ProveedorId, COUNT(*) AS TotalRecepciones,
            AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS AvgLT,
            STDEV(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) AS StdDevLT,
            SUM(CASE WHEN DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha) <= 
                AVG(DATEDIFF(DAY, rh.[OC Fecha], rh.RecepcionFecha)) OVER (PARTITION BY rh.[OC Proveedor]) * 1.2 
                THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS OnTimePct,
            CASE WHEN AVG(rh.[OC PrecioUSD]) > 0 THEN STDEV(rh.[OC PrecioUSD]) / AVG(rh.[OC PrecioUSD]) ELSE NULL END AS PriceCV
        FROM dbo.stg_factRecepcionesHistoria rh
        WHERE rh.[OC Fecha] IS NOT NULL AND rh.RecepcionFecha IS NOT NULL AND rh.[OC Proveedor] IS NOT NULL
        GROUP BY rh.[OC Proveedor] HAVING COUNT(*) >= 5
    ),
    ScoredSuppliers AS (
        SELECT *, OnTimePct AS ScoreOnTime,
            CASE WHEN AvgLT > 0 AND StdDevLT/AvgLT <= 0.3 THEN 100 WHEN StdDevLT/AvgLT >= 2.0 THEN 0 ELSE 100*(1-(StdDevLT/AvgLT-0.3)/1.7) END AS ScoreLeadTime,
            CASE WHEN PriceCV IS NULL THEN 50 WHEN PriceCV <= 0.1 THEN 100 WHEN PriceCV >= 1.0 THEN 0 ELSE 100*(1-(PriceCV-0.1)/0.9) END AS ScorePrice,
            CASE WHEN TotalRecepciones >= 100 THEN 100 WHEN TotalRecepciones >= 50 THEN 80 WHEN TotalRecepciones >= 20 THEN 60 WHEN TotalRecepciones >= 10 THEN 40 ELSE 20 END AS ScoreVolume
        FROM SupplierStats
    )
    SELECT 
        CASE WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 80 THEN 'A'
             WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 65 THEN 'B'
             WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 50 THEN 'C'
             WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 35 THEN 'D'
             ELSE 'F' END AS Grade,
        COUNT(*) AS Suppliers
    FROM ScoredSuppliers
    GROUP BY CASE WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 80 THEN 'A'
                  WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 65 THEN 'B'
                  WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 50 THEN 'C'
                  WHEN ScoreOnTime*0.35+ScoreLeadTime*0.25+ScorePrice*0.25+ScoreVolume*0.15 >= 35 THEN 'D'
                  ELSE 'F' END
    ORDER BY Grade
"@
    $cmd3.CommandTimeout = 60
    $reader = $cmd3.ExecuteReader()
    Write-Output "`n=== Score Distribution ==="
    while ($reader.Read()) {
        Write-Output "Grade $($reader[0]): $($reader[1]) suppliers"
    }
    $reader.Close()
    $conn.Close()
}
