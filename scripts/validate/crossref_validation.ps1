# Cross-reference report entity/property references vs SSAS schema
$pagesDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages"

# Read all visual.json content
$allContent = ""
Get-ChildItem $pagesDir -Recurse -Filter "visual.json" | ForEach-Object {
    $allContent += (Get-Content $_.FullName -Raw) + "`n"
}
Get-ChildItem $pagesDir -Recurse -Filter "page.json" | ForEach-Object {
    $allContent += (Get-Content $_.FullName -Raw) + "`n"
}

# SSAS schema (from AMO output)
$schema = @{
    "dimArticulo" = @("Artículo Código","Artículo Nombre","Artículo Catalogo","Tipo Artículo Código","Tipo de Artículo Nombre","Tipo Artículo","Marca Código","Marca Descripción","Clase Código","Clase Nombre","Familia Código","Familia Nombre","Subfamilia Código","SubFamilia Nombre","Unidad Stock","Grupo Contable de Venta Código","Grupo","Grupo Artículo Nombre","Uso Código","Uso Nombre","Artículo Stock Mínimo","plazo","Lote Mínimo Compra","Proveedor Codigo","TipoComponente","Clase","Artículo","Proveedor Nombre","Proveedor Artículo Full")
    "dimProveedor" = @("Proveedor Id","Proveedor Nombre","Proveedor Dirección","Proveedor Ciudad","Proveedor Ciudad Nombre","Proveedor Departamento","Proveedor Nombre Departamento","País Código","País Nombre","Proveedor Teléfono","Proveedor Email","Proveedor Origen","Proveedor Clase Id","Proveedor Clase Nombre","Proveedor Forma de Pago","Proveedor Forma de Pago Nombre","Proveedor RUT","Proveedor Status","Proveedor","Proveedor Clase","Proveedor Forma de Pago1")
    "Calendario" = @("Date","Fecha","Año Fiscal Número","Año Fiscal","Fiscal Month Number","Fiscal Month","Fiscal Month in Quarter Number","Trimestre del Año Fiscal Número","Trimestre del año fiscal","Trimestre Fiscal","Año Mes Número","Año Mes","Year Month Key")
    "factComprasEnProceso" = @("CompraEP Tipo","CompraEP Proveedor","CompraEP Doc","CompraEP Serie","CompraEP Numero","CompraEP Articulo Codigo","CompraEP Cantidad","CompraEP Fecha Ultima Modificacion","CompraEP Ultima Fecha Entrega","CompraEP Documento","cod_tipoart")
    "factConsumoHistoria" = @("Consumo Artículo Código","Consumo Formulario","Consumo Transacción","Consumo Documento","Consumo Nº Documento","Consumo Fecha","Consumo Depósito","Consumo Estado","Consumo Cantidad","Consumo Obligatorio")
    "factConsumoPlanificado" = @("Consumo Planificado Orden","Consumo Planificado Fecha Planificacion","Consumo Planificado Tipo Orden","Consumo Planificado Nº Paso Orden","Consumo Planificado Artículo","Consumo Planificado Cantidad")
    "factDemandaPendientePlanificacion" = @("Demanda Pendiente Formula","Producto","Demanda Pendiente Artículo Nombre","Demanda Pendiente Componente Formula","Demanda Pendiente Componente Código","NomComponente","Demanda Pendiente Componente Tipo","Demanda Pendiente Componente Tipo Ficha","LoteMinFabricacion","Demanda Pendiente Componente Nivel","Obligatorio","Demanda Pendiente Componente Cantidad Requerida","PedOrigen_documento","PedOrigen_serie","PedOrigen_numero","Demanda Pendiente Artículo Formula Origen","Demanda Pendiente Articulo Pedido x Cliente","TrazaComposicion","NodoID_Hex","NodoPadreID_Hex","Pedido")
    "factRecepcionesHistoria" = @("Compra Empresa","RecepcionFecha","RecepcionArticulo","RecepcionCantidad","RecepcionOCDocumento","RecepcionOCNumero","OC Documento","OC Numero","OC Proveedor","OC Fecha","OC Total MO","OC Total TR","OC Moneda","OC Articulo Codigo","OC PrecioMO","OC PrecioUSD","SolicitudDocumento","SolicitudNumero","SolicitudFecha","Compra Documento","Compra Numero","Compra Fecha","Compra OC Doc","Compra OC Numero","Compra Fecha Inicio Proceso Interno Desde Solicitud","Compra Fecha Inicio Proceso Con Proveedor","Lead Time Dias")
    "factStockEPSA" = @("Stock Depósito","Stock Estado","Stock Estado Tipo","Stock Artículo Código","Stock Cantidad","Stock Fecha_Corte")
    "Medidas_Stock" = @("E + C - CP - CD - SM","Gap Stock","Stock Compras","Stock Debajo Mínimo","Stock Existencia","Stock Mínimo","Stock Proyectado")
    "Medidas_Consumo" = @("_RangoFechas_Debug","Consumo Cantidad","Consumo Cantidad Absoluta","Consumo Medio por Artículo","Consumo Mensual Promedio","Consumo Promedio por Mes Activo","Consumos","Meses con Consumo","Promedio Anual Consumo","Promedio Consumo","Promedio Consumo por Movimiento","Sumatoria Movs Consumo Sin Recepciones")
    "Medidas_Compras" = @("Cantidad Recepciones","Cobertura Meses sobre Existencia","Lead Time Promedio Dias","Ultima Recepcion Fecha")
    "Medidas_Consumo_Planificado" = @("Consumo Planificado Cantidad")
    "Medidas_DemandaPendiente" = @("Cantidad Requerida por Demanda Pendiente")
}

# Extract Column references (Entity + Property pairs)
$columnRefs = [regex]::Matches($allContent, '"Column"\s*:\s*\{[^}]*"Expression"\s*:\s*\{[^}]*"SourceRef"\s*:\s*\{[^}]*"Entity"\s*:\s*"([^"]+)"[^}]*\}[^}]*\}[^}]*"Property"\s*:\s*"([^"]+)"')

# Also try simpler extraction
$entityProps = @{}
$simpleMatches = [regex]::Matches($allContent, '"Entity"\s*:\s*"([^"]+)"')
$propertyMatches = [regex]::Matches($allContent, '"Property"\s*:\s*"([^"]+)"')

# Better approach: find visual blocks with both Entity and Property
$visualFiles = Get-ChildItem $pagesDir -Recurse -Filter "visual.json"
$missing = @()
$found = 0

foreach ($vf in $visualFiles) {
    $content = Get-Content $vf.FullName -Raw
    $entities = [regex]::Matches($content, '"Entity"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    $properties = [regex]::Matches($content, '"Property"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    
    foreach ($entity in $entities) {
        if ($schema.ContainsKey($entity)) {
            foreach ($prop in $properties) {
                $allCols = @()
                foreach ($key in $schema.Keys) { $allCols += $schema[$key] }
                if ($allCols -contains $prop) {
                    $found++
                } else {
                    $missing += "$entity.$prop (in $($vf.Name) at $($vf.Directory.Name))"
                }
            }
        } elseif ($entity -ne "d" -and $entity -notlike "Medidas_*") {
            $missing += "ENTITY NOT FOUND: '$entity' (in $($vf.Name))"
        }
    }
}

# Also check for NativeReferenceName (measure references)
$measureRefs = [regex]::Matches($allContent, '"NativeReferenceName"\s*:\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host "=== VALIDATION RESULTS ===" -ForegroundColor Cyan
Write-Host "Entity+Property references found: $found" -ForegroundColor Green
Write-Host "Missing references: $($missing.Count)" -ForegroundColor $(if ($missing.Count -gt 0) { "Red" } else { "Green" })

if ($missing.Count -gt 0) {
    Write-Host "`n=== MISSING REFERENCES ===" -ForegroundColor Red
    foreach ($m in ($missing | Sort-Object -Unique)) { Write-Host "  MISSING: $m" -ForegroundColor Yellow }
}

if ($measureRefs.Count -gt 0) {
    Write-Host "`n=== Measure NativeReferenceNames ===" -ForegroundColor Cyan
    foreach ($m in $measureRefs) {
        $foundMeasure = $false
        foreach ($key in $schema.Keys) {
            if ($schema[$key] -contains $m) { $foundMeasure = $true; break }
        }
        $color = if ($foundMeasure) { "Green" } else { "Red" }
        Write-Host "  [$m] - $(if ($foundMeasure) { 'OK' } else { 'NOT FOUND' })" -ForegroundColor $color
    }
}
