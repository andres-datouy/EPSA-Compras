# Comprehensive check: compare model columns vs SQL columns for ALL tables
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

# Get model columns from JSON
$modelJson = Get-Content "d:\Andres\Dev\EPSA-Compras\model\database_staging.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$tables = $modelJson.model.tables

Write-Host "=== MODEL COLUMNS ===" -ForegroundColor Cyan
foreach ($table in $tables) {
    Write-Host "`n--- $($table.name) ---" -ForegroundColor Yellow
    $dataCols = $table.columns | Where-Object { $_.type -ne "rowNumber" -and $_.type -ne "calculated" }
    $calcCols = $table.columns | Where-Object { $_.type -eq "calculated" }
    foreach ($col in $dataCols) {
        $src = if ($col.sourceColumn) { $col.sourceColumn } else { "(no source)" }
        Write-Host "  DATA: $($col.name) [$($col.dataType)] -> $src"
    }
    foreach ($col in $calcCols) {
        Write-Host "  CALC: $($col.name) [$($col.dataType)]"
    }
    
    # Get partition query
    $partition = $table.partitions[0]
    if ($partition -and $partition.source -and $partition.source.query) {
        Write-Host "  QUERY: $($partition.source.query.Substring(0, [Math]::Min(120, $partition.source.query.Length)))..."
    }
}

# Get SQL columns from server
$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT t.name AS tbl, STRING_AGG(c.name, '|') WITHIN GROUP (ORDER BY c.column_id) AS cols FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id WHERE t.name LIKE 'stg_%' GROUP BY t.name ORDER BY t.name"
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        Write-Output "$($reader['tbl'])|||$($reader['cols'])"
    }
    $reader.Close()
    $conn.Close()
}

Write-Host "`n`n=== SQL TABLES ===" -ForegroundColor Cyan
$result | ForEach-Object { 
    $parts = $_ -split '\|\|\|'
    Write-Host "`n--- $($parts[0]) ---" -ForegroundColor Yellow
    $parts[1] -split '\|' | ForEach-Object { Write-Host "  $_" }
}
