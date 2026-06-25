# De Reactivo a Estratégico: La Transformación de Compras EPSA
## Informe para Dirección - Insights y Hoja de Ruta

**Fecha:** Mayo 2026
**Elaborado por:** Área de Business Intelligence
**Datos:** 49,779 recepciones de compra (2009-2026) | 3,367 artículos | 155+ proveedores activos

---

## Resumen Ejecutivo

EPSA gestiona un volumen de compras histórico de **USD 214.6 millones** a través de una red de más de 150 proveedores en 22 países. El análisis de nuestros datos revela tres hallazgos críticos:

1. **46% de nuestro gasto proviene del exterior**, con lead times que van de 50 a 150 días según el país
2. **845 artículos están en riesgo de quiebre de stock** hoy, con cobertura insuficiente para cubrir su lead time
3. **USD 1.15 millones están inmovilizados en stock excesivo** (>12 meses de cobertura)

Este informe presenta los datos, las oportunidades identificadas, y una hoja de ruta con machine learning para transformar nuestra gestión de compras.

---

## Capítulo 1: El Panorama

### ¿Cuánto gastamos y en qué?

| Año Fiscal | Gastado USD | Proveedores Activos |
|-----------|-------------|-------------------|
| FY 2021 | 4,669,826 | 144 |
| FY 2022 | 7,821,114 | 151 |
| FY 2023 | 32,145,260 | 155 |
| FY 2024 | 3,713,041 | 131 |
| FY 2025 | 8,640,408 | 142 |
| FY 2026 (parcial) | 2,059,975 | 97 |

**Insight clave:** FY2023 tuvo un pico de gasto excepcional (USD 32M), posiblemente por acumulación de stock post-pandemia o proyectos especiales. El gasto normalizado se sitúa entre USD 4-9M anuales.

### Top 10 Categorías por Gasto (USD histórico)

| Categoría | Gasto USD | % del Total |
|-----------|-----------|-------------|
| Art. Limpieza | 62,322,147 | 29.0% |
| Indicador Biológico | 30,887,103 | 14.4% |
| Pegamento | 25,512,463 | 11.9% |
| Válvula de Retención | 23,052,622 | 10.7% |
| Film de Polietileno | 12,852,972 | 6.0% |
| Alambre p/Mandril | 12,181,461 | 5.7% |
| Papel | 5,514,346 | 2.6% |
| Sustancia Química | 4,808,579 | 2.2% |
| Cánula | 2,965,533 | 1.4% |
| PVC | 2,301,474 | 1.1% |

**Insight clave:** Las 4 primeras categorías concentran el **66% del gasto total**. Esto significa alta concentración de categoría, lo que genera poder de negociación pero también dependencia.

---

## Capítulo 2: El Riesgo

### Dependencia del Exterior

| País | Gasto USD | Lead Time Promedio | Recepciones |
|------|-----------|-------------------|-------------|
| Uruguay | 116,747,547 | 10 días | 42,696 |
| Reino Unido | 25,411,257 | 128 días | 42 |
| Alemania | 25,332,207 | 93 días | 3,721 |
| Finlandia | 17,618,995 | 122 días | 143 |
| China | 1,427,243 | 121 días | 991 |
| EEUU | 1,242,694 | 85 días | 330 |
| Brasil | 1,222,947 | 77 días | 902 |

**Insight clave:** El 46% del gasto viene del exterior. Los proveedores de Alemania y Reino Unido representan el mayor gasto exterior, pero sus lead times (93-128 días) nos obligan a planificar con 4-5 meses de anticipación. Malasia tiene el peor lead time: **150 días**.

### Alerta de Stock

| Indicador | Valor | Significado |
|-----------|-------|-------------|
| Artículos CRÍTICOS | **263** | Stock por debajo del mínimo definido |
| Artículos en Riesgo | **845** | Cobertura menor al lead time del proveedor |
| Artículos Sin Stock con Demanda Pendiente | **28** | Producción potencialmente detenida |
| Stock Muerto | **1,430** | Artículos con stock pero sin consumo en 12 meses |

**Insight clave:** De los 3,367 artículos del catálogo, el **25% está en riesgo** (845 artículos). De ellos, 263 ya están por debajo del stock mínimo. Y hay 1,430 artículos que no se consumen hace un año pero siguen ocupando espacio en depósito: **posible obsolescencia**.

### Riesgo por Concentración de Proveedores

- **155 proveedores** activos en los últimos años
- La base se mantiene estable pero hay señales de contracción (97 activos en FY2026 parcial)
- El lead time promedio global es **22 días**, pero con alta dispersión (CV = 2.11)

**Insight clave:** Un CV de 2.11 significa que la variabilidad del lead time es el doble del promedio. Esto hace extremadamente difícil calcular stock de seguridad con fórmulas estáticas.

---

## Capítulo 3: La Eficiencia

### ¿Qué tan bien estamos comprando?

| Métrica | Valor | Interpretación |
|---------|-------|---------------|
| On-Time Delivery | **79%** | 1 de cada 5 pedidos llega fuera de plazo |
| Lead Time CV | **2.11** | Alta variabilidad, difícil de predecir |
| Recepciones totales | **49,779** | Base estadística robusta (16 años) |

### Lead Time por País de Origen

```
Uruguay       ████████░░░░░░░░░░░░░░░░░░░░░  10 días
Argentina     ████████████████████░░░░░░░░░░░  53 días
Bélgica       ██████████████████████░░░░░░░░░  61 días
Brasil        ████████████████████████████░░░  77 días
EEUU          ███████████████████████████████  85 días
Italia        ██████████████████████████████░  91 días
Alemania      ███████████████████████████████  93 días
China         █████████████████████████████████ 121 días
Finlandia     █████████████████████████████████ 122 días
India         █████████████████████████████████ 124 días
Gran Bretaña  █████████████████████████████████ 128 días
Malasia       █████████████████████████████████ 150 días
```

**Insight clave:** La diferencia entre proveedor local (10 días) e internacional (90-150 días) es de 10-15x. Esto obliga a estrategias de stock diferenciadas por origen.

### Top 10 Artículos por Gasto Histórico

| Artículo | Gasto USD |
|----------|-----------|
| INDICADOR BIOLÓGICO 3M 1264 | 25,928,028 |
| TOALLAS 20x26 BLANCAS | 25,988,247 |
| VÁLVULA BESPAK BK333308S | 23,024,231 |
| BOSTIK PA5050E | 15,802,808 |
| TOALLAS HIGIÉNICAS PAPEL | 14,831,634 |
| ALAMBRE ACERO SELDIN | 11,979,267 |
| FILM PA/PE 322MM | 10,982,950 |
| TIVOFIX 3140 | 9,606,530 |
| CLEAN BY PEROXY | 7,336,623 |
| ALVFRESH | 5,813,254 |

**Insight clave:** Los top 10 artículos concentran USD 151M (70% del gasto). Esto es una oportunidad enorme para negociación de volumen, contratos marco, y consolidación de pedidos.

---

## Capítulo 4: La Oportunidad

### Capital Inmovilizado

| Oportunidad | Valor Estimado |
|-------------|---------------|
| Stock Excesivo (>12 meses cobertura) | **USD 1,154,708** |
| Stock Muerto (0 consumo 12m+, stock > 0) | **1,430 artículos** |
| Consolidación de pedidos por proveedor | **Por analizar** |

**Insight clave:** Hay más de USD 1.15M en stock que no se necesitará en los próximos 12 meses. Parte puede ser obsolescencia (los 1,430 artículos sin consumo), parte puede reubicarse o devolver a proveedor.

### Pipeline de Demanda Actual

| Concepto | Cantidad |
|----------|----------|
| Stock Existencia (unidades) | 5,652,514 |
| Stock Mínimo Requerido | 2,451,206 |
| Gap (Stock - Mínimo) | 3,201,307 |
| Demanda Pendiente de Planificar | 3,150,183 |
| Consumo Promedio Mensual Activo | 9,053,873 |

**Insight clave:** El gap positivo de 3.2M unidades a nivel agregado oculta problemas de distribución: 263 artículos están en CRÍTICO y 845 en riesgo. El agregado esconde la concentración del problema.

---

## Capítulo 5: El Futuro con Machine Learning

### Propuesta de Desarrollo ML para EPSA

Con los datos disponibles (1.7M+ registros de consumo diarios, 50K recepciones de 16 años, catálogo de 3,367 artículos), EPSA tiene la base para implementar capacidades predictivas de alto impacto.

### ML-1: Pronóstico de Demanda (ALTA PRIORIDAD)

| Aspecto | Detalle |
|---------|---------|
| **Qué predice** | Demanda mensual por artículo para los próximos 3-6 meses |
| **Datos** | factConsumoHistoria (1.7M registros, 5 años) |
| **Modelo** | Prophet (Facebook) o Azure ML AutoML |
| **Frecuencia** | Entrenamiento mensual |
| **Output** | Tabla `factDemandForecast` con predicción + intervalo de confianza |
| **Valor** | Reducir compras reactivas en 30-40%, anticipar necesidades |

**¿Por qué ahora?** Tenemos 5 años de historia diaria con suficiente volumen para modelos robustos. La variabilidad de consumo (que hoy hace difícil planificar manualmente) es exactamente lo que estos modelos manejan mejor.

### ML-2: Predicción de Lead Time (ALTA PRIORIDAD)

| Aspecto | Detalle |
|---------|---------|
| **Qué predice** | Días de entrega por proveedor/artículo/ruta |
| **Datos** | factRecepcionesHistoria (50K registros, 16 años) |
| **Modelo** | XGBoost o regresión con features (país, clase, mes, valor) |
| **Frecuencia** | Entrenamiento trimestral |
| **Output** | Tabla `factLeadTimePrediction` con lead time estimado + confianza |
| **Valor** | Stock de seguridad dinámico, reducir over/under-ordering |

**¿Por qué importa?** El CV de lead time actual (2.11) muestra que un promedio estático no sirve. Un modelo puede capturar patrones estacionales, por país, y por proveedor.

### ML-3: Alerta Temprana de Quiebre (MEDIA PRIORIDAD)

| Aspecto | Detalle |
|---------|---------|
| **Qué predice** | Probabilidad de quiebre de stock a 30/60/90 días |
| **Requiere** | ML-1 + ML-2 como inputs |
| **Modelo** | Clasificación binaria |
| **Output** | Probabilidad por artículo + semáforo visual |
| **Valor** | Prevenir paradas de producción, compras proactivas |

### ML-4: Punto de Reorden Óptimo (MEDIA PRIORIDAD)

| Aspecto | Detalle |
|---------|---------|
| **Qué calcula** | ROP y EOQ óptimo por artículo |
| **Requiere** | ML-1 + ML-2 (distribuciones, no promedios) |
| **Modelo** | Optimización estocástica de inventario |
| **Output** | Stock mínimo sugerido vs actual |
| **Valor** | Sugerencias automáticas de compra, capital optimizado |

### ML-5: Scoring de Proveedores (QUICK WIN)

| Aspecto | Detalle |
|---------|---------|
| **Qué mide** | Score 0-100 por proveedor |
| **Dimensiones** | On-Time %, consistencia de LT, estabilidad de precio, fill rate |
| **Requiere** | Solo datos existentes (no ML, es analítica) |
| **Valor** | Selección data-driven de proveedores, base para negociación |

---

## Hoja de Ruta Recomendada

| Fase | Entregable | Plazo | Dependencia |
|------|-----------|-------|-------------|
| **Fase 1** | 5 páginas Power BI (storytelling ejecutivo) | 2-3 semanas | Ninguna (inmediato) |
| **Fase 2** | ML-1: Pronóstico de Demanda (pipeline Python) | 3-4 semanas | Ambiente Python/Azure ML |
| **Fase 3** | ML-2: Predicción de Lead Time | 2-3 semanas | Infraestructura Fase 2 |
| **Fase 4** | ML-5: Scoring de Proveedores (quick win) | 1 semana | Ninguna (paralelo) |
| **Fase 5** | ML-3: Alerta Temprana de Quiebre | 3-4 semanas | Fases 2+3 |
| **Fase 6** | ML-4: Punto de Reorden Óptimo | 2-3 semanas | Fases 2+3 |

### Inversión Estimada

| Concepto | Costo | ROI Esperado |
|----------|-------|-------------|
| Desarrollo Power BI (5 páginas) | Interno | Decisiones informadas desde día 1 |
| Infraestructura ML (Azure/local) | USD 500-2000/mes | Reducción 30% en stockouts |
| Desarrollo modelos ML | Interno o consultoría | Optimización USD 1M+ en stock inmovilizado |

---

## Próximos Pasos Inmediatos

1. **Aprobar** la narrativa y prioridades de visualización
2. **Implementar** las 5 páginas Power BI con medidas ya desplegadas en SSAS
3. **Definir** ambiente para ML (Azure ML vs Python local)
4. **Prototipo** ML-1: explorar datos de consumo y validar factibilidad

---

## Anexo: Medidas DAX Desplegadas

Las siguientes 12 medidas fueron desplegadas al modelo SSAS (Compras_EPSA) y están listas para usar en Power BI:

| Medida | Tabla | Valor Actual |
|--------|-------|-------------|
| Gastado USD | Medidas_Compras | 214,591,105 |
| Gastado MO | Medidas_Compras | (en moneda original) |
| Gastado Exterior USD | Medidas_Compras | 97,843,558 |
| % Gastado Exterior | Medidas_Compras | 46% |
| Precio Unitario Promedio USD | Medidas_Compras | (promedio) |
| Lead Time CV | Medidas_Compras | 2.11 |
| On-Time % | Medidas_Compras | 79% |
| Artículos en Riesgo | Medidas_Stock | 845 |
| Artículos Críticos | Medidas_Stock | 263 |
| Artículos Sin Stock con Demanda | Medidas_Stock | 28 |
| Stock Muerto COUNT | Medidas_Stock | 1,430 |
| Stock Exceso Valor USD | Medidas_Stock | 1,154,708 |
