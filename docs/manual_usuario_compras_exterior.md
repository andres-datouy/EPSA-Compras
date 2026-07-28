# Manual de Usuario: Reporte Compras al Exterior

## Version: 2.1
## Fecha: 2026-05-18
## Dirigido a: Area de Compras Exteriores (Rosana y equipo)
## Cambio v2.0: Documentacion de A Pedir Sugerido, nuevas paginas (Fase 1-6), referencia DAX
## Cambio v2.1: Pagina "Programacion Compras Exterior" (flujo de decision), export a Excel en vivo

---

## 1. Introduccion

Este manual explica como usar el reporte **Compras al Exterior** en Power BI para monitorear articulos que requieren compra internacional.

### 1.1 Que reemplaza este reporte?
- El Excel `Pedidos a exterior 2026.04.09.xlsx`
- Las busquedas manuales de stock en el ERP
- Los calculos manuales de cobertura

### 1.2 Acceso al reporte
- El archivo PBIX se encuentra en SharePoint: `[ruta de SharePoint]`
- Abrir con Power BI Desktop (gratuito)
- Los datos se actualizan cuando se abre el archivo y se presiona "Actualizar"

---

## 2. Estructura del reporte

### 2.1 Pagina: Compras al Exterior

Esta pagina muestra una tabla con todos los articulos a monitorear.

#### Filtros disponibles (parte superior)
| Filtro | Para que sirve |
|--------|---------------|
| Pais Origen | Filtra por pais del proveedor (excluye Uruguay por defecto) |
| Tipo Componente | Filtra componentes obligatorios vs opcionales |
| Proveedor | Filtra por nombre del proveedor |
| Articulo | Busca un articulo especifico |

#### Tabla principal
La tabla muestra 19 columnas. Las mas importantes son:

| Columna | Que significa | Como usarla |
|---------|---------------|-------------|
| **Alerta Cobertura** | Estado del articulo: PEDIR / Atencion / OK | Si dice "PEDIR" (rojo), hay que ordenar. Si dice "Atencion" (amarillo), planificar compra. |
| **Diferencia Cobertura Lead Time** | Cuanto excede o falta el stock vs el lead time | Negativo (rojo) = falta stock. Positivo (verde) = sobra stock. |
| **Stock Existencia** | Cuanto hay ahora en EPSA | Comparar con el stock minimo. |
| **Stock Proyectado** | Stock actual + compras en camino | Mejor estimador de disponibilidad futura. |
| **Consumo Promedio por Mes Activo** | Cuanto se consume por mes | Base para calcular cuanto ordenar. |
| **Lead Time Promedio Dias** | Dias promedio de demora del proveedor | Se calcula del historial de recepciones. |
| **Cobertura Meses sobre Existencia** | Cuantos meses dura el stock actual | Si es menor al lead time = alerta. |

### 2.2 Pagina: Programacion Compras Exterior (flujo de decision)

Pagina dedicada al flujo de trabajo de programacion de compras. Sigue 4 pasos:

#### Paso 1 - Elegir con que trabajar
| Filtro | Cuando usarlo |
|--------|---------------|
| **Proveedor** | Camino normal: programar la compra de un proveedor |
| **Clase** | Cuando el "proveedor" es la empresa consolidadora y no el fabricante real: filtrar por clase de articulo |
| **Articulo** (multi-seleccion con busqueda) | Armar un conjunto arbitrario de articulos a analizar |
| **Proveedores** (busqueda por texto) | Encontrar el proveedor real dentro de la lista de proveedores del articulo |

#### Paso 2 - Tabla de decision
La tabla central "PROGRAMACION DE COMPRAS - TABLA DE DECISION" responde las preguntas en orden:
1. **Stock Minimo**: cual es el minimo definido
2. **Lead Time Promedio Dias / Lead Time Meses**: cuanto tarda en llegar
3. **Consumo Promedio por Mes Activo**: cuanto se consume
4. **Existencia + Stock Compras = Stock Proyectado**: cuanto tengo y cuanto viene en camino
5. **Consumo Planificado Cantidad**: cuanto esta comprometido en ordenes de produccion en curso
6. **Cantidad Requerida por Demanda Pendiente**: cuanto exigen los pedidos que aun no tienen orden asociada
7. **Stock Util E+C-CP-CD**: que queda neto despues de descontar compromisos
8. **Coberturas**: tres miradas segun el caso:
   - `Cobertura Meses sobre Stock Proyectado`: con lo que tengo + lo que viene, cuantos meses cubro (mirada optimista)
   - `Cobertura Meses sobre Stock Util`: descontando OP en curso y demanda pendiente (mirada conservadora, es la que dispara la alerta)
   - `Meses Cobertura del Stock Minimo`: valida si el stock minimo configurado es coherente con el lead time
9. **Alerta**: PEDIR (cobertura util < lead time) / Atencion (< lead time + 1 mes) / OK
10. **A Pedir Sugerido**: cantidad sugerida de compra
11. **Comentarios**: notas del articulo cargadas en Nodum (ej. "proveedor no fabrica mas este item")

#### Paso 3 - Verificar contra Nodum
Al hacer clic en un articulo de la tabla de decision, los paneles inferiores muestran los registros fuente con su documento Nodum:
- Movimientos de consumo (formulario, transaccion, nro. de documento)
- Recepciones historicas (documento de compra, OC, proveedor)
- Compras en proceso (documento, fecha de entrega)
- Ordenes de produccion planificadas (orden, paso)
- Demanda pendiente (pedido, cliente, componente)
- Stock por deposito y por estado

Cada cifra agregada se puede rastrear a su documento en Nodum antes de decidir.

#### Paso 4 - Exportar
Dos opciones:
- **Excel en vivo**: abrir `export\Compras EPSA - Modelo SSAS.odc` (doble clic) crea una tabla dinamica conectada directo al modelo. Los datos se actualizan con "Actualizar" en Excel, sin copias estaticas. *(Requiere permiso de lectura sobre el modelo; solicitar al administrador.)*
- **Export puntual**: en cualquier tabla del reporte, menu `...` -> "Exportar datos" genera un Excel/CSV con lo que se esta viendo (respeta los filtros aplicados).

---

## 3. Como interpretar las alertas

### 3.1 Alerta "PEDIR" (rojo)

**Significado:** El stock actual no cubre el lead time del proveedor. Si no se ordena ahora, puede haber faltante.

**Accion:**
1. Verificar la cantidad sugerida en el campo "A pedir" (cuando esté disponible)
2. Considerar el minimo de compra (MOQ)
3. Verificar si hay oportunidad de consolidar con otros articulos del mismo proveedor
4. Generar la orden de compra

### 3.2 Alerta "Atencion" (amarillo)

**Significado:** El stock cubre el lead time, pero no hay margen de seguridad. Cualquier demora o consumo inesperado puede generar faltante.

**Accion:**
1. Planificar la compra para el proximo ciclo
2. No es urgente, pero no debe posponerse

### 3.3 Alerta "OK" (verde)

**Significado:** El stock cubre el lead time con al menos 1 mes de seguridad.

**Accion:**
1. No requiere accion inmediata
2. Revisar en el proximo ciclo de monitoreo

---

## 4. Casos de uso tipicos

### 4.1 "Que tengo que comprar esta semana?"

1. Aplicar filtro: `Alerta Cobertura = "PEDIR"`
2. Ordenar por `Diferencia Cobertura Lead Time` (de menor a mayor)
3. Los primeros son los mas criticos
4. Para cada uno, verificar `Stock Existencia` y `Consumo Promedio`

### 4.2 "Cuanto debo pedir de un articulo?"

La columna **"A Pedir Sugerido"** en la pagina "Stock Minimo Vs Lead Time" calcula automaticamente la cantidad a ordenar.

**Formula implementada:**
```
A Pedir = MAX(0, Necesidad - StockNeto)

Donde:
  Necesidad = Consumo Mensual x (LT en meses + 1 mes de seguridad)
  StockNeto = Stock Proyectado - Consumo Planificado - Demanda Pendiente
```

**Interpretacion:**
- Valor > 0: cantidad sugerida para cubrir el lead time con 1 mes de margen
- Valor = 0: stock suficiente, no requiere pedido

**Ajustes manuales a considerar:**
- Minimo de compra (MOQ) del proveedor — si A Pedir < MOQ, ajustar al MOQ
- Presentacion del producto (cajas, pallets, bobinas) — redondear a multiplo
- Consolidacion con otros articulos del mismo proveedor
- Oportunidades de flete compartido
- Condiciones comerciales especiales (descuentos por volumen)

### 4.3 "Hay articulos de un proveedor que puedo consolidar?"

1. Filtrar por proveedor (ej: "Martech")
2. Ver todos sus articulos
3. Revisar cuales tienen alerta PEDIR o Atencion
4. Sumar las cantidades a pedir
5. Evaluar si conviene un solo envio

### 4.4 "Un articulo aparece con proveedor 'Sin datos'"

Esto significa que el articulo no tiene proveedor asignado en el ERP.

**Accion:**
1. Verificar en el ERP si el articulo tiene proveedor por defecto
2. Si es un articulo nuevo, solicitar alta de proveedor
3. Comunicar a Sistemas para actualizar la vista

---

## 5. Preguntas frecuentes

### P: Los numeros no coinciden con mi Excel
R: El reporte toma datos directamente del ERP. Si hay diferencias, verificar:
- Fecha de ultima actualizacion del ERP
- Si el articulo tiene movimientos recientes no reflejados
- Comunicar a Sistemas para validar

### P: Un articulo deberia estar en la lista pero no aparece
R: Verificar si cumple los criterios de inclusion (ver Reglas de Negocio). Si cumple y no aparece, solicitar alta mediante el proceso establecido.

### P: Un articulo aparece pero ya no lo compro al exterior
R: Solicitar baja mediante el proceso establecido. El articulo se marcara como "No monitoreado".

### P: El lead time no coincide con lo que yo se
R: El lead time se calcula del historial de recepciones. Si cambio recientemente, comunicar a Sistemas para actualizar.

### P: Puedo guardar mis filtros?
R: Si. Power BI Desktop permite guardar filtros con "Bookmarks" (Marcadores). Consultar la seccion avanzada.

---

## 6. Glosario

| Termino | Significado |
|---------|-------------|
| **Lead Time** | Tiempo entre ordenar y recibir |
| **Cobertura** | Cuantos meses de stock hay |
| **Stock Proyectado** | Stock actual + lo que viene en camino |
| **MOQ** | Minimo de compra |
| **Consolidacion** | Juntar varios articulos en un solo envio |
| **A Pedir Sugerido** | Cantidad calculada automaticamente |
| **Alerta PEDIR** | Cobertura < LT — ordenar urgente |
| **Stock Util** | Proyectado - compromisos - minimo |

---

## 7. Nuevas Paginas del Reporte (Fase 1-6)

Ademas de la pagina principal "Stock Minimo Vs Lead Time", el reporte incluye:

| Pagina | Objetivo | Cuando usar |
|--------|----------|-------------|
| Suficiencia Stock Produccion | Vista general de suficiencia | Al inicio del dia |
| Compras x Stock Minimo | Articulos bajo minimo | Semanal |
| Stock Minimo - Deficit | Analisis de deficit | Para priorizar |
| Rotacion y Stock Muerto | Articulos sin movimiento | Mensual |
| Control Vencimientos | Lotes por vencer | Semanal |
| Proveedor - Articulo | Detalle por proveedor | Investigar proveedor |
| Direccion - Compras | Dashboard ejecutivo | Presentaciones |
| Prevision de Gasto | Estimacion de gasto futuro | Planificacion |

> Manual detallado para Administradora de Produccion: `docs/manual_produccion_compras.md`

---

## 8. Referencia de Formulas DAX

Las formulas completas de todas las medidas estan documentadas en:
**`docs/dax_formulas_reference.md`**

Resumen de las medidas mas usadas:

| Medida | Formula simplificada |
|--------|---------------------|
| Stock Existencia | SUM(factStockEPSA) donde Estado in {existencia, stkaf} |
| Stock Proyectado | Existencia + Compras en proceso |
| Consumo Promedio Mes Activo | Consumo sin recepciones / Meses con consumo |
| Cobertura Meses | Existencia / Consumo Promedio Mensual |
| Lead Time Dias | AVG(RecepcionFecha - OCFecha) |
| A Pedir Sugerido | MAX(0, Consumo x (LT+1) - StockNeto) |
| Alerta Cobertura | PEDIR si Cob < LT, Atencion si LT <= Cob < LT+1, OK si Cob >= LT+1 |

---

## 9. Soporte

| Problema | Contacto |
|----------|----------|
| Error en el reporte | Sistemas / BI |
| Datos incorrectos | Sistemas / BI + Compras |
| Nuevo articulo a incluir | Jefe de Compras |
| Articulo a excluir | Jefe de Compras |
| Dudas sobre interpretacion | Rosana (referente de Compras) |
