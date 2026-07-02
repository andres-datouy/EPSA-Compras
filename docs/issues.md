# Issues / Seguimiento de Requerimientos

## Issue #1: Reporte Compras al Exterior — Panel de Decision (Rosana)

**Status:** En implementacion — Page 1 construida, medidas implementadas, pendiente validacion con Rosana
**Labels:** `enhancement`, `power-bi`, `compras-exterior`, `in-progress`
**Assignee:** por definir

### Descripcion
Rosana del departamento de Compras utiliza dos archivos Excel para decidir las compras al exterior. Se requiere construir un reporte en Power BI que centralice la informacion, automatice los calculos y ahorre horas de trabajo manual.

### Alcance aprobado
- [x] Criterio "Compras al Exterior": articulos cuyo proveedor tiene `dimProveedor[País Nombre] != 'Uruguay'`
- [x] Lead time: usar medida historica del modelo PBIX (`Lead Time Promedio Dias`)
- [x] ETAFPA: fuera de alcance (deposito discontinuado)
- [x] Consolidacion Mercurius: fuera de alcance por ahora
- [x] Calculo "A pedir": se trabajara sobre casos de uso con Rosana antes de implementar
- [x] Cada cambio al modelo PBIX requiere aprobacion explicita

### Implementado
- [x] Denormalizacion de proveedor en `dimArticulo` (campos: ProveedorArticulo, ProveedorArticuloNombre, ProveedorPais, ProveedorPaisNombre)
- [x] Fix de auto-exist entre `factRecepcionesHistoria` y `factConsumoHistoria`
- [x] Medidas modificadas con `COALESCE(..., 0)`: Stock Existencia, Stock Compras, Stock Proyectado, Consumo Promedio por Mes Activo, Cobertura Meses sobre Existencia
- [x] Medida `Diferencia Cobertura Lead Time` — compara cobertura actual vs lead time del proveedor
- [x] Medida `Alerta Cobertura` — flag visual: "PEDIR", "Atencion", "OK"
- [x] Medida `Cobertura Meses sobre Existencia + Proyectado`
- [x] Formato condicional en tabla (rojo/amarillo/verde)
- [x] Tabla "C.Ext. Proveedor - Articulo" funcional con 19 columnas

### Pendiente
- [ ] Validar numeros con Rosana (comparar Excel vs PBIX)
- [ ] Ajustar umbrales de alerta con Rosana
- [ ] Agregar KPI cards
- [ ] Definir e implementar calculo "A pedir"
- [ ] Agregar grafico de tendencia de consumo (drill-through)

### Proximos pasos
- [ ] Validacion con Rosana en caso de uso real
- [ ] Definir e implementar calculo "A pedir"
- [ ] Evaluar agregados de KPI y drill-through
- [ ] Guardar version estable del PBIX en SharePoint

---

## Issue #2: Documentacion del Modelo de Datos

**Status:** Completo
**Labels:** `documentation`

### Descripcion
Se extrajo y documento el esquema completo del modelo Power BI `Compras EPSA - Stock.pbix`.

### Entregables
- [x] `docs/modelo_datos.md` — Tablas, columnas, medidas, relaciones, fuentes de datos
- [x] `pbix/model_export.json` — Exportacion programatica del modelo via AMO
- [x] `docs/requerimiento_compras_exterior.md` — Requerimiento completo con entrevista a Rosana

---

## Issue #3: Integracion GitHub

**Status:** Completo
**Labels:** `setup`

### Descripcion
Repositorio Git configurado y sincronizado con GitHub (epsa-acunarro/EPSA-Compras).

### Entregables
- [x] Repo remoto en GitHub (epsa-acunarro)
- [x] Remote origin configurado
- [x] Push de la rama master
- [x] GitHub Projects para seguimiento

---

## Issue #4: Arquitectura de Despliegue y Refresh Automatizado

**Status:** Completo ✅
**Labels:** `architecture`, `ssas`, `deployment`

### Descripcion
Se implementó la arquitectura SSAS Tabular + Live Connection con capa de staging intermedia y refresh automatizado via SQL Agent.

### Implementado
- [x] SSAS Tabular deployed en 192.168.2.47:2383 (Compras_EPSA)
- [x] Staging layer creada en staging_compras (192.168.2.47:1435)
- [x] 8 stored procedures de refresco (FULL/INCREMENTAL)
- [x] SQL Agent jobs configurados (2x dia)
- [x] Power BI report migrado a formato PBIR con Live Connection
- [x] Modelo semantico sincronizado entre staging y SSAS
- [x] Validacion end-to-end: Fuentes → Staging → SSAS → Report

### Arquitectura final
```
192.168.2.7 (Nodum/EPSA_BI)
       ↓ (linked server [192.168.2.7])
192.168.2.47:1435 (staging_compras)
       ↓ (SQL queries)
192.168.2.47:2383 (SSAS Compras_EPSA)
       ↓ (Live Connection)
Power BI Desktop (EPSA-Compras.pbip)
```

### Pendiente
- [ ] Configurar gateway para refresh desde Power BI Service (futuro)
- [ ] Evaluar Power BI Service ($50/month) para distribucion web

---

## Issue #15: Herramientas de Mantenimiento del Perfil PrdImport

**Status:** Backlog
**Labels:** `enhancement`, `data-management`, `compras-exterior`
**Prioridad:** Media

### Descripcion
Scripts y herramientas para gestionar el ciclo de vida de los articulos asignados al perfil de compra `PrdImport` (Produccion Importacion). El perfil se inicializo con 1.275 articulos combinando 6 criterios.

### Sub-issues

#### 15.1 Depuracion por inactividad de consumo
**Objetivo:** Quitar componentes de formulas y otros insumos que no se consumen por un periodo prudente.

**Criterios propuestos:**
- Articulos sin consumo en los ultimos 12 meses
- Que no tengan stock existente ni compras en proceso
- Que no esten en formulas de produccion activas (factConsumoPlanificado reciente)
- Excepcion: articulos marcados como "critico" o con observacion manual

**Entregable:** Script SQL/PowerShell que identifique candidatos a baja, genere reporte y permita confirmar la exclusion.

#### 15.2 Depuracion por baja de equipos/herramientas
**Objetivo:** Quitar repuestos o insumos de maquinas o herramientas que se dieron de baja.

**Criterios propuestos:**
- Repuestos (clase REPUESTOS BOMBAS, REP MOTORES&MAQUINAS, etc.) cuyo equipo asociado fue dado de baja
- Herramientas de produccion (tubos de vidrio, cuchillas, etc.) sin consumo >18 meses
- Cruce con registro de activos/equipos del ERP si existe

**Entregable:** Script que cruce datos de consumo historico con el perfil activo y sugiera bajas.

#### 15.3 Mantenimiento proactivo y sugerencias de alta
**Objetivo:** Detectar y sugerir articulos que deberian estar en el perfil pero no estan, y alertar sobre inconsistencias.

**Deteccion automatica:**
- Articulos nuevos en dimArticulo con proveedor exterior + consumo reciente que no estan en el perfil
- Articulos en formulas de produccion nuevas que no estan dados de alta
- Articulos con Stock Minimo > 0 recientemente configurados
- Alertas de inconsistencia: articulo en perfil pero con proveedor local, sin consumo y sin stock

**Entregable:** Pagina de dashboard "Gestion de Lista" y/o script periodico con reporte de sugerencias.

### Notas tecnicas
- Los scripts deben generar reportes de candidatos (no ejecutar bajas automaticas)
- Toda baja debe registrarse en la bitacora (`articulo_bitacora_compra`)
- La frecuencia sugerida de ejecucion es mensual
- Considerar integracion con el campo `MonitoreoComprasExterior` propuesto en ERP

---

## Issue #16: Estrategia de Deploy PBIP → PBIX

**Status:** Backlog
**Labels:** `deployment`, `power-bi`, `documentation`
**Prioridad:** Alta

### Descripcion
Definir y documentar una estrategia para generar un archivo PBIX distribuible a partir del proyecto PBIP (PBIR + SemanticModel Live Connection a SSAS).

### Pendiente
- [ ] Evaluar opciones: `pbixray`, `pbi-tools`, `tabular-editor`, export manual
- [ ] Documentar flujo de generacion del PBIX
- [ ] Automatizar el proceso con script
- [ ] Validar que el PBIX resultante funcione standalone (sin SSAS)
- [ ] Definir cadencia de generacion (manual vs CI/CD)

---

## Issue #17: Documentacion de Medidas DAX del Modelo

**Status:** Completo ✅
**Labels:** `documentation`, `dax`, `semantic-model`

### Descripcion
Generar documentacion completa para cada medida del modelo semantico, incluyendo formula, descripcion, uso, dependencias y ejemplos.

### Implementado
- [x] Descripcion agregada a las 25 medidas DAX del modelo (JSON + SSAS via AMO)
- [x] Workaround SSAS 2017: inyeccion post-deploy via `inject_descriptions.ps1` (TMSL no persiste campo description)
- [x] `deploy_tmsl_remote.ps1` ejecuta automaticamente la inyeccion de descripciones

### Notas
- Las descripciones se inyectan via AMO (`$measure.Description`) porque SSAS 2017 TMSL ignora el campo description en createOrReplace.

---

## Issue #18: Manual de Usuario

**Status:** Backlog
**Labels:** `documentation`, `user-guide`
**Prioridad:** Media

### Descripcion
Crear un manual de usuario completo para los distintos roles que usan el reporte (Compras, Produccion, Logistica, Calidad, Gerencia).

### Pendiente
- [ ] Definir estructura por rol/perfil
- [ ] Capturas de pantalla de cada pagina
- [ ] Descripcion de funcionalidades por pagina
- [ ] Guia de interpretacion de alertas e indicadores
- [ ] FAQ y troubleshooting basico
- [ ] Formato final: PDF + version online

---

## Issue #19: Relevamiento con Areas de Negocio

**Status:** Backlog
**Labels:** `requirements`, `stakeholder-engagement`
**Prioridad:** Alta

### Descripcion
Iniciar etapas de trabajo en conjunto con: Comercio Exterior, Produccion, Logistica, Calidad y Gerencia para relevar que todos sus requerimientos y consultas sobre los datos se resuelven.

### Sub-tareas por area
| Area | Responsable | Estado |
|------|-------------|--------|
| Comercio Exterior | Rosana | En progreso (Issue #1) |
| Produccion | TBD | Pendiente |
| Logistica | TBD | Pendiente |
| Calidad | TBD | Pendiente |
| Gerencia | TBD | Pendiente |

### Pendiente
- [ ] Agendar reunion por area
- [ ] Preparar demo del modelo actual para cada area
- [ ] Documentar requerimientos por area
- [ ] Priorizar backlog por area
- [ ] Validar que datos actuales resuelven consultas clave

---

## Issue #20: Mejoras en Indicadores y Machine Learning

**Status:** Backlog
**Labels:** `ml`, `analytics`, `enhancement`
**Prioridad:** Media

### Descripcion
Trabajar sobre mejoras en indicadores existentes e implementar modelos de machine learning para prediccion de demanda, deteccion de anomalias, optimizacion de stock.

### Ideas a evaluar
- [ ] Prediccion de demanda por articulo (series de tiempo)
- [ ] Deteccion de anomalias en consumo (outliers)
- [ ] Optimizacion de stock minimo basada en ML
- [ ] Clasificacion ABC de articulos automatizada
- [ ] Lead time prediction por proveedor
- [ ] Prototipos iniciales en `scripts/ml/`

---

## Issue #21: Integraciones con Otras Tecnologias

**Status:** Backlog
**Labels:** `integration`, `api`, `mobile`
**Prioridad:** Baja

### Descripcion
Crear integraciones con otras tecnologias para obtener insights desde el ERP o cualquier otra app que lo requiera (incluyendo app movil).

### Opciones a evaluar
- [ ] API REST sobre SSAS (Tabular query endpoint)
- [ ] Power BI Embedded para integracion web
- [ ] App movil (React Native / MAUI) para consulta de indicadores
- [ ] Alertas via Teams/Email basadas en umbrales
- [ ] Integration con ERP via webhooks o polling
- [ ] Chatbot interno con acceso a datos del modelo

---

## Issue #22: Historias de Datos para Finanzas y Direccion

**Status:** Backlog
**Labels:** `storytelling`, `finance`, `executive`
**Prioridad:** Media

### Descripcion
Crear historias de datos orientadas a finanzas, direccion y flujos de caja/gasto para presentacion ejecutiva.

### Pendiente
- [ ] Definir metricas clave de finanzas (flujo de caja, gastos por area, proyecciones)
- [ ] Disenar paginas de narrativa ejecutiva
- [ ] Integrar datos contables del ERP
- [ ] Crear tablero de direccion con KPIs consolidados
- [ ] Comparativa YoY y budget vs actual

---

## Issue #23: Proceso de Validacion de Datos (Cierre)

**Status:** Backlog
**Labels:** `data-quality`, `validation`, `governance`
**Prioridad:** Alta

### Descripcion
Implementar un proceso de validacion de datos (Cierre) para mantener la confianza en los datos y que el modelo sea fuente de verdad.

### Pendiente
- [ ] Definir reglas de validacion por tabla (rangos, completitud, consistencia)
- [ ] Crear script de validacion automatica post-refresh
- [ ] Dashboard de calidad de datos (completitud, anomalias, drift)
- [ ] Alertas automaticas cuando se detectan inconsistencias
- [ ] Proceso de cierre mensual con firma de responsable
- [ ] Integrar con stg_refresh_log existente

---

## Issue #24: Registro de Cambios de Fechas de Entrega (Roberta - Importaciones)

**Status:** Backlog
**Labels:** `data-source`, `importaciones`, `integration`
**Prioridad:** Media

### Descripcion
Relevar con Roberta de Importaciones como lleva el registro de cambios de fechas de entrega para integrarlo al sistema.

### Pendiente
- [ ] Reunion con Roberta para entender el proceso actual
- [ ] Documentar como registra cambios de fecha de entrega (Excel, ERP, manual?)
- [ ] Evaluar fuente de datos: Excel importado, tabla en ERP, o nueva tabla
- [ ] Disenar tabla `factEntregaCambios` en el modelo
- [ ] Implementar ETL y relacion con factComprasEnProceso
- [ ] Crear visualizacion de historial de cambios de fecha por OC

---

## Issue #25: Remocion de Relacion factStockEPSA-Calendario

**Status:** Completo ✅
**Labels:** `model-fix`, `dax`, `ssas`

### Descripcion
La relacion `factStockEPSA[Stock Fecha_Corte] → Calendario[Fecha]` causaba que las medidas de stock (Existencia, Compras, Proyectado, etc.) quedaran en blanco al cambiar el rango del slicer de fechas. El stock es una tabla snapshot (foto del ultimo corte) y no debe filtrarse por fecha.

### Causa raiz
El filtro de Calendario se propagaba a factStockEPSA a traves de la relacion, filtrando solo registros cuya Fecha_Corte caia dentro del rango seleccionado. Como el stock solo tiene datos del ultimo corte, cualquier rango que no lo incluya retornaba BLANK.

### Implementado
- [x] Rel eliminada del modelo SSAS en vivo (192.168.2.47:2383)
- [x] Script `add_calendario_metadata.ps1` actualizado (rel removida de relDefs y affectedTables)
- [x] Documentacion `modelo_datos.md` actualizada (rel removida de tabla y diagrama)
- [x] Script one-shot: `remove_stock_calendario_rel.ps1`

### Decision de diseno
Las tablas snapshot (como factStockEPSA) NO deben tener relacion con Calendario. El filtro de fecha no tiene sentido sobre datos que representan un estado actual, no una serie historica.

---

## Issue #26: Meses de Cobertura, Stock Mínimo y Fórmula de "A Pedir"

**Status:** Pendiente reunion con Compras
**Labels:** `business-rule`, `compras-exterior`, `discussion`
**Prioridad:** Alta

### Contexto
La medida `[A Pedir Txt]` muestra la formula actual de forma legible:
```
AP = {E}e + {SP}sp - ({CP}cp + {CDP}cdp) - {SM}sm
```
Donde:
- **e** = Existencia (stock en deposito)
- **sp** = Stock en proceso de compra
- **cp** = Consumo Planificado (ordenes de produccion)
- **cdp** = Cantidad demandada pendiente
- **sm** = Stock Minimo

Esta formula y sus operandos estan sujetos a revision con el departamento de Compras.

### Temas a tratar

#### 26.1 Meses de Cobertura como dato maestro
Los Excel de Rosana tienen una columna "Meses de Cobertura" ingresada manualmente que no existe en el ERP. Esto representa cuantos meses de consumo deberia cubrir el stock disponible.

**Relacion propuesta:**
```
Stock Minimo = Meses de Cobertura x Consumo Promedio por Mes
```

Esto permite:
- Vigilar si los stocks minimos configurados en ERP son adecuados
- Detectar articulos con stock minimo desactualizado
- Sugerir ajustes basados en consumo real

**Pendiente:**
- [ ] Definir si "Meses de Cobertura" se ingresa como campo en dimArticulo o se calcula
- [ ] Validar con Compras que valores son razonables por tipo de articulo
- [ ] Evaluar alerta visual cuando StockMin real != StockMin teorico

#### 26.2 Cobertura de Lead Time
Los Meses de Cobertura deben cubrir el Lead Time del proveedor + un margen de seguridad (1-2 meses adicionales).

**Formula propuesta:**
```
Meses Cobertura >= LT_Meses + Meses Seguridad
```

Esto asegura que:
- No se quede sin stock mientras llega el pedido
- Hay colchon para variaciones de demanda o demoras

**Pendiente:**
- [ ] Definir cuantos meses de seguridad por tipo de articulo/proveedor
- [ ] Evaluar si el margen debe ser fijo (1 mes) o proporcional al LT

#### 26.3 Revision de formula "A Pedir"
La formula actual puede variar segun necesidades:
- Opcion A: `AP = Necesidad(LT) - StockNeto` (basada en lead time)
- Opcion B: `AP = StockMin - StockNeto` (basada en stock minimo configurado)
- Opcion C: Híbrida que tome el maximo de ambas

**Pendiente:**
- [ ] Reunion con responsables de compras para definir formula final
- [ ] Validar con casos reales (articulos con y sin stock minimo configurado)
- [ ] Actualizar `[A Pedir Sugerido]` y `[A Pedir Txt]` segun decision

### Dependencias
- Requiere datos de "Meses de Cobertura" (hoy solo en Excel, no en ERP)
- Requiere validacion de stocks minimos actuales vs teoricos
- Impacta directamente en Issue #1 (caso de uso Rosana)
