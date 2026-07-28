$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Muestra la definicion actual de sp_refresh_dimArticulo (solo lectura)
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;"
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.sp_refresh_dimArticulo')) AS def;"
$def = $cmd.ExecuteScalar()
Write-Host $def
$conn.Close()
