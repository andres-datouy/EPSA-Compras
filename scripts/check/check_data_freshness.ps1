$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Check staging data freshness and SSAS sync
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # === STAGING REFRESH LOG ===
    $stgConn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$using:sqlPass;Connect Timeout=30")
    $stgConn.Open()
    
    # Last refresh per table
    $cmd = $stgConn.CreateCommand()
    $cmd.CommandText = @"
SELECT t.table_name, 
    MAX(t.end_time) as last_refresh,
    (SELECT TOP 1 status FROM stg_refresh_log WHERE table_name = t.table_name ORDER BY log_id DESC) as last_status,
    (SELECT TOP 1 rows_affected FROM stg_refresh_log WHERE table_name = t.table_name ORDER BY log_id DESC) as last_rows
FROM stg_refresh_log t
GROUP BY t.table_name
ORDER BY t.table_name
"@
    $cmd.CommandTimeout = 30
    $r = $cmd.ExecuteReader()
    $output += "=== STAGING REFRESH LOG (last per table) ==="
    $output += "{0,-42} {1,-20} {2,-10} {3,10}" -f "Table", "Last Refresh", "Status", "Rows"
    $output += ("-" * 85)
    while ($r.Read()) {
        $refreshDate = if ($r[1] -is [DBNull]) { "N/A" } else { $r[1].ToString("yyyy-MM-dd HH:mm") }
        $status = if ($r[2] -is [DBNull]) { "N/A" } else { $r[2] }
        $rows = if ($r[3] -is [DBNull]) { "N/A" } else { $r[3] }
        $output += "{0,-42} {1,-20} {2,-10} {3,10}" -f $r[0], $refreshDate, $status, $rows
    }
    $r.Close()
    
    # Row counts for all stg_ tables
    $output += ""
    $output += "=== STAGING ROW COUNTS ==="
    $tables = @(
        "stg_dimArticulo", "stg_dimProveedor",
        "stg_factComprasEnProceso", "stg_factConsumo",
        "stg_factConsumoPlanificado", "stg_factDemandaPendiente",
        "stg_factRecepcionesHistoria", "stg_factStockEPSA"
    )
    foreach ($t in $tables) {
        try {
            $cmd2 = $stgConn.CreateCommand()
            $cmd2.CommandText = "SELECT COUNT(*) FROM dbo.[$t]"
            $count = $cmd2.ExecuteScalar()
            $output += "  {0,-42} {1,10}" -f $t, $count
        } catch {
            $output += "  {0,-42} {1,10}" -f $t, "ERROR"
        }
    }
    
    # Date ranges for key date columns
    $output += ""
    $output += "=== STAGING DATE RANGES ==="
    $dateChecks = @(
        @{ Table = "stg_factRecepcionesHistoria"; Col = "RecepcionFecha" }
        @{ Table = "stg_factComprasEnProceso"; Col = "CompraEP Fecha Ultima Modificacion" }
        @{ Table = "stg_factConsumo"; Col = "fec_doc" }
        @{ Table = "stg_factStockEPSA"; Col = "Stock_Fecha_Corte" }
        @{ Table = "stg_factConsumoPlanificado"; Col = "Consumo Planificado Fecha Planificacion" }
    )
    foreach ($dc in $dateChecks) {
        try {
            $cmd3 = $stgConn.CreateCommand()
            $cmd3.CommandText = "SELECT CONVERT(VARCHAR,MIN([$($dc.Col)]),103), CONVERT(VARCHAR,MAX([$($dc.Col)]),103) FROM dbo.$($dc.Table)"
            $cmd3.CommandTimeout = 30
            $r3 = $cmd3.ExecuteReader()
            if ($r3.Read()) {
                $output += "  {0,-42} min={1,-12} max={2,-12}" -f $dc.Table, $r3[0], $r3[1]
            }
            $r3.Close()
        } catch {
            $output += "  {0,-42} ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(60, $_.Exception.Message.Length)))" -f $dc.Table
        }
    }
    
    $stgConn.Close()
    
    # === SSAS ROW COUNTS (via ADOMD) ===
    $output += ""
    $output += "=== SSAS ROW COUNTS ==="
    
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue
    if (-not ([System.Type]::GetType("Microsoft.AnalysisServices.AdomdClient.AdomdConnection"))) {
        $amoPaths = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Sort-Object FullName -Descending
        if ($amoPaths) { Add-Type -Path $amoPaths[0].FullName -ErrorAction SilentlyContinue }
    }
    
    try {
        $ssasConn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
        $ssasConn.ConnectionString = "Data Source=localhost:2383;Catalog=Compras_EPSA"
        $ssasConn.Open()
        
        $ssasTables = @(
            @{ Name = "dimArticulo"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimArticulo'))" }
            @{ Name = "dimProveedor"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimProveedor'))" }
            @{ Name = "factComprasEnProceso"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factComprasEnProceso'))" }
            @{ Name = "factConsumoHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoHistoria'))" }
            @{ Name = "factConsumoPlanificado"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoPlanificado'))" }
            @{ Name = "factDemandaPendientePlanificacion"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factDemandaPendientePlanificacion'))" }
            @{ Name = "factRecepcionesHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factRecepcionesHistoria'))" }
            @{ Name = "factStockEPSA"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factStockEPSA'))" }
            @{ Name = "Calendario"; DAX = "EVALUATE ROW(""c"", COUNTROWS('Calendario'))" }
        )
        
        foreach ($t in $ssasTables) {
            try {
                $cmd4 = $ssasConn.CreateCommand()
                $cmd4.CommandText = $t.DAX
                $r4 = $cmd4.ExecuteReader()
                $count = "ERR"
                if ($r4.Read()) { $count = $r4[0] }
                $r4.Close()
                $output += "  {0,-42} {1,10}" -f $t.Name, $count
            } catch {
                $output += "  {0,-42} {1,10}" -f $t.Name, "ERR"
            }
        }
        
        # SSAS last processed time
        $output += ""
        $output += "=== SSAS LAST PROCESSED ==="
        $cmd5 = $ssasConn.CreateCommand()
        $cmd5.CommandText = "SELECT LAST_SCHEMA_UPDATE, LAST_DATA_UPDATE FROM `$system.MDSCHEMA_CUBES WHERE CUBE_NAME='Model'"
        $r5 = $cmd5.ExecuteReader()
        if ($r5.Read()) {
            $output += "  Last Schema Update: $($r5[0])"
            $output += "  Last Data Update:   $($r5[1])"
        }
        $r5.Close()
        $ssasConn.Close()
    } catch {
        $output += "  SSAS connection failed: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
    }
    
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
