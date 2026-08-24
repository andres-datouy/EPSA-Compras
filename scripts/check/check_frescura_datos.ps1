# Auditoria de frescura de datos: staging -> jobs SQL Agent -> SSAS (live)
# Responde: hasta que fecha hay datos en staging, cuando corrieron los jobs por ultima vez,
# cuando se proceso SSAS por ultima vez y que rangos de fecha sirve el modelo hoy.
# Uso: pwsh -File scripts/check/check_frescura_datos.ps1

$e = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=', 2)[1]
$sqlPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=', 2)[1]
if (-not $pass -or -not $sqlPass) { throw "Faltan SSAS_PASSWORD/SQL_PASSWORD en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($sqlPwd)
    $out = @()

    # ================= A) STAGING: ultimos refresh por tabla =================
    $out += "=== A) STAGING_COMPRAS: ultimo refresh por tabla (stg_refresh_log) ==="
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPwd;Connect Timeout=8")
    $conn.Open()
    $cmd = $conn.CreateCommand(); $cmd.CommandTimeout = 120
    $cmd.CommandText = @"
SELECT table_name, refresh_type, FORMAT(start_time,'yyyy-MM-dd HH:mm') AS inicio, status, rows_affected,
       ISNULL(LEFT(error_message,100),'') AS err
FROM dbo.stg_refresh_log
WHERE log_id IN (SELECT MAX(log_id) FROM dbo.stg_refresh_log GROUP BY table_name)
ORDER BY table_name
"@
    $r = $cmd.ExecuteReader()
    while ($r.Read()) {
        $out += ("{0,-28} {1,-11} {2}  {3,-7} rows={4,-8} {5}" -f $r["table_name"], $r["refresh_type"], $r["inicio"], $r["status"], $r["rows_affected"], $r["err"])
    }
    $r.Close()

    # ================= B) STAGING: max fecha por columna de cada stg_* =================
    $out += ""
    $out += "=== B) STAGING_COMPRAS: fechas max/min por tabla stg_* ==="
    $cmd.CommandText = @"
SET NOCOUNT ON
DECLARE @t NVARCHAR(128), @c NVARCHAR(128), @sql NVARCHAR(MAX)
DECLARE cur CURSOR FAST_FORWARD FOR
SELECT t.TABLE_NAME, c.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLES t
JOIN INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = 'dbo'
WHERE t.TABLE_NAME LIKE 'stg[_]%' AND c.DATA_TYPE IN ('date','datetime','datetime2')
ORDER BY t.TABLE_NAME, c.ORDINAL_POSITION
OPEN cur
FETCH NEXT FROM cur INTO @t, @c
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'SELECT ''' + @t + ''' AS tbl, ''' + @c + ''' AS col, CONVERT(VARCHAR(23), MAX([' + @c + ']), 121) AS maxv, CONVERT(VARCHAR(23), MIN([' + @c + ']), 121) AS minv, COUNT(*) AS filas FROM dbo.[' + @t + ']'
    BEGIN TRY
        EXEC (@sql)
    END TRY
    BEGIN CATCH
        SELECT @t, @c, 'ERROR', ERROR_MESSAGE(), -1
    END CATCH
    FETCH NEXT FROM cur INTO @t, @c
END
CLOSE cur; DEALLOCATE cur
"@
    $r = $cmd.ExecuteReader()
    do {
        while ($r.Read()) {
            $out += ("{0,-28} {1,-38} min={2}  max={3}  filas={4}" -f $r["tbl"], $r["col"], $r["minv"], $r["maxv"], $r["filas"])
        }
    } while ($r.NextResult())
    $r.Close()
    $conn.Close()

    # ================= C) MSDB: estado y ultima ejecucion de los jobs =================
    $out += ""
    $out += "=== C) MSDB: jobs de refresh (estado + ultima ejecucion) ==="
    try {
        $conn2 = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=msdb;Integrated Security=SSPI;Connect Timeout=8")
        $conn2.Open()
        $cmd2 = $conn2.CreateCommand(); $cmd2.CommandTimeout = 60
        $cmd2.CommandText = @"
SELECT j.name, j.enabled,
       CONVERT(VARCHAR(16), msdb.dbo.agent_datetime(h.run_date, h.run_time), 120) AS ultima_ejecucion,
       CASE h.run_status WHEN 0 THEN 'FAILED' WHEN 1 THEN 'OK' WHEN 2 THEN 'RETRY' WHEN 3 THEN 'CANCELED' ELSE '?' END AS resultado,
       CONVERT(VARCHAR(16), msdb.dbo.agent_datetime(js.next_run_date, js.next_run_time), 120) AS proxima_ejecucion
FROM msdb.dbo.sysjobs j
OUTER APPLY (SELECT TOP 1 run_date, run_time, run_status FROM msdb.dbo.sysjobhistory hh
             WHERE hh.job_id = j.job_id AND hh.step_id = 0 ORDER BY hh.run_date DESC, hh.run_time DESC) h
LEFT JOIN msdb.dbo.sysjobschedules js ON js.job_id = j.job_id
LEFT JOIN msdb.dbo.sysschedules s ON s.schedule_id = js.schedule_id
WHERE j.name LIKE 'Staging[_]Refresh%' OR j.name LIKE 'EPSA - Refresh%'
ORDER BY j.name
"@
        $r2 = $cmd2.ExecuteReader()
        while ($r2.Read()) {
            $out += ("{0,-42} enabled={1}  ultima={2}  {3,-8} proxima={4}" -f $r2["name"], $r2["enabled"], $r2["ultima_ejecucion"], $r2["resultado"], $r2["proxima_ejecucion"])
        }
        $r2.Close()
        $conn2.Close()
    } catch {
        $out += "No se pudo leer msdb con Windows auth: $($_.Exception.Message)"
    }

    # ================= D) SSAS: ultimo process + rangos servidos =================
    $out += ""
    $out += "=== D) SSAS Compras_EPSA: processed time por particion ==="
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if (-not $db) { throw "No se encontro la base Compras_EPSA" }
    $out += "DB LastUpdate: $($db.LastUpdate) | LastProcessed: $($db.LastProcessed)"
    foreach ($t in $db.Model.Tables) {
        foreach ($p in $t.Partitions) {
            $rt = $null
            try { $rt = $p.RefreshedTime } catch { }
            $out += "{0,-26} part={1,-26} refreshed={2}" -f $t.Name, $p.Name, $rt
        }
    }

    $out += ""
    $out += "=== D2) SSAS: data sources del modelo live ==="
    foreach ($ds in $db.Model.DataSources) {
        $cs = ""
        try { $cs = $ds.ConnectionString -replace 'Password=[^;]+', 'Password=***' -replace 'pwd=[^;]+', 'pwd=***' } catch { }
        $out += "$($ds.Name) | $($ds.GetType().Name) | $cs"
    }

    $out += ""
    $out += "=== D3) SSAS: fuente (query) de las particiones fact live ==="
    foreach ($tn in @("factConsumoHistoria","factStockEPSA","factComprasEnProceso","factRecepcionesHistoria","factConsumoPlanificado","factDemandaPendientePlanificacion")) {
        $t = $db.Model.Tables | Where-Object { $_.Name -eq $tn }
        foreach ($p in $t.Partitions) {
            $src = $p.Source
            $out += "--- $tn | sourceType=$($src.GetType().Name)"
            try { $out += ($src.QueryDefinition) }
            catch { try { $out += ($src.Expression) } catch { $out += "(sin query visible)" } }
        }
    }

    $out += ""
    $out += "=== E) SSAS: rangos de fecha sin filtros (ALL) ==="
    $gac = "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_14.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"
    Add-Type -Path $gac
    $connA = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=Compras_EPSA")
    $connA.Open()
    $cmd3 = $connA.CreateCommand()
    $cmd3.CommandText = @"
EVALUATE
ROW(
 "MinFactConsumo", CALCULATE(MIN(factConsumoHistoria[Consumo Fecha]), ALL(factConsumoHistoria)),
 "MaxFactConsumo", CALCULATE(MAX(factConsumoHistoria[Consumo Fecha]), ALL(factConsumoHistoria)),
 "MinCal", CALCULATE(MIN(Calendario[Fecha]), ALL(Calendario)),
 "MaxCal", CALCULATE(MAX(Calendario[Fecha]), ALL(Calendario)),
 "MaxStock", CALCULATE(MAX(factStockEPSA[Stock Fecha_Corte]), ALL(factStockEPSA)),
 "MaxRecep", CALCULATE(MAX(factRecepcionesHistoria[RecepcionFecha]), ALL(factRecepcionesHistoria)),
 "MaxCompraEP", CALCULATE(MAX(factComprasEnProceso[CompraEP Ultima Fecha Entrega]), ALL(factComprasEnProceso)),
 "MaxPlanif", CALCULATE(MAX(factConsumoPlanificado[Consumo Planificado Fecha Planificacion]), ALL(factConsumoPlanificado))
)
"@
    $r3 = $cmd3.ExecuteReader()
    while ($r3.Read()) {
        for ($i = 0; $i -lt $r3.FieldCount; $i++) {
            $out += ("{0,-16} = {1}" -f $r3.GetName($i), $r3.GetValue($i))
        }
    }
    $r3.Close()
    $connA.Close()
    $ssas.Disconnect()

    return $out
} -ArgumentList $sqlPass

$result | ForEach-Object { Write-Host $_ }
