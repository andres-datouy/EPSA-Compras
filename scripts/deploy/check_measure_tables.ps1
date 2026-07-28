$j = Get-Content 'd:\Andres\Dev\EPSA-Compras\model\database_staging.json' -Raw | ConvertFrom-Json
$targets = @('Articulos Debajo Minimo','% Articulos Debajo Minimo','Brecha Stock Minimo USD','Articulos Sin SM Configurado','Total Articulos Activos','Articulos Stock Muerto','Stock Muerto USD','Rotacion Inventario','Stock Valor Total USD','Dias Sin Consumo','Ultima Fecha Consumo','Consumo Anual Cantidad','% Stock Muerto','Dias Cobertura Stock Actual','Consumo Promedio Diario','Dias Cobertura Necesidad','Articulos Sin Cobertura Suficiente','Compras En Proceso USD','Valor Stock Existencia USD','Gasto Recepciones USD','Compras Totales USD YTD','Gasto Promedio Mensual USD','Ticket Promedio USD','On Time Delivery %','Proveedor Concentracion %','Gasto Proyectado Mes','Costo Unitario Promedio USD')
foreach ($t in $j.model.tables) {
    foreach ($m in $t.measures) {
        if ($targets -contains $m.name) {
            Write-Output "$($m.name) -> $($t.name)"
        }
    }
}
