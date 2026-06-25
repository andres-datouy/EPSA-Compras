# Especificación de Visualizaciones Power BI
## Compras EPSA - Storytelling para Dirección

**Formato:** PBIR (Live Connection a SSAS Compras_EPSA)
**Páginas a crear:** 5 nuevas + 1 enhancement
**Tema:** Innovate (built-in)

---

## Página 1: "Panorama Ejecutivo"

**Objetivo:** Vista ejecutiva de un vistazo - cuánto gastamos, en qué, con quién
**Audiencia:** Dirección / Gerencia General
**Layout:** 16:9, filtros en panel lateral

### Visuales

| # | Tipo | Posición | Medidas | Dimensión/Agrupación |
|---|------|----------|---------|---------------------|
| 1.1 | Card (4 KPIs) | Top row, 4 cards | Gastado USD, % Gastado Exterior, Artículos Críticos, Proveedores Activos | - |
| 1.2 | Line Chart | Left half, mid | Eje X: Calendario[Año Fiscal], Valores: Gastado USD | Año Fiscal |
| 1.3 | Bar Chart (horizontal) | Right half, mid | Valores: Gastado USD, Eje Y: dimProveedor[País Nombre] (Top 8) | País |
| 1.4 | Donut Chart | Bottom left | Valores: Gastado USD, Leyenda: dimArticulo[Clase Nombre] (Top 8) | Clase |
| 1.5 | Filled Map | Bottom right | Ubicación: dimProveedor[País Nombre], Valores: Gastado USD | País |
| 1.6 | Card multi-row | Top-right small | Lead Time Promedio Dias, On-Time % | - |

### Filtros de Página
- Calendario[Año Fiscal] (slicer, multi-select, default: últimos 3 años)
- dimProveedor[País Nombre] (slicer opcional)

### Formato
- KPIs con indicadores de tendencia (vs año anterior)
- Colores: Verde = local (UY), Azul = exterior
- Formato moneda: USD con separador de miles

---

## Página 2: "Alertas y Riesgo"

**Objetivo:** Identificar artículos en riesgo, priorizar acción
**Audiencia:** Jefe de Compras / Compras Exteriores
**Layout:** Filtros arriba, tabla central, gráficos de apoyo

### Visuales

| # | Tipo | Posición | Medidas | Dimensión/Agrupación |
|---|------|----------|---------|---------------------|
| 2.1 | Card (3 KPIs) | Top row | Artículos Críticos, Artículos en Riesgo, Artículos Sin Stock con Demanda | - |
| 2.2 | Scatter Plot | Center-left | Eje X: Stock Existencia, Eje Y: Stock Mínimo, Color: Stock Debajo Mínimo (CRÍTICO/OK), Tamaño: Consumo Promedio por Mes Activo | Artículo Código |
| 2.3 | Table w/conditional formatting | Center-right | Columnas: Artículo Código, Artículo Nombre, Stock Existencia, Stock Mínimo, Cobertura Meses sobre Existencia, Lead Time Promedio Dias, Stock Debajo Mínimo | Artículo (ordenado por Gap Stock ASC) |
| 2.4 | Clustered Bar | Bottom | Eje Y: dimProveedor[País Nombre], Valores: Avg Cobertura Meses sobre Existencia, Avg (Lead Time Promedio Dias / 30) | País |
| 2.5 | Histogram (bar) | Bottom-right | Distribución de Cobertura Meses sobre Existencia en bins (0-1, 1-3, 3-6, 6-12, 12+) | Bins |

### Formato Condicional (Tabla 2.3)
- Stock Debajo Mínimo = "CRÍTICO" → fondo rojo, texto blanco
- Cobertura < Lead Time meses → texto rojo
- Stock Existencia = 0 → texto rojo bold

### Filtros de Página
- dimArticulo[Clase Nombre] (slicer)
- dimProveedor[País Nombre] (slicer)
- Stock Debajo Mínimo (checkbox: CRÍTICO / OK)

---

## Página 3: "Eficiencia de Compras"

**Objetivo:** Evaluar performance de compra - lead times, precios, estacionalidad
**Audiencia:** Compras / Analista
**Layout:** 2x2 grid con gráficos de tendencia

### Visuales

| # | Tipo | Posición | Medidas | Dimensión/Agrupación |
|---|------|----------|---------|---------------------|
| 3.1 | Multi-line Chart | Top-left | Eje X: Calendario[Año Fiscal], Valores: Lead Time Promedio Dias, Series: dimProveedor[País Nombre] (Top 5 países) | País, Año |
| 3.2 | Area Chart | Top-right | Eje X: Calendario[Fiscal Month], Valores: Consumo Cantidad Absoluta, Small Multiples: Calendario[Año Fiscal] | Mes, Año |
| 3.3 | Line Chart | Mid-left | Eje X: Calendario[Año Fiscal Trimestre Fiscal], Valores: Precio Unitario Promedio USD (con filtro Top 5 artículos) | Trimestre |
| 3.4 | Matrix | Bottom-full | Filas: dimProveedor[Proveedor Nombre], Columnas: -, Valores: Lead Time Promedio Dias, On-Time %, Gastado USD, Cantidad Recepciones | Proveedor |
| 3.5 | Card (2) | Top-right small | Lead Time CV, On-Time % | - |

### Formato Matrix (3.4)
- On-Time %: barra de datos condicional (verde > 85%, amarillo 70-85%, rojo < 70%)
- Lead Time Dias: data bar proporcional
- Gastado USD: formato moneda

### Filtros de Página
- Calendario[Año Fiscal] (slicer, rango)
- dimArticulo[Clase Nombre] (slicer)

---

## Página 4: "Oportunidades"

**Objetivo:** Identificar ahorros, capital inmovilizado, optimizaciones
**Audiencia:** Jefe de Compras / Dirección
**Layout:** KPIs arriba, tablas de detalle

### Visuales

| # | Tipo | Posición | Medidas | Dimensión/Agrupación |
|---|------|----------|---------|---------------------|
| 4.1 | Card (3 KPIs) | Top row | Stock Exceso Valor USD, Stock Muerto COUNT, Demanda Pendiente | - |
| 4.2 | Waterfall Chart | Center-top | Categorías: Stock Existencia → + Stock Compras → - Consumo Planificado → - Demanda Pendiente → = Stock Proyectado | - |
| 4.3 | Combo Chart (Pareto) | Center | Eje X: Artículo Código (top 50 por gasto), Columnas: Gastado USD, Línea: % Acumulado | Artículo |
| 4.4 | Table "Stock Excesivo" | Bottom-left | Artículo Código, Artículo Nombre, Stock Existencia, Consumo Promedio por Mes Activo, Cobertura Meses, Stock Exceso Valor USD | Filtrar: Cobertura > 12 |
| 4.5 | Table "Stock Muerto" | Bottom-right | Artículo Código, Artículo Nombre, Stock Existencia, Última Recepción Fecha | Filtrar: artículos sin consumo 12m+ con stock > 0 |

### Formato
- Waterfall: colores verde (positivo), rojo (negativo), azul (total)
- Pareto: línea de 80% marcada en rojo punteado
- Tablas: máximo 20 filas visibles, scroll

### Filtros de Página
- dimArticulo[Clase Nombre] (slicer)
- Calendario[Año Fiscal] (para el Pareto)

---

## Página 5: "Decision Panel - Compras Exterior" (Enhancement)

**Objetivo:** Herramienta de decisión diaria para Rosana
**Audiencia:** Compras Exteriores (Rosana)
**Estado:** Existe parcialmente. Agregar:

### Mejoras a Implementar

| # | Mejora | Implementación |
|---|--------|---------------|
| 5.1 | Columna "A Pedir Sugerido" | Medida DAX: MAX(0, (Consumo Promedio por Mes Activo * (Lead Time Promedio Dias/30 + 1)) - Stock Proyectado) |
| 5.2 | Semáforo de alerta | Conditional formatting: CRÍTICO (rojo) / ATENCIÓN (amarillo) / OK (verde) |
| 5.3 | Sparkline consumo | Columna con gráfico inline de últimos 12 meses |
| 5.4 | Badge lead time | Icono del país del proveedor + lead time en días |

### Nueva Medida DAX Requerida
```
A Pedir Sugerido = MAX(0, 
    [Consumo Promedio por Mes Activo] * (DIVIDE([Lead Time Promedio Dias], 30, 0) + 1) - [Stock Proyectado]
)
```

### Alerta Cobertura
```
Alerta Cobertura = 
VAR Cobertura = [Cobertura Meses sobre Existencia]
VAR LT_Meses = DIVIDE([Lead Time Promedio Dias], 30, 0)
RETURN
SWITCH(TRUE(),
    Cobertura < LT_Meses, "CRÍTICO",
    Cobertura < LT_Meses + 1, "ATENCIÓN",
    "OK"
)
```

---

## Notas de Implementación

### Orden de Implementación
1. Página 1 (Panorama) - más impacto para Dirección
2. Página 2 (Alertas) - operativa inmediata
3. Página 4 (Oportunidades) - savings visibles
4. Página 3 (Eficiencia) - análisis profundo
5. Página 5 (Decision Panel) - enhancement incremental

### Medidas Nuevas a Crear (además de las 12 ya desplegadas)
- `A Pedir Sugerido` - para Página 5
- `Alerta Cobertura` - para Páginas 2 y 5
- `Gastado Acumulado %` - para Pareto en Página 4
- `Cobertura Bins` - para histograma en Página 2

### Compatibilidad
- Todas las medidas están en SSAS (Live Connection)
- No se requiere importar datos
- Formato PBIR soporta todos los tipos de visual mencionados
- Tema "Innovate" (built-in) para colores consistentes

### Performance
- Las medidas de conteo (FILTER + VALUES) iteran sobre ~3,367 artículos
- Tiempo de respuesta esperado: 2-5 segundos por visual
- Para tabla con 3,367 filas: usar Top N + scroll
- Cache de SSAS se calienta con primer query
