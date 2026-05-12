# Requerimiento: Compras al Exterior

## Contexto

Rosana del departamento de Compras utiliza actualmente dos archivos Excel para decidir las compras al exterior:

1. **EPSA - Control Stock Minimo - 2025-10-15.xlsx** (10.644 filas)
   - Hoja unica con control de stock minimo para todos los articulos
   - Columnas: Articulo, Descripcion, Existencia EPSA, Existencia ETAFPA, Compras Proyectadas, Compras 2, validacion de error, VALOR A TOMAR COMPRAS PROYECTADAS

2. **Pedidos a exterior 2026.04.09.xlsx** (329 filas activas)
   - Hoja principal **"actual"** donde trabaja Rosana
   - Hojas auxiliares: POLIZEN, TOTM, ALAMBRES, lupa, Hoja1
   - Hoja obsoleta: "Obsoleto no eliminar 2" (historia)

## Proceso Actual de Decision (Hoja "actual")

### Columnas de entrada
| Columna | Origen / Significado |
|---------|----------------------|
| Proveedor | Proveedor exterior (ej: Borla Italia, Martech, KDL, SAKIRA, Shanghai Health, etc.) |
| Codigo | Codigo del articulo |
| Descripcion | Nombre del producto |
| comentarios | Notas sobre desuso, sustituciones, discontinuacion |
| Presentacion y minimos de compra | Restricciones de packaging/MOQ |
| lead time | Meses de lead time del proveedor |
| consumo mensual 2019-2024 | Historia de consumo anual |
| Consumo | Consumo mensual promedio utilizado para calculo |
| Stock | Stock actual en EPSA |
| stock ETAFPA | Stock en planta ETAFPA (no esta en el modelo PBIX) |
| En Camino | Cantidad ya ordenada en transito |
| Actualizado | Fecha de ultima actualizacion |

### Columnas calculadas / decision
| Columna | Logica inferida |
|---------|-----------------|
| Meses cobertura | (Stock + ETAFPA + En Camino) / Consumo Mensual |
| aviso | Alerta visual (ej: "PEDIR") cuando cobertura < umbral |
| Comentarios cobertura | Notas sobre la situacion de cobertura |
| A pedir | Cantidad recomendada a ordenar |
| Cobertura | Cobertura actual en meses |
| cobertura a la llegada | Cobertura proyectada despues de llegar el pedido en curso |

### Logica de decision observada

```
SI Meses cobertura <= Lead Time (o umbral critico)
    ENTONCES aviso = "PEDIR"
    
A pedir = f(Consumo, Lead Time, Stock, En Camino, Minimos de compra)
```

Ejemplos encontrados:
- **Martech Temporary pacing cath**: Consumo 4.658/mes, Stock 16.169, Lead Time 5 meses, Cobertura 3 meses -> **PEDIR**
- **Martech Canula c/alas**: Consumo 3.704/mes, Stock 3.031, Cobertura 1 mes -> **PEDIR**
- **KDL Male luer**: Consumo 27.509/mes, Stock 124.046, En Camino 200.000, Cobertura 12 meses -> OK

## Eventos de Compra Identificados

| Evento | Descripcion | Ejemplo en Excel |
|--------|-------------|------------------|
| Sustitucion de proveedor | Cambio a proveedor chino por costo | "va a quedar en desuso -se sustituye por proveedor chino" (Borla) |
| Discontinuacion | Proveedor deja de fabricar | "el proveedor avisa que se va a discontinuar" (Shanghai Health tapon) |
| Prueba de alternativa | Pedido de muestras a nuevo proveedor | "Se hace pedido a Haiyan kangyuan medical para probar" |
| Transferencia de compra | Pasa de un proveedor a otro | "se le pasa a comprar a Day Engineering" (alambres) |
| Compra directa vs indirecta | Via intermediario (GSSA) o directo | "Se le pide a Sakira directamente (A veces por medio de GSSA)" |
| Pedido consolidado | Optimizacion de carga/costos desde mismo origen | Pendiente confirmar con Rosana |

## Proveedores / Origenes Geograficos Actuales

| Proveedor / Pais inferido | Articulos | Observaciones |
|---------------------------|-----------|---------------|
| Borla (Italia) | Portador micro, IV filter | En desuso, sustituyendo por chino |
| Martech | Temporary pacing cath, branulas, canulas | Alemania/Europa? |
| Alpingomma | Succidares | En desuso, sustituyendo por chino |
| Promepla | Clamp p/alas Seldinger | |
| KDL | Male luer, needle free connector | |
| SAKIRA | Llave 3 vias, agujas | A veces via GSSA |
| Shanghai Health Medical (China) | Tapon para sonda | En discontinuacion |
| Changzhou Longyin (China) | Regulador de succion | |
| BQ Plus Medical (China) | Conector macho alimentacion enteral | |
| Tecnica del Plata | Caseina | Tratado como exterior aunque es plaza |
| POLIZEN (Alemania?) | Pur pellet (poliuretanos) | Requiere certificado de conformidad por lote |
| Day Engineering | Alambres | Sustituyendo a EPFLEX |

## Gaps respecto al modelo Power BI existente

| Dato en Excel de Rosana | Disponible en modelo PBIX | Gap |
|-------------------------|---------------------------|-----|
| Stock ETAFPA | NO | **CRITICO** - Falta tabla/fuente de datos |
| Lead time por articulo/proveedor | NO - Solo existe `Lead Time Promedio Dias` a nivel global en recepciones | **CRITICO** - Necesita maestro de proveedores con lead time |
| Compras en camino por articulo | PARCIAL - `factComprasEnProceso` tiene cantidades pero no granularidad de "en transito" vs "solicitud" | Medio - Verificar si `CompraEP Tipo` permite filtrar "en camino" |
| Consumo mensual historico 2019-2024 | SI - `factConsumoHistoria` con datos desde 2020 (5 anos) | OK - El modelo ya tiene la historia |
| Stock actual EPSA | SI - `factStockEPSA` | OK |
| Calculo "A pedir" recomendado | NO - No existe medida | **CRITICO** - Nueva medida DAX necesaria |
| Minimos de compra / MOQ | NO - No existe en el modelo | Medio - Podria agregarse a dimArticulo o dimProveedor |
| Comentarios / decisiones de compra | NO | Medio - Podria gestionarse fuera del modelo (SharePoint, etc.) |
| Alertas de cobertura | PARCIAL - `Stock Debajo Minimo` existe pero es generico | Medio - Necesita ser mas sofisticado (lead time-aware) |

## Oportunidades de Automatizacion

### Alta prioridad
1. **Extraer Stock ETAFPA** del ERP (Nodum) o del sistema de ETAFPA para incluirlo en el modelo
2. **Crear maestro de proveedores externos** con lead time por articulo y minimos de compra
3. **Crear medida DAX "Cantidad Recomendada a Pedir"** basada en:
   - Consumo promedio mensual
   - Lead time del proveedor
   - Stock actual (EPSA + ETAFPA)
   - Compras en camino
   - Stock minimo
   - Minimo de compra / presentacion
4. **Reporte de Compras al Exterior** con:
   - Ranking de articulos a pedir (por criticidad)
   - Consolidacion por proveedor / origen geografico
   - Optimizacion de cargas (ej: todo lo de Alemania en un solo pedido)
   - Proyeccion de cobertura post-pedido

### Media prioridad
5. Integrar comentarios y alertas de desuso/discontinuacion
6. Dashboard de seguimiento de pedidos en curso con fechas estimadas de llegada
7. Analisis de sustitucion de proveedores (costo, lead time, calidad)

## Preguntas para entrevista con Rosana

### Proceso de trabajo
1. **Frecuencia:** Con que frecuencia revisas y actualizas la hoja "actual"? Semanal? Mensual? Es reactivo (cuando llega alerta) o proactivo?
2. **Trigger de compra:** Que evento te indica que es momento de comprar? Cobertura baja de X meses? Llegada de un contenedor? Calendario fijo?
3. **Decision:** Como calculas exactamente la cantidad "A pedir"? Hay una formula o es estimacion?

### Eventos de compra
4. **Consolidacion:** Cuando compras a proveedores de Europa (ej: Martech, Borla, POLIZEN), intentas consolidar multiples articulos en un solo envio para optimizar flete?
5. **Alemania/Europa:** Que articulos se compran especificamente de Alemania o Europa? POLIZEN es aleman?
6. **Cambio de proveedor:** Cuando decides sustituir un proveedor europeo por uno chino, que informacion comparas? Costo, lead time, calidad, stock de seguridad?

### Datos y fuentes
7. **Stock ETAFPA:** De donde sacas el stock de ETAFPA? Es del mismo ERP o de otro sistema?
8. **Lead time:** De donde sacas los lead times? Son fijos por proveedor o varian?
9. **En Camino:** Como registras las compras "en camino"? Viene del ERP o lo cargas manualmente?
10. **Comentarios:** Los comentarios sobre desuso/sustitucion los tomas de Calidad, de Produccion, o son decisiones de Compras?

### Presentacion y minimos
11. **MOQ:** Los "minimos de compra" son por articulo o por proveedor? Afectan la cantidad "A pedir"?
12. **Presentacion:** Que significa "Presentacion y minimos de compra" en tu hoja? Cajas, pallets, contenedores?

## Respuestas de Rosana (entrevista)

| # | Pregunta | Respuesta | Impacto |
|---|----------|-----------|---------|
| 1 | Frecuencia de actualizacion | Base mensual, pero reactiva a pedidos de clientes y aprovechando procesos de importacion en curso | El reporte debe ser dinamico y actualizable en cualquier momento |
| 2 | Calculo de "A pedir" | Formula sugerida + campo editable manualmente al momento de la decision | Necesitamos medida DAX con formula + campo de ajuste manual en el reporte |
| 3 | Trigger de compra | Cualquier factor: lead time, necesidad, cobertura. La formula considera: necesidad, stock actual, compras proyectadas y meses de cobertura del articulo | La logica es mas compleja que solo cobertura < lead time |
| 4 | Consolidacion Europa | Si consolidan con Mercurius en Alemania | Reporte debe agrupar por proveedor/region y sugerir consolidaciones para Mercurius |
| 5 | Articulos de Alemania/Europa | El articulo tiene esa info asociada (depende del proveedor primario) | Podemos usar dimProveedor para filtrar por pais de origen |
| 6 | Cambio de proveedor | Calidad es esencial (productos medicos descartables), pero tambien lead time y costo | Futuro: analisis comparativo de proveedores |
| 7 | Stock ETAFPA | Deposito tercerizado que YA NO se esta contratando | **Stock ETAFPA puede ignorarse** - simplifica el modelo |
| 8 | Lead times | Fijos por proveedor; pueden variar por tipo de embarque (barco, aereo) | Necesitamos tabla de lead time por proveedor con variantes por modalidad |
| 9 | En camino | En el ERP corresponde al stock proyectado | El modelo ya tiene `Stock Proyectado` = Existencia + Compras en proceso |

## Analisis del modelo Power BI existente (post-entrevista)

### Medidas ya disponibles y relevantes
| Medida | Formula actual | Estado |
|--------|---------------|--------|
| `Stock Existencia` | SUM de factStockEPSA donde Stock Estado in {"existencia", "stkaf"} | OK |
| `Stock Compras` | SUM(factComprasEnProceso[CompraEP Cantidad]) | OK |
| `Stock Proyectado` | Stock Existencia + Stock Compras | OK |
| `Consumo Promedio por Mes Activo` | Promedio de consumo en meses con movimiento | OK |
| `Cobertura Meses sobre Existencia` | Stock Existencia / Consumo Promedio por Mes Activo | OK |
| `Lead Time Promedio Dias` | AVERAGE de lead time historico de recepciones | **Limitado** - es global, no por proveedor |

### Gaps actualizados (post-entrevista)
| Dato necesario | Disponible en PBIX | Prioridad |
|----------------|-------------------|-----------|
| Lead time por proveedor / modalidad de embarque | NO | **ALTA** - Necesita maestro o vista en EPSA_BI |
| Medida "A pedir" recomendado | NO | **ALTA** - Nueva medida DAX |
| Campo editable "A pedir ajustado" | NO | **ALTA** - Parametro o campo de entrada en reporte |
| Filtro de articulos "Compras al Exterior" | NO | **MEDIA** - Puede derivarse de dimProveedor[País Nombre] != 'Uruguay' o lista manual |
| Minimos de compra / MOQ por articulo | NO | **MEDIA** - Agregar a dimArticulo o tabla auxiliar |
| Stock ETAFPA | No aplica | **ELIMINADO** - Ya no se contrata |
| Alerta cobertura < lead time aware | PARCIAL | **MEDIA** - Usar Cobertura vs Lead Time por proveedor |
| Consolidacion por origen (Mercurius) | NO | **MEDIA** - Reporte debe agrupar por pais/proveedor |

## Diseno propuesto del reporte "Compras al Exterior"

### Pagina 1: Panel de decision (Rosana)
**Objetivo:** Reemplazar la hoja "actual" del Excel

**Filtros:**
- Proveedor / Pais de origen
- Articulo
- Tipo de embarque (barco/aereo) - cuando tengamos lead time por modalidad

**Tabla principal:**
| Columna | Origen |
|---------|--------|
| Codigo | dimArticulo |
| Descripcion | dimArticulo |
| Proveedor | dimProveedor |
| Pais Origen | dimProveedor[País Nombre] |
| Consumo Promedio Mensual | Medida `Consumo Promedio por Mes Activo` |
| Stock Existencia | Medida `Stock Existencia` |
| Stock Proyectado | Medida `Stock Proyectado` |
| Cobertura Meses (Existencia) | Medida `Cobertura Meses sobre Existencia` |
| Lead Time (dias) | NUEVO: Lead time por proveedor/modalidad |
| Diferencia Cobertura - Lead Time | NUEVO: `Cobertura - Lead Time` |
| **A pedir (sugerido)** | **NUEVO: Medida DAX** |
| **A pedir (ajustado)** | **NUEVO: Campo editable** |
| Alerta | NUEVO: Visual conditional formatting si Diferencia < 0 |

**Visualizaciones adicionales:**
- KPI: Cantidad de articulos con alerta de compra
- Grafico: Stock proyectado vs Necesidad por proveedor
- Timeline: Fechas estimadas de llegada de compras en proceso

### Pagina 2: Consolidacion Europa (Mercurius)
**Objetivo:** Optimizar cargas desde Alemania/Europa

- Tabla filtrada a proveedores europeos (Alemania, Italia, etc.)
- Agrupacion por proveedor
- Suma de "A pedir" por proveedor
- Indicador de viabilidad de consolidacion (volumen/peso estimado)

### Pagina 3: Analisis de consumo y cobertura
**Objetivo:** Tendencias y proyecciones

- Evolucion mensual de consumo (ultimos 24 meses)
- Proyeccion de stock con y sin compras en curso
- Ranking de criticidad (articulos con menor cobertura)

## Medidas DAX necesarias

### 1. Lead Time por Proveedor (dias)
```dax
Lead Time Proveedor Dias = 
AVERAGEX(
    VALUES(factRecepcionesHistoria[OC Proveedor]),
    CALCULATE([Lead Time Promedio Dias])
)
```
*Nota: Esto es una aproximacion. Idealmente necesitamos una tabla maestra con lead time por proveedor y modalidad.*

### 2. Cobertura sobre Stock Proyectado
```dax
Cobertura Meses Proyectado = 
DIVIDE(
    [Stock Proyectado],
    [Consumo Promedio por Mes Activo]
)
```

### 3. Diferencia Cobertura vs Lead Time
```dax
Diferencia Cobertura Lead Time = 
[Cobertura Meses Proyectado] - DIVIDE([Lead Time Proveedor Dias], 30)
```

### 4. Cantidad Recomendada a Pedir (base)
```dax
A Pedir Sugerido = 
VAR ConsumoMensual = [Consumo Promedio por Mes Activo]
VAR CoberturaObjetivo = DIVIDE([Lead Time Proveedor Dias], 30) + 1 // +1 mes seguridad
VAR Necesidad = ConsumoMensual * CoberturaObjetivo
VAR StockProy = [Stock Proyectado]
VAR Resultado = Necesidad - StockProy
RETURN
    MAX(0, Resultado)
```
*Nota: La formula exacta debe validarse con Rosana. El "+1 mes seguridad" es hipotetico.*

## Decisiones de alcance aprobadas

| Decision | Estado |
|----------|--------|
| **Lead time** | Usar medida historica del modelo PBIX (`Lead Time Promedio Dias`). Mas fiable que el Excel. Si hay mucha diferencia, se evaluara inicializar atributo en dimProveedor desde Excel para medir diferencia. |
| **Consolidacion Mercurius** | **FUERA DE ALCANCE** por ahora. Enfoque en planificar compras por proveedor. |
| **"A pedir"** | Se trabajara sobre casos de uso con Rosana para definir y validar el calculo. No se crea medida DAX sin aprobacion previa. |
| **Cambios al modelo PBIX** | Cada cambio requiere aprobacion explicita del usuario antes de implementarse. |
| **Compras al exterior** | Definidas como articulos cuyo proveedor tiene `dimProveedor[País Nombre] != 'Uruguay'`. |
| **Paginas del reporte** | Se construiran paso a paso segun lo requiera el departamento de compras. Page 2 (Mercurius) no es necesaria por ahora. |

## Proximos pasos aprobados

1. **Validar criterio "Compras al Exterior"** - Consultar modelo live para verificar que proveedores no-uruguayos existen y cuantos articulos cubren
2. **Disenar wireframe Page 1: Decision Panel** - Presentar para aprobacion antes de construir
3. **Construir Page 1 paso a paso** - Implementar solo despues de aprobacion del diseno
4. **Trabajar casos de uso con Rosana** para definir calculo "A pedir"
5. **Evaluar nuevas medidas DAX** una por una con aprobacion previa
