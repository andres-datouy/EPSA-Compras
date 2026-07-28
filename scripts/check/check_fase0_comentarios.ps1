$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Verifica estado de Fase 0 en staging_compras (solo lectura)
# 1. Comentarios con datos en stg_dimArticulo
# 2. SP sp_refresh_dimArticulo incluye Comentarios
# 3. Ultimo refresh en stg_refresh_log
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;"
$conn.Open()

function Run-Query($sql, $title) {
    Write-Host "`n=== $title ===" -ForegroundColor Cyan
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $da = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
    $dt = New-Object System.Data.DataTable
    [void]$da.Fill($dt)
    $dt | Format-Table -AutoSize | Out-String -Width 300 | Write-Host
}

Run-Query @"
SELECT COUNT(*) AS TotalFilas,
       SUM(CASE WHEN Comentarios IS NOT NULL AND LTRIM(RTRIM(Comentarios)) <> '' THEN 1 ELSE 0 END) AS ConComentarios
FROM dbo.stg_dimArticulo;
"@ "1. Datos Comentarios en stg_dimArticulo"

Run-Query @"
SELECT CASE WHEN OBJECT_DEFINITION(OBJECT_ID('dbo.sp_refresh_dimArticulo')) LIKE '%Comentarios%'
            THEN 'SI - SP incluye Comentarios' ELSE 'NO - SP desactualizado' END AS SP_Estado;
"@ "2. SP sp_refresh_dimArticulo"

Run-Query @"
SELECT TOP 3 log_id, table_name, refresh_type, start_time, end_time, rows_affected, status
FROM dbo.stg_refresh_log
WHERE table_name = 'stg_dimArticulo'
ORDER BY log_id DESC;
"@ "3. Ultimos refresh de stg_dimArticulo"

Run-Query @"
SELECT TOP 5 cod_articulo, LEFT(nom_articulo, 40) AS nom_articulo, LEFT(Comentarios, 80) AS Comentarios
FROM dbo.stg_dimArticulo
WHERE Comentarios IS NOT NULL AND LTRIM(RTRIM(Comentarios)) <> '';
"@ "4. Muestra de Comentarios"

$conn.Close()
