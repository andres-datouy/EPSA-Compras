# Fix partition queries: add column aliases to match model column names
# Based on semantic analysis of SQL vs model column mapping

$file = "$PSScriptRoot\..\model\database_staging.json"
$content = Get-Content $file -Raw -Encoding UTF8

# factConsumoHistoria (SQL: stg_factConsumo)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factConsumo]"',
    '"query":  "SELECT [cod_articulo] AS [Consumo Artículo Código], [formulario] AS [Consumo Formulario], [nro_trans] AS [Consumo Transacción], [nro_docum] AS [Consumo Documento], [fec_doc] AS [Consumo Fecha], [cod_tit] AS [Consumo Depósito], [cod_estado] AS [Consumo Estado], [cantidad] AS [Consumo Cantidad], [nom_articulo], [cod_tipoart], [FuenteConsumo], [Articulo_TipoComponente] FROM [dbo].[stg_factConsumo]"'
)

# dimArticulo (SQL: stg_dimArticulo) - 29 SQL cols → 27 model data cols + 5 calculated
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_dimArticulo]"',
    '"query":  "SELECT [cod_articulo] AS [Artículo Código], [nom_articulo] AS [Artículo Nombre], [catalogo] AS [Artículo Catalogo], [cod_tipoart] AS [Tipo Artículo Código], [nom_tipoart] AS [Tipo de Artículo Nombre], [Tipo Artículo], [cod_marca] AS [Marca Código], [marca_dsc] AS [Marca Descripción], [cod_clasifart] AS [Clase Código], [nom_clasifart] AS [Clase Nombre], [cod_familia_art] AS [Familia Código], [nom_familia_art] AS [Familia Nombre], [cod_subfam_art] AS [Subfamilia Código], [nom_subfam_art] AS [SubFamilia Nombre], [cod_uni_stk] AS [Unidad Stock], [cod_grcontvta] AS [Grupo Contable de Venta Código], [Grupo], [nom_grupoart] AS [Grupo Artículo Nombre], [cod_uso] AS [Uso Código], [nom_usofinal] AS [Uso Nombre], [stock_minimo] AS [Artículo Stock Mínimo], [plazo], [lote_min_cpra] AS [Lote Mínimo Compra], [ProveedorArticulo] AS [Proveedor Codigo], [ProveedorArticuloNombre] AS [Proveedor Nombre], [ProveedorPais], [ProveedorPaisNombre], [Proveedores], [TipoComponente] FROM [dbo].[stg_dimArticulo]"'
)

# factStockEPSA (SQL: stg_factStockEPSA)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factStockEPSA]"',
    '"query":  "SELECT [Deposito] AS [Stock Depósito], [Estado] AS [Stock Estado], [EstadoTipo] AS [Stock Estado Tipo], [cod_articulo] AS [Stock Artículo Código], [Cantidad] AS [Stock Cantidad], [Fecha_Corte] AS [Stock Fecha_Corte] FROM [dbo].[stg_factStockEPSA]"'
)

# factConsumoPlanificado (SQL: stg_factConsumoPlanificado)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factConsumoPlanificado]"',
    '"query":  "SELECT [nro_orden] AS [Consumo Planificado Orden], [Fecha_Planificacion] AS [Consumo Planificado Fecha Planificacion], [OrdenTipo] AS [Consumo Planificado Tipo Orden], [nro_pasoprod] AS [Consumo Planificado Nº Paso Orden], [cod_articulo] AS [Consumo Planificado Artículo], [Cantidad_Requerida] AS [Consumo Planificado Cantidad] FROM [dbo].[stg_factConsumoPlanificado]"'
)

# factDemandaPendientePlanificacion (SQL: stg_factDemandaPendiente)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factDemandaPendiente]"',
    '"query":  "SELECT [Formula] AS [Demanda Pendiente Formula], [Producto], [NomProducto] AS [Demanda Pendiente Artículo Nombre], [FormulaComp] AS [Demanda Pendiente Componente Formula], [Componente] AS [Demanda Pendiente Componente Código], [NomComponente], [TipoComp] AS [Demanda Pendiente Componente Tipo], [Componente_TipoFicha] AS [Demanda Pendiente Componente Tipo Ficha], [LoteMinFabricacion], [Level] AS [Demanda Pendiente Componente Nivel], [Obligatorio], [Cantidad_Requerida] AS [Demanda Pendiente Componente Cantidad Requerida], [PedOrigen_documento], [PedOrigen_serie], [PedOrigen_numero], [FormulaOrigen] AS [Demanda Pendiente Artículo Formula Origen], [ArticuloPedido] AS [Demanda Pendiente Articulo Pedido x Cliente], [TrazaComposicion], [NodoID_Hex], [NodoPadreID_Hex] FROM [dbo].[stg_factDemandaPendiente]"'
)

# factRecepcionesHistoria (SQL: stg_factRecepcionesHistoria)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factRecepcionesHistoria]"',
    '"query":  "SELECT [Empresa] AS [Compra Empresa], [RecepcionFecha], [RecepcionArticulo], [RecepcionCantidad], [RecepcionOCDocumento], [RecepcionOCNumero], [OCDocumento] AS [OC Documento], [OCNumero] AS [OC Numero], [OCProveedor] AS [OC Proveedor], [OCFecha] AS [OC Fecha], [OCTotalMO] AS [OC Total MO], [OCTotalTR] AS [OC Total TR], [OCMoneda] AS [OC Moneda], [OCArticuloCodigo] AS [OC Articulo Codigo], [OCPrecioMO] AS [OC PrecioMO], [OCPrecioUSD] AS [OC PrecioUSD], [SolicitudDocumento], [SolicitudNumero], [SolicitudFecha], [CompraDocumento] AS [Compra Documento], [CompraNumero] AS [Compra Numero], [CompraFecha] AS [Compra Fecha], [CompraOCDoc] AS [Compra OC Doc], [CompraOCNumero] AS [Compra OC Numero] FROM [dbo].[stg_factRecepcionesHistoria]"'
)

# dimProveedor (SQL: stg_dimProveedor) - columns match, no aliases needed
# But model has 3 extra calculated columns (Proveedor, Proveedor Clase, Proveedor Forma de Pago1)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_dimProveedor]"',
    '"query":  "SELECT [Proveedor Id], [Proveedor Nombre], [Proveedor Dirección], [Proveedor Ciudad], [Proveedor Ciudad Nombre], [Proveedor Departamento], [Proveedor Nombre Departamento], [País Código], [País Nombre], [Proveedor Teléfono], [Proveedor Email], [Proveedor Origen], [Proveedor Clase Id], [Proveedor Clase Nombre], [Proveedor Forma de Pago], [Proveedor Forma de Pago Nombre], [Proveedor RUT], [Proveedor Status] FROM [dbo].[stg_dimProveedor]"'
)

# factComprasEnProceso (SQL: stg_factComprasEnProceso)
$content = $content.Replace(
    '"query":  "SELECT * FROM [dbo].[stg_factComprasEnProceso]"',
    '"query":  "SELECT [Tipo] AS [CompraEP Tipo], [cod_tit] AS [CompraEP Proveedor], [cod_doca] AS [CompraEP Doc], [serie_doca] AS [CompraEP Serie], [nro_doca] AS [CompraEP Numero], [cod_articulo] AS [CompraEP Articulo Codigo], [Cant] AS [CompraEP Cantidad], [FechaUltimaMod] AS [CompraEP Fecha Ultima Modificacion], [FechaEntregaMax] AS [CompraEP Ultima Fecha Entrega], [cod_tipoart] FROM [dbo].[stg_factComprasEnProceso]"'
)

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "All partition queries updated with column aliases!" -ForegroundColor Green
