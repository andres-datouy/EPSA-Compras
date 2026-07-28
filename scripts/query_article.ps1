$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Query staging data for a specific article
param(
    [string]$ArticleCode = "%16405004%"
)

$connStr = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()

# 1. dimArticulo info
Write-Host "`n=== stg_dimArticulo ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT cod_articulo, nom_articulo, stock_minimo, lote_min_cpra, ProveedorArticuloNombre, ProveedorPaisNombre FROM stg_dimArticulo WHERE cod_articulo LIKE '$ArticleCode'"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 2. factComprasEnProceso - projected purchases
Write-Host "`n=== stg_factComprasEnProceso (Compras Proyectadas) ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT Tipo, nro_doca AS 'Nro Doc', cod_articulo, Cant, FechaUltimaMod AS 'Fecha Mod', FechaEntregaMax AS 'Fecha Entrega' FROM stg_factComprasEnProceso WHERE cod_articulo LIKE '$ArticleCode' ORDER BY FechaEntregaMax"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 3. factStockEPSA - current stock
Write-Host "`n=== stg_factStockEPSA (Stock Actual) ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT Deposito, Estado, EstadoTipo, cod_articulo, Cantidad, Fecha_Corte FROM stg_factStockEPSA WHERE cod_articulo LIKE '$ArticleCode'"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 4. Last consumption
Write-Host "`n=== Ultimos 10 movimientos de consumo ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT TOP 10 fec_doc AS Fecha, formulario, nro_docum AS Doc, cantidad, cod_estado AS Estado FROM stg_factConsumo WHERE cod_articulo LIKE '$ArticleCode' ORDER BY fec_doc DESC"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 5. Recepciones (for lead time / arrival dates)
Write-Host "`n=== Ultimas 5 recepciones ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT TOP 5 RecepcionFecha, RecepcionArticulo, RecepcionCantidad, RecepcionOCDocumento, RecepcionOCNumero FROM stg_factRecepcionesHistoria WHERE RecepcionArticulo LIKE '$ArticleCode' ORDER BY RecepcionFecha DESC"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

$conn.Close()
# Query staging data for a specific article
param(
    [string]$ArticleCode = "%16405004%"
)

$connStr = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()

# 1. dimArticulo info
Write-Host "`n=== stg_dimArticulo ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT cod_articulo, nom_articulo, stock_minimo, lote_min_cpra, ProveedorArticuloNombre, ProveedorPaisNombre FROM stg_dimArticulo WHERE cod_articulo LIKE '$ArticleCode'"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 2. factComprasEnProceso - projected purchases
Write-Host "`n=== stg_factComprasEnProceso (Compras Proyectadas) ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT Tipo, nro_doca AS 'Nro Doc', cod_articulo, Cant, FechaUltimaMod AS 'Fecha Mod', FechaEntregaMax AS 'Fecha Entrega' FROM stg_factComprasEnProceso WHERE cod_articulo LIKE '$ArticleCode' ORDER BY FechaEntregaMax"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 3. factStockEPSA - current stock
Write-Host "`n=== stg_factStockEPSA (Stock Actual) ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT Deposito, Estado, EstadoTipo, cod_articulo, Cantidad, Fecha_Corte FROM stg_factStockEPSA WHERE cod_articulo LIKE '$ArticleCode'"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 4. Last consumption
Write-Host "`n=== Últimos 10 movimientos de consumo ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT TOP 10 fec_doc AS Fecha, formulario, nro_docum AS Doc, cantidad, cod_estado AS Estado FROM stg_factConsumo WHERE cod_articulo LIKE '$ArticleCode' ORDER BY fec_doc DESC"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

# 5. Recepciones (for lead time / arrival dates)
Write-Host "`n=== Últimas 5 recepciones ===" -ForegroundColor Cyan
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT TOP 5 RecepcionFecha, RecepcionArticulo, RecepcionCantidad, RecepcionOCDocumento, RecepcionOCNumero FROM stg_factRecepcionesHistoria WHERE RecepcionArticulo LIKE '$ArticleCode' ORDER BY RecepcionFecha DESC"
$adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$dt = New-Object System.Data.DataTable
$null = $adapter.Fill($dt)
if ($dt.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt | Format-Table -AutoSize -Wrap }

$conn.Close()
# Query staging data for a specific article
param(
    [string]$ArticleCode = "16405004"
)

$connStr = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()

# 1. dimArticulo info
Write-Host "`n=== stg_dimArticulo ===" -ForegroundColor Cyan
$cmd3 = $conn.CreateCommand()
$cmd3.CommandText = "SELECT Articulo_Codigo, Articulo_Nombre, Articulo_Stock_Minimo, Proveedor_Nombre, Lote_Minimo_Compra FROM stg_dimArticulo WHERE Articulo_Codigo LIKE '%$ArticleCode%'"
$adapter3 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd3)
$dt3 = New-Object System.Data.DataTable
$null = $adapter3.Fill($dt3)
if ($dt3.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt3 | Format-Table -AutoSize }

# 2. factComprasEnProceso - projected purchases
Write-Host "`n=== stg_factComprasEnProceso (Compras Proyectadas) ===" -ForegroundColor Cyan
$cmd1 = $conn.CreateCommand()
$cmd1.CommandText = "SELECT * FROM stg_factComprasEnProceso WHERE CompraEP_Articulo_Codigo LIKE '%$ArticleCode%' ORDER BY CompraEP_Fecha_Prometida"
$adapter1 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd1)
$dt1 = New-Object System.Data.DataTable
$null = $adapter1.Fill($dt1)
if ($dt1.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt1 | Format-Table -AutoSize }

# 3. factStockEPSA - current stock
Write-Host "`n=== stg_factStockEPSA (Stock Actual) ===" -ForegroundColor Cyan
$cmd2 = $conn.CreateCommand()
$cmd2.CommandText = "SELECT Stock_Articulo_Codigo, Stock_Estado, Stock_Cantidad, Stock_Fecha_Corte FROM stg_factStockEPSA WHERE Stock_Articulo_Codigo LIKE '%$ArticleCode%'"
$adapter2 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd2)
$dt2 = New-Object System.Data.DataTable
$null = $adapter2.Fill($dt2)
if ($dt2.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt2 | Format-Table -AutoSize }

# 4. Last consumption
Write-Host "`n=== Últimos 10 movimientos de consumo ===" -ForegroundColor Cyan
$cmd4 = $conn.CreateCommand()
$cmd4.CommandText = "SELECT TOP 10 Consumo_Fecha, Consumo_Documento, Consumo_Cantidad, Consumo_Estado FROM stg_factConsumo WHERE Consumo_Articulo_Codigo LIKE '%$ArticleCode%' ORDER BY Consumo_Fecha DESC"
$adapter4 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd4)
$dt4 = New-Object System.Data.DataTable
$null = $adapter4.Fill($dt4)
if ($dt4.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt4 | Format-Table -AutoSize }

# 5. Recepciones (for lead time / arrival dates)
Write-Host "`n=== Últimas 5 recepciones ===" -ForegroundColor Cyan
$cmd5 = $conn.CreateCommand()
$cmd5.CommandText = "SELECT TOP 5 * FROM stg_factRecepcionesHistoria WHERE RecepcionArticulo LIKE '%$ArticleCode%' ORDER BY RecepcionFecha DESC"
$adapter5 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd5)
$dt5 = New-Object System.Data.DataTable
$null = $adapter5.Fill($dt5)
if ($dt5.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt5 | Format-Table -AutoSize }

$conn.Close()
# Query staging data for a specific article
param(
    [string]$ArticleCode = "16405004"
)

$connStr = "Server=192.168.2.47,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPass;TrustServerCertificate=True"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()

# 1. factComprasEnProceso - projected purchases
Write-Host "`n=== factComprasEnProceso (Compras Proyectadas) ===" -ForegroundColor Cyan
$cmd1 = $conn.CreateCommand()
$cmd1.CommandText = "SELECT * FROM factComprasEnProceso WHERE CompraEP_Articulo_Codigo LIKE '%$ArticleCode%' ORDER BY CompraEP_Fecha_Prometida"
$adapter1 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd1)
$dt1 = New-Object System.Data.DataTable
$null = $adapter1.Fill($dt1)
if ($dt1.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt1 | Format-Table -AutoSize }

# 2. factStockEPSA - current stock
Write-Host "`n=== factStockEPSA (Stock Actual) ===" -ForegroundColor Cyan
$cmd2 = $conn.CreateCommand()
$cmd2.CommandText = "SELECT Stock_Articulo_Codigo, Stock_Estado, Stock_Cantidad, Stock_Fecha_Corte FROM factStockEPSA WHERE Stock_Articulo_Codigo LIKE '%$ArticleCode%'"
$adapter2 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd2)
$dt2 = New-Object System.Data.DataTable
$null = $adapter2.Fill($dt2)
if ($dt2.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt2 | Format-Table -AutoSize }

# 3. dimArticulo info
Write-Host "`n=== dimArticulo ===" -ForegroundColor Cyan
$cmd3 = $conn.CreateCommand()
$cmd3.CommandText = "SELECT Articulo_Codigo, Articulo_Nombre, Articulo_Stock_Minimo, Proveedor_Nombre, Lote_Minimo_Compra FROM dimArticulo WHERE Articulo_Codigo LIKE '%$ArticleCode%'"
$adapter3 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd3)
$dt3 = New-Object System.Data.DataTable
$null = $adapter3.Fill($dt3)
if ($dt3.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt3 | Format-Table -AutoSize }

# 4. Last consumption
Write-Host "`n=== Últimos 10 movimientos de consumo ===" -ForegroundColor Cyan
$cmd4 = $conn.CreateCommand()
$cmd4.CommandText = "SELECT TOP 10 Consumo_Fecha, Consumo_Documento, Consumo_Cantidad, Consumo_Estado FROM factConsumoHistoria WHERE Consumo_Articulo_Codigo LIKE '%$ArticleCode%' ORDER BY Consumo_Fecha DESC"
$adapter4 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd4)
$dt4 = New-Object System.Data.DataTable
$null = $adapter4.Fill($dt4)
if ($dt4.Rows.Count -eq 0) { Write-Host "  (sin datos)" } else { $dt4 | Format-Table -AutoSize }

$conn.Close()
