# Propuesta: Definicion del Alcance de Monitoreo - Compras al Exterior

## Estado: Borrador para alineacion de equipo
## Fecha: 2026-05-18
## Responsable: Rosana (Compras Produccion)

---

## 1. Contexto

El reporte de Compras al Exterior requiere definir con precision **que articulos se monitorean**. Actualmente Rosana gestiona ~329 articulos en su Excel de seguimiento. El modelo de datos (Power BI) contiene 3.362 articulos totales, de los cuales 737 tienen proveedor exterior y consumo activo.

### 1.1 Problema actual
La lista de monitoreo se mantiene manualmente en Excel sin un criterio sistematico que permita:
- Detectar automaticamente nuevos articulos que requieren seguimiento
- Excluir articulos que ya no tienen consumo
- Distinguir la responsabilidad entre areas (Produccion vs Mantenimiento vs otros)

---

## 2. Hallazgos del Modelo de Datos

### 2.1 Universo de articulos (datos al 2026-05-18)

| Filtro aplicado | Articulos |
|-----------------|-----------|
| Total en dimArticulo | 3.362 |
| Proveedor Exterior (pais != UY) | 1.700 |
| + Consumo activo | 737 |
| + Stock Minimo > 0 | 293 |
| + Excluyendo clases de Mantenimiento | ~214 |
| **Excel de Rosana** | **~329** |

### 2.2 Distribucion por Clase (Ext + Consumo activo, top 15)

| Clase | Total | Stock Min > 0 | Obligatorio |
|-------|-------|---------------|-------------|
| REPUESTOS BOMBAS (*) | 145 | 70 | 0 |
| Insumo para mantenimiento (*) | 63 | 1 | 0 |
| Repuestos (*) | 44 | 1 | 0 |
| HERRAMIENTAS P/ PRODUCCION | 41 | 35 | 0 |
| REP MOTORES&MAQUINAS (*) | 40 | 7 | 1 |
| EXTRACTOR DE EMBOLOS | 31 | 13 | 31 |
| MAT.MANTENIM.VARIOS | 24 | 14 | 3 |
| ESPIRAL DE ACERO | 20 | 18 | 20 |
| PVC | 19 | 10 | 17 |
| ALAMBRE P/MANDRIL | 17 | 8 | 13 |
| SONDA | 17 | 0 | 17 |
| PIGMENTO | 15 | 10 | 11 |
| FOLEY A GRANEL | 14 | 0 | 14 |
| POLIURETANO | 13 | 9 | 13 |
| Material a Envasar | 13 | 0 | 11 |

> (*) Clases tipicamente gestionadas por Mantenimiento, no por Produccion.

### 2.3 Indicadores clave para segmentar

| Atributo | Uso propuesto | Valores relevantes |
|----------|---------------|--------------------|
| `Clase Nombre` | Slicer en reporte - familia de producto | Medicas vs Empaque vs Mantenimiento |
| `TipoComponente` | Slicer en reporte - criticidad | Obligatorio / No Obligatorio / No es Componente |
| `Articulo Stock Minimo` | Criterio de inclusion (> 0 = requiere monitoreo) | Numerico |
| `ProveedorPais` | Slicer en reporte - origen geografico | DE, IT, CN, US, BR... |

---

## 3. Propuesta de Definicion del Alcance

### 3.1 Formula de inclusion

Un articulo pertenece al monitoreo de Rosana si cumple **al menos una** condicion:

| # | Condicion | Justificacion |
|---|-----------|---------------|
| A | Esta en la lista Excel de Rosana | Base inicial - autoridad de negocio |
| B | Proveedor exterior + Consumo activo + Stock Minimo > 0 + Clase NO es de mantenimiento | Regla automatica basada en atributos |
| C | Fue agregado manualmente por decision de Compras | Excepciones no cubiertas por A o B |

### 3.2 Clases excluidas del alcance de Rosana (gestionadas por Mantenimiento)

- REPUESTOS BOMBAS
- Insumo para mantenimiento
- Repuestos
- REP MOTORES&MAQUINAS
- MAT.ELECTRICO VARIOS
- REPUESTOS P/SERVICIOS REPARAC.
- MATRICERIA VARIOS

> **Pregunta para validar:** HERRAMIENTAS P/ PRODUCCION (41 art, 35 con Stock Min) y MAT.MANTENIM.VARIOS (24 art, 14 con Stock Min) — son responsabilidad de Rosana o de Mantenimiento?

---

## 4. Propuesta Tecnica: Atributo Explicito en ERP

### 4.1 Problema que resuelve
Hoy la pertenencia a la lista de monitoreo se determina por reglas implicitas (pais, tipo componente, stock minimo). Esto genera:
- Ambiguedad en articulos de frontera (ej: HERRAMIENTAS P/ PRODUCCION)
- Necesidad de reconciliar manualmente con el Excel
- Imposibilidad de que el BI detecte altas/bajas sin intervencion manual

### 4.2 Solucion propuesta

Agregar un campo en `ct_articulos` (tabla de articulos del ERP Nodum):

```
Campo: MonitoreoComprasExterior
Tipo: VARCHAR(20) o similar
Valores posibles:
  - "PRODUCCION"   → Rosana (compras para produccion)
  - "MANTENIMIENTO" → Area de mantenimiento
  - "EMPAQUE"      → Area de empaque (si aplica)
  - NULL / vacio   → No requiere monitoreo exterior
```

**Alternativa:** Si modificar ct_articulos no es viable, crear una tabla auxiliar `ComprasExteriores_Monitoreo` con:

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| ArticuloCodigo | VARCHAR | FK a ct_articulos |
| ResponsableArea | VARCHAR | PRODUCCION / MANTENIMIENTO / EMPAQUE |
| FechaAlta | DATE | Cuando se agrego al monitoreo |
| FechaBaja | DATE | Cuando se retiro (NULL = activo) |
| Observaciones | VARCHAR | Motivo de inclusion/exclusion |

### 4.3 Beneficios

1. **Fuente unica de verdad:** El ERP define quien monitorea que
2. **Mantenible:** Rosana puede dar alta/baja desde Nodum sin depender de Excel
3. **Extensible:** Permite separar responsabilidades (Produccion vs Mantenimiento)
4. **Trazable:** Registro de cuando y por que se agrego/retiro un articulo
5. **Automatizable:** El modelo BI lee el flag y filtra sin reglas complejas

### 4.4 Impacto en el modelo BI

- `dimArticulo` incorpora el campo `MonitoreoComprasExterior` (o JOIN con tabla auxiliar)
- El filtro del reporte de Rosana pasa a ser: `WHERE MonitoreoComprasExterior = 'PRODUCCION'`
- Los slicers de Clase, TipoComponente y Pais siguen disponibles como drill-down

---

## 5. Plan de Trabajo

### Paso 1: Validacion con Rosana (esta semana)
- [ ] Revisar la lista de clases y confirmar cuales son su responsabilidad
- [ ] Conciliar los 329 items del Excel con los ~293 del modelo (Stock Min > 0)
- [ ] Identificar articulos faltantes en el modelo y articulos sobrantes en el Excel
- [ ] Definir si HERRAMIENTAS P/ PRODUCCION es su scope
- [ ] Aprobar la formula de inclusion (seccion 3.1)

### Paso 2: Implementacion del atributo en ERP (si se aprueba)
- [ ] Definir con el equipo de Nodum si se agrega campo en ct_articulos o tabla auxiliar
- [ ] Carga inicial: marcar los 329 articulos del Excel como "PRODUCCION"
- [ ] Definir proceso de alta/baja (quien, cuando, como)
- [ ] Modificar vista SQL que alimenta dimArticulo para incluir el nuevo campo

### Paso 3: Actualizacion del modelo BI
- [ ] Incorporar el atributo en dimArticulo
- [ ] Reemplazar reglas implicitas por filtro explicito
- [ ] Agregar slicer de "Area Responsable" al reporte
- [ ] Validar que el reporte muestra los mismos articulos que el Excel

---

## 6. Preguntas para la Sesion de Validacion

1. **Herramientas:** Los 41 articulos de "HERRAMIENTAS P/ PRODUCCION" (importados, con stock minimo) — los gestiona Rosana o Mantenimiento?
2. **Mantenimiento varios:** Los 24 articulos de "MAT.MANTENIM.VARIOS" (14 con stock min, 3 obligatorios) — los gestiona Rosana?
3. **Articulos sin Stock Min:** Hay articulos en el Excel que NO tienen stock minimo definido en Nodum? Si es asi, deberian tenerlo?
4. **Articulos con proveedor UY:** Cuales de los articulos "locales" en el Excel son realmente importados por el proveedor local? (ej: Tecnica del Plata)
5. **Alta de nuevos articulos:** Cuando un articulo nuevo entra en produccion con proveedor exterior — como se entera Rosana? Quien lo agrega a la lista?
6. **Baja de articulos:** Cuando un articulo deja de consumirse — se revisa periodicamente para sacarlo de la lista?
7. **Tabla ERP:** Es factible agregar un campo/tabla en Nodum para explicitar la asignacion? Quien tiene permiso de edicion?
