# Generate SQL queries with column aliases matching model column names
# This maps SQL column names → model column names for each table

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Write-Host "Getting SQL column info..." -ForegroundColor Yellow
$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT t.name AS tbl, c.name AS col, c.column_id AS cid FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id WHERE t.name LIKE 'stg_%' ORDER BY t.name, c.column_id"
    $reader = $cmd.ExecuteReader()
    $output = @()
    while ($reader.Read()) {
        $output += "$($reader['tbl'])|$($reader['col'])|$($reader['cid'])"
    }
    $reader.Close()
    $conn.Close()
    $output
}

# Parse SQL columns
$sqlCols = @{}
foreach ($line in $result) {
    $parts = $line.Split('|')
    $tbl = $parts[0]
    $col = $parts[1]
    if (-not $sqlCols.ContainsKey($tbl)) { $sqlCols[$tbl] = @() }
    $sqlCols[$tbl] += $col
}

# Parse model columns
$model = Get-Content "$PSScriptRoot\..\model\database_staging.json" -Raw | ConvertFrom-Json

# Table name mapping: model table → SQL table
$tableMap = @{
    'factConsumoHistoria' = 'stg_factConsumo'
    'dimArticulo' = 'stg_dimArticulo'
    'factStockEPSA' = 'stg_factStockEPSA'
    'factConsumoPlanificado' = 'stg_factConsumoPlanificado'
    'factDemandaPendientePlanificacion' = 'stg_factDemandaPendiente'
    'factRecepcionesHistoria' = 'stg_factRecepcionesHistoria'
    'dimProveedor' = 'stg_dimProveedor'
    'factComprasEnProceso' = 'stg_factComprasEnProceso'
}

Write-Host "`n=== Column Mapping Analysis ===" -ForegroundColor Cyan
foreach ($table in $model.model.tables) {
    $sqlTable = $tableMap[$table.name]
    if (-not $sqlTable -or -not $sqlCols.ContainsKey($sqlTable)) { continue }
    
    $modelColNames = @()
    foreach ($c in $table.columns) {
        if ($c.name -notlike 'RowNumber-*') { $modelColNames += $c.name }
    }
    $sqlColNames = $sqlCols[$sqlTable]
    
    Write-Host "`n--- $($table.name) ($sqlTable) ---" -ForegroundColor Yellow
    Write-Host "  SQL cols ($($sqlColNames.Count)): $($sqlColNames -join ', ')"
    Write-Host "  Model cols ($($modelColNames.Count)): $($modelColNames -join ', ')"
    
    # Try to match by position (skip RowNumber)
    Write-Host "  Positional mapping:" -ForegroundColor Gray
    for ($i = 0; $i -lt [Math]::Min($sqlColNames.Count, $modelColNames.Count); $i++) {
        $sqlCol = $sqlColNames[$i]
        $modelCol = $modelColNames[$i]
        if ($sqlCol -ne $modelCol) {
            Write-Host "    [$sqlCol] AS [$modelCol]" -ForegroundColor White
        } else {
            Write-Host "    [$sqlCol]" -ForegroundColor DarkGray
        }
    }
}
