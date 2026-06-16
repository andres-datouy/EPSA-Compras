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
