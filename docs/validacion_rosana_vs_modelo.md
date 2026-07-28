# Validacion Cruzada: Excel de Rosana vs Modelo Semantico SSAS

## Version: 1.1
## Fecha: 2026-05-18 (act. columna Comentarios en dimArticulo)
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
| 2 | **Stock ETAFPA** | R | Stock en otra planta del grupo, usado en cobertura | Verificar si EPSA_BI tiene vista con stock ETAFPA; si no, crear vista o ampliar factStockEPSA |
| 3 | **Cobertura proyectada post-pedido** | Y | "Si pido X unidades, cuantos meses de cobertura tendre?" | Medida DAX nueva: `[Cobertura Post Pedido]` (requiere parametro "A Pedir") |
| 4 | **Cobertura a la llegada** | Z | "Cuando llegue la mercaderia, cuanta cobertura tendre?" | Medida DAX nueva: `[Cobertura a la Llegada]` (requiere ETA del CRM Nodum) |

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

### 4.2 Proceso Objetivo (con Power BI + Nodum)

```
1. Rosana abre Power BI → pagina "Stock Minimo Vs Lead Time"
2. Filtra por proveedor o ve articulos con Alerta="PEDIR"
3. Para cada articulo:
   a. Ve [Cobertura Meses] vs [Lead Time Meses] → semaforo visual
   b. Ve `dimArticulo[Comentarios]` (cargado desde vista ERP) → avisos vigentes
   c. Ve [Lote Minimo Compra] → restriccion de cantidad
   d. Ve [Stock Existencia] + [Stock Compras] → disponibilidad
   e. Ve [A Pedir Sugerido] → sugerencia del modelo
   f. Decide cantidad final (puede diferir de la sugerencia)
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

| Necesidad | Formula Excel | Propuesta de medida DAX | Prioridad |
|-----------|--------------|------------------------|-----------|
| Cobertura post-pedido | Y = (Q+S+X)/N | `[Cobertura Post Pedido]` = (Stock Proyectado + Parametro APedir) / Consumo | ALTA |
| Cobertura a la llegada | Z = Y - G + U | `[Cobertura a la Llegada]` = Cobertura + (EnCamino/Consumo) - LT | ALTA |
| Comentarios concatenados | D (texto libre) | ⚠️ Resuelto parcialmente: columna `dimArticulo[Comentarios]` ya disponible; `[Comentarios Activos]` CONCATENATEX solo si se pasa a formulario estructurado en Nodum | MEDIA (columna lista; formulario Nodum pendiente) |
| Stock ETAFPA | R (VLOOKUP) | `[Stock ETAFPA]` = SUM(stock ETAFPA) | MEDIA (verificar fuente) |

---

## 6. Preguntas para Validacion con Rosana

1. **Stock ETAFPA:** ¿El stock de ETAFPA es relevante para decisiones de compra al exterior? ¿Siempre se suma al stock EPSA para cobertura?

2. **Buffer de alerta:** Tu formula usa `Cobertura <= LT + 4` para disparar "PEDIR". ¿4 meses es el buffer correcto para todos los proveedores, o varia?

3. **Consumo override:** Algunos consumos (columna N) los pusiste manualmente (ej: 600, 2900). ¿Cuando decidis overridear el promedio calculado? ¿Que criterio usas?

4. **A Pedir manual:** ¿Siempre decidis la cantidad manualmente o a veces usas una formula? ¿Que factores consideras ademas de la cobertura? (MOQ, flete, presupuesto, consolidacion)

5. **Comentarios:** ¿Que tipo de informacion registras en "comentarios" (col D) que necesitarias ver en el reporte? (discontinuaciones, cambios de proveedor, problemas de calidad, plazos especiales)

6. **Cobertura a la llegada:** ¿La columna Z (cobertura a la llegada) la usas para decidir? ¿Que significa exactamente para vos?

7. **Lead Time:** ¿El lead time que pusiste (col G) es el tiempo total desde que pedis hasta que llega, o solo el tiempo del proveedor?

---

## 7. Proximos Pasos

| # | Accion | Responsable | Dependencia |
|---|--------|-------------|-------------|
| 1 | Validar este documento con Rosana | Andres + Rosana | Este documento |
| 2 | Verificar si stock ETAFPA existe en EPSA_BI | Andres (query SQL) | Pregunta 1 |
| 3 | Diseñar formulario de comentarios en Nodum | Andres + Rosana | Pregunta 5 |
| 4 | Implementar medidas [Cobertura Post Pedido] y [Cobertura a la Llegada] | Andres | Validacion de formulas |
| 5 | Ajustar buffer de alerta (4 vs 1 mes) segun validacion | Andres | Pregunta 2 |
| 6 | Auditar campo Lote Minimo Compra en ERP | Andres (query SQL) | Pregunta 4 |
