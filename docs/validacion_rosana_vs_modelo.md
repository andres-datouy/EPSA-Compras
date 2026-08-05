# Validacion Cruzada: Excel de Rosana vs Modelo Semantico SSAS

## Version: 2.0
## Fecha: 2026-08-05 (actualizacion a realidad actual pre-sesion con Rosana; ver §8)
## Historial: 1.0 2026-05-13 | 1.1 2026-05-18 (columna Comentarios en dimArticulo) | 2.0 2026-08-05 (inventario as-is de pagina y medidas + auditorias MOQ/ETAFPA)
## Objetivo: Certificar que el modelo SSAS representa todos los datos que Rosana necesita para decisiones de compra

---

## 1. Estructura del Excel "Pedidos a exterior" — Hoja "actual"

**Archivo:** `docs/excel/Pedidos a exterior 2026.04.09.xlsx`
**Hoja principal:** `actual` (329 filas x 26 columnas utiles A-Z)
**Responsable:** Rosana (Administracion de Produccion)
**Uso:** Control de stock minimo, cobertura y decisiones de compra al exterior

---

## 2. Mapeo Columna por Columna

### 2.1 Datos Maestros (A-F)

| Col | Header Excel | Contenido | Origen del dato | Equivalente SSAS | Estado |
|-----|---|---|---|---|---|
| A | Proveedor | Nombre del proveedor | Manual (Rosana) | `dimProveedor[Proveedor Nombre]` | ✅ Representado |
| B | Codigo | Codigo de articulo (12 digitos) | ERP (Nodum) | `dimArticulo[Articulo Codigo]` | ✅ Representado |
| C | Descripcion | Nombre del articulo | ERP (Nodum) | `dimArticulo[Articulo Nombre]` | ✅ Representado |
| D | comentarios | Notas libres por proveedor/articulo | **Manual (Rosana)** | `dimArticulo[Comentarios]` (texto libre desde vista ERP) | ⚠️ **Parcial** (columna existe; formulario estructurado en Nodum pendiente) |
| E | (sin header) | Unidad de medida ("gramos", "Unitario") | ERP (Nodum) | `dimArticulo[Unidad Stock]` | ✅ Representado |
| F | Presentacion y minimos de compra | MOQ / presentacion ("Unitario", "Kg") | **Manual (Rosana)** | `dimArticulo[Lote Minimo Compra]` | ⚠️ Parcial (campo ERP existe pero puede estar incompleto) |

### 2.2 Lead Time (G)

| Col | Header Excel | Contenido | Origen del dato | Equivalente SSAS | Estado |
|-----|---|---|---|---|---|
| G | lead time | Meses de lead time (valor entero: 4, 5, 6) | **Manual (Rosana)** | `[Lead Time Meses]` = `[Lead Time Promedio Dias] / 30` | ⚠️ **Fuente diferente** |

**Diferencia clave:**
- **Rosana:** Valor fijo manual basado en experiencia (ej: "5 meses para Borla")
- **Modelo:** Calculado dinamicamente del historial de recepciones (OC Fecha → Recepcion Fecha)
- **Implicancia:** El LT del modelo puede diferir del LT manual de Rosana. El modelo es mas preciso (basado en datos reales) pero puede no reflejar cambios recientes del proveedor.

### 2.3 Consumo Historico (H-N)

| Col | Header Excel | Contenido | Origen del dato | Equivalente SSAS | Estado |
|-----|---|---|---|---|---|
| H | consumo mensual 2019 | Promedio mensual de consumo 2019 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2019 | ✅ Derivable |
| I | consumo mensual 2020 | Promedio mensual de consumo 2020 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2020 | ✅ Derivable |
| J | consumo mensual 2021 | Promedio mensual de consumo 2021 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2021 | ✅ Derivable |
| K | consumo mensual 2022 | Promedio mensual de consumo 2022 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2022 | ✅ Derivable |
| L | Consumo mensual 2023 | Promedio mensual de consumo 2023 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2023 | ✅ Derivable |
| M | consumo mensual 2024 | Promedio mensual de consumo 2024 | Derivado de ERP | `factConsumoHistoria` filtrado por ano 2024 | ✅ Derivable |
| N | Consumo | **Consumo mensual usado para calculos** | **Mixto: manual o formula** | `[Consumo Promedio por Mes Activo]` | ⚠️ **Metodologia diferente** |

**Diferencia clave en columna N:**
- **Rosana:** Algunos valores son HARDCODED (ej: 600, 2900, 27) — override manual basado en criterio. Otros son formula `=AVERAGE(J:L)` (promedio 2021-2023).
- **Modelo:** `[Consumo Promedio por Mes Activo]` = Sumatoria consumo / Meses con consumo activo (desde 2020, cutoff fijo)
- **Implicancia:** El modelo es consistente y auditable. Los overrides manuales de Rosana responden a conocimiento contextual (ej: "este articulo va a crecer", "este se discontinuo").

### 2.4 Stock y Compras (Q-T)

| Col | Header Excel | Contenido | Formula Excel | Equivalente SSAS | Estado |
|-----|---|---|---|---|---|
| Q | Stock | Existencia EPSA | VLOOKUP a "Control Stock Minimo" col 3 | `[Stock Existencia]` (estados: existencia + stkaf) | ✅ Representado |
| R | stock ETAFPA | Existencia en planta ETAFPA | VLOOKUP a "Control Stock Minimo" col 4 | — | ❌ **NO REPRESENTADO** |
| S | En Camino | Compras en proceso (solicitudes + OC + carpetas) | VLOOKUP a "Control Stock Minimo" col 9 | `[Stock Compras]` (factComprasEnProceso) | ✅ Representado |
| T | Actualizado | Fecha de ultima actualizacion del dato | Manual (fecha) | `factStockEPSA[Stock Fecha_Corte]` | ✅ Representado |

**Nota sobre columna R (ETAFPA):**
- ETAFPA es otra planta del grupo EPSA.
- El stock de ETAFPA NO esta en el modelo actual (factStockEPSA solo incluye depositos EPSA).
- **Pregunta para validacion:** ¿Se necesita el stock de ETAFPA para decisiones de compra de insumos al exterior? Si si, requiere ampliar la fuente de factStockEPSA.

### 2.5 Calculos de Cobertura (U-Z)

| Col | Header Excel | Formula Excel | Equivalente SSAS | Estado |
|-----|---|---|---|---|
| U | Meses cobertura | `=SUM(Q:S)/N` = (Stock + ETAFPA + EnCamino) / Consumo | `[Cobertura Meses sobre Existencia + Proyectado]` = Stock Proyectado / Consumo Promedio | ⚠️ **Diferencia: Rosana incluye ETAFPA** |
| V | aviso | `=IF(U<=(4+G),"PEDIR","")` | `[Alerta Cobertura]` (PEDIR/Atencion/OK) | ⚠️ **Logica diferente** |
| W | Comentarios cobertura | Texto libre | `dimArticulo[Comentarios]` | ⚠️ **Parcial** (mismo estado que D) |
| X | A pedir | **Manual** (Rosana decide la cantidad) | `[A Pedir Sugerido]` (calculado) | ⚠️ **Manual vs Calculado** |
| Y | Cobertura | `=(Q+S+X)/N` = (Stock + EnCamino + APedir) / Consumo | — | ❌ **NO REPRESENTADO** |
| Z | cobertura a la llegada | `=Y-G+U` | — | ❌ **NO REPRESENTADO** |

**Diferencias clave en alertas (V):**
- **Rosana:** `PEDIR` si Cobertura <= Lead Time + **4 meses** (buffer fijo de 4 meses)
- **Modelo:** `PEDIR` si Cobertura < Lead Time (sin buffer); `Atencion` si < LT + 1
- **Implicancia:** Rosana es mas conservadora (4 meses de margen). El modelo usa 1 mes de seguridad.

**Diferencia en "A Pedir" (X):**
- **Rosana:** Decide manualmente cuanto pedir (considera MOQ, presentacion, consolidacion de flete, presupuesto)
- **Modelo:** `[A Pedir Sugerido]` = MAX(0, Necesidad - StockNeto) — sugerencia automatica
- **Implicancia:** El modelo SUGIERE, Rosana DECIDE. El reporte debe mostrar la sugerencia y permitir ver el contexto para la decision.

---

## 3. Resumen de Gaps

### 3.1 Gaps Criticos (datos que NO estan en el modelo ni en el ERP)

| # | Dato | Columna Excel | Impacto | Solucion Propuesta |
|---|------|---------------|---------|-------------------|
| 1 | **Comentarios de proveedor/articulo** | D, W | Rosana registra avisos de discontinuacion, cambios, problemas de calidad | ⚠️ **PARCIALMENTE RESUELTO (2026-05):** columna `Comentarios` agregada a `vw_Compras_DimArticuloEPSA` → `stg_dimArticulo` → `dimArticulo[Comentarios]`. Pendiente: formulario estructurado en Nodum (cod_proveedor, cod_articulo, comentario, fecha, es_vigente, prioridad) |
| 2 | **Stock ETAFPA** | R | Stock en otra planta del grupo, usado en cobertura | ❌ **CERRADO (2026-08):** fuera de alcance — deposito discontinuado (alcance aprobado issue #1, decision ratificada). No se modela ni se pregunta en sesion |
| 3 | **Cobertura proyectada post-pedido** | Y | "Si pido X unidades, cuantos meses de cobertura tendre?" | Medida DAX nueva: `[Cobertura Post Pedido]` (requiere parametro "A Pedir") — **sigue pendiente** |
| 4 | **Cobertura a la llegada** | Z | "Cuando llegue la mercaderia, cuanta cobertura tendre?" | Medida DAX nueva: `[Cobertura a la Llegada]` (requiere ETA del CRM Nodum) — **sigue pendiente** |
| 5 | **MOQ / presentacion de compra** | F | Auditoria 2026-08-05: `lote_min_cpra` viene en 0 para el 100% de los 3.371 articulos (la vista EPSA_BI no lo informa; el ETL si lo carga). El unico MOQ existente vive en el Excel de Rosana | Fuente suplementaria: tabla staging con valores del Excel (o formulario Nodum v2). Medidas `[Cumple MOQ]` / `[A Pedir con MOQ]` pendientes de implementacion (ADR aprobado) |

### 3.2 Gaps de Metodologia (datos que SI estan pero se calculan diferente)

| # | Dato | Excel | Modelo | Diferencia | Accion |
|---|------|-------|--------|-----------|--------|
| 5 | Lead Time | Manual (meses fijos) | Calculado de recepciones (dias/30) | Fuente diferente | Documentar ambos; el modelo es auditable, el manual es experiencial |
| 6 | Consumo mensual | Mixto (manual/formula) | Consumo Promedio por Mes Activo | Rosana hace overrides | Documentar; el modelo es consistente, los overrides son contexto |
| 7 | Alerta "PEDIR" | Cobertura <= LT + 4 | Cobertura < LT (PEDIR), < LT+1 (Atencion) | Buffer diferente (4 vs 1 mes) | Validar con Rosana cual buffer es correcto para cada proveedor |
| 8 | A Pedir | Manual (decision humana) | A Pedir Sugerido (formula) | El modelo sugiere, Rosana decide | Correcto: el modelo informa, el humano decide |

### 3.3 Datos Correctamente Representados

| # | Dato | Columna | Medida SSAS |
|---|------|---------|-------------|
| 1 | Codigo articulo | B | dimArticulo[Articulo Codigo] |
| 2 | Descripcion | C | dimArticulo[Articulo Nombre] |
| 3 | Proveedor | A | dimProveedor[Proveedor Nombre] |
| 4 | Unidad de medida | E | dimArticulo[Unidad Stock] |
| 5 | Stock EPSA | Q | [Stock Existencia] |
| 6 | Compras en proceso | S | [Stock Compras] |
| 7 | Consumo historico por ano | H-M | factConsumoHistoria (filtrable por ano) |
| 8 | Fecha de corte | T | factStockEPSA[Stock Fecha_Corte] |
| 9 | Stock minimo | (no visible en Excel pero usado) | [Stock Minimo] |
| 10 | Consumo planificado | (no visible en Excel) | [Consumo Planificado Cantidad] |
| 11 | Demanda pendiente | (no visible en Excel) | [Cantidad Requerida por Demanda Pendiente] |

---

## 4. Flujo de Decision de Compra (Rosana)

### 4.1 Proceso Actual (con Excel)

```
1. Rosana abre "Pedidos a exterior.xlsx" → hoja "actual"
2. Filtra por proveedor o revisa articulos con V="PEDIR"
3. Para cada articulo en alerta:
   a. Revisa U (meses cobertura) vs G (lead time)
   b. Revisa D (comentarios) — ¿hay avisos de discontinuacion?
   c. Revisa F (MOQ/presentacion) — ¿cuanto minimo puedo pedir?
   d. Revisa Q (stock) + S (en camino) — ¿cuanto tengo + cuanto viene?
   e. Decide X (a pedir) — cantidad manual considerando:
      - Cobertura objetivo (U deseada)
      - MOQ del proveedor
      - Consolidacion de flete
      - Presupuesto disponible
   f. Verifica Y (cobertura post-pedido) y Z (cobertura a la llegada)
4. Genera la orden de compra en Nodum
```

### 4.2 Proceso Objetivo (con Power BI + Nodum) — realidad 2026-08

```
1. Rosana abre Power BI → pagina "Programacion Compras Exterior" (PBIX live connection, lanzado con runas /netonly bi_compras)
2. Filtra por Proveedor Preferido / Clase / Articulo / texto en Proveedores, o ve articulos con Alerta="PEDIR"
3. Para cada articulo, en la tabla de decision (24 columnas):
   a. Ve [Alerta Cobertura] (PEDIR/Atencion/OK) y coberturas: sobre Stock Minimo vs LT, sobre Stock Proyectado y sobre Stock Util
   b. Ve dimArticulo[Comentarios] (cargado desde vista ERP) → avisos vigentes
   c. MOQ: HOY NO HAY DATO ERP (lote_min_cpra=0 en 100%) → la restriccion sigue viviendo en su Excel (gap §3.1 #5)
   d. Ve [Stock Existencia] + [Stock Compras] + [Stock Proyectado] + [Stock Util E+C-CP-CD] → disponibilidad neta
   e. Ve [A Pedir Sugerido] → sugerencia del modelo (sin MOQ, sin override de consumo)
   f. Decide cantidad final (puede diferir de la sugerencia)
   g. Auditoria: tablas de detalle con documento Nodum (consumos, recepciones, compras en proceso, OP planificadas, demanda pendiente, stock por deposito)
4. Genera la OC en Nodum
5. (Futuro) Registra comentario si hay novedad del proveedor
```

---

## 5. Medidas DAX del Modelo — Documentacion para Aprobacion

### 5.1 Medidas que Rosana usa directamente

| Medida | Formula simplificada | Que le dice a Rosana | Columna Excel equivalente |
|--------|---------------------|---------------------|--------------------------|
| [Stock Existencia] | SUM(stock donde estado in {existencia, stkaf}) | Cuanto hay en deposito EPSA | Q |
| [Stock Compras] | SUM(compras en proceso) | Cuanto viene en camino | S |
| [Stock Proyectado] | Existencia + Compras | Cuanto tendre pronto | Q + S |
| [Consumo Promedio por Mes Activo] | Consumo total / meses activos | Velocidad de consumo mensual | N (parcial) |
| [Cobertura Meses sobre Existencia] | Stock / Consumo mensual | Cuantos meses dura el stock | U (parcial) |
| [Cobertura Meses sobre Existencia + Proyectado] | Stock Proyectado / Consumo | Cobertura incluyendo lo que viene | U |
| [Lead Time Meses] | Lead Time Dias / 30 | Cuanto tarda el proveedor | G |
| [Alerta Cobertura] | PEDIR / Atencion / OK | Semaforo de accion | V |
| [A Pedir Sugerido] | MAX(0, Necesidad - StockNeto) | Cuanto deberia pedir | X (sugerencia) |
| [Stock Minimo] | SUM(stock minimo ERP) | Umbral configurado en Nodum | (no visible) |

### 5.2 Medidas que el modelo tiene pero Rosana NO usa en Excel

| Medida | Que hace | Por que Rosana no la usa |
|--------|---------|-------------------------|
| [Consumo Planificado Cantidad] | Ordenes de produccion planificadas | Rosana no gestiona produccion |
| [Cantidad Requerida por Demanda Pendiente] | Pedidos de clientes sin planificar | Rosana no ve demanda de clientes |
| [E + C - CP - CD - SM] | Stock neto despues de compromisos | Es un calculo intermedio del modelo |
| [Gap Stock] | Stock - Stock Minimo | Rosana usa cobertura, no gap absoluto |
| [Diferencia Cobertura Lead Time] | Cobertura - LT | Similar a su logica de alerta |

### 5.3 Medidas que Rosana NECESITA y el modelo NO tiene

| Necesidad | Formula Excel | Propuesta de medida DAX | Estado 2026-08 |
|-----------|--------------|------------------------|--------------|
| Cobertura post-pedido | Y = (Q+S+X)/N | `[Cobertura Post Pedido]` = (Stock Proyectado + Parametro APedir) / Consumo | PENDIENTE (prioridad ALTA) |
| Cobertura a la llegada | Z = Y - G + U | `[Cobertura a la Llegada]` = Cobertura + (EnCamino/Consumo) - LT | PENDIENTE (ALTA, depende ETA Nodum) |
| Comentarios concatenados | D (texto libre) | ✅ RESUELTO: columna `dimArticulo[Comentarios]` deployada y visible en la tabla de decision; formulario estructurado Nodum queda como v2 | ✅ |
| Stock ETAFPA | R (VLOOKUP) | ❌ DESCARTADO: deposito discontinuado, fuera de alcance aprobado | CERRADO |
| MOQ / presentacion | F (manual) | `[Cumple MOQ]` + `[A Pedir con MOQ]` sobre fuente suplementaria (ERP viene vacio, ver §3.1 #5) | PENDIENTE (ADR aprobado, sin implementar) |

---

## 6. Preguntas para Validacion con Rosana

1. **Stock ETAFPA:** ~~¿El stock de ETAFPA es relevante...?~~ **CERRADA (2026-08):** deposito discontinuado, fuera de alcance aprobado (issue #1). No se conversa en sesion.

2. **Buffer de alerta:** Tu formula usa `Cobertura <= LT + 4` para disparar "PEDIR". ¿4 meses es el buffer correcto para todos los proveedores, o varia?

3. **Consumo override:** Algunos consumos (columna N) los pusiste manualmente (ej: 600, 2900). ¿Cuando decidis overridear el promedio calculado? ¿Que criterio usas?

4. **A Pedir manual:** ¿Siempre decidis la cantidad manualmente o a veces usas una formula? ¿Que factores consideras ademas de la cobertura? (MOQ, flete, presupuesto, consolidacion)

5. **Comentarios:** ¿Que tipo de informacion registras en "comentarios" (col D) que necesitarias ver en el reporte? (discontinuaciones, cambios de proveedor, problemas de calidad, plazos especiales) — hoy la columna `dimArticulo[Comentarios]` ya muestra los comentarios de la vista ERP; validar si alcanzan.

6. **Cobertura a la llegada:** ¿La columna Z (cobertura a la llegada) la usas para decidir? ¿Que significa exactamente para vos?

7. **Lead Time:** ¿El lead time que pusiste (col G) es el tiempo total desde que pedis hasta que llega, o solo el tiempo del proveedor?

8. **MOQ / presentacion (NUEVA 2026-08):** El ERP no informa lote minimo de compra (auditoria: 0/3.371 articulos). ¿Tus valores de "Presentacion y minimos de compra" (col F) son por articulo o por articulo+proveedor? ¿Quien y donde deberia mantenerse ese dato si lo sacamos de tu Excel?

9. **Stock disponible para el calculo (NUEVA 2026-08):** La sugerencia del modelo descuenta el stock en deposito (`A Pedir Sugerido` = Necesidad - Existencia - Compras). En tu planilla a veces consideras solo lo que viene en camino. ¿Cuando el stock en deposito NO cuenta para tu decision (mercaderia reservada, calidad, ubicacion)?

---

## 7. Proximos Pasos

| # | Accion | Responsable | Estado 2026-08 |
|---|--------|-------------|----------------|
| 1 | Validar este documento con Rosana (sesion §6 + walkthrough) | Andres + Rosana | EN PREPARACION (kit: `docs/sesion_validacion_rosana_2026-08.md`) |
| 2 | ~~Verificar si stock ETAFPA existe en EPSA_BI~~ | — | CERRADO: fuera de alcance (deposito discontinuado) |
| 3 | Diseñar formulario de comentarios en Nodum (v2) | Andres + Rosana | Pendiente (v1 con columna ERP ya operativa) |
| 4 | Implementar medidas [Cobertura Post Pedido] y [Cobertura a la Llegada] | Andres | Pendiente de validar formulas en sesion |
| 5 | Ajustar buffer de alerta (4 vs 1 mes) segun validacion | Andres | Pendiente (pregunta 2) |
| 6 | ~~Auditar campo Lote Minimo Compra en ERP~~ | Andres | ✅ HECHO 2026-08-05: viene vacio (0/3.371) → requiere fuente suplementaria (pregunta 8) |
| 7 | Implementar [Cumple MOQ] / [A Pedir con MOQ] sobre fuente suplementaria | Andres | Pendiente (ADR aprobado) |

---

## 8. Realidad Actual del Reporte — Inventario as-is (2026-08-05)

### 8.1 Pagina "Programacion Compras Exterior" (id `e244718f235796748fbf`)

**Slicers (5):** Calendario.Fecha (rango) | dimArticulo.Articulo (multiseleccion con busqueda) | dimArticulo.Clase | dimArticulo.Proveedor Articulo Full ("Proveedor Preferido") | textSlicer dimArticulo.Proveedores.

**Tabla de decision (24 columnas):** Articulo Codigo/Nombre | Alerta Cobertura→"Alerta" | Articulo Stock Minimo→"Stock Minimo" | Consumo Promedio por Mes Activo | Meses Cobertura del Stock Minimo | Cobertura sobre Stock Minimo vs Lead Time | Stock Existencia→"Existencia" | Stock Compras | Stock Proyectado | Stock Util E+C-CP-CD | Cobertura Meses sobre Stock Proyectado | Cobertura Meses sobre Stock Util | Consumo Planificado Cantidad | Cantidad Requerida por Demanda Pendiente→"...SIN Planificar" | A Pedir Sugerido | Meses con Consumo | Lead Time Promedio Dias | Lead Time Meses | Tipo Articulo Codigo | Proveedor Articulo Full→"Proveedor Preferido" | Proveedores | Comentarios.

**Tabla de control ancha:** codigo/nombre + Existencia, Stock Minimo, Stock Compras, Consumo, Consumo Planificado, Demanda Pendiente, Meses con Consumo, Consumo Promedio, Promedio por Movimiento, Cobertura Meses, Lead Time Dias, Proveedores.

**Detalle de auditoria (7):** consumos (documento Nodum) | recepciones (OC, proveedor, USD) | compras en proceso | consumo planificado (OP) | demanda pendiente (composicion) | stock por deposito | stock por estado.

**Card debug:** RangoFechas_Debug.

### 8.2 Medidas del modelo (68 en 4 tablas de medidas)

- **Medidas_Stock (22):** Stock Existencia/Compras/Proyectado/Minimo, Stock Util E+C-CP-CD, E+C-CP-CD-SM, Gap Stock, coberturas en dias, rotacion, stock muerto, valores USD, etc.
- **Medidas_Consumo (22):** Consumo Promedio por Mes Activo, Meses con Consumo, A Pedir Sugerido, A Pedir Txt, Cobertura Meses sobre Stock Proyectado/Util, Alerta Cobertura, Lead Time Meses, consumos varios, debug.
- **Medidas_Compras (22):** Cobertura Meses sobre Existencia, Meses Cobertura del Stock Minimo, Cobertura sobre Stock Minimo vs Lead Time, Lead Time Promedio Dias, lead times de proceso, OTD, gastos USD, etc.
- **Medidas_Consumo_Planificado / Medidas_DemandaPendiente (1 c/u):** Consumo Planificado Cantidad | Cantidad Requerida por Demanda Pendiente.

**NO existen aun:** [Cobertura Post Pedido], [Cobertura a la Llegada], [Cumple MOQ], [A Pedir con MOQ], [Stock ETAFPA] (descartada).

### 8.3 Auditorias tecnicas 2026-08-05

| Auditoria | Resultado |
|-----------|-----------|
| MOQ en ERP (`stg_dimArticulo.lote_min_cpra`) | 0/3.371 articulos con valor >0 (tambien 0/395 del universo exterior con StockMin>0). La vista `vw_Compras_DimArticuloEPSA` no lo informa; el ETL si lo carga. Script: `scripts/check/check_moq_coverage.ps1` |
| ETAFPA | Fuera de alcance aprobado (deposito discontinuado) |
| Seguridad de acceso | ✅ Rol SSAS `Lectura_Compras` + cuenta `bi_compras` creados (resuelve el "Pendiente rol Read" de v1.1); PBIX live connection publicado y validado bajo bi_compras (2026-08-05) |
