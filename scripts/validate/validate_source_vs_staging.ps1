$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Validate source vs staging for remaining mismatches
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # Source connection
    $srcConn = New-Object System.Data.SqlClient.SqlConnection("Server=192.168.2.7;Database=Nodum;User Id=biEPSA;Password=GralServando2450;Connect Timeout=15")
    $srcConn.Open()
    
    # factConsumoHistoria source - use correct column names
    $cmd = $srcConn.CreateCommand()
    $cmd.CommandText = "SELECT COUNT(*) FROM cpf_stockaux WHERE cod_emp = 'EPSA' AND cod_estado IN ('existencia','stkaf') AND fec_doc >= DATEADD(YEAR,-5,GETDATE())"
    $cmd.CommandTimeout = 120
    $count = $cmd.ExecuteScalar()
    $output += "=== factConsumoHistoria (Nodum cpf_stockaux) ==="
    $output += "  Source (no cod_tipoart filter, 5yr): $count"
    
    # Try with cod_tipoart filter (check if column exists)
    $cmd2 = $srcConn.CreateCommand()
    $cmd2.CommandText = "SELECT COUNT(*) FROM cpf_stockaux s INNER JOIN ct_articulos a ON s.cod_articulo = a.cod_articulo WHERE s.cod_emp = 'EPSA' AND s.cod_estado IN ('existencia','stkaf') AND s.fec_doc >= DATEADD(YEAR,-5,GETDATE()) AND a.cod_tipoart NOT IN ('prvta','pt','semi','tubos')"
    $cmd2.CommandTimeout = 120
    try {
        $count2 = $cmd2.ExecuteScalar()
        $output += "  Source (with JOIN + tipoart filter, 5yr): $count2"
    } catch {
        $output += "  Source (JOIN filter): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
    }
    
    # dimProveedor - check actual query logic (the SP does complex filtering)
    $cmd3 = $srcConn.CreateCommand()
    $cmd3.CommandText = "SELECT COUNT(*) FROM ct_proveedores"
    $provAll = $cmd3.ExecuteScalar()
    $output += "`n=== dimProveedor (Nodum ct_proveedores) ==="
    $output += "  Total rows in ct_proveedores: $provAll"
    
    # Check how many distinct suppliers appear in recepciones (that's what staging filters by)
    $cmd4 = $srcConn.CreateCommand()
    $cmd4.CommandText = "SELECT COUNT(DISTINCT cod_proveedor) FROM ct_proveedores WHERE cod_proveedor IN (SELECT DISTINCT prov_cod FROM cpg_oc WHERE cod_emp = 'EPSA')"
    $cmd4.CommandTimeout = 60
    try {
        $provFiltered = $cmd4.ExecuteScalar()
        $output += "  Filtered (with EPSA orders): $provFiltered"
    } catch {
        $output += "  Filtered query: ERROR"
    }
    
    $srcConn.Close()
    
    # Staging
    $stgConn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$using:sqlPass;Connect Timeout=10")
    $stgConn.Open()
    
    # stg_factConsumo date range
    $cmd5 = $stgConn.CreateCommand()
    $cmd5.CommandText = "SELECT MIN(fec_doc), MAX(fec_doc), COUNT(*) FROM dbo.stg_factConsumo"
    $r5 = $cmd5.ExecuteReader()
    $output += "`n=== stg_factConsumo ==="
    if ($r5.Read()) {
        $output += "  Min fec_doc: $($r5[0])"
        $output += "  Max fec_doc: $($r5[1])"
        $output += "  Count: $($r5[2])"
    }
    $r5.Close()
    
    # factConsumoPlanificado check
    $output += "`n=== factConsumoPlanificado timing ==="
    $cmd6 = $stgConn.CreateCommand()
    $cmd6.CommandText = "SELECT TOP 5 CONVERT(VARCHAR, start_time, 120), rows_affected, status FROM stg_refresh_log WHERE table_name = 'stg_factConsumoPlanificado' ORDER BY log_id DESC"
    $r6 = $cmd6.ExecuteReader()
    while ($r6.Read()) {
        $output += "  $($r6[0]) - rows: $($r6[1]) - $($r6[2])"
    }
    $r6.Close()
    
    $stgConn.Close()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
