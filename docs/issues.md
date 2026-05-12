# Issues / Seguimiento de Requerimientos

## Issue #1: Reporte Compras al Exterior — Panel de Decision (Rosana)

**Status:** En diseno — esperando aprobacion de medidas DAX  
**Labels:** `enhancement`, `power-bi`, `compras-exterior`, `pending-approval`  
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

### Diseno propuesto: Page 1 — Decision Panel
Ver detalle completo en `requerimiento_compras_exterior.md`.

**Medidas DAX pendientes de aprobacion:**
1. `Diferencia Cobertura Lead Time` — compara cobertura actual vs lead time del proveedor
2. `Alerta Cobertura` — flag visual: "PEDIR", "Atencion", "OK"

### Proximos pasos
- [ ] Aprobar medidas DAX A y B
- [ ] Implementar medidas en modelo PBIX
- [ ] Construir Page 1: Decision Panel
- [ ] Validar con Rosana en caso de uso real
- [ ] Definir e implementar calculo "A pedir"

---

## Issue #2: Documentacion del Modelo de Datos

**Status:** Completo  
**Labels:** `documentation`  

### Descripcion
Se extrajo y documento el esquema completo del modelo Power BI `Compras EPSA - Stock.pbix`.

### Entregables
- [x] `docs/modelo_datos.md` — Tablas, columnas, medidas, relaciones, fuentes de datos
- [x] `pbix/model_export.json` — Exportacion programatica del modelo via AMO

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
