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
- [ ] Ejecutar el plan de walkthrough: `docs/plan_validacion_compradores.md` (sesiones con Rosana, registro de hallazgos, loop de mejora)
- [ ] Validacion con Rosana en caso de uso real
- [ ] Definir e implementar calculo "A pedir" (ver Issue #26)
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

**Status:** Cerrado — not planned (2026-08-06)
**Labels:** `deployment`, `power-bi`, `documentation`
**Prioridad:** Alta

### Descripcion
Definir y documentar una estrategia para generar un archivo PBIX distribuible a partir del proyecto PBIP (PBIR + SemanticModel Live Connection a SSAS).

### Motivo de cierre (2026-08-06)
- La arquitectura actual es **Live Connection a SSAS** (`192.168.2.47:2383`): el modelo semantico vive en el servidor, por lo que un PBIX "standalone sin SSAS" es contradictorio con el diseno (el PBIP ya es el formato de trabajo del reporte).
- El caso de distribucion real (acceso web/usuarios sin Power BI Desktop) se resuelve con **Power BI Service + gateway**, que ya esta contemplado como item futuro en el Issue #4.
- Si mas adelante surge la necesidad concreta de un artefacto PBIX distribuible, se crea un issue nuevo con el caso de uso especifico.

### Pendiente original (no se ejecuta)
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

**Decision pendiente — EPSA debe definir la direccion de la relacion:**

Opcion A: Meses de Cobertura es un **calculo derivado**:
```
Meses Cobertura = Stock Mínimo / Consumo Promedio Mensual
```
→ El SM es el dato maestro (viene del ERP), Meses Cobertura se calcula para vigilancia.

Opcion B: Stock Mínimo es un **calculo derivado**:
```
Stock Mínimo = Meses de Cobertura x Consumo Promedio Mensual
```
→ Meses Cobertura es el dato maestro (ingresado manualmente), el SM se calcula.

**Medida implementada (Opcion A):** `[Meses Cobertura] = DIVIDE([Stock Mínimo], [Consumo Promedio por Mes Activo])`
Esto permite visualizar si el SM configurado cubre al menos el Lead Time + margen.

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

---

## Issue #27: Dual Lead Time — Proceso Interno vs Proveedor

**Status:** Completo ✅
**Labels:** `model-fix`, `dax`, `ssas`, `lead-time`

### Descripcion
Diferenciar dos conceptos de fecha de inicio de compra para medir correctamente el lead time:

1. **Compra Fecha Inicio Proceso Interno Desde Solicitud** — MIN(SolicitudFecha, OC Fecha, Compra Fecha). Incluye el tiempo del proceso interno (solicitud antes de emitir OC). Para Produccion.
2. **Compra Fecha Inicio Proceso Con Proveedor** — MIN(OC Fecha, Compra Fecha). Solo desde que se emite la OC al proveedor. Para medir demora real del proveedor.

### Implementado
- [x] Columna renombrada: `Compra Fecha Inicio Proceso` → `Compra Fecha Inicio Proceso Interno Desde Solicitud`
- [x] Nueva columna calculada: `Compra Fecha Inicio Proceso Con Proveedor` = MIN(OC Fecha, Compra Fecha)
- [x] `Lead Time Dias` ahora usa `Con Proveedor` (antes usaba la de 3 fechas)
- [x] Medida `[Lead Time Proceso Interno Dias]` — AVERAGEX desde Solicitud hasta Recepcion (para Produccion)
- [x] Medida `[Dias Transcurridos En Proceso Promedio]` — dias promedio desde OC para compras en curso
- [x] Medida `[Dias Hasta Fecha Entrega Promedio]` — dias restantes hasta entrega esperada (negativo = vencida)
- [x] Medida `[Compras En Proceso Vencidas]` — cantidad de OC con fecha de entrega ya pasada
- [x] JSON files sincronizados (database_staging.json + _fixed.json)
- [x] Scripts actualizados (update_date_formats.ps1, crossref_validation.ps1)

### Impacto
- Todas las medidas basadas en `[Lead Time Promedio Dias]` ahora miden lead time del **proveedor** (no del proceso interno)
- Afecta: `[Lead Time Meses]`, `[Cobertura sobre Stock Minimo vs Lead Time]`, `[A Pedir Sugerido]`
- Para Produccion: usar `[Lead Time Proceso Interno Dias]` que incluye solicitud interna

### Script
`scripts/deploy/dual_lead_time.ps1`

---

## Issue #28: Sin procesamiento automatico de SSAS tras el refresh de staging (modelo atrasado)

**Status:** ✅ RESUELTO 2026-08-06 (job desplegado, test run SUCCEEDED, 15 particiones reprocesadas)
**Labels:** `ops`, `ssas`, `refresh`
**Prioridad:** Alta

### Descripcion
Los jobs SQL Agent `Staging_Refresh_*` actualizan `staging_compras` correctamente a diario, pero **no existe ningun job que procese el modelo SSAS `Compras_EPSA`**. El modelo tabular (import) queda con los datos del ultimo process manual: los compradores ven datos con semanas de atraso aunque staging este al dia.

### Evidencia (auditoria 2026-08-06, `scripts/check/check_frescura_datos.ps1`)
- Staging al dia: `stg_factConsumo.fec_doc` max = 2026-08-05; `stg_factStockEPSA` = 2026-08-06; jobs `Staging_Refresh_*` todos OK hoy.
- SSAS atrasado: particion `factConsumoHistoria` refreshed 2026-07-01; `factStockEPSA` 2026-07-01; el modelo sirve consumo hasta 01/07/2026 y stock al 01/07/2026 (~5 semanas de atraso).
- `DB LastProcessed` 2026-07-28 corresponde solo al deploy de `dimArticulo` (Comentarios).

### Correccion aplicada (2026-08-06)
- Componentes:
  - `scripts/powershell/Process_SSAS.ps1` → corre en el servidor (`C:\Scripts\`): TMSL `refresh` full via ADOMD del GAC (**ExecuteNonQuery**; ExecuteReader falla con "not a rowset") + verificacion de frescura (max consumo a <= 2 dias) + exit code 0/1.
  - `scripts/sql/ssas_staging/13_process_ssas_job.sql` → job `Staging_Process_SSAS` de 3 steps (process → alerta Teams verde / roja), schedules `Daily_09_30` y `Daily_14_15`, 1 reintento a los 5 min.
  - `scripts/deploy/deploy_process_ssas_job.ps1` → copia el script, crea credential/proxy/job (usa `sa` para msdb), inyecta el secret del credential, opcional `-TestRun`.
- **Permisos (hallazgos clave)**:
  - `app_compras` no tiene ningun permiso en `msdb`: la DDL del job requiere `sa`.
  - La cuenta de servicio del Agent (`NT Service\SQLAgent$SSAS`) no puede hacer refresh de SSAS: sin permiso de process la DB aparece como "database cannot be found". Solucion: el step de process corre bajo proxy `Proxy_SSAS_Process` (credential `cred_schaaf_ssas`, identidad `EXLER-SERVER\schaaf_ssas`, admin SSAS). Ademas se agrego la cuenta del Agent al rol `Lectura_Compras` del modelo (inocuo, queda).
- Verificacion: test run SUCCEEDED (alerta Teams verde enviada); `check_frescura_datos.ps1` → las 15 particiones reprocesadas hoy, `DB LastProcessed` actualizado, staging y modelo al dia.
- Rollback: `sp_delete_job 'Staging_Process_SSAS'` + `sp_delete_proxy` + `DROP CREDENTIAL`.

---

## Issue #29: CALENDARAUTO contaminado por factVencimientos (Calendario 1924-2101)

**Status:** ✅ RESUELTO 2026-08-06 (verificado en vivo: Calendario 01/01/2009 - 31/12/2028)
**Labels:** `model-fix`, `dax`, `ssas`
**Prioridad:** Alta

### Descripcion
Al incorporar `factVencimientos` (procesada 2026-07-03), su columna `[fec_venc]` (vencimientos 1925-2100) entro en el rango que considera `CALENDARAUTO(1)`: el Calendario paso a abarcar **01/02/1924 - 31/01/2101**. Impacto: slicer de fechas con rangos absurdos, card `_RangoFechas_Debug` enganosa, y riesgo de distorsionar medidas temporales que iteran `VALUES(Calendario)`.

### Evidencia
- `MIN/MAX(Calendario[Fecha])` con `ALL()` = 1924-02-01 / 2101-01-31 (coincide con el ano fiscal Feb-Ene que envuelve 1925-01-01 y 2100-03-12 de `stg_factVencimientos.fec_venc`).

### Correccion aplicada
- `CALENDARAUTO(1)` → `CALENDAR(DATE(2009,1,1), DATE(2028,12,31))` en `model/database_staging.json` + `model/database_staging_fixed.json` (ambos, politica de validacion estructural).
- Inicio 2009-01-01 (no 2020) porque `stg_factRecepcionesHistoria.RecepcionFecha` tiene datos desde 2009-12-01; fin 2028-12-31 cubre el max de `FechaEntregaMax` de compras en proceso (2027-04-25) con margen.
- Deploy: `createOrReplace` TMSL fallo con error opaco (ver Issue #30); se aplico por via AMO directa (set `Partition.Source.Expression` + `SaveChanges` + process full de la tabla). Verificado: `check_frescura_datos.ps1` → `MinCal=01/01/2009, MaxCal=31/12/2028`.

### Causa raiz en los datos de origen (2026-08-06)
- La contaminacion viene de DATOS (no de estructura): `stg_factVencimientos.fec_venc` carga de `[192.168.2.7].[Nodum].[dbo].[cpt_lote]` (maestro de lotes del ERP) via `sp_refresh_factVencimientos` (`12_factVencimientos.sql`).
- En Nodum hay lotes con fechas centinela de "sin vencimiento" (`1753-01-01`, `1899-12-31`, `1900-01-01`, `1925-01-01`) y fechas futuras basura (cluster 2050/2051 con 1.202 lotes, `2099-12-01`, `2100-03-12`, etc.): 1.333 filas anomalas sobre 2.170. Detalle en Issue #31.

---

## Issue #30: Motor TMSL DDL de SSAS falla con NullReference (deploy createOrReplace roto)

**Status:** RESUELTO (2026-08-06) — reinicio controlado del servicio SSAS reparo el motor DDL
**Labels:** `ops`, `ssas`, `deploy`
**Prioridad:** Alta

### Descripcion
Todo comando TMSL DDL contra la instancia SSAS (`192.168.2.47:2383`) falla con error opaco: `XmlaResult` con codigo `-1052704700` (createOrReplace) / `-1055784777` (alter) y **texto vacio**. Por ADOMD el mismo alter devuelve: *"The JSON DDL request failed with the following error: Referencia a objeto no establecida como instancia de un objeto"* (NullReferenceException server-side). Los comandos de **refresh** funcionan bien; solo DDL esta roto.

### Evidencia (2026-08-06)
- `deploy_tmsl_remote.ps1` → "ERROR:" sin texto; el modelo no se reemplaza (la particion Calendario quedo con la expresion vieja tras el deploy).
- JSON de deploy valido (parse OK en el servidor, longitud identica 706.226 chars), DB ReadWriteMode=ReadWrite.
- Alter minimo (solo descripcion de DB) tambien falla → no depende del payload.
- Hipotesis: corrupcion de estado del motor DDL tras el deploy de `factVencimientos` (03/07) o parche del binario SSAS; candidatos: reinicio del servicio SSAS, revisar `msmdsrv.log`.

### Workaround aplicado (mientras estuvo abierto)
- Cambios de modelo via AMO directa desde WinRM: modificar objetos + `SaveChanges()` (funciona). Asi se aplico el fix del Issue #29.

### Causa raiz y resolucion (2026-08-06)
- Causa raiz: estado interno corrupto del motor JSON DDL en el proceso `msmdsrv` de larga ejecucion (sin logs utiles: `msmdsrv.log` congelado desde 02/06 solo con mensajes de arranque; binario 17.0.25.223). El NullReference era reproducible con cualquier DDL, incluso un alter minimo de descripcion.
- Pre-requisito verificado antes de actuar: 4 sesiones activas, todas de `schaaf_ssas` y en estado IDLE (sin comandos en curso).
- Fix: reinicio controlado del servicio `MSOLAP$SSAS` (PID 4184 → 4376, puerto 2383 escuchando).
- Verificacion post-reinicio:
  - Alter minimo de descripcion de `Compras_EPSA`: OK.
  - `createOrReplace` + `delete` de DB descartable (`zz_diag_tmsl_test`): OK (limpieza confirmada).
  - Regresion: job `Staging_Process_SSAS` (Issue #28) disparado tras el reinicio → **SUCCEEDED**; `Compras_EPSA` reprocesada (LastProcessed 14:07).
- `deploy_tmsl_remote.ps1` vuelve a ser confiable para deploys por TMSL.

### Nota preventiva
- Si el NullReference en JSON DDL reaparece (refresh OK pero DDL roto), aplicar reinicio controlado del servicio `MSOLAP$SSAS` verificando antes que no haya sesiones con comandos activos.

### Recurrencia parcial (2026-08-06, tarde)
- `deploy_tmsl_remote.ps1` volvio a fallar con `ERROR:` de texto vacio durante el deploy del hallazgo #1 de validacion (filtro de demanda); el modelo NO se reemplazo.
- Pero el motor DDL esta **sano**: round-trip descartable `create`/`delete` de `zz_ddl_test_20260806` via ADOMD OK, y el parser JSON devuelve errores de validacion concretos (no NullReference).
- El cambio se aplico igualmente via AMO: `QueryPartitionSource.Query = ...` + `SaveChanges()` + refresh full de la tabla (funciono a la primera).
- Pendiente: si un proximo `createOrReplace` completo vuelve a fallar con texto vacio, capturar el detalle del `XmlaResult` completo (todos los Messages con tipo/severidad) antes de asumir recaida del motor.
- Alcance completo del fix del hallazgo #1: la blank row de dimArticulo se alimentaba de 3 particiones con claves fuera de alcance compras; se filtro con `WHERE EXISTS` contra `stg_dimArticulo` en `factDemandaPendientePlanificacion` (1.109 codigos), `factConsumoHistoria` (1.639 codigos / 115.237 filas) y `factRecepcionesHistoria` (60 codigos / 276 filas). Verificado: las 6 facts relacionadas a dimArticulo quedan 100% con articulo real. Leccion: la blank row sintetica solo desaparece cuando TODAS las facts relacionadas estan limpias; el diagnostico debe barrer todas las relaciones.

---

## Issue #31: Fechas de vencimiento basura en Nodum cpt_lote (fuente de factVencimientos)

**Status:** Diagnosticado — requiere correccion en el ERP por el negocio + opcion de fix defensivo en staging
**Labels:** `data-quality`, `erp`, `staging`
**Prioridad:** Alta

### Descripcion
El maestro de lotes del ERP Nodum (`[192.168.2.7].[Nodum].[dbo].[cpt_lote]`) contiene fechas `fec_venc` ficticias para lotes sin vencimiento real. Estas fechas contaminan `stg_factVencimientos` → `factVencimientos` y distorsionan las medidas de vencimiento (Stock Por Vencer 30d/90d, Stock Vencido, % Stock Por Vencer).

### Evidencia (2026-08-06)
- De 2.170 filas en `stg_factVencimientos`, **1.333 (61%) tienen fecha anomala** (fuera del rango 2000–2045):
  - Centinela 1925-01-01: 1 lote (SCRAP PS (UNION), lote s03115261, 4.65).
  - Cluster 2050/2051: 1.202 lotes, 4,25 M de cantidad (parece default "sin vencimiento").
  - 2099-12-01: 86 lotes; 2052/2055/2056/2069/2080/2085/2100: restos.
- En el ERP ademas existen centinelas `1753-01-01` (minimo SQL), `1899-12-31` (epoca Excel/OLE) y `1900-01-01` que hoy no llegan a staging por filtros de stock pero demuestran el patron.
- Resumen ERP: de 5.781 lotes epsa con stock, 1.462 tienen fecha > 2045.
- Extracto completo: `docs/vencimientos_anomalos_2026-08-06.csv` (cod_articulo, nom_articulo, nro_lote, cantidad, fec_venc, categoria). Re-exportable con `scripts/check/check_vencimientos_anomalos.ps1`.

### Correccion propuesta
1. **Fuente (negocio)**: corregir en Nodum los 1.333 lotes del CSV — cargar la fecha de vencimiento real o dejar el campo que el ERP use para "sin vencimiento" de forma consistente.
2. **Defensivo (staging, documentado — pendiente de aprobacion)**: ver seccion siguiente.
3. Verificar con `check_vencimientos_anomalos.ps1` tras cada correccion; re-procesar `factVencimientos` en SSAS.

### Fix defensivo documentado (NO aplicado aun)

**Objetivo**: que `stg_factVencimientos` trate los lotes sin vencimiento real como "sin vencimiento" (`fec_venc = NULL`) en vez de cargar fechas ficticias, sanando el reporte aunque el ERP nunca se corrija.

**Cambio en `dbo.sp_refresh_factVencimientos`** (`scripts/sql/ssas_staging/12_factVencimientos.sql`) — reemplazar el `INSERT ... SELECT` actual:

```sql
-- Rango plausible de vencimientos: fuera de el, la fecha es un centinela de "sin vencimiento"
DECLARE @vencMin DATE = '2000-01-01';
DECLARE @vencMax DATE = '2045-12-31';

INSERT INTO dbo.stg_factVencimientos (
    [cod_articulo], [nro_lote], [cantidad], [fec_venc]
)
SELECT 
    s.cod_articulo, 
    s.nro_lote, 
    s.cantidad, 
    CASE 
        WHEN l.fec_venc IS NULL OR l.fec_venc < @vencMin OR l.fec_venc > @vencMax THEN NULL
        ELSE l.fec_venc
    END AS fec_venc
FROM [192.168.2.7].[Nodum].[dbo].[sa_stocklote] s
INNER JOIN [192.168.2.7].[Nodum].[dbo].[ct_articulos] a 
    ON a.cod_articulo = s.cod_articulo
INNER JOIN [192.168.2.7].[Nodum].[dbo].[cpt_lote] l 
    ON l.cod_articulo = s.cod_articulo 
    AND l.nro_lote = s.nro_lote 
    AND l.cod_emp = 'epsa'
WHERE s.cod_emp = 'epsa'
  AND s.cantidad > 0
  AND a.cod_tipoart NOT IN ('pt','semi','tubos','prvta')
  AND s.cod_estado = 'existencia';
```

**Efectos esperados**:
- Las ~1.333 filas anomalas quedan con `fec_venc NULL`: los lotes siguen presentes (sus cantidades siguen contando en totales de stock por lote) pero las medidas de vencimiento (`Stock Por Vencer 30d/90d`, `Stock Vencido`, `Stock Vencido USD`, `% Stock Por Vencer`) los ignoran — hoy tampoco son "por vencer" ni "vencidos" con criterio real.
- El Calendario no se ve afectado: ya usa rango explicito `CALENDAR(DATE(2009,1,1), DATE(2028,12,31))` (Issue #29), no depende de esta tabla.
- Opcional a futuro: medida `Stock Sin Vencer` = `CALCULATE(SUM(factVencimientos[Vencimiento Cantidad]), ISBLANK(factVencimientos[Vencimiento Fecha]))` para visibilizar ese stock.

**Consideraciones**:
- El rango plausible (2000–2045) es ajustable; quedo calibrado con el diagnostico del 2026-08-06 (las fechas 2036–2045 parecen reales; el cluster basura arranca en 2050).
- Si mas adelante se sanea el ERP, el fix es inocuo: las fechas reales pasan el filtro sin cambio.
- Rollback: restaurar el `SELECT` original (sin el `CASE`).
- Al aplicar: actualizar `12_factVencimientos.sql` en el repo, ejecutar el `CREATE OR ALTER PROC` en staging, correr el SP y re-procesar la tabla `factVencimientos` en SSAS.

---

## Issue #32: Slicer "Proveedor Preferido" en blanco (columna calculada stubeada con BLANK() en la migracion)

**Status:** ✅ RESUELTO 2026-08-06 (verificado en vivo: 204 proveedores distintos, 0 blanks)
**Labels:** `model-fix`, `dax`, `ssas`, `migracion`
**Prioridad:** Media

### Descripcion
El slicer "Proveedor Preferido" (columna `dimArticulo[Proveedor Artículo Full]`) mostraba unicamente "(En blanco)". Hallazgo #2 de la validacion con compradores.

### Cadena de datos (3 fases)
1. **ERP → staging** (`03_dimArticulo.sql`): `sp_refresh_dimArticulo` copia `ProveedorArticulo` y `ProveedorArticuloNombre` desde `vw_Compras_DimArticuloEPSA`. Datos OK: 3.371 articulos, 204 proveedores, 0 vacios/nulos.
2. **Staging → SSAS** (particion dimArticulo): `RTRIM([ProveedorArticulo]) AS [Proveedor Codigo]`, `RTRIM([ProveedorArticuloNombre]) AS [Proveedor Nombre]`. OK.
3. **Columna calculada**: en el modelo original (`model/tables/dimArticulo.json`) la expresion era `dimArticulo[Proveedor Codigo] & "- " & dimArticulo[Proveedor Nombre]`; en el modelo deployado (`database_staging.json` / `_fixed`) quedo stubeada como `BLANK()` desde el commit de migracion `76c8cdc` → todos los valores en blanco.

### Correccion aplicada
- Restaurada la expresion original en ambos JSON del modelo (politica de validacion estructural).
- Deploy via AMO: `CalculatedColumn.Expression = ...` + `SaveChanges()` + refresh full de `dimArticulo`.
- Verificado en vivo: `DISTINCTCOUNT([Proveedor Artículo Full]) = 204` (coincide con staging), 0 blanks; valores muestra: "P0696- MERCURIUS...", "EPSA- ELECTROPLAST S.A.", "S/P- Sin datos de Proveedor".

### Leccion
Las columnas calculadas del modelo original deben auditarse contra el deployado tras una migracion PBIX→TMSL: un stub `BLANK()` compila y deploya sin error pero vacia el dato silenciosamente.

## Issue #33: Medidas numéricas muestran "(En blanco)" en vez de 0 sin datos en el contexto

**Status:** ✅ RESUELTO 2026-08-07 (verificado en vivo con articulo sin consumo ni stock)
**Labels:** `model-fix`, `dax`, `ssas`
**Prioridad:** Baja

### Descripcion
En la tabla de decision del reporte, columnas de medidas mostraban "(En blanco)" cuando el contexto de filtro no tenia datos: Consumo Promedio por Mes Activo, Meses Cobertura del Stock Minimo, Cobertura sobre Stock Minimo vs Lead Time, Existencia, Stock Compras, Stock Proyectado, Cobertura Meses sobre Stock Proyectado, etc. Criterio acordado con compradores: mostrar **0 como caso general** (hallazgo #3 de la validacion).

### Correccion aplicada
- Patron uniforme `+ 0` al final de la expresion (BLANK + 0 = 0; funciona tambien sobre resultados de DIVIDE), siguiendo el estilo ya existente en `Sumatoria Movs Consumo Sin Recepciones`.
- 68 medidas auditadas en las 5 tablas de medidas (Medidas_Stock, Medidas_Consumo, Medidas_Consumo_Planificado, Medidas_DemandaPendiente, Medidas_Compras); ~55 expresiones modificadas. En ambos JSONs del modelo (politica de validacion estructural).
- Sin tocar por diseño: medidas de texto (`A Pedir Txt`, `Stock Debajo Mínimo`, `_RangoFechas_Debug`), de fecha (`Ultima Fecha Consumo`, `Ultima Recepcion Fecha`) y combinaciones aritmeticas que ya coaccionan BLANK via sus operandos.
- **Alerta Cobertura**: el guard `ISBLANK(Cob) || ISBLANK(LT)` se reescribio a `[Meses con Consumo] = 0, BLANK()` — con entradas ahora basadas en 0, el semaforo conserva el blanco solo para articulos sin historial de consumo.
- Deploy via AMO: `Measure.Expression = ...` + `SaveChanges()` sobre las 68 medidas (cambio de expresion no requiere reprocesar datos). Resultado: updated=57+3, mismo estado final, 0 faltantes.
- **Side-fix (drift)**: `Meses Cobertura del Stock Minimo`, `Cobertura sobre Stock Minimo vs Lead Time` y `Lead Time Meses` estaban en Medidas_Compras en los JSON pero en Medidas_Consumo en SSAS; se movieron en los JSON para alinear.

### Verificacion
Articulo 970010105225 (sin consumo, sin stock): Consumo Promedio por Mes Activo = 0, Meses Cobertura del Stock Minimo = 0, Existencia = 0, Stock Compras = 0, Stock Proyectado = 0, Cobertura Meses sobre Stock Proyectado = 0, Cobertura Meses sobre Existencia = 0, Consumo Planificado = 0, Demanda Pendiente = 0, Alerta Cobertura = (blanco, intencional). Cobertura sobre Stock Minimo vs Lead Time = -0.37 (valor legitimo: SM 0 menos LT en meses).

### Drift restante (resuelto el mismo dia)
- SSAS tenia la medida `% Stock Muerto sobre Total` (Medidas_Stock) y la tabla `factVencimientos` (4 columnas, 5 medidas) que no figuraban en los JSON. Se les aplico el criterio 0 (`+ 0` en las 6 expresiones, deploy AMO) y se incorporaron a ambos JSON: tabla `factVencimientos` completa (particion sobre `[dbo].[stg_factVencimientos]`, dataSource staging_compras) y la medida en Medidas_Stock. Sin relaciones (es una tabla de monitoreo independiente, sin filtro por articulo). Verificado: contexto vacio devuelve 0 en las 5 medidas de vencimientos; los totales reales se mantienen (Stock Vencido = 22.025 und / USD 30.282).

### Lecciones
- Edicion masiva de expresiones en JSON: los reemplazos que cambian el final de linea deben conservar la coma trailing (`"expression": "...",`), sino el JSON queda invalido.
- Tras un deploy de medidas, comparar sistematicamente nombre/tabla/expresion entre JSON y SSAS: la ubicacion de una medida en la tabla contenedora puede derivar silenciosamente.

## Issue #34: La columna Alerta totaliza en la fila "Total" y no tiene colores por estado

**Estado:** Resuelto (2026-08-07)
**Prioridad:** Baja

### Descripcion
En "PROGRAMACION DE COMPRAS - TABLA DE DECISION", la medida `Alerta Cobertura` devolvia "OK" en la fila de totales (se evaluaba en el contexto de total, sin agrupacion por articulo) y todos los estados se mostraban del mismo color, dificultando la lectura del semaforo. Pedido del comprador (hallazgo #4 de la validacion): que la columna no totalice y colorear el texto por valor: OK verde, PEDIR naranja, Atencion amarillo, cualquier otro valor en blanco por defecto.

### Correccion aplicada
- DAX: el semaforo quedo envuelto en `IF ( NOT ( ISINSCOPE ( dimArticulo[Artículo Código] ) ), BLANK (), SWITCH ( ... ) )`. Se uso ISINSCOPE y no HASONEVALUE porque esta ultima devuelve TRUE en la fila de total cuando el filtro contiene un unico articulo; ISINSCOPE es FALSE en el total siempre. Aplicado en ambos JSONs del modelo y deploy via AMO (solo expresion, sin reproceso).
- PBIR: en el visual `ae824a0995dd34ff420c` (pagina `e244718f235796748fbf`) se agrego un entry `values` con formato condicional de `fontColor` basado en reglas (`Conditional.Cases` con `ComparisonKind: 0` = igualdad sobre la propia medida): OK `#00E676`, PEDIR `#FF9800`, Atencion `#FFEB3B`, `DefaultValue` `#FFFFFF`. Selector con `dataViewWildcard matchingOption 1` + `metadata` (ambos obligatorios en tablas; matchingOption 1 excluye la fila de total). Referencia de authoring: microsoft/skills-for-fabric, powerbi-report-authoring, conditional-formatting.md.

### Verificacion
ADOMD contra SSAS: `EVALUATE ROW ( "AlertaEnTotal", [Alerta Cobertura] )` devuelve BLANK; las filas de detalle conservan sus valores (OK / Atencion / PEDIR segun articulo). Los colores requieren recargar el PBIP en Desktop (`/refrescar-pbip`) porque viven en el reporte, no en el modelo.

### Lecciones
- Medidas de texto usadas como semaforo deben suprimir su fila de total con ISINSCOPE; HASONEVALUE falla con filtros de un solo articulo.
- En PBIR, el formato condicional de tablas/matrices exige selector con `data` (dataViewWildcard) Y `metadata`; sin ambos, el formato se descarta silenciosamente.

---

## Issue #35: Articulos inactivos para compras visibles en el reporte (atributo dimArticulo[Activo Compras] + slicer inicializado en S)

**Status:** ✅ RESUELTO 2026-08-18 (cadena completa deployada y verificada: vista → staging → SSAS → slicer PBIR)
**Labels:** `enhancement`, `compras-exterior`, `ssas`, `pbir`
**Prioridad:** Media
**Origen:** validacion con Rosana — Opcion B aprobada: el universo del reporte mostraba articulos que el ERP marca como inactivos para compras.

### Descripcion
Nodum `ct_articulos` tiene el indicador `activo_cmp` (S/N, articulo activo para compras) que no estaba expuesto en la cadena BI. Se lo expuso de punta a punta para filtrar el reporte a articulos vigentes de compra por defecto.

### Cadena implementada
1. **Vista (192.168.2.7, EPSA_BI):** `vw_Compras_DimArticuloEPSA` expone `activo_cmp` (aplicado manual 2026-08-18, mismo criterio de naming que `activo_stk`). Referencia: `scripts/sql/epsa_bi/alter_vw_DimArticuloEPSA_add_activo_cmp.sql`.
2. **Staging (192.168.2.47,1435 staging_compras):** `scripts/sql/ssas_staging/03b_dimArticulo_add_ActivoCompras.sql` — columna `activo_cmp CHAR(1)` en `stg_dimArticulo` + `sp_refresh_dimArticulo` la incluye. Refresh verificado: S=3362 / N=9 (total 3371).
3. **SSAS (Compras_EPSA):** particion de dimArticulo con `RTRIM([activo_cmp]) AS [Activo Compras]` + DataColumn `Activo Compras` (String). Deploy: `scripts/deploy/add_activoCompras_dimArticulo.ps1` (AMO + refresh Full). Verificado por ADOMD: 'S'=3362, 'N'=9.
4. **Reporte (PBIR):** nuevo slicer `f3a7b2c81d4e5906ab12` en pagina `e244718f235796748fbf` (Dropdown, pre-seleccionado en 'S' via `general[].properties.filter`). Validacion PBIR sin diagnosticos propios; render y pre-seleccion verificados en Desktop.

### Los 9 articulos N (al 2026-08-18)
130052000000, 140090002263, 160216801588, 633007000000, 800003450578, 800034502351, 800034505288, 800034522280, 980005000000.

### Leccion (pitfall de SSAS)
`DataColumn.SourceColumn` debe coincidir con el **alias de salida** de la query de la particion (`AS [Activo Compras]`), NO con la columna cruda de staging (`activo_cmp`). Con mismatch el refresh falla con "The 'activo_cmp' column does not exist in the rowset" y la particion queda Incomplete. Todas las columnas existentes del modelo siguen este patron.

### Leccion (verificacion DAX en scripts de deploy)
TOM `Model` no tiene `ExecuteQuery`; la verificacion DAX server-side se hace con ADOMD del GAC (mismo patron que `scripts/powershell/Process_SSAS.ps1`).

---

## Issue #36: Columnas decision-criticas ausentes en la tabla de decision + definicion de tooltips explicativos

**Status:** ABIERTO 2026-08-19 — se decide columna a columna con Rosana
**Labels:** `enhancement`, `compras-exterior`, `pbir`, `tooltips`
**Origen:** validacion del trabajo de Rosana con proveedor Color System (COLORSERVICE, P0067).

### Columnas que usa Rosana y hoy no estan en la tabla de decision (visual `ae824a0995dd34ff420c`)
- **Lead Time Meses** — su "lead time" (G, en meses) entra en el umbral PEDIR (`cobertura <= LT + 4`) y en la proyeccion "a la llegada".
- **A Pedir Sugerido** — su "A pedir" (X) es la salida de decision.
- **Proveedor** — ella trabaja agrupada por proveedor.
Se resolveran de a poco, columna a columna; no se agregan por ahora.

### Decisiones de columnas tomadas (2026-08-19)
- Las 3 columnas de Stock Minimo **se mantienen**: participan de la decision aunque no esten en el Excel (supuesto verdadero: meses de cobertura se determinan por consumo mensual y stock minimo). De las columnas de cobertura SM se dejara **solo una** (aun no decidido con Rosana cual).
- Proyectado vs Util: se dejara **solo una** pareja, luego de tener los tooltips prontos y decidiendo con Rosana (probablemente la de Stock Util).

### Criterio de tooltips acordado
- **Oracion** (medida de texto): cuando el valor es un calculo basado en otras campos/medidas.
- **Reporte** (pagina tooltip): cuando se quiere ampliar un dato que es un promedio, etc.
- Criterio general: cada medida/calculo que requiera responder "¿de donde salieron esos datos?".

### Logica de Rosana decodificada (hoja 'actual' de `Pedidos a exterior 2026.04.09.xlsx`, formulas extraidas 2026-08-19)
- N Consumo: `AVERAGE` de consumos mensuales 2019-2023 (en algunas filas solo 2022-23, eleccion manual por articulo).
- U Meses cobertura = `(Stock + ETAFPA + EnCamino) / Consumo`.
- V aviso = `PEDIR` si `U <= 4 + leadtime`.
- Y Cobertura (post-pedido) = `(Stock + EnCamino + APedir) / Consumo` (excluye ETAFPA, inconsistente con U).
- Z cobertura a la llegada = `Y - leadtime + U`.
- Stock ETAFPA y En Camino: VLOOKUP a `EPSA - Control Stock Minimo` (col 4 y col 9 "VALOR A TOMAR COMPRAS PROYECTADAS"); algunas filas manuales.
- Bugs encontrados en su Excel: fila 233 (140090003927) `#REF!` en Y; fila 234 (140090055493) referencia S233 en vez de S234; Z con doble conteo de U cuando R=0.

### Tooltip por medida implementado y verificado (2026-08-19)
- Pagina tooltip `b7e9d2a4f1c64e8a9001` ("TT Consumo Promedio"): tarjetas con [Consumo Promedio por Mes Activo], [Sumatoria Movs Consumo Sin Recepciones], [Meses con Consumo] + grafico de columnas de consumo mensual + texto explicativo. Verificado en Desktop por usuario: el tooltip aparece SOLO al hacer hover sobre la columna de la medida en la tabla de decision.
- **Asociacion por medida (lado pagina, "Tooltip fields")**: `filterConfig.filters[]` = `{ name, field: <Measure>, type: "Categorical", howCreated: "Drillthrough" }` + `pageBinding` = `{ name: "TooltipFields", type: "Tooltip", parameters: [{ name, boundFilter: <filter name>, asAggregation: false, qnaSingleSelectRequired: false, fieldExpr: <Measure> }] }`.
- **Lado visual consumidor (Format > Tooltips > Type: Report page, Page: Auto)**: se serializa como `visualTooltip: [{ properties: { show: Literal "true" } }]` (sin type ni section). En cambio `type: "'Canvas'"` + `section: "'<pageName>'"` fuerza UNA pagina para todo el visual (comportamiento por fila, descartado).
- Grafico del tooltip: Category = `Calendario[Año Mes Número]` + `objects.categoryAxis[].axisType "'Categorical'"` + `sortDefinition` Descending → barras discretas con el mes mas reciente primero; filtros visuales `Sumatoria > 0` y mes no nulo.
- Para medidas calculadas (tooltip tipo oracion) el visual ofrece `showSentenceFormat` / `sentenceTemplate` dentro de `visualTooltip`; queda pendiente definir columna a columna con Rosana que medidas llevan oracion y cuales reporte.

---

## Issue #37: Calendario con meses futuros (2028) y meses iniciales sin consumo → ventanas vacias en graficos temporales

**Status:** MITIGADO 2026-08-19 (tooltip con eje categorico descendente, verificado por usuario; pendiente revisar otras paginas)
**Labels:** `data-quality`, `ssas`, `compras-exterior`
**Origen:** construccion del tooltip de Consumo Promedio por Mes Activo (pagina `b7e9d2a4f1c64e8a9001`).

### Observacion
- `Calendario` extiende hasta 2028 (meses futuros) y desde ~2009; los meses 2027-2028 y 2009-~2018 tienen `[Sumatoria Movs Consumo Sin Recepciones]` = 0/blank.
- Un grafico mensual sin filtro de medida muestra primero (asc) o ultimo (desc) puros meses en cero; los 80 meses con consumo quedan en el medio, fuera de la ventana visible de un tooltip no interactivo.

### Mitigacion aplicada en el tooltip (verificada por usuario 2026-08-19)
- Filtro a nivel visual: `[Sumatoria Movs Consumo Sin Recepciones] > 0` (coincide con el denominador de [Meses con Consumo]) y mes no nulo.
- Category numerica `Calendario[Año Mes Número]` con `objects.categoryAxis[].axisType = 'Categorical'` (barras discretas en vez de escala continua 202.000-202.700) + `sortDefinition` Descending → mes mas reciente primero.

### Pendiente
- Revisar si otras paginas con graficos temporales sufren el mismo efecto y si conviene acotar `Calendario` en el modelo (p.ej. hasta el mes actual) o agregar filtros analogos.
- Nota tecnica: serializacion PBIR `Not(IsNull(...))` rechazada por Desktop; reemplazar por `Not(Comparison(Equal, null))`. Sort por columna fuera de roles (`Año Mes Número`) es ignorado por Desktop; ordenar por la propia columna de categoria.

---

## Issue #38: Lead Time inconsistente (Rosana vs Power BI) — semantica del filtro de proveedor, P0067 sin recepciones propias y ausencia de modal de transporte

**Status:** BASE DE CALCULO CAMBIADA A SOLICITUD 2026-08-19 (solo medidas; columna [Lead Time Dias] y [On Time Delivery %] quedan base OC); TOOLTIP IMPLEMENTADO 2026-08-19; tratamiento Avion = documentar limitacion (decidido); variante LT por OC Proveedor = NO por ahora (decidido)
**Labels:** `data-quality`, `business-rules`, `compras-exterior`, `lead-time`
**Origen:** Rosana presenta lead times manuales del proveedor Color Systems (COLOR SERVICE GMBH / P0067) de 4-6 meses que no coinciden con el [Lead Time Promedio Dias] de Power BI (~24 dias ≈ 0.8 meses).

### Hallazgos (consultas ADOMD contra SSAS Compras_EPSA)
1. **El filtro "proveedor" del reporte no es el proveedor que entregó.** El slicer de la pagina de decision (`d1bdeb42d648bc9643e3`) filtra `dimArticulo[Proveedor Artículo Full] = 'P0067- COLOR SERVICE GMBH'` (proveedor PREFERIDO de la maestra de articulos). El promedio de LT cubre las recepciones de los 12 articulos con ese proveedor preferido, sin importar quien entregó realmente.
2. **P0067 tiene CERO recepciones como `OC Proveedor`.** Entregaron: P0696 (n=37, LT prom 35.2 dias) y EXLER (n=23, LT prom 6.9 dias — proveedor interno que arrastra el promedio hacia abajo). Total: 60 recepciones, promedio global 24.37 dias (min 1, max 81), historico 2010-2026.
3. **El promedio abarca TODO el historico e incluye valores anomalos.** Por año: 2010:1d(n1), 2011:7, 2012:10, 2014:17.9(n10), 2015:14.75(n8), 2016:16.9(n10), 2017:28.5(n8), 2018:18.5(n4), 2019:8(n2), 2020:34(n1), 2021:40(n1), 2022:9(n2), 2023:49(n7), 2026:56.25(n4). Los años recientes se acercan mas a la percepcion de Rosana, pero siguen lejos de 4-6 meses.
4. **El modal/medio de transporte NO existe en la cadena de datos.** La vista Nodum `vw_ComprasBI_HistoriaRecepciones` (24 columnas) no trae modal; tampoco existe en staging ni en SSAS. Unica referencia: Excel de Roberta (`docs/importaciones_analisis.md`: MARITIMO ~88%, Aereo ~11%). Excluir envios por Avion **no es implementable hoy**; `docs/requerimiento_compras_exterior.md` ya lista LT por modal como necesidad pendiente.

### Medidas y tablas involucradas
- `factRecepcionesHistoria[Lead Time Dias]` (columna calculada) = DATEDIFF(Compra Fecha Inicio Proceso Con Proveedor, RecepcionFecha, DAY); inicio = MIN(OC Fecha, Compra Fecha) (ver Issue #27).
- `[Lead Time Promedio Dias]` = `[Lead Time Proceso Interno Dias]` (tabla Medidas_Compras; redefinido 2026-08-19 a base solicitud a pedido de Rosana; expresion original: AVERAGE(factRecepcionesHistoria[Lead Time Dias]) + 0).
- `[Lead Time Meses]` = DIVIDE([Lead Time Promedio Dias], 30, 0) (tabla Medidas_Consumo).
- **Unica tabla fact involucrada: `factRecepcionesHistoria`**; dimensiones relacionadas: dimArticulo (articulo), dimProveedor (OC Proveedor), Calendario (RecepcionFecha).
- Dependientes aguas abajo: [Cobertura sobre Stock Minimo vs Lead Time], [A Pedir Sugerido], [Alerta Cobertura], [Articulos Sin Cobertura Suficiente], [On Time Delivery %] (compara contra dimArticulo[plazo]).

### Reportes implementados con Lead Time
- Pagina "Stock Minimo Vs Lead Time" (`052225f7ed5a4eabddaf`): tabla por articulo con [Lead Time Promedio Dias].
- Pagina "Compras x Año" (`d0ff7cbddc87e7e4b660`): dos tablas por articulo con [Lead Time Promedio Dias] y proveedor del articulo.
- Tabla de decision (`e244718f235796748fbf`): columnas [Lead Time Promedio Dias] y [Lead Time Meses].

### Decisiones tomadas (2026-08-19)
- Tooltip de LT: pagina de reporte con desglose (implementada, ver abajo).
- Avion/modal: solo documentar la limitacion (el texto del tooltip lo explicita); no se excluyen envios aereos.
- Variante de LT por OC Proveedor: NO se crea medida nueva; el desglose por proveedor que entrego vive dentro del tooltip.

### Tooltip implementado (2026-08-19)
- Pagina `c8f2a1d94e37b56c0a01` ("TT Lead Time", type Tooltip, 640x480, HiddenInViewMode): oracion explicativa (formula + historico completo + sin exclusion por modal + semantica de proveedor preferido en ambar), tarjetas [Lead Time Promedio Dias] / [Lead Time Meses] / [Cantidad Recepciones] / [Ultima Recepcion Fecha], grafico de columnas LT por `Calendario[Año Fiscal]` (categorico, descendente, filtro [Cantidad Recepciones] > 0) y tabla `dimProveedor[Proveedor Nombre]` + [Cantidad Recepciones] + [Lead Time Promedio Dias] (proveedores que realmente entregaron via OC Proveedor).
- Binding de Tooltip fields con DOS medidas en la misma pagina: dos entradas en `filterConfig.filters` + dos `pageBinding.parameters` ([Lead Time Promedio Dias] de Medidas_Compras y [Lead Time Meses] de Medidas_Consumo). La tabla de decision ya tenia `visualTooltip show=true` (Page: Auto), por lo que el hover sobre cualquiera de las dos columnas LT resuelve a esta pagina.
- **Pitfall PBIR (tableEx)**: una proyeccion de columna con `"active": true` (sin sortDefinition) hace que Desktop renderice la tabla VACIA (solo header). Sin `active` renderiza bien. Ancho por columna: `objects.columnWidth` con `selector.metadata = "<queryRef>"` y valor `"<n>D"`.

### Cambio de base de calculo a fecha de solicitud (2026-08-19)
- **Pedido de Rosana**: que el LT promedio se calcule desde la fecha de la SOLICITUD interna para acercar las cifras a las que ella maneja. Se confirma que `[Lead Time Proceso Interno Dias]` inicia en `MIN(SolicitudFecha, OC Fecha, Compra Fecha)` (columna `Compra Fecha Inicio Proceso Interno Desde Solicitud`).
- **Decision (usuario)**: alcance SOLO MEDIDAS. `[Lead Time Promedio Dias]` pasa a ser `[Lead Time Proceso Interno Dias]`; por herencia cambian `[Lead Time Meses]` y las coberturas ([A Pedir Sugerido], [Alerta Cobertura], [Articulos Sin Cobertura Suficiente], [Cobertura sobre Stock Minimo vs Lead Time]). La columna `[Lead Time Dias]` y `[On Time Delivery %]` quedan base OC (correcto para medir cumplimiento del proveedor contra el plazo acordado).
- **Deploy**: `scripts/deploy/deploy_lt_solicitud.ps1` (AMO via WinRM a 192.168.2.47, SSAS localhost:2383, db Compras_EPSA): redefine expresion + descripcion de `[Lead Time Promedio Dias]` en Medidas_Compras. Sincronizado en `model/database_staging.json` y texto del tooltip `c8f2b000000000000001`.
- **Impacto verificado (ADOMD post-deploy)**: Color Service (filtro proveedor preferido) 24.4 d / 0.81 meses → **63.5 d / 2.12 meses**; global 13 d → **22 d / 0.75 meses**; `[On Time Delivery %]` sin cambio (55.1%).

### Ceros en Lead Time Meses tras el cambio (diagnostico 2026-08-19)
- La pagina abre por defecto con el slicer `Fecha` = Last 5 Years (20/08/2021-19/08/2026, persistido en el PBIR; slicer `37083fb98873fc5f3c2b` sobre `Calendario[Fecha]`).
- Los 0,00 son articulos SIN recepciones dentro de esa ventana (ultima recepcion anterior: 130030000000 el 22/01/2019, 130080000000 el 09/04/2012, 140090226698 el 23/06/2021; o sin historial: 13006/13010/13011/140090055493). Promedio blank y el `+ 0` historico de la medida lo muestra como 0,00.
- Verificado: con la formula vieja (base OC) esos mismos articulos tambien daban blank/0 en la misma ventana → NO es regresion del cambio de base. Con Fecha en All, 130030000000 pasa de 16,6 d (viejo) a 47,5 d = 1,58 meses (nuevo).
- Los valores no-cero suben (130070000000: 40,4 d → 121,8 d = 4,06 meses en la ventana) por el efecto esperado de incluir el proceso interno desde la solicitud.
- Accion: ampliar el slicer Fecha para ver el historial completo. Opcional pendiente: quitar `+ 0` para mostrar blank en lugar de 0,00 (afectaria el semaforo [Alerta Cobertura] en articulos sin LT: Atencion→OK).

### Redefinicion a PEOR CASO sin filtro de proveedor (2026-08-19)
- Pedido del usuario: (1) tomar el peor caso (MAX) en vez del promedio; (2) no filtrar por proveedor y considerar toda la historia de compras de la empresa (los proveedores de OC suelen ser consolidadores como Giesser o Mercurius); (3) sin solicitud el proceso inicia con la OC; (4) sin solicitud ni OC, con la fecha de factura; (5) nunca incluir compras de EPSA con proveedor EXLER.
- Decisiones (usuario): fecha de inicio = MIN(solicitud, OC, compra) (coincide con la referencia de 85 dias del articulo 140090003927); se RESPETA el slicer de Fecha del reporte; exclusion = solo `OC Proveedor = "EXLER"` (las recepciones con Empresa EXLER entran si caen en el contexto de fechas).
- Deploy: `scripts/deploy/deploy_lt_worst_case.ps1` redefine `[Lead Time Proceso Interno Dias]` en Medidas_Compras:
  `VAR t = CALCULATETABLE(factRecepcionesHistoria, REMOVEFILTERS(dimProveedor), factRecepcionesHistoria[OC Proveedor] <> "EXLER") RETURN MAXX(t, DATEDIFF(MIN(solicitud,OC,compra), RecepcionFecha, DAY)) + 0`. Por herencia cambian `[Lead Time Promedio Dias]`, `[Lead Time Meses]` y las coberturas. Columna `[Lead Time Dias]` y `[On Time Delivery %]` siguen base OC.
- Verificacion ADOMD: art 140090003927 = 107 d con historia completa (solicitud 01/07/2015, empresa EXLER, dentro de contexto) y 85 d con contexto >= 2026 (solicitud 24/02/2026 → recepcion 20/05/2026, compra P0696); global 2080 d; Color Service 329 d / 10,97 meses.
- Textos de tooltips TT Lead Time / TT Lead Time Meses actualizados a "peor caso".

### Regresion de tooltips por columna y fix (2026-08-19)
- Sintoma: con dos paginas de tooltip, Desktop mostraba el tooltip de LT en TODAS las columnas de la tabla de decision, perdiendo la asociacion por columna del tooltip de Consumo.
- Causa: la pagina TT Lead Time tenia binding de DOS medidas ([Lead Time Promedio Dias] + [Lead Time Meses]); el matching automatico de Desktop con bindings multi-medida no discrimina por columna.
- Fix: la pagina `c8f2a1d94e37b56c0a01` (TT Lead Time) queda con binding unico de `[Lead Time Promedio Dias]`; nueva pagina `c8f2a1d94e37b56c0a02` (TT Lead Time Meses, clon de visuales) con binding unico de `[Lead Time Meses]`; la pagina de Consumo `b7e9d2a4f1c64e8a9001` sin cambios. Registrada en pages.json; validacion sin errores nuevos; Desktop recargado. Pendiente: verificacion de hover por el usuario.

### Decisiones pendientes originales (resueltas arriba)
- Diseño del tooltip de LT (propuesta: pagina de reporte con desglose — n/prom/min/max, LT por año y proveedor real que entregó).
- Tratamiento Avion/modal: investigar campo fuente en Nodum para incorporar modal vs documentar la limitacion.
- Si conviene una variante de LT filtrada por proveedor que realmente entrega (OC Proveedor) en lugar del proveedor preferido de la maestra.

---

## Issue #39: Pagina tooltip unificada "TT Detalle Articulo" (reemplaza las 3 paginas TT)

**Status:** Implementado 2026-08-20 — pendiente verificacion de hover por el usuario
**Labels:** `enhancement`, `compras-exterior`, `pbir`, `tooltips`
**Origen:** trabajo de tooltips de los Issues #36/#38; pedido del usuario de unificar en una sola pagina.

### Descripcion
Power BI no permite asociar tooltips de tipo oracion distintos por campo, y la estrategia de una pagina por medida (Issues #36/#38) tenia flancos: el matching automatico de Desktop con bindings multi-medida no discriminaba por columna y quedaban 3 paginas TT en el reporte (2 sin uso). El usuario pidio UN solo reporte de tooltip con secciones claras por dato y tamaño optimizado.

### Implementado
- [x] Pagina unica `b7e9d2a4f1c64e8a9001` "TT Detalle Articulo" (660×452, type Tooltip, HiddenInViewMode) con binding TooltipFields unico a `[Consumo Promedio por Mes Activo]` (la tabla de decision ya tiene visualTooltip show=true / Page: Auto).
- [x] 5 secciones con titulo azul + oracion gris + card: CONSUMO (card de 2 valores + grafico mensual), LEAD TIME — PEOR CASO (card de 2 valores), STOCK ÚTIL E+C-CP-CD, COBERTURA MESES S/ STOCK ÚTIL y A PEDIR SUGERIDO (card de 1 valor cada una).
- [x] Lineas de leyenda en los textboxes ("De izq. a der.: ...") para identificar los valores de las cards, que este build de Desktop renderiza sin labels.
- [x] Borradas las paginas `c8f2a1d94e37b56c0a01` / `c8f2a1d94e37b56c0a02` (TT Lead Time / TT Lead Time Meses) y sus entradas en pages.json.
- [x] Validacion PBIR sin errores nuevos; verificado con reload Y fresh open (capturas).

### Pitfalls descubiertos
- **cardVisual ignora los objetos `value`/`label` en este build de Desktop**: validate pasa y reload no acusa error, pero la card renderiza con formato del tema (sin labels, valores ~24pt). Workaround: maximo 2 valores por card (con 3 se truncan) + leyenda en textbox.
- **Crash transitorio de Desktop tras un crash espontaneo**: durante ~15 min todo fresh open dio "Something went wrong / Object reference not set..." mientras reload funcionaba; la biseccion de contenido demostro que no era el PBIR (todos los estados abrieron eventualmente). Leccion: tras un crash espontaneo de Desktop no culpar al contenido sin bisectar; verificar siempre con fresh open ademas de reload.

### Pendiente
- [ ] Verificacion de hover por el usuario sobre la tabla de decision: el tooltip debe aparecer como pagina unica al pasar por las columnas de medidas con binding.

### Ajustes tras validacion del usuario (2026-08-21)
El usuario verifico el popup y pidio 4 ajustes; todos implementados y verificados con captura:
1. **Tamanos/visibilidad**: se eliminaron las 5 cardVisual (valores recortados por el tamano ~24pt del tema que este build no permite configurar). Los valores ahora viven DENTRO del textbox de cada seccion como textRuns dinamicos (`objects.values[]` + `propertyIdentifier objectName values/propertyName expr` + `selector id "Value N"`), con fuente controlada (8-9px, resultado en bold blanco). Pagina compactada de 660×452 a 660×356.
2. **Sin sufijos K/M**: los textboxes renderizan el formatString de la medida tal cual (numero completo con separador de miles). En el grafico, `valueAxis.labelDisplayUnits` con `"1D"` = None (ver pitfall abajo).
3. **Eje de fechas AAMM**: nueva columna `Calendario[Año Mes AM]` = `FORMAT(CurrentDate, "yyMM")` (ej. "2608"). Modelo: agregada al ROW de la particion calculada + DataColumn con `sortByColumn = Año Mes Número` en ambos JSON y deploy AMO (`scripts/deploy/add_calendario_am.ps1`, con RequestRefresh Full). Grafico: Category = Año Mes AM, `categoryAxis.fontSize 8D`, `showAxisTitle false`, `sortDefinition` Descending sobre la propia columna de categoria.
4. **Cuenta instanciada en cada oracion**: parrafo final por seccion que mezcla runs dinamicos (operandos y resultado en blanco; resultado bold) con runs estaticos (operadores `÷ + − × =` y literales como "MAX(0, " o "÷ 30 =" en gris). Ej.: `22.297.419,37 ÷ 80,00 = 278.717,74`. Se quitaron las lineas de leyenda "De izq. a der." (la cuenta las reemplaza).

### Pitfalls nuevos (2026-08-21)
- **labelDisplayUnits**: `"0"` = Auto (sigue mostrando 0,5M); `"1D"` = None (numeros completos). Tipo formatting → literal con sufijo D.
- **Schema cache de conexion live**: tras agregar una columna en SSAS, `reload` NO la refleja (el grafico da "Something's wrong with one or more fields"); hay que cerrar y reabrir el PBIP (fresh open) para que Desktop re-lea el modelo remoto.
- **Sort por columna fuera de roles ignorado**: con Category = Año Mes AM, el `sortDefinition` sobre Año Mes Número no se aplica (barras ascendentes); ordenar por la propia columna proyectada (confirmado en #37).
- Inestabilidad de arranque de Desktop: un `open` murio en silencio (proceso inexistente a los ~2 min); el reintento abrio limpio. Consistente con el pitfall de crash transitorio de este issue.

### Pendiente
- [x] Verificacion de hover por el usuario con el diseno ajustado. Verificado OK en la sesion del 2026-08-24.

---

## Issue #40: Pagina "Detalle Lead Time Recepciones" con drillthrough desde la tabla de decision

**Status:** Implementado 2026-08-24 — pendiente verificacion del drillthrough por el usuario
**Labels:** `enhancement`, `compras-exterior`, `pbir`, `drillthrough`, `lead-time`
**Origen:** pedido del usuario (2026-08-24): reporte nuevo que detalle el lead time desde factRecepcionesHistoria con los mismos slicers de "Programacion Compras Exterior", accesible por drillthrough desde la tabla de decision.

### Descripcion
Pagina `d7c3e8f2a1b945600031` "Detalle Lead Time Recepciones" (registrada segunda en pages.json, detras de Programacion). Replica los 6 slicers de la pagina Programacion (Articulo, Proveedor Preferido, Clase, Fecha con syncGroup "Fecha", Proveedores textSlicer, Activo Compras) sin las selecciones interactivas que el usuario tenia guardadas alli, salvo el rango relativo de Fecha (ultimos 5 anios). Detalla recepciones individuales con su `[Lead Time Dias]` (base OC, cumplimiento de proveedor — NO la cadena peor-caso de planificacion, que queda intacta segun regla de negocio).

### Implementado
- [x] 3 medidas nuevas en Medidas_Compras (deploy AMO `scripts/deploy/add_lt_recepciones_medidas.ps1`, upsert, sin DataType): `[Lead Time Promedio Dias Recepciones]` (AVERAGEX de la columna), `[Lead Time Promedio Dias Recepciones P90]` (PERCENTILEX.INC 0.9 con `CONVERT ( p, DOUBLE )`), `[Lead Time Meses Recepciones]` (dias/30). Sincronizadas en ambos JSON del modelo.
- [x] Layout: 4 cardVisual (LT promedio dias, LT P90 dias, LT promedio meses, Recepciones), textbox explicativo, tableEx con 10 columnas de factRecepcionesHistoria (RecepcionFecha, OC Proveedor, OC Numero, OC Fecha, SolicitudNumero, SolicitudFecha, Compra Numero, Compra Fecha, RecepcionCantidad, Lead Time Dias; sort LT Dias desc; numericas alineadas a la derecha) y columnChart de LT promedio por `Calendario[Año Mes AM]`.
- [x] Drillthrough: 3 filtros `howCreated: "Drillthrough"` en page.json (dimArticulo[Artículo Código], [Artículo Nombre], [Proveedor Artículo Full]) + `pageBinding` Pod/Drillthrough. Acceso: click derecho sobre un valor de Articulo Codigo / Articulo Nombre / Proveedor en la tabla de decision → "Drilla a traves" → "Detalle Lead Time Recepciones". La flecha de regreso la agrega Desktop automaticamente al llegar por drillthrough (no hace falta boton).
- [x] Validacion PBIR sin errores nuevos (los 4 errores PBIR_FORMATTING_PROP_NESTED son baseline de slicers viejos); verificado con fresh open y capturas de ambas paginas.

### Pitfalls descubiertos
- **`DOUBLE(x)` como funcion NO existe en este build de SSAS** (170): da "syntax for '(' is incorrect" y el motor guarda el placeholder SYNTAXERROR que revienta la medida en el visual. Usar `CONVERT ( x, DOUBLE )`, que ademas deja DataType estatico Double en la metadata.
- **AdomdClient v15 del GAC no carga en pwsh 7** (`System.Runtime.Remoting.Messaging.CallContext` ausente en .NET Core): los probes DAX deben correr con `powershell.exe` (5.1).
- **`file.reload` del bridge NO limpia el cache de consulta de un visual que ya erro** con conexion live: tras corregir una medida en SSAS hay que cerrar y reabrir Desktop (fresh open) para que el visual reconsulte.
- **Tabular.Server (AMO) no tiene CreateCommand**: para probes DAX usar AdomdClient, no el OM tabular.

### Pendiente
- [ ] Verificacion del usuario: drillthrough desde la tabla de decision (click derecho en Articulo/Proveedor) y lectura de la pagina de detalle.

### Cambio de regla de fecha de inicio (2026-08-24)
Al revisar la tabla de detalle, el usuario observo la recepcion OC 31593 (Solicitud 24/02, OC 02/04, Compra 07/05, Recepcion 20/05) con 48 dias (MIN de OC/Compra) y redefinio la regla: el reloj arranca en la mejor fecha entre Solicitud, OC y Compra. `[Lead Time Dias]` ahora referencia la columna `[Compra Fecha Inicio Proceso Interno Desde Solicitud]` (MINX de las tres fechas); esa recepcion paso a 85 dias; promedio global 13 → 22,4 y P90 44 → 74 (sin filtro de fecha). `[On Time Delivery %]` hereda la nueva base. Deploy: `scripts/deploy/update_lt_dias_base_solicitud.ps1` (cambio de expresion + refresh Full de factRecepcionesHistoria, columna calculada). Queda asi unificada la fecha de inicio entre detalle y planificacion; la diferencia entre ambas perspectivas sigue siendo la agregacion (por recepcion vs MAXX peor caso) y los filtros (EXLER y REMOVEFILTERS(dimProveedor) solo en planificacion).

---
