Add-Type -Path "C:\Program Files\Microsoft SQL Server\160\Setup Bootstrap\SQL2022\x64\Microsoft.AnalysisServices.Tabular.DLL"
$server = New-Object Microsoft.AnalysisServices.Tabular.Server
$server.Connect("Data Source=192.168.2.47:2383")
$db = $server.Databases.FindByName("EPSA-Compras")
$model = $db.Model

$fieldsToCheck = @(
    @{Table="Medidas_Stock"; Name="Articulos Sin Cobertura Suficiente"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Compras En Proceso USD"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Dias Cobertura Stock Actual"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Stock Existencia"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Stock Compras"; Type="Measure"},
    @{Table="Medidas_Consumo_Planificado"; Name="Consumo Planificado Cantidad"; Type="Measure"},
    @{Table="Medidas_DemandaPendiente"; Name="Cantidad Requerida por Demanda Pendiente"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Stock Util E+C-CP-CD"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="Dias Cobertura Necesidad"; Type="Measure"},
    @{Table="Medidas_Stock"; Name="A Pedir Sugerido"; Type="Measure"},
    @{Table="factComprasEnProceso"; Name="CompraEP Articulo Codigo"; Type="Column"},
    @{Table="factComprasEnProceso"; Name="CompraEP Cantidad"; Type="Column"},
    @{Table="factComprasEnProceso"; Name="CompraEP Tipo"; Type="Column"},
    @{Table="factComprasEnProceso"; Name="CompraEP Proveedor"; Type="Column"},
    @{Table="factComprasEnProceso"; Name="CompraEP Fecha Ultima Modificacion"; Type="Column"},
    @{Table="factComprasEnProceso"; Name="CompraEP Ultima Fecha Entrega"; Type="Column"},
    @{Table="dimArticulo"; Name="Articulo Codigo"; Type="Column"},
    @{Table="dimArticulo"; Name="Articulo Nombre"; Type="Column"}
)

foreach ($f in $fieldsToCheck) {
    $tbl = $model.Tables[$f.Table]
    $found = "TABLE_MISSING"
    if ($tbl) {
        $col = $tbl.Columns | Where-Object { $_.Name -eq $f.Name }
        if ($col) { $found = "OK (column)" }
        else {
            $msr = $tbl.Measures | Where-Object { $_.Name -eq $f.Name }
            if ($msr) { $found = "OK (measure)" }
            else { $found = "NOT_FOUND" }
        }
    }
    Write-Output "$($f.Table).$($f.Name) = $found"
}

# Also list actual columns on factComprasEnProceso and dimArticulo
Write-Output "`n=== factComprasEnProceso columns ==="
$tbl = $model.Tables["factComprasEnProceso"]
if ($tbl) {
    foreach ($c in $tbl.Columns) { Write-Output "  $($c.Name)" }
} else { Write-Output "  TABLE NOT FOUND" }

Write-Output "`n=== dimArticulo columns ==="
$tbl2 = $model.Tables["dimArticulo"]
if ($tbl2) {
    foreach ($c in $tbl2.Columns) { Write-Output "  $($c.Name)" }
} else { Write-Output "  TABLE NOT FOUND" }

Write-Output "`n=== Medidas_Stock measures ==="
$tbl3 = $model.Tables["Medidas_Stock"]
if ($tbl3) {
    foreach ($m in $tbl3.Measures) { Write-Output "  $($m.Name)" }
} else { Write-Output "  TABLE NOT FOUND" }

Write-Output "`n=== Medidas_Consumo_Planificado measures ==="
$tbl4 = $model.Tables["Medidas_Consumo_Planificado"]
if ($tbl4) {
    foreach ($m in $tbl4.Measures) { Write-Output "  $($m.Name)" }
} else { Write-Output "  TABLE NOT FOUND" }

Write-Output "`n=== Medidas_DemandaPendiente measures ==="
$tbl5 = $model.Tables["Medidas_DemandaPendiente"]
if ($tbl5) {
    foreach ($m in $tbl5.Measures) { Write-Output "  $($m.Name)" }
} else { Write-Output "  TABLE NOT FOUND" }

$server.Disconnect()
