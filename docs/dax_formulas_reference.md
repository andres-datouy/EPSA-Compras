# EPSA Compras - Referencia de Formulas DAX

## Version: 1.0
## Fecha: 2026-05-18
## Modelo: Compras_EPSA (SSAS Tabular 2017)

---

## 1. Medidas de Stock (Medidas_Stock)

### 1.1 Stock Existencia

```dax
Stock Existencia = COALESCE(
    CALCULATE(
        SUM(factStockEPSA[Stock Cantidad]),
        factStockEPSA[Stock Estado] IN {"existencia", "stkaf"}
    ),
    0
)
```

**Objetivo:** Cantidad fisica de articulos disponible en depositos EPSA.
**Fuente:** `factStockEPSA` (vista snapshot — siempre muestra el ultimo corte).
**Estados incluidos:** "existencia" (deposito principal) y "stkaf" (stock asignado a fabricacion).
**Interpretacion:**
- Valor > 0: hay unidades disponibles.
- Valor = 0: sin stock actual. Revisar si hay compras en proceso.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion, Compras x Stock Minimo, Stock Minimo - Deficit, Proveedor - Articulo.

---

### 1.2 Stock Compras

```dax
Stock Compras = COALESCE(SUM(factComprasEnProceso[CompraEP Cantidad]), 0)
```

**Objetivo:** Cantidad total en ordenes de compra activas (solicitudes + OC + carpetas de importacion).
**Fuente:** `factComprasEnProceso` (incluye tipos: Solicitud, Orden de Compra, Carpeta Import).
**Interpretacion:**
- Valor > 0: hay mercaderia en camino.
- Valor = 0: no hay pedidos pendientes de recepcion.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion, Proveedor - Articulo.

---

### 1.3 Stock Minimo

```dax
Stock Minimo = SUM(dimArticulo[Articulo Stock Minimo])
```

**Objetivo:** Stock minimo configurado en el ERP (Nodum) para el articulo.
**Fuente:** `dimArticulo[Articulo Stock Minimo]` — dato maestro del ERP.
**Interpretacion:**
- Es el umbral por debajo del cual se considera que el stock es insuficiente.
- Se configura por articulo en el ERP. Algunos articulos pueden tener SM = 0 (no configurado).
**Paginas que la usan:** Stock Minimo Vs Lead Time, Compras x Stock Minimo, Stock Minimo - Deficit, Suficiencia Stock Produccion.

---

### 1.4 Stock Proyectado

```dax
Stock Proyectado = COALESCE([Stock Existencia], 0) + COALESCE([Stock Compras], 0)
```

**Objetivo:** Estimacion del stock futuro considerando existencias + compras en proceso.
**Formula:** Stock Existencia + Stock Compras.
**Interpretacion:**
- Mejor estimador de disponibilidad futura cercana.
- No descuenta consumo planificado ni demanda pendiente (para eso usar "Stock Util").
**Paginas que la usan:** Stock Minimo Vs Lead Time, Proveedor - Articulo, Direccion - Compras.

---

### 1.5 Gap Stock

```dax
Gap Stock = [Stock Existencia] - [Stock Minimo]
```

**Objetivo:** Diferencia entre el stock actual y el minimo configurado.
**Interpretacion:**
- Negativo: stock por debajo del minimo (riesgo).
- Positivo: stock por encima del minimo.
- Cero: stock exactamente en el minimo.
**Paginas que la usan:** Stock Minimo - Deficit (ordenamiento), alertas visuales.

---

### 1.6 Stock Debajo Minimo

```dax
Stock Debajo Minimo = IF([Gap Stock] < 0, "CRITICO", "OK")
```

**Objetivo:** Flag de alerta binario para identificar articulos por debajo del stock minimo.
**Interpretacion:**
- "CRITICO": el stock actual esta por debajo del minimo configurado.
- "OK": el stock actual es suficiente respecto al minimo.
**Paginas que la usan:** Stock Minimo - Deficit, Compras x Stock Minimo (formato condicional).

---

### 1.7 Stock Util E+C-CP-CD

```dax
Stock Util E+C-CP-CD = [Stock Existencia] + [Stock Compras] - [Consumo Planificado Cantidad] - [Cantidad Requerida por Demanda Pendiente SIN Planificar] - [Stock Minimo]
```

**Objetivo:** Stock neto disponible despues de descontar todos los compromisos conocidos y el colchon de seguridad (stock minimo).
**Formula:** E + C - CP - CD - SM
**Componentes:**
- E = Existencia
- C = Compras en proceso
- CP = Consumo Planificado (ordenes de produccion)
- CD = Cantidad Demandada Pendiente (pedidos sin planificar)
- SM = Stock Minimo
**Interpretacion:**
- Positivo: hay stock util disponible despues de cubrir compromisos y minimo.
- Negativo: deficit — no alcanza para cubrir compromisos + minimo.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion.

---

## 2. Medidas de Consumo (Medidas_Consumo)

### 2.1 Consumo Cantidad

```dax
Consumo Cantidad = SUM(factConsumoHistoria[Consumo Cantidad])
```

**Objetivo:** Suma total de movimientos de consumo (incluye salidas y entradas).
**Fuente:** `factConsumoHistoria` — ultimos 5 anos de movimientos de stock.
**Nota:** Los valores negativos representan salidas (consumo real) y positivos representan entradas/devoluciones.

---

### 2.2 Consumo Cantidad Absoluta

```dax
Consumo Cantidad Absoluta = SUMX(factConsumoHistoria, ABS(factConsumoHistoria[Consumo Cantidad]))
```

**Objetivo:** Suma de valores absolutos de todos los movimientos (sin distinguir signo).
**Uso:** Analisis de volumen total de movimiento del articulo.

---

### 2.3 Sumatoria Movs Consumo Sin Recepciones

```dax
Sumatoria Movs Consumo Sin Recepciones = 
ABS(
    CALCULATE(
        SUM(factConsumoHistoria[Consumo Cantidad]),
        factConsumoHistoria[Consumo Documento] <> "recstktr"
    )
) + 0
```

**Objetivo:** Consumo neto excluyendo recepciones de stock (documento "recstktr").
**Logica:** Las recepciones no son consumo — son entradas. Se filtran para obtener solo las salidas.
**Interpretacion:** Representa el consumo real del articulo (solo salidas de almacen).
**Dependencias:** Ninguna medida previa.

---

### 2.4 Meses con Consumo

```dax
Meses con Consumo = 
COUNTX(
    VALUES(Calendario[Ano Mes]),
    IF(
        CALCULATE(
            [Sumatoria Movs Consumo Sin Recepciones],
            ALLEXCEPT(Calendario, Calendario[Ano Mes])
        ) <> 0,
        1,
        BLANK()
    )
)
```

**Objetivo:** Cantidad de meses distintos donde hubo consumo efectivo (distinto de cero).
**Logica:** Excluye meses sin movimiento del denominador del promedio.
**Interpretacion:**
- Si un articulo tiene consumo en 8 de los ultimos 12 meses, esta medida = 8.
- Los meses sin consumo no penalizan el promedio.
**Dependencias:** `Sumatoria Movs Consumo Sin Recepciones`.

---

### 2.5 Consumo Promedio por Mes Activo

```dax
Consumo Promedio por Mes Activo = 
COALESCE(
    DIVIDE(
        [Sumatoria Movs Consumo Sin Recepciones],
        [Meses con Consumo]
    ),
    0
)
```

**Objetivo:** Promedio mensual de consumo considerando solo meses con movimiento.
**Formula:** Sumatoria de consumo (sin recepciones) / Meses con consumo activo.
**Interpretacion:**
- Es la medida principal de velocidad de consumo.
- "Mes activo" = mes con al menos un movimiento de consumo.
- Se usa como base para calcular cobertura y cantidades a pedir.
**Dependencias:** `Sumatoria Movs Consumo Sin Recepciones`, `Meses con Consumo`.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion, Proveedor - Articulo, Direccion - Compras.

---

### 2.6 Consumos

```dax
Consumos = COUNTROWS(factConsumoHistoria)
```

**Objetivo:** Cantidad total de transacciones de consumo (registros, no unidades).

---

### 2.7 Consumo Medio por Articulo

```dax
Consumo Medio por Articulo = DIVIDE([Consumo Cantidad], [Consumos])
```

**Objetivo:** Promedio de cantidad por transaccion de consumo.

---

### 2.8 Promedio Consumo por Movimiento

```dax
Promedio Consumo por Movimiento = DIVIDE(ABS([Sumatoria Movs Consumo Sin Recepciones]), [Consumos])
```

**Objetivo:** Promedio de cantidad absoluta por transaccion (excluye recepciones).

---

### 2.9 Consumo Mensual Promedio

```dax
Consumo Mensual Promedio = 
AVERAGEX(
    VALUES(Calendario[Fiscal Month]),
    [Consumo Cantidad]
)
```

**Objetivo:** Promedio de consumo por mes fiscal (incluye meses sin movimiento como cero).
**Diferencia con 2.5:** Esta incluye meses sin movimiento (0), por lo que el resultado es menor. Usar "Consumo Promedio por Mes Activo" para decisiones de compra.

---

### 2.10 Promedio Anual Consumo

```dax
Promedio Anual Consumo = 
AVERAGEX(
    VALUES(Calendario[Ano Fiscal]),
    [Consumo Cantidad Absoluta]
)
```

**Objetivo:** Promedio anual de consumo absoluto por ano fiscal.

---

### 2.11 A Pedir Sugerido

```dax
A Pedir Sugerido = 
VAR ConsumoMensual = [Consumo Promedio por Mes Activo]
VAR LeadTimeMeses = DIVIDE([Lead Time Promedio Dias], 30, 0)
VAR MesesSeguridad = 1
VAR Necesidad = ConsumoMensual * (LeadTimeMeses + MesesSeguridad)
VAR StockNeto = [Stock Proyectado] - [Consumo Planificado Cantidad] - [Cantidad Requerida por Demanda Pendiente SIN Planificar]
RETURN
    MAX(0, Necesidad - StockNeto)
```

**Objetivo:** Cantidad sugerida a ordenar para cubrir el lead time + 1 mes de seguridad.
**Formula:**
```
A Pedir = MAX(0, Necesidad - StockNeto)
Donde:
  Necesidad = Consumo Mensual x (LT meses + 1 mes seguridad)
  StockNeto = Stock Proyectado - Consumo Planificado - Demanda Pendiente
```
**Interpretacion:**
- Valor > 0: cantidad sugerida para cubrir lead time con margen.
- Valor = 0: stock suficiente, no se requiere pedido.
**Ajustes manuales a considerar:**
- MOQ (minimo de compra del proveedor)
- Presentacion (cajas, pallets, bobinas)
- Consolidacion con otros articulos del proveedor
- Oportunidades de flete compartido
**Dependencias:** `Consumo Promedio por Mes Activo`, `Lead Time Promedio Dias`, `Stock Proyectado`, `Consumo Planificado Cantidad`, `Cantidad Requerida por Demanda Pendiente`.
**Paginas que la usan:** Stock Minimo Vs Lead Time.

---

### 2.12 A Pedir Txt

```dax
A Pedir Txt = 
"AP = {E}e + {SP}sp - ({CP}cp + {CDP}cdp) - {SM}sm"
```

**Objetivo:** Representacion legible de la formula de "A Pedir" para tooltips y documentacion.
**Nota:** Muestra los operandos con sus valores actuales para facilitar la interpretacion.

---

### 2.13 _RangoFechas_Debug

Medida auxiliar de debugging. No se usa en produccion.

---

## 3. Medidas de Compras y Cobertura (Medidas_Compras)

### 3.1 Cobertura Meses sobre Existencia

```dax
Cobertura Meses sobre Existencia = 
COALESCE(
    DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo]),
    0
)
```

**Objetivo:** Cuantos meses dura el stock actual al ritmo de consumo promedio.
**Formula:** Stock Existencia / Consumo Promedio por Mes Activo.
**Interpretacion:**
- Valor > LT + 1: stock suficiente (OK).
- Valor entre LT y LT + 1: atencion — margen insuficiente.
- Valor < LT: stock insuficiente (PEDIR).
- Valor = 0: sin stock o sin consumo historico.
**Dependencias:** `Stock Existencia`, `Consumo Promedio por Mes Activo`.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion, Proveedor - Articulo, Direccion - Compras.

---

### 3.2 Cobertura Meses sobre Existencia + Proyectado

```dax
Cobertura Meses sobre Existencia + Proyectado = 
COALESCE(
    DIVIDE([Stock Proyectado], [Consumo Promedio por Mes Activo]),
    0
)
```

**Objetivo:** Cobertura incluyendo compras en proceso.
**Formula:** Stock Proyectado / Consumo Promedio por Mes Activo.
**Diferencia con 3.1:** Incluye mercaderia en camino. Usar como referencia secundaria.
**Paginas que la usan:** Stock Minimo Vs Lead Time (columna secundaria).

---

### 3.3 Meses Cobertura del Stock Minimo

```dax
Meses Cobertura del Stock Minimo = DIVIDE([Stock Minimo], [Consumo Promedio por Mes Activo])
```

**Objetivo:** Cuantos meses de consumo cubre el stock minimo configurado.
**Interpretacion:**
- Si es menor que el Lead Time en meses: el SM no cubre el LT (riesgo estructural).
- Si es mayor que LT + 1: el SM esta bien configurado.
**Paginas que la usan:** Stock Minimo Vs Lead Time.

---

### 3.4 Cobertura sobre Stock Minimo vs Lead Time

```dax
Cobertura sobre Stock Minimo vs Lead Time = 
[Meses Cobertura del Stock Minimo] - DIVIDE([Lead Time Promedio Dias], 30, 0)
```

**Objetivo:** Diferencia entre los meses que cubre el SM y el LT del proveedor.
**Interpretacion:**
- Positivo: el SM cubre el LT con margen.
- Negativo: el SM es insuficiente para el LT del proveedor.
**Paginas que la usan:** Stock Minimo Vs Lead Time.

---

### 3.5 Diferencia Cobertura Lead Time

```dax
Diferencia Cobertura Lead Time = 
[Cobertura Meses sobre Existencia] - DIVIDE([Lead Time Promedio Dias], 30, 0)
```

**Objetivo:** Cuanto excede o falta la cobertura actual respecto al lead time.
**Interpretacion:**
- Negativo (rojo): falta stock para cubrir el LT.
- Positivo (verde): sobra stock respecto al LT.
**Paginas que la usan:** Stock Minimo Vs Lead Time (formato condicional).

---

### 3.6 Alerta Cobertura

```dax
Alerta Cobertura = 
VAR Cobertura = [Cobertura Meses sobre Existencia]
VAR LT_Meses = DIVIDE([Lead Time Promedio Dias], 30, 0)
RETURN
SWITCH(TRUE(),
    Cobertura < LT_Meses, "PEDIR",
    Cobertura < LT_Meses + 1, "Atencion",
    "OK"
)
```

**Objetivo:** Semaforo de alerta para priorizar acciones de compra.
**Niveles:**
| Nivel | Condicion | Accion |
|-------|-----------|--------|
| PEDIR | Cobertura < LT | Ordenar inmediatamente |
| Atencion | LT <= Cobertura < LT + 1 | Planificar compra |
| OK | Cobertura >= LT + 1 | Sin accion requerida |

**Dependencias:** `Cobertura Meses sobre Existencia`, `Lead Time Promedio Dias`.
**Paginas que la usan:** Stock Minimo Vs Lead Time (formato condicional rojo/amarillo/verde).

---

### 3.7 Lead Time Promedio Dias

```dax
Lead Time Promedio Dias = 
AVERAGEX(
    factRecepcionesHistoria,
    DATEDIFF(
        factRecepcionesHistoria[Compra Fecha Inicio Proceso Con Proveedor],
        factRecepcionesHistoria[RecepcionFecha],
        DAY
    )
)
```

**Objetivo:** Dias promedio entre la emision de la OC al proveedor y la recepcion de la mercaderia.
**Fuente:** `factRecepcionesHistoria` (historial completo desde 2009).
**Nota:** Desde Issue #27, usa "Con Proveedor" (MIN(OC Fecha, Compra Fecha)), NO incluye tiempo de solicitud interna.
**Interpretacion:**
- Mide la demora real del proveedor.
- Para Produccion (que necesita incluir el tiempo interno), usar `Lead Time Proceso Interno Dias`.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Proveedor - Articulo, Direccion - Compras.

---

### 3.8 Lead Time Proceso Interno Dias

```dax
Lead Time Proceso Interno Dias = 
AVERAGEX(
    factRecepcionesHistoria,
    DATEDIFF(
        factRecepcionesHistoria[Compra Fecha Inicio Proceso Interno Desde Solicitud],
        factRecepcionesHistoria[RecepcionFecha],
        DAY
    )
)
```

**Objetivo:** Dias promedio desde la solicitud interna hasta la recepcion.
**Diferencia con 3.7:** Incluye el tiempo del proceso interno (generacion de solicitud antes de emitir OC).
**Uso:** Para Produccion — representa el tiempo total desde que se detecta la necesidad hasta que llega la mercaderia.

---

### 3.9 Lead Time Meses

```dax
Lead Time Meses = DIVIDE([Lead Time Promedio Dias], 30, 0)
```

**Objetivo:** Lead time expresado en meses (para comparacion con cobertura).

---

### 3.10 Cantidad Recepciones

```dax
Cantidad Recepciones = COUNTROWS(factRecepcionesHistoria)
```

**Objetivo:** Cantidad total de recepciones registradas en el historial.

---

### 3.11 Ultima Recepcion Fecha

```dax
Ultima Recepcion Fecha = MAX(factRecepcionesHistoria[RecepcionFecha])
```

**Objetivo:** Fecha de la ultima recepcion del articulo.
**Interpretacion:** Si es muy antigua, puede indicar que el articulo no se ha comprado recientemente.
**Paginas que la usan:** Compras x Stock Minimo, Proveedor - Articulo.

---

### 3.12 Dias Transcurridos En Proceso Promedio

```dax
Dias Transcurridos En Proceso Promedio = 
AVERAGEX(
    factComprasEnProceso,
    DATEDIFF(
        factComprasEnProceso[Compra Fecha Inicio Proceso Con Proveedor],
        TODAY(),
        DAY
    )
)
```

**Objetivo:** Dias promedio que llevan las compras en proceso actuales desde la OC.

---

### 3.13 Dias Hasta Fecha Entrega Promedio

```dax
Dias Hasta Fecha Entrega Promedio = 
AVERAGEX(
    factComprasEnProceso,
    DATEDIFF(
        TODAY(),
        factComprasEnProceso[CompraEP Ultima Fecha Entrega],
        DAY
    )
)
```

**Objetivo:** Dias restantes promedio hasta la fecha de entrega esperada.
**Interpretacion:**
- Positivo: la entrega es futura.
- Negativo: la fecha de entrega ya paso (retraso).

---

### 3.14 Compras En Proceso Vencidas

```dax
Compras En Proceso Vencidas = 
COUNTROWS(
    FILTER(
        factComprasEnProceso,
        factComprasEnProceso[CompraEP Ultima Fecha Entrega] < TODAY()
    )
)
```

**Objetivo:** Cantidad de ordenes de compra cuya fecha de entrega ya paso.
**Interpretacion:** Indica retrasos del proveedor o problemas de seguimiento.

---

## 4. Medidas de Consumo Planificado (Medidas_Consumo_Planificado)

### 4.1 Consumo Planificado Cantidad

```dax
Consumo Planificado Cantidad = SUMX(factConsumoPlanificado, ABS(factConsumoPlanificado[Consumo Planificado Cantidad]))
```

**Objetivo:** Cantidad total comprometida en ordenes de produccion planificadas pero aun no ejecutadas.
**Fuente:** `factConsumoPlanificado` — trabajo planificado en EPSA que aun no ha sido programado.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion.

---

## 5. Medidas de Demanda Pendiente (Medidas_DemandaPendiente)

### 5.1 Cantidad Requerida por Demanda Pendiente SIN Planificar

```dax
Cantidad Requerida por Demanda Pendiente SIN Planificar = 
SUMX(factDemandaPendientePlanificacion, ABS(factDemandaPendientePlanificacion[Demanda Pendiente Componente Cantidad Requerida]))
```

**Objetivo:** Cantidad de componentes requeridos por pedidos pendientes que aun no tienen orden de produccion.
**Fuente:** `factDemandaPendientePlanificacion` — descomposicion de demanda de pedidos sin planificar.
**Paginas que la usan:** Stock Minimo Vs Lead Time, Suficiencia Stock Produccion.

---

## 6. Medidas Futuras (Diferidas — Pendiente diseño en Nodum)

Las siguientes medidas se implementaran una vez que las estructuras de datos necesarias existan en Nodum (ERP oficial) o en tablas de mantenimiento oficiales:

| # | Medida | Dependencia | Estado |
|---|--------|-------------|--------|
| 1 | Comentarios Activos Concatenados | Tabla de comentarios en Nodum (formulario) | Pendiente diseño ERP |
| 2 | Cantidad Comentarios Activos | Tabla de comentarios en Nodum | Pendiente diseño ERP |
| 3 | Dias Restantes Llegada | CRM de carpeta/importaciones en Nodum | Pendiente diseño ERP |
| 4 | Llegadas En Transito | CRM de carpeta/importaciones en Nodum | Pendiente diseño ERP |
| 5 | Cumple MOQ | Campo Lote Minimo Compra completo en ERP | Pendiente auditoria ERP |
| 6 | A Pedir con MOQ | Cumple MOQ | Pendiente |
| 7 | Desvio Llegada Promedio Dias | Historico de llegadas en CRM Nodum | Pendiente diseño ERP |

> **Decision:** No se toman archivos Excel (Roberta, Rosana) como fuente directa del modelo. Los datos ingresaran al modelo solo desde Nodum o estructuras oficiales de mantenimiento.
> Ver analisis en: `docs/importaciones_analisis.md`

---

## 7. Resumen de Dependencias

```
A Pedir Sugerido
├── Consumo Promedio por Mes Activo
│   ├── Sumatoria Movs Consumo Sin Recepciones
│   │   └── factConsumoHistoria
│   └── Meses con Consumo
│       └── Calendario[Ano Mes]
├── Lead Time Promedio Dias
│   └── factRecepcionesHistoria
├── Stock Proyectado
│   ├── Stock Existencia
│   │   └── factStockEPSA
│   └── Stock Compras
│       └── factComprasEnProceso
├── Consumo Planificado Cantidad
│   └── factConsumoPlanificado
└── Cantidad Requerida por Demanda Pendiente
    └── factDemandaPendientePlanificacion
```

---

## 8. Columnas Calculadas Relevantes

| Columna | Tabla | Descripcion |
|---------|-------|-------------|
| Compra Fecha Inicio Proceso Con Proveedor | factRecepcionesHistoria | MIN(OC Fecha, Compra Fecha) |
| Compra Fecha Inicio Proceso Interno Desde Solicitud | factRecepcionesHistoria | MIN(SolicitudFecha, OC Fecha, Compra Fecha) |
| ProveedorArticulo | dimArticulo | Proveedor por defecto del articulo (denormalizado) |
| ProveedorPaisNombre | dimArticulo | Pais del proveedor (denormalizado para evitar auto-exist) |
| Articulo Stock Minimo | dimArticulo | Stock minimo configurado en ERP |
| Lote Minimo Compra | dimArticulo | MOQ del articulo (desde ERP) |

---

## 9. Historial de cambios

| Version | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2026-05-18 | Documento inicial con 37 medidas + 4 propuestas |
| 1.1 | 2026-07-14 | Seccion 6 diferida: datos vendran de Nodum, no de Excel |
