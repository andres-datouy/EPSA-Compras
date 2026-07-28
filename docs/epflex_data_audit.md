# EPFLEX - Auditoria de Datos y Validacion PBIP

## Version: 1.0
## Fecha: 2026-05-18
## Proveedor: EPFLEX (en transicion a Day Engineering)
## Fuente Excel: Pedidos a exterior 2026.04.09.xlsx — Sheet: ALAMBRES

---

## 1. Contexto del Proveedor

**EPFLEX** es un proveedor de alambres de acero (4310) y aluminio utilizado para la fabricacion de:
- Mandriles para cateteres ureterales
- Componentes de dispositivos medicos

**Estado actual:** EPFLEX esta siendo **reemplazado por Day Engineering**. La hoja ALAMBRES del Excel de Rosana documenta la migracion de codigos de articulo de EPFLEX a Day Engineering.

**Implicancia para compras:**
- Los codigos EPFLEX quedaran en desuso progresivamente.
- Las nuevas compras deben hacerse con los codigos Day Engineering.
- Durante la transicion, algunos articulos pueden tener stock residual del codigo EPFLEX.

---

## 2. Mapeo de Articulos EPFLEX → Day Engineering

### 2.1 Alambres de Acero 4310 — Diametro 0.3mm a 0.5mm (Largo 709mm)

| # | Codigo EPFLEX | Descripcion EPFLEX | Codigo Day Eng. | Descripcion Day Eng. | Estado | Uso en Produccion |
|---|---------------|-------------------|-----------------|---------------------|--------|-------------------|
| 1 | 267092001988 | ALAMBRE 0,3 x 709 ACERO 4310 | 267092001995 | ALAMBRE 0,3 x 709 ACERO 4310 | En transicion | Mandril cat. ureteral N°1 (12940100000000) |
| 2 | 267092001989 | ALAMBRE 0,4 x 709 ACERO 4310 | 267025000000 | ALAMBRE 0,4 x 709 ACERO 4310 | En transicion | Mandril cat. ureteral N°2 (12940200000000) |
| 3 | 267092001990 | ALAMBRE 0,5 x 709 ACERO 4310 | 267092730005 | ALAMBRE acero 0.5X709 | En transicion | — |

### 2.2 Alambres de Acero 4310 — Diametro 0.2mm a 0.5mm (Largo 850mm)

| # | Codigo EPFLEX | Descripcion EPFLEX | Codigo Day Eng. | Descripcion Day Eng. | Estado |
|---|---------------|-------------------|-----------------|---------------------|--------|
| 4 | 267092001991 | ALAMBRE 0,2 x 850 ACERO 4310 | (sin codigo) | ALAMBRE 0,2 x 850 ACERO 4310 | Pendiente codigo Day Eng. |
| 5 | 267092730130 | ALAMBRE 0.3X850 | 267092002000 | ALAMBRE acero 0.3X850 | En transicion |
| 6 | 267092730140 | ALAMBRE 0.4X850 | 267092002100 | ALAMB. Acero 0.4X850 | En transicion |
| 7 | 267927300150 | ALAMB.0.5X850 | 267092002200 | ALAMB. Acero 0.5X850 | En transicion |

### 2.3 Alambres de Acero 4310 — Diametro 1.0mm y 1.5mm

| # | Codigo EPFLEX | Descripcion EPFLEX | Codigo Day Eng. | Descripcion Day Eng. | Estado |
|---|---------------|-------------------|-----------------|---------------------|--------|
| 8 | 267092770010 | ALAMBRE 1.0X370 | (sin codigo) | ALAMBRE 1.0X370 | Quedara en desuso → Day Eng. |
| 9 | 267092770030 | ALAMBRE 1.5X470 | 267092770031 | ALAMBRE 1.5X470 | Quedara en desuso → Day Eng. |
| — | — | — | 267092002300 | ALAMBRE acero 1.5X470 | Nuevo codigo Day Eng. (adicional) |

### 2.4 Alambres de Aluminio

| # | Codigo EPFLEX | Descripcion EPFLEX | Codigo Day Eng. | Descripcion Day Eng. | Estado |
|---|---------------|-------------------|-----------------|---------------------|--------|
| 10 | 267062000000 | ALAMBRE ALUM.2.6MM(+0.05)X525MM | 267062001000 | ALAMBRE ALUM.2.6MM(+0.05)X525MM | Quedara en desuso → Day Eng. |
| — | — | — | 267065001000 | ALAMBRE ALUM.2.6MM(+0.05)X600MM | Nuevo codigo Day Eng. (variante 600mm) |

---

## 3. Checklist de Validacion en PBIP

Para cada articulo de la tabla anterior, verificar en el reporte Power BI:

### Pagina: "Stock Minimo Vs Lead Time"
Filtrar por proveedor: **EPFLEX** (y luego **Day Engineering** para los nuevos codigos).

| # | Codigo | Verificar en PBIP | Esperado | Observaciones |
|---|--------|-------------------|----------|---------------|
| | | ¿Existe en dimArticulo? | Si | Buscar por codigo en slicer Articulo |
| | | Stock Existencia | >= 0 | Si = 0, verificar si hay compras en proceso |
| | | Consumo Promedio Mes Activo | > 0 si hay demanda | Si = 0, verificar historial |
| | | Cobertura Meses | Calcular: Existencia / ConsumoMensual | Validar contra LT |
| | | Lead Time Promedio Dias | Debe tener historial | Si esta vacio, no hay recepciones previas |
| | | Stock Minimo | Configurado en ERP | Si = 0, validar con Produccion |
| | | Alerta Cobertura | PEDIR / Atencion / OK | Validar contra LT |
| | | Proveedor Articulo | EPFLEX o Day Engineering | Verificar que esta correcto |

---

## 4. Datos a Obtener del Modelo (Queries SSAS)

### Query 1: Articulos EPFLEX en dimArticulo
```sql
-- Ejecutar en SSAS via DAX Studio o MDX
EVALUATE
FILTER(
    dimArticulo,
    SEARCH("EPFLEX", dimArticulo[Proveedor Articulo], 1, 0) > 0
    || SEARCH("Day Engineering", dimArticulo[Proveedor Articulo], 1, 0) > 0
    || dimArticulo[Articulo Codigo] IN {
        "267092001988", "267092001989", "267092001990", "267092001991",
        "267092730130", "267092730140", "267927300150",
        "267092770010", "267092770030", "267062000000",
        "267092001995", "267025000000", "267092730005",
        "267092002000", "267092002100", "267092002200",
        "267092770031", "267092002300",
        "267062001000", "267065001000"
    }
)
```
**Columnas a revisar:** Articulo Codigo, Articulo Nombre, Proveedor Articulo, Articulo Stock Minimo, Lote Minimo Compra, Clase Nombre.

### Query 2: Stock actual de articulos EPFLEX/Day Engineering
```sql
EVALUATE
ADDCOLUMNS(
    FILTER(
        dimArticulo,
        dimArticulo[Articulo Codigo] IN {
            "267092001988", "267092001989", "267092001990", "267092001991",
            "267092730130", "267092730140", "267927300150",
            "267092770010", "267092770030", "267062000000",
            "267092001995", "267025000000", "267092730005",
            "267092002000", "267092002100", "267092002200",
            "267092770031", "267092002300",
            "267062001000", "267065001000"
        }
    ),
    "Existencia", [Stock Existencia],
    "Compras", [Stock Compras],
    "Proyectado", [Stock Proyectado],
    "Consumo Mensual", [Consumo Promedio por Mes Activo],
    "Cobertura Meses", [Cobertura Meses sobre Existencia],
    "Lead Time Dias", [Lead Time Promedio Dias],
    "Ultima Recepcion", [Ultima Recepcion Fecha],
    "Alerta", [Alerta Cobertura]
)
```

### Query 3: Compras en proceso para articulos de alambre
```sql
EVALUATE
FILTER(
    factComprasEnProceso,
    factComprasEnProceso[CompraEP Articulo Codigo] IN {
        "267092001988", "267092001989", "267092001990", "267092001991",
        "267092730130", "267092730140", "267927300150",
        "267092770010", "267092770030", "267062000000",
        "267092001995", "267025000000", "267092730005",
        "267092002000", "267092002100", "267092002200",
        "267092770031", "267092002300",
        "267062001000", "267065001000"
    }
)
```

---

## 5. Checklist de Impresion para Validacion en Campo

Imprimir esta seccion y llevar a la reunion con la Administradora de Produccion.

### 5.1 Articulos EPFLEX (codigos viejos)

| Codigo | Descripcion | ¿En PBIP? | Stock | Consumo | Cobertura | LT | Alerta | Comentarios |
|--------|-------------|-----------|-------|---------|-----------|----|--------|-------------|
| 267092001988 | Alambre 0,3x709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092001989 | Alambre 0,4x709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092001990 | Alambre 0,5x709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092001991 | Alambre 0,2x850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092730130 | Alambre 0.3X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092730140 | Alambre 0.4X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267927300150 | Alambre 0.5X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092770010 | Alambre 1.0X370 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092770030 | Alambre 1.5X470 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267062000000 | Alambre Aluminio 2.6x525 | [ ] | _____ | _____ | _____ | _____ | _____ | |

### 5.2 Articulos Day Engineering (codigos nuevos)

| Codigo | Descripcion | ¿En PBIP? | Stock | Consumo | Cobertura | LT | Alerta | Comentarios |
|--------|-------------|-----------|-------|---------|-----------|----|--------|-------------|
| 267092001995 | Alambre 0,3x709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267025000000 | Alambre 0,4x709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092730005 | Alambre 0.5X709 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092002000 | Alambre 0.3X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092002100 | Alambre 0.4X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092002200 | Alambre 0.5X850 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092770031 | Alambre 1.5X470 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267092002300 | Alambre 1.5X470 (nuevo) | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267062001000 | Alambre Aluminio 2.6x525 | [ ] | _____ | _____ | _____ | _____ | _____ | |
| 267065001000 | Alambre Aluminio 2.6x600 | [ ] | _____ | _____ | _____ | _____ | _____ | |

### 5.3 Articulos de Produccion relacionados (mandriles)

| Codigo | Descripcion | ¿En PBIP? | Stock | Consumo | Formula | Comentarios |
|--------|-------------|-----------|-------|---------|---------|-------------|
| 12940100000000 | Mandril cat. ureteral N°1 | [ ] | _____ | _____ | | |
| 12940200000000 | Mandril cat. ureteral N°2 | [ ] | _____ | _____ | | |

---

## 6. Preguntas para la Reunion con Produccion

1. **¿EPFLEX sigue activo como proveedor o ya se compro solo a Day Engineering?**
   - Si solo Day Engineering: los codigos EPFLEX deberian aparecer sin consumo reciente.

2. **¿Los codigos Day Engineering ya estan dados de alta en Nodum (ERP)?**
   - Si no estan: no apareceran en dimArticulo y no tendran datos.

3. **¿El stock de codigos EPFLEX se sigue usando en produccion?**
   - Si se usa: el consumo seguira apareciendo bajo el codigo viejo.

4. **¿Hay MOQ diferente entre EPFLEX y Day Engineering?**
   - Importante para la formula de "A Pedir con MOQ".

5. **¿El lead time de Day Engineering es similar al de EPFLEX?**
   - Si es diferente: las alertas de cobertura cambiaran para los nuevos codigos.

6. **¿Roberta tiene fechas de llegada estimadas para alambres?**
   - Para alimentar la tabla de Fechas de Llegada propuesta.

7. **¿Hay comentarios relevantes sobre EPFLEX o Day Engineering?**
   - Para registrar en la tabla de Comentarios de Proveedor propuesta.

---

## 7. Datos Faltantes Identificados

| Dato | ¿Esta en el modelo? | ¿Donde obtenerlo? | Prioridad |
|------|---------------------|-------------------|-----------|
| Comentarios EPFLEX | No (Gap 3.1) | Entrevista con Produccion | ALTA |
| Fechas llegada Roberta | No (Gap 3.2) | Excel de Roberta | ALTA |
| MOQ Day Engineering | Parcial (Lote Minimo Compra) | Verificar en ERP + entrevista | MEDIA |
| Codigos Day Engineering en ERP | Por verificar | Query a Nodum | ALTA |
| Lead Time Day Engineering | Por verificar (si hay recepciones) | Query a SSAS | MEDIA |
| Estado transicion por articulo | No | Entrevista con Rosana/Produccion | MEDIA |

---

## 8. Proximo Paso

Una vez completada la validacion en campo con las checklists de seccion 5:
1. Ejecutar queries de seccion 4 en SSAS para obtener datos actuales.
2. Comparar datos del PBIP con las observaciones de campo.
3. Documentar gaps encontrados.
4. Priorizar correcciones con Produccion.
