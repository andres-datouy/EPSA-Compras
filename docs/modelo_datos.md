# EPSA Compras - Modelo de Datos

## Informacion General

| Propiedad | Valor |
|-----------|-------|
| Archivo | Compras EPSA - Stock.pbix |
| Version PBIX | 1.28 |
| Origen | Cloud (Power BI Service) |
| Release | 2026.04 |
| Compatibilidad | 1600 |
| Database ID | 96a1dcae-a2cd-468c-9e4d-7134493b91c7 |

## Fuentes de Datos

| Servidor | Base de Datos | Uso |
|----------|---------------|-----|
| 192.168.2.7 | Nodum | ERP principal (consumos, proveedores, compras en proceso, demanda pendiente) |
| 192.168.2.7 | EPSA_BI | Data Warehouse / vistas BI (dimensiones, stock, consumo planificado, recepciones) |

## Tablas del Modelo (17)

### Dimensiones

#### Calendario
- **Tipo:** Calculada (basada en DateAutoTemplate)
- **Descripcion:** Dimension de tiempo con ano fiscal
- **Columnas:** Fecha, Ano Fiscal, Ano Fiscal Numero, Ano Mes, Ano Mes Numero, Fiscal Month, Fiscal Month in Quarter Number, Fiscal Month Number, Trimestre del ano fiscal, Trimestre del Ano Fiscal Numero, Trimestre Fiscal, Year Month Key

#### DateAutoTemplate
- **Tipo:** Calculada (tabla de fechas automatica)
- **Columnas:** Date, Fiscal Month, Fiscal Month in Quarter Number, Fiscal Month Number, Fiscal Quarter, Fiscal Year, Fiscal Year Number, Fiscal Year Quarter, Fiscal Year Quarter Number, Year Month, Year Month Key, Year Month Number

#### dimArticulo
- **Fuente:** `Sql.Database("192.168.2.7", "EPSA_BI")` → `dbo.vw_Compras_DimArticuloEPSA`
- **Columnas clave:**
  - Articulo Codigo (PK, String)
  - Articulo Nombre (String)
  - Articulo Catalogo (String)
  - Articulo Stock Minimo (Double)
  - Clase Codigo / Clase Nombre (String)
  - Familia Codigo / Familia Nombre (String)
  - Subfamilia Codigo / SubFamilia Nombre (String)
  - Grupo Contable de Venta Codigo / Grupo Articulo Nombre (String)
  - Marca Codigo / Marca Descripcion (String)
  - Tipo Articulo Codigo / Tipo de Articulo Nombre (String)
  - Uso Codigo / Uso Nombre (String)
  - Unidad Stock (String)
  - Lote Minimo Compra (Double)
  - plazo (Int64)
  - Proveedor Articulo (String)
  - TipoComponente (String)

#### dimProveedor
- **Fuente:** `Sql.Database("192.168.2.7", "Nodum")` - Query SQL directo
- **Tablas origen ERP:** ct_proveedores, ct_paises, ct_provincias, ct_ciudades, ct_clasesprov, ct_fpagos
- **Filtro:** Proveedores con recepciones en historia (`epsa_bi.dbo.vw_ComprasBI_RecepcionesHistoria`)
- **Columnas clave:**
  - Proveedor Id (PK, String)
  - Proveedor Nombre (String)
  - Proveedor Direccion (String)
  - Proveedor Ciudad / Proveedor Ciudad Nombre (String)
  - Proveedor Departamento / Proveedor Nombre Departamento (String)
  - Pais Codigo / Pais Nombre (String)
  - Proveedor Telefono / Email (String)
  - Proveedor Origen (String)
  - Proveedor Clase Id / Proveedor Clase Nombre (String)
  - Proveedor Forma de Pago / Proveedor Forma de Pago Nombre (String)
  - Proveedor RUT (String)
  - Proveedor Status (String)

### Hechos

#### factStockEPSA
- **Fuente:** `Sql.Database("192.168.2.7", "EPSA_BI")` → `dbo.vw_ComprasBI_factStockEPSA`
- **Objetivo:** 1.4 Stock actual
- **Columnas:**
  - Stock Articulo Codigo (String)
  - Stock Cantidad (Double)
  - Stock Deposito (String)
  - Stock Estado (String) - existencia, stkaf
  - Stock Estado Tipo (String)
  - Stock Fecha_Corte (DateTime)

#### factConsumoHistoria
- **Fuente:** `Sql.Database("192.168.2.7", "Nodum")` - Query SQL directo
- **Tablas origen ERP:** cpf_stockaux, ct_articulos
- **Objetivo:** 1.1 Historia de consumos de EPSA
- **Filtros:** cod_emp = 'EPSA', cod_estado = 'existencia', fec_doc ultimos 5 anos, cod_tipoart NOT IN ('prvta', 'pt', 'semi', 'tubos')
- **Columnas:**
  - Consumo Articulo Codigo (String)
  - Consumo Cantidad (Double)
  - Consumo Deposito (String)
  - Consumo Documento (String)
  - Consumo Estado (String)
  - Consumo Fecha (DateTime)
  - Consumo Formulario (String)
  - Consumo N Documento (Int64)
  - Consumo Obligatorio (String)
  - Consumo Transaccion (Int64)

#### factConsumoPlanificado
- **Fuente:** `Sql.Database("192.168.2.7", "EPSA_BI")` → `dbo.vw_ComprasBI_factConsumoPlanificadoEPSA`
- **Objetivo:** 1.2 Trabajo planificado en EPSA que aun no ha sido programado
- **Columnas:**
  - Consumo Planificado Articulo (String)
  - Consumo Planificado Cantidad (Double)
  - Consumo Planificado Fecha Planificacion (DateTime)
  - Consumo Planificado N Paso Orden (Int64)
  - Consumo Planificado Orden (String)
  - Consumo Planificado Tipo Orden (String)

#### factDemandaPendientePlanificacion
- **Fuente:** `Sql.Database("192.168.2.7", "Nodum")` → `EPSA_BI.dbo.stg_RequerimientosSobreDemandaPendientePlanificacion`
- **Objetivo:** 1.3 Consumo requerido por pedidos pendientes (descomposicion de demanda)
- **Nota:** La tabla `00_Run_Staging` ejecuta el SP `dbo.Staging_RequerimientosSobreDemandaPendientePlanificacion` para poblar esta staging previo a la carga
- **Columnas clave:**
  - Demanda Pendiente Componente Codigo (String)
  - Demanda Pendiente Componente Cantidad Requerida (Double)
  - Demanda Pendiente Formula / Componente Formula (Int64)
  - Demanda Pendiente Componente Nivel (Int64)
  - Demanda Pendiente Componente Tipo / Tipo Ficha (String)
  - Producto / NomProducto (String)
  - Articulo Pedido x Cliente (String)
  - NodoID_Hex / NodoPadreID_Hex (String)
  - TrazaComposicion (String)
  - Obligatorio (String)
  - LoteMinFabricacion (Int64)

#### factRecepcionesHistoria
- **Fuente:** `Sql.Database("192.168.2.7", "EPSA_BI")` → `dbo.vw_ComprasBI_HistoriaRecepciones`
- **Objetivo:** 1.5.2 Ordenes de compra - fecha de llegada / Historial de recepciones
- **Columnas clave:**
  - RecepcionArticulo (String)
  - RecepcionCantidad (Double)
  - RecepcionFecha (DateTime)
  - RecepcionOCDocumento / RecepcionOCNumero (String/Int64)
  - OC Proveedor (String)
  - OC Articulo Codigo (String)
  - OC Documento / OC Numero (String/Int64)
  - OC Fecha (DateTime)
  - OC Moneda (String)
  - OC PrecioMO / OC PrecioUSD (Double)
  - OC Total MO / OC Total TR (Double)
  - Compra Documento / Compra Numero (String)
  - Compra Fecha (DateTime)
  - SolicitudDocumento / SolicitudNumero / SolicitudFecha
  - Lead Time Dias (Int64)
  - Compra Fecha Inicio Proceso (DateTime)

#### factComprasEnProceso
- **Fuente:** `Sql.Database("192.168.2.7", "Nodum")` - Query SQL directo (Union de 3 tablas)
- **Tablas origen ERP:** cps_solicitudes, cps_ocompras, cpf_stockaux + cpp_importacione
- **Objetivo:** 1.5.1 Solicitudes de compra + 1.5.2 Ordenes de compra + 1.5.3 Carpetas de importacion
- **Tipos incluidos:** 'Solicitud', 'Orden de Compra', 'Carpeta Import'
- **Filtros:** Ultimos 5 anos, tipo art no incluye PT, PRVTA, SEMI, TUBOS, SERVTA
- **Columnas:**
  - CompraEP Tipo (String)
  - CompraEP Proveedor (String)
  - CompraEP Doc / Serie / Numero (String/Int64)
  - CompraEP Articulo Codigo (String)
  - CompraEP Cantidad (Double)
  - CompraEP Fecha Ultima Modificacion (DateTime)
  - CompraEP Ultima Fecha Entrega (DateTime)

### Tablas de Medidas (Measure Groups)

#### Medidas_Consumo
| Medida | Expresion DAX |
|--------|---------------|
| Consumo Cantidad | `SUM(factConsumoHistoria[Consumo Cantidad])` |
| Consumo Cantidad Absoluta | `SUMX(factConsumoHistoria, ABS(...))` |
| Consumo Medio por Articulo | `DIVIDE([Consumo Cantidad], MovimientosArticulo)` |
| Consumo Mensual Promedio | `AVERAGEX(VALUES(Calendario[Fiscal Month]), ...)` |
| Consumo Promedio por Mes Activo | `DIVIDE([Sumatoria Movs Consumo Sin Recepciones], [Meses con Consumo])` |
| Consumos | `COUNTROWS(factConsumoHistoria)` |
| Meses con Consumo | Compleja - cuenta meses con consumo <> 0 |
| Promedio Anual Consumo | `AVERAGEX(VALUES(Calendario[Ano Fiscal]), ...)` |
| Promedio Consumo | `AVERAGE(factConsumoHistoria[Consumo Cantidad])` |
| Promedio Consumo por Movimiento | `DIVIDE(ABS([Sumatoria Movs...]), [Consumos])` |
| Sumatoria Movs Consumo Sin Recepciones | `ABS(CALCULATE(SUM(...), Documento <> "recstktr"))` |
| _RangoFechas_Debug | Debug de rangos de fecha |

#### Medidas_Stock
| Medida | Expresion DAX |
|--------|---------------|
| Stock Existencia | `CALCULATE(SUM(factStockEPSA[Stock Cantidad]), Estado in {"existencia","stkaf"})` |
| Stock Compras | `SUM(factComprasEnProceso[CompraEP Cantidad])` |
| Stock MInimo | `SUM(dimArticulo[Articulo Stock Minimo])` |
| Stock Proyectado | `[Stock Existencia] + [Stock Compras]` |
| Gap Stock | `[Stock Existencia] - [Stock Minimo]` |
| Stock Debajo Minimo | `IF([Gap Stock] < 0, "CRITICO", "OK")` |
| E + C - CP - CD - SM | `Stock + Compras - ConsumoPlanificado - DemandaPendiente - StockMinimo` |

#### Medidas_Compras
| Medida | Expresion DAX |
|--------|---------------|
| Cantidad Recepciones | `COUNTROWS(factRecepcionesHistoria)` |
| Cobertura Meses sobre Existencia | `DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo])` |
| Lead Time Promedio Dias | `AVERAGE(factRecepcionesHistoria[Lead Time Dias])` |
| Ultima Recepcion Fecha | `MAX(factRecepcionesHistoria[RecepcionFecha])` |

#### Medidas_Consumo_Planificado
| Medida | Expresion DAX |
|--------|---------------|
| Consumo Planificado Cantidad | `SUMX(factConsumoPlanificado, ABS(...))` |

#### Medidas_DemandaPendiente
| Medida | Expresion DAX |
|--------|---------------|
| Cantidad Requerida por Demanda Pendiente | `SUMX(factDemandaPendientePlanificacion, ABS(...))` |

#### Medidas_HistoriaCompra
- Tabla vacia (reservada para futuras medidas)

## Relaciones (11)

| Desde | Columna | Hacia | Columna | Direccion |
|-------|---------|-------|---------|-----------|
| factConsumoHistoria | Consumo Fecha | Calendario | Fecha | OneDirection |
| factConsumoHistoria | Consumo Articulo Codigo | dimArticulo | Articulo Codigo | OneDirection |
| factStockEPSA | Stock Articulo Codigo | dimArticulo | Articulo Codigo | OneDirection |
| factConsumoPlanificado | Consumo Planificado Articulo | dimArticulo | Articulo Codigo | OneDirection |
| factDemandaPendientePlanificacion | Demanda Pendiente Componente Codigo | dimArticulo | Articulo Codigo | OneDirection |
| factStockEPSA | Stock Fecha_Corte | Calendario | Fecha | OneDirection |
| factConsumoPlanificado | Consumo Planificado Fecha Planificacion | Calendario | Fecha | OneDirection |
| factRecepcionesHistoria | RecepcionArticulo | dimArticulo | Articulo Codigo | OneDirection |
| factRecepcionesHistoria | RecepcionFecha | Calendario | Fecha | OneDirection |
| factRecepcionesHistoria | OC Proveedor | dimProveedor | Proveedor Id | OneDirection |
| factComprasEnProceso | CompraEP Articulo Codigo | dimArticulo | Articulo Codigo | OneDirection |

## Diagrama de Relaciones (Mermaid)

```mermaid
graph LR
    dimArticulo[dimArticulo]
    dimProveedor[dimProveedor]
    Calendario[Calendario]
    factStockEPSA[factStockEPSA]
    factConsumoHistoria[factConsumoHistoria]
    factConsumoPlanificado[factConsumoPlanificado]
    factDemandaPendientePlanificacion[factDemandaPendientePlanificacion]
    factRecepcionesHistoria[factRecepcionesHistoria]
    factComprasEnProceso[factComprasEnProceso]

    factStockEPSA --> dimArticulo
    factStockEPSA --> Calendario
    factConsumoHistoria --> dimArticulo
    factConsumoHistoria --> Calendario
    factConsumoPlanificado --> dimArticulo
    factConsumoPlanificado --> Calendario
    factDemandaPendientePlanificacion --> dimArticulo
    factRecepcionesHistoria --> dimArticulo
    factRecepcionesHistoria --> Calendario
    factRecepcionesHistoria --> dimProveedor
    factComprasEnProceso --> dimArticulo
```

## Mapeo a Objetivos del Proyecto

| Objetivo | Tablas del modelo |
|----------|-------------------|
| 1.1 Historia de consumos | factConsumoHistoria + Medidas_Consumo |
| 1.2 Trabajo planificado no programado | factConsumoPlanificado + Medidas_Consumo_Planificado |
| 1.3 Consumo requerido por pedidos pendientes | factDemandaPendientePlanificacion + Medidas_DemandaPendiente |
| 1.4 Stock actual | factStockEPSA + Medidas_Stock |
| 1.4.1 Existencia | factStockEPSA[Stock Estado] in {"existencia","stkaf"} |
| 1.4.2 Existencia con vencimiento proximo | *Requiere verificar si existe columna de vencimiento* |
| 1.4.3 Cuarentena | *Requiere verificar campo Stock Estado Tipo* |
| 1.5 Compras en curso | factComprasEnProceso + factRecepcionesHistoria + Medidas_Compras |
| 1.5.1 Solicitudes de compra | factComprasEnProceso[CompraEP Tipo] = "Solicitud" |
| 1.5.2 Ordenes de compra | factComprasEnProceso[CompraEP Tipo] = "Orden de Compra" |
| 1.5.3 Carpetas de importacion | factComprasEnProceso[CompraEP Tipo] = "Carpeta Import" + factRecepcionesHistoria |
