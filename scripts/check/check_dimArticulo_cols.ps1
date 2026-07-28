$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;"
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'stg_dimArticulo' ORDER BY ORDINAL_POSITION"
$reader = $cmd.ExecuteReader()
Write-Host "COLUMN_NAME|DATA_TYPE|MAX_LEN|NUM_PREC|NUM_SCALE|NULLABLE"
while ($reader.Read()) {
    Write-Host "$($reader['COLUMN_NAME'])|$($reader['DATA_TYPE'])|$($reader['CHARACTER_MAXIMUM_LENGTH'])|$($reader['NUMERIC_PRECISION'])|$($reader['NUMERIC_SCALE'])|$($reader['IS_NULLABLE'])"
}
$reader.Close()
$conn.Close()
