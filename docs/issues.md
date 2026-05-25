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

**Status:** Pendiente
**Labels:** `setup`

### Descripcion
El repositorio Git local esta inicializado. Falta crear el repositorio remoto en GitHub y configurar el push.

### Proximos pasos
- [ ] Crear repo remoto `EPSA-Compras` en GitHub (epsa-acunarro)
- [ ] Configurar remote origin
- [ ] Push de la rama master
- [ ] Opcional: configurar GitHub Projects para seguimiento

---

## Issue #4: Arquitectura de Despliegue y Refresh Automatizado

**Status:** En evaluacion
**Labels:** `architecture`, `ssas`, `deployment`

### Descripcion
Se evaluo alternativas para automatizar la actualizacion de datos y distribuir el reporte sin requerir que cada usuario actualice manualmente.

### Evaluacion realizada
- [x] Power BI Service ($50/month para 5 usuarios) — opcion recomendada cuando haya presupuesto
- [x] SSAS Tabular + Live Connection ($0 con SQL Server Standard 2019) — opcion tecnica ideal a largo plazo
- [x] Power Automate Desktop ($0) — opcion RPA para refresh automatico del PBIX
- [x] Open source (Cube.dev, Metabase, Superset) — ninguno iguala el valor de SSAS+Power BI

### Decision pendiente
- [ ] Decidir si se migra modelo a SSAS Tabular o se mantiene en PBIX
- [ ] Decidir mecanismo de refresh automatizado (RPA vs SSAS vs PBI Service)
