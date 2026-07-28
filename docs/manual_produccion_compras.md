# Manual de Usuario: Administracion de Produccion — Reportes de Compras Power BI

## Version: 1.0
## Fecha: 2026-05-18
## Dirigido a: Administradora de Produccion
## Reporte: EPSA-Compras.pbip (Live Connection a SSAS Compras_EPSA)

---

## 1. Introduccion

### 1.1 Objetivo de este manual

Este manual guia a la **Administradora de Produccion** en el uso de los reportes Power BI de EPSA para:
- Validar datos de stock, consumo y cobertura de los articulos que usa Produccion
- Apoyar decisiones de compra para proveedores del exterior (ej: EPFLEX, Day Engineering)
- Identificar articulos en riesgo de desabastecimiento
- Conocer el estado de pedidos en proceso y fechas de llegada estimadas

### 1.2 Que es el reporte Power BI de Compras?

Es un tablero interactivo conectado en tiempo real al sistema de datos de EPSA. Muestra:
- Stock actual de todos los articulos
- Consumo historico y promedios mensuales
- Cobertura (cuantos meses dura el stock)
- Lead times de proveedores
- Compras en proceso (solicitudes, ordenes, carpetas de importacion)
- Alertas de riesgo (semaforo PEDIR / Atencion / OK)

### 1.3 Como acceder

1. Abrir Power BI Desktop (gratuito, instalado en la PC)
2. Abrir el archivo `EPSA-Compras.pbip`
3. Los datos se actualizan automaticamente al abrir (Live Connection a SSAS)
4. Si los datos parecen desactualizados: clic en "Actualizar" (pestaña Inicio)

### 1.4 Rol de la Administradora de Produccion

La Administradora de Produccion necesita:
- Saber si los componentes necesarios para fabricar tienen stock suficiente
- Validar que las compras realizadas cubriran la demanda prevista
- Coordinar con Compras Exteriores (Rosana) e Importaciones (Roberta)
- Conocer fechas estimadas de llegada de mercaderia importada

---

## 2. Seleccion de Articulos

El reporte permite 4 formas de seleccionar articulos para analizar. Todas se combinan entre si.

### 2.1 Un articulo especifico (slicer Articulo)

**Como:** En el panel lateral izquierdo, buscar el slicer "Articulo". Escribir el codigo o nombre del articulo.

**Cuando usarlo:**
- Cuando se necesita validar datos de UN articulo puntual
- Ejemplo: "Quiero ver el estado del alambre 0.3x709 para el mandril de cateter ureteral"

**Pasos:**
1. Ir a la pagina "Stock Minimo Vs Lead Time"
2. En el slicer Articulo, escribir el codigo (ej: 267092001995)
3. La tabla se filtra mostrando solo ese articulo
4. Revisar todas las columnas de datos (ver Capitulo 3)

### 2.2 Todos los articulos de un proveedor (slicer Proveedor)

**Como:** En el panel lateral, buscar el slicer "Proveedor Preferido". Seleccionar el proveedor deseado.

**Cuando usarlo:**
- Cuando se quiere ver el panorama completo de un proveedor
- Ejemplo: "Quiero ver todos los articulos de Day Engineering para evaluar un pedido consolidado"
- Para EPFLEX: seleccionar "EPFLEX" para ver los codigos viejos, o "Day Engineering" para los nuevos

**Pasos:**
1. Ir a la pagina "Stock Minimo Vs Lead Time"
2. En el slicer Proveedor, seleccionar el proveedor
3. La tabla muestra todos los articulos de ese proveedor
4. Revisar cada articulo y su estado de alerta

### 2.3 Articulos por clase o tipo (slicers TipoComponente, Clase)

**Como:** Usar los slicers "TipoComponente" o "Clase Nombre" en el panel lateral.

**Cuando usarlo:**
- Cuando se quiere analizar una categoria de componentes
- Ejemplo: "Quiero ver todos los alambres (clase: ALAMBRES) para validar stock"
- Ejemplo: "Quiero ver solo los componentes obligatorios de formulas"

**Pasos:**
1. Ir a la pagina "Stock Minimo Vs Lead Time"
2. En slicer Clase Nombre, seleccionar la clase deseada
3. Combinar con Pais o Proveedor para refinar

### 2.4 Seleccion multiple de articulos

**Como:** En el slicer Articulo, mantener Ctrl y hacer clic en varios articulos.

**Cuando usarlo:**
- Cuando se necesita comparar varios articulos especificos
- Ejemplo: "Quiero comparar los 3 alambres que usa Produccion este mes"

---

## 3. Validacion de Datos por Articulo

Una vez seleccionado el articulo, la tabla principal muestra los siguientes datos. Cada dato tiene un significado y una forma de validarlo.

### 3.1 Existencia (Stock Existencia)

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Cantidad fisica del articulo disponible en depositos EPSA |
| **Fuente** | `factStockEPSA` — snapshot del ERP (Nodum) |
| **Que incluye** | Estado "existencia" (deposito principal) + "stkaf" (asignado a fabricacion) |
| **Actualizacion** | Diaria (refresh del SSAS) |

**Como validar:**
1. Ver el valor en la columna "Existencia" de la tabla
2. Comparar con el conteo fisico en deposito si hay dudas
3. Si el valor parece incorrecto, verificar con Sistemas la fecha del ultimo refresh

**Interpretacion:**
- **> 0:** Hay unidades disponibles
- **= 0:** Sin stock — verificar si hay "Stock Compras" en proceso
- **< Stock Minimo:** Riesgo de desabastecimiento

### 3.2 Consumo Promedio por Mes Activo

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Promedio de consumo mensual considerando solo meses con movimiento |
| **Fuente** | `factConsumoHistoria` — ultimos 5 anos de movimientos de stock |
| **Formula** | Sumatoria de consumo (sin recepciones) / Meses con consumo > 0 |
| **Actualizacion** | Dos veces por dia (incremental) |

**Como validar:**
1. Ver el valor en columna "Consumo Promedio por Mes Activo"
2. Comparar con la columna "Meses con Consumo" — si son pocos meses, el promedio es menos confiable
3. Si el valor es 0, el articulo no tuvo consumo en el periodo analizado

**Interpretacion:**
- Es la velocidad de consumo del articulo
- Se usa como base para calcular cobertura y cantidades a pedir
- Un valor alto = se consume rapido; bajo = consumo esporadico
- **Mes activo** = mes donde hubo al menos una salida de almacen (se excluyen meses sin movimiento para no subestimar el consumo)

**Ejemplo:** Si un articulo tiene consumo en 8 de los ultimos 24 meses, y en esos 8 meses consumió 800 unidades, el promedio = 800/8 = 100 unidades/mes activo.

### 3.3 Cobertura Meses sobre Existencia

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Cuantos meses dura el stock actual al ritmo de consumo promedio |
| **Fuente** | Calculo: Stock Existencia / Consumo Promedio por Mes Activo |
| **Actualizacion** | Se recalcula cada vez que se refresca el reporte |

**Como validar:**
1. Verificar que Stock Existencia y Consumo Promedio sean correctos (puntos 3.1 y 3.2)
2. La cobertura es un cociente automatico — si los datos base son correctos, la cobertura es confiable

**Interpretacion:**
- **Cobertura > LT + 1 mes:** OK — stock suficiente con margen de seguridad
- **LT <= Cobertura < LT + 1:** Atencion — cubre el lead time pero sin margen
- **Cobertura < LT:** PEDIR — stock insuficiente, hay que ordenar

**Cobertura Proyectada (secundaria):**
- Hay una segunda cobertura que incluye compras en proceso: "(Existencia + Compras) / Consumo"
- Usar como referencia, pero la alerta principal se basa solo en existencia

### 3.4 Lead Time Promedio Dias

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Dias promedio entre la emision de OC al proveedor y la recepcion de mercaderia |
| **Fuente** | `factRecepcionesHistoria` — historial de recepciones desde 2009 |
| **Formula** | Promedio de (Fecha Recepcion - Fecha OC) para todas las recepciones del articulo |
| **Nota** | Mide lead time del **proveedor** (no incluye proceso interno de solicitud) |

**Como validar:**
1. Ver el valor en "Lead Time Promedio Dias"
2. Si esta vacio: el articulo nunca tuvo recepciones registradas (articulo nuevo o sin compras previas)
3. Comparar con la experiencia del equipo — si el LT real difiere mucho del calculado, informar a Sistemas

**Interpretacion:**
- 30 dias = 1 mes de lead time
- 90 dias = 3 meses de lead time
- 150 dias = 5 meses de lead time (tipico de proveedores de Asia)
- Para Produccion: usar **"Lead Time Proceso Interno Dias"** que incluye el tiempo de solicitud interna

**Lead Time para Produccion vs Compras:**
| Tipo | Que mide | Para quien |
|------|----------|------------|
| Lead Time Promedio Dias | Desde OC hasta recepcion | Compras / Importaciones |
| Lead Time Proceso Interno Dias | Desde solicitud hasta recepcion | **Produccion** |

### 3.5 Stock Minimo

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Umbral configurado en el ERP (Nodum) para cada articulo |
| **Fuente** | `dimArticulo[Articulo Stock Minimo]` — dato maestro del ERP |
| **Actualizacion** | Cuando se modifica en el ERP |

**Como validar:**
1. Ver valor en columna "Stock Minimo"
2. Si es 0: puede ser que no este configurado o que sea un articulo sin minimo
3. Consultar con Produccion si el SM configurado es adecuado

**Interpretacion:**
- Si Stock Existencia < Stock Minimo → alerta "CRITICO"
- El SM deberia cubrir al menos el Lead Time + 1 mes de seguridad
- La medida "Meses Cobertura del Stock Minimo" muestra cuantos meses cubre el SM

### 3.6 A Pedir Sugerido

| Aspecto | Detalle |
|---------|---------|
| **Que es** | Cantidad sugerida para ordenar, calculada automaticamente |
| **Formula** | MAX(0, ConsumoMensual x (LT_meses + 1) - StockNeto) |
| **StockNeto** | Stock Proyectado - Consumo Planificado - Demanda Pendiente |

**Como interpretar:**
- **> 0:** Se sugiere ordenar esa cantidad
- **= 0:** No se necesita pedido (stock suficiente)

**Ajustes a considerar:**
| Factor | Ejemplo |
|--------|---------|
| MOQ (minimo de compra) | Si A Pedir = 50 pero MOQ = 100, pedir 100 |
| Presentacion | Si viene en cajas de 500, redondear a multiplo de 500 |
| Consolidacion | Si hay 3 articulos del mismo proveedor, evaluar pedido conjunto |
| Flete compartido | Aprovechar envios programados para agregar articulos |

### 3.7 Alerta Cobertura (Semaforo)

| Color | Nivel | Condicion | Accion |
|-------|-------|-----------|--------|
| Rojo | **PEDIR** | Cobertura < LT | Ordenar inmediatamente |
| Amarillo | **Atencion** | LT <= Cobertura < LT+1 | Planificar compra para proximo ciclo |
| Verde | **OK** | Cobertura >= LT+1 | Sin accion — revisar en proximo ciclo |

---

## 4. Datos Complementarios (En Desarrollo)

> Nota: Estos datos requieren nuevas tablas en el modelo. Se encuentran en fase de diseno.

### 4.1 Comentarios del Proveedor

**Que seran:** Notas operativas registradas por proveedor y/o articulo:
- Avisos de discontinuacion
- Cambios de proveedor
- Problemas de calidad
- Plazos especiales de entrega
- Condiciones de pago

**Como se mostraran:** Texto concatenado al seleccionar un proveedor en el reporte.

**Fuente futura:** Formulario en Nodum (ERP) con campos: cod_proveedor, comentario, fecha, es_vigente, prioridad.
Dos niveles: comentarios para el proveedor general y para la relacion Proveedor-Articulo.

> **Estado:** Pendiente diseño e implementacion en Nodum. Actualmente la informacion existe en Excel de Rosana como notas informales.

**Ejemplos (desde Excel de Rosana como referencia):**
- EPFLEX: "Quedara en desuso, se le pasa a comprar a Day Engineering"
- Shanghai Health: "05/02/2024 el proveedor avisa que se va a discontinuar"

### 4.2 Fechas de Llegada (Roberta — Importaciones)

**Que seran:** Fecha estimada/real de llegada de mercaderia a EPSA.

**Diferencia con la fecha de entrega de la OC:**
| Dato | Significado | Fuente |
|------|-------------|--------|
| Fecha Entrega OC | Fecha prometida por el proveedor en la orden | ERP (Nodum) |
| **Fecha Llegada Estimada** | Fecha que Roberta estima que la mercaderia llega a EPSA | **CRM Carpeta en Nodum (futuro)** |
| Fecha Llegada Real | Fecha efectiva de recepcion en EPSA | ERP (al recibir) |

**Por que importa:** La fecha de entrega de la OC puede diferir de la llegada real por:
- Demoras en aduana
- Problemas de transporte internacional
- Procesamiento interno en EPSA

> **Estado:** Pendiente diseño de CRM de carpeta/importaciones en Nodum.
> Actualmente Roberta mantiene esta informacion en su Excel de importaciones en curso.

### 4.3 Unidades Minimas de Compra (MOQ)

**Que es:** Cantidad minima que el proveedor exige por pedido.

**Estado actual:** El campo `Lote Minimo Compra` existe en el ERP pero puede no estar completo para todos los articulos.

**En Excel de Rosana:** Columna "Presentacion y minimos de compra" — valores como "Unitario" (MOQ = 1) o vacio (sin minimo definido).

**Como afecta la compra:** Si A Pedir Sugerido = 30 pero MOQ = 100, la cantidad real a ordenar es 100.

---

## 5. Proceso de Validacion para EPFLEX

### 5.1 Contexto

EPFLEX es un proveedor de **alambres de acero inoxidable 4310 y aluminio** utilizado para mandriles de cateteres ureterales. Actualmente esta siendo **reemplazado por Day Engineering**.

**Productos:**
- Alambres de acero 4310 en diametros 0.2mm a 1.5mm
- Alambres de aluminio 2.6mm
- Largos estandar: 370mm, 470mm, 525mm, 600mm, 709mm, 850mm

**Articulos en produccion que los usan:**
- Mandril cateter ureteral N°1 (12940100000000) → usa alambre 0.3x709
- Mandril cateter ureteral N°2 (12940200000000) → usa alambre 0.4x709

### 5.2 Paso a paso para validar EPFLEX en el PBIP

**Paso 1:** Abrir el reporte e ir a pagina **"Stock Minimo Vs Lead Time"**

**Paso 2:** En el slicer Proveedor, seleccionar **EPFLEX**
- Si no aparece EPFLEX: buscar como "Day Engineering" (puede estar migrado)
- Si no aparece ninguno: el proveedor no esta registrado en dimProveedor

**Paso 3:** Revisar la tabla para cada articulo:
- ¿Tiene stock? (columna Existencia)
- ¿Tiene consumo reciente? (columna Consumo Promedio por Mes Activo)
- ¿Cual es la cobertura? (columna Cobertura Meses)
- ¿Cual es la alerta? (columna Alerta Cobertura)

**Paso 4:** Para articulos en transicion EPFLEX → Day Engineering:
- Verificar si el codigo Day Engineering ya existe en el ERP
- Si existe: buscarlo en el slicer Articulo y validar sus datos
- Si no existe: informar a Produccion que necesita alta en Nodum

**Paso 5:** Ir a pagina **"Proveedor - Articulo"** para ver el detalle:
- Historico de recepciones
- Compras en proceso activas
- Ultimo pedido realizado

### 5.3 Tabla de mapeo EPFLEX → Day Engineering

| Codigo EPFLEX | Descripcion | Codigo Day Eng. | Estado |
|---------------|-------------|-----------------|--------|
| 267092001988 | Alambre 0,3x709 | 267092001995 | En transicion |
| 267092001989 | Alambre 0,4x709 | 267025000000 | En transicion |
| 267092001990 | Alambre 0,5x709 | 267092730005 | En transicion |
| 267092001991 | Alambre 0,2x850 | (pendiente) | Sin codigo Day Eng. |
| 267092730130 | Alambre 0.3X850 | 267092002000 | En transicion |
| 267092730140 | Alambre 0.4X850 | 267092002100 | En transicion |
| 267927300150 | Alambre 0.5X850 | 267092002200 | En transicion |
| 267092770010 | Alambre 1.0X370 | (pendiente) | En desuso |
| 267092770030 | Alambre 1.5X470 | 267092770031 | En desuso |
| 267062000000 | Alambre Aluminio 2.6x525 | 267062001000 | En desuso |

> Referencia completa: `docs/epflex_data_audit.md`

---

## 6. Proceso de Decision de Compra

### 6.1 Descripcion general

El proceso de decision de compra responde a la pregunta: **"Que cantidad debo comprar de cada articulo para que Produccion no se quede sin componentes?"**

### 6.2 Flujo paso a paso

```
PASO 1: Identificar necesidad
   ↓
PASO 2: Validar datos del articulo
   ↓
PASO 3: Consultar fechas de llegada
   ↓
PASO 4: Revisar comentarios del proveedor
   ↓
PASO 5: Calcular cantidad a pedir
   ↓
PASO 6: Ajustar por MOQ y presentacion
   ↓
PASO 7: Consolidar por proveedor
   ↓
PASO 8: Coordinar con Compras Exteriores
   ↓
PASO 9: Registrar y hacer seguimiento
```

### 6.3 Detalle de cada paso

#### PASO 1: Identificar necesidad

**Pagina:** "Stock Minimo Vs Lead Time"
**Accion:** Filtrar por Alerta = "PEDIR" para ver articulos criticos.

Preguntas clave:
- ¿Que articulos tienen cobertura menor al lead time?
- ¿Hay pedidos de produccion pendientes que requieran estos componentes?
- ¿La demanda pendiente planificada ya consume stock futuro?

#### PASO 2: Validar datos del articulo

**Pagina:** "Stock Minimo Vs Lead Time" (tabla principal)

Para cada articulo critico, verificar:
| Dato | Que revisar | Si es incorrecto |
|------|-------------|------------------|
| Existencia | ¿Coincide con stock fisico? | Solicitar conteo |
| Consumo | ¿Es representativo del uso actual? | Revisar si cambio la demanda |
| Lead Time | ¿Es realista? | Consultar con Importaciones |
| Stock Minimo | ¿Esta configurado? | Solicitar alta en ERP |
| Compras en proceso | ¿Hay OC activas? | Verificar en "Proveedor - Articulo" |

#### PASO 3: Consultar fechas de llegada

**Pregunta:** ¿Hay mercaderia en camino? ¿Cuando llega?

**En el reporte:** Columna "Stock Compras" — si > 0, hay pedidos activos.

**Con Roberta (Importaciones):**
- Consultar el Excel de fechas de llegada
- Verificar si la fecha estimada cubre la necesidad
- Si la llegada es posterior al agotamiento previsto → urgencia

#### PASO 4: Revisar comentarios del proveedor

**En el reporte:** (pendiente implementacion — por ahora, consultar Excel de Rosana)

Informacion relevante:
- ¿El proveedor esta discontinuando el articulo?
- ¿Hay problemas de calidad conocidos?
- ¿Cambio el MOQ recientemente?
- ¿Hay un proveedor alternativo?

#### PASO 5: Calcular cantidad a pedir

**Columna:** "A Pedir Sugerido"

Formula que usa el sistema:
```
A Pedir = MAX(0, Necesidad - StockNeto)

Necesidad = Consumo Mensual x (LT en meses + 1 mes seguridad)
StockNeto = Stock Proyectado - Consumo Planificado - Demanda Pendiente
```

**Ejemplo:**
```
Articulo: Alambre 0.3x709 (267092001995)
Consumo Mensual: 500 unidades
Lead Time: 120 dias (4 meses)
Stock Existencia: 800
Stock Compras: 0
Consumo Planificado: 200
Demanda Pendiente: 100

Necesidad = 500 x (4 + 1) = 2,500
StockNeto = 800 + 0 - 200 - 100 = 500
A Pedir = MAX(0, 2500 - 500) = 2,000 unidades
```

#### PASO 6: Ajustar por MOQ y presentacion

| Ajuste | Ejemplo |
|--------|---------|
| MOQ | Si A Pedir = 2,000 pero MOQ = 5,000 → pedir 5,000 |
| Presentacion | Si viene en bobinas de 1,000 → redondear a multiplo de 1,000 |
| Stock maximo | No exceder 12 meses de cobertura (evitar stock muerto) |

#### PASO 7: Consolidar por proveedor

**Pagina:** "Stock Minimo Vs Lead Time" con filtro Proveedor

1. Ver todos los articulos del mismo proveedor
2. Sumar cantidades a pedir
3. Evaluar si conviene un envio consolidado (menor costo de flete)
4. Verificar si hay oportunidad de flete compartido con otro pedido programado

#### PASO 8: Coordinar con Compras Exteriores

Una vez definida la cantidad:
1. Informar a Rosana (Compras Exteriores) la necesidad de compra
2. Rosana gestiona la OC con el proveedor
3. Rosana informa a Roberta (Importaciones) para seguimiento
4. Roberta registra fecha estimada de llegada

#### PASO 9: Registrar y hacer seguimiento

1. Verificar que la OC fue emitida (aparecera en "Stock Compras")
2. Monitorear cobertura periodicamente
3. Cuando llegue la mercaderia: confirmar recepcion en ERP
4. Verificar que "Existencia" se actualiza en el reporte

---

## 7. Paginas del Reporte — Guia de Uso

### 7.1 Suficiencia Stock Produccion (Pagina 1)

**Objetivo:** Vista general de suficiencia de stock para todos los articulos de Produccion.
**Cuando usar:** Al inicio del dia, para tener un panorama rapido.
**Que muestra:** KPIs generales de stock, articulos bajo minimo.

### 7.2 Compras x Stock Minimo (Pagina 2)

**Objetivo:** Identificar articulos cuyo stock esta por debajo del minimo configurado.
**Cuando usar:** Semanalmente, para detectar deficits.
**Que muestra:** Tabla con codigo, nombre, stock, minimo, deficit, ultima recepcion.
**Columna clave:** "Stock Debajo Minimo" = CRITICO (rojo) / OK.

### 7.3 Stock Minimo - Deficit (Pagina 3)

**Objetivo:** Analisis detallado del deficit de stock vs minimo.
**Cuando usar:** Cuando se necesita priorizar que articulos atender primero.
**Que muestra:** Articulos ordenados por gap (diferencia entre existencia y minimo).

### 7.4 Rotacion y Stock Muerto (Pagina 4)

**Objetivo:** Identificar articulos sin consumo reciente que tienen stock inmovilizado.
**Cuando usar:** Mensualmente, para decisiones de descarte o reasignacion.
**Que muestra:** Articulos con stock pero sin consumo en 6-12+ meses.

### 7.5 Control Vencimientos (Pagina 5)

**Objetivo:** Monitorear articulos con vencimiento proximo.
**Cuando usar:** Semanalmente, para evitar perdidas por vencimiento.
**Que muestra:** Lotes con fecha de vencimiento, cantidad, dias restantes.

### 7.6 Stock Minimo Vs Lead Time (Pagina 6) — **PAGINA PRINCIPAL**

**Objetivo:** Herramienta de decision diaria para compras.
**Cuando usar:** **Diariamente** — es la pagina mas importante para la Administradora de Produccion.
**Que muestra:** Tabla completa con 17+ columnas:
- Codigo y nombre del articulo
- Existencia, Stock Minimo, Compras
- Consumo, Consumo Planificado, Demanda Pendiente
- Meses con consumo, Consumo Promedio Mensual
- Stock Util (E+C-CP-CD)
- Lead Time, Tipo de articulo, Proveedor
- Alerta Cobertura (semaforo)

**Filtros principales:** Pais, TipoComponente, Proveedor, Articulo, Alerta.

### 7.7 Proveedor - Articulo (Pagina 7)

**Objetivo:** Detalle por proveedor y sus articulos.
**Cuando usar:** Cuando se necesita investigar un proveedor especifico.
**Que muestra:** Relacion proveedor-articulo, historico, datos de compra.

### 7.8 Control Datos (Pagina 8)

**Objetivo:** Validacion de calidad de datos.
**Cuando usar:** Cuando se sospecha que hay datos faltantes o inconsistentes.

### 7.9 Direccion - Compras (Pagina 10)

**Objetivo:** Dashboard ejecutivo para Direccion.
**Cuando usar:** Para presentaciones o revisiones de alto nivel.

---

## 8. Glosario

| Termino | Significado |
|---------|-------------|
| **Cobertura** | Meses de stock disponibles al ritmo de consumo actual |
| **Lead Time (LT)** | Tiempo entre ordenar y recibir mercaderia |
| **LT Proceso Interno** | LT + tiempo de gestion interna (solicitud) |
| **Stock Existencia** | Cantidad fisica en deposito |
| **Stock Proyectado** | Existencia + compras en camino |
| **Stock Util** | Proyectado - compromisos (planificado + pendiente) - minimo |
| **MOQ** | Minimum Order Quantity — minimo de compra exigido por proveedor |
| **A Pedir Sugerido** | Cantidad calculada para cubrir LT + 1 mes seguridad |
| **Consumo Promedio Mensual Activo** | Promedio de consumo en meses con movimiento |
| **Demanda Pendiente** | Componentes necesarios para pedidos sin planificar |
| **Consumo Planificado** | Componentes comprometidos en ordenes de produccion |
| **OC** | Orden de Compra |
| **Alerta PEDIR** | Cobertura menor al Lead Time — ordenar urgente |
| **Alerta Atencion** | Cobertura cubre LT pero sin margen — planificar |
| **CRITICO** | Stock por debajo del minimo configurado |

---

## 9. Preguntas Frecuentes

### P: Los datos no coinciden con lo que veo en deposito
**R:** El reporte muestra el ultimo refresh del SSAS. Verificar:
- ¿Cuando fue la ultima actualizacion? (pestaña Inicio → Informacion de datos)
- Si el consumo o stock cambio hoy, puede no estar reflejado hasta el proximo refresh
- Si la diferencia es grande, informar a Sistemas

### P: Un articulo no aparece en el reporte
**R:** Posibles causas:
- El articulo no tiene proveedor del exterior asignado en el ERP
- El articulo no tiene consumo ni stock (no aparece en ninguna tabla de hechos)
- Verificar con Sistemas si el articulo esta en dimArticulo

### P: El Lead Time parece incorrecto
**R:** El LT se calcula del historico completo de recepciones. Puede ser afectado por:
- Recepciones muy antiguas (de hace anos)
- Un solo pedido que tardo mucho (outlier)
- Si el proveedor cambio recientemente, el historico no refleja el LT actual
- Informar a Sistemas para evaluar ajuste

### P: No veo la columna "A Pedir Sugerido"
**R:** La medida existe en el modelo. Si no aparece en la tabla, verificar que la pagina sea "Stock Minimo Vs Lead Time" (pagina 6).

### P: Quiero ver solo articulos de Produccion (no mantenimiento ni empaque)
**R:** Usar el filtro "TipoComponente" o "Clase Nombre" para seleccionar las clases relevantes para Produccion. Actualmente no hay un filtro explicito de "solo Produccion" — esto esta en evaluacion (ver propuesta de campo MonitoreoComprasExterior).

### P: Como se si un pedido ya fue emitido?
**R:** Si la columna "Stock Compras" > 0, hay pedidos activos. Ir a pagina "Proveedor - Articulo" para ver el detalle de las OC.

---

## 10. Soporte

| Situacion | Contactar |
|-----------|-----------|
| Dato incorrecto en el reporte | Sistemas / BI |
| Articulo que deberia estar pero no aparece | Sistemas / BI + Compras |
| Lead time que no coincide con la realidad | Compras + Sistemas |
| Necesidad de nuevo articulo en monitoreo | Jefe de Compras |
| Fecha de llegada de mercaderia | Roberta (Importaciones) |
| Dudas sobre proceso de compra | Rosana (Compras Exteriores) |
| Dudas sobre uso del reporte | Este manual + Sistemas |

---

## 11. Documentacion Relacionada

| Documento | Ubicacion | Contenido |
|-----------|-----------|-----------|
| Manual Compras Exteriores (Rosana) | `docs/manual_usuario_compras_exterior.md` | Guia para Rosana |
| Reglas de Negocio | `docs/reglas_negocio_compras_exterior.md` | Criterios de inclusion/exclusion, alertas |
| Modelo de Datos | `docs/modelo_datos.md` | Estructura tecnica del modelo |
| Referencia DAX | `docs/dax_formulas_reference.md` | Todas las formulas con explicacion |
| Auditoria EPFLEX | `docs/epflex_data_audit.md` | Mapeo de codigos y checklist |
