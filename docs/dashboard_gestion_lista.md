# Especificacion: Dashboard de Gestion de Lista de Monitoreo

## Version: 1.0
## Fecha: 2026-05-18
## Estado: Propuesta — Pendiente aprobacion

---

## 1. Objetivo

Crear una pagina adicional en el reporte de Compras al Exterior para **gestionar la lista de articulos monitoreados**.

Esta pagina permite:
1. Visualizar articulos actualmente en monitoreo
2. Identificar **nuevos candidatos** a inclusion (articulos con demanda reciente no en lista)
3. Identificar **candidatos a baja** (articulos sin demanda ni stock)
4. Consultar informacion complementaria de cualquier articulo

---

## 2. Fuentes de datos necesarias

### 2.1 Tabla maestra: `dimArticuloMonitoreo`

Se propone crear una tabla auxiliar en el modelo (o en SQL) que marque que articulos estan en monitoreo.

| Columna | Tipo | Descripcion |
|---------|------|-------------|
| `Articulo Codigo` | String | PK. Codigo del articulo |
| `En Monitoreo` | Boolean | TRUE si el articulo esta activo en la lista |
| `Fecha Alta` | Date | Cuando se agrego a la lista |
| `Fecha Baja` | Date | Cuando se removio (NULL si esta activo) |
| `Motivo Inclusion` | String | Por que se incluyo (Regla R1-R4) |
| `Usuario Alta` | String | Quien solicito la inclusion |
| `Usuario Baja` | String | Quien solicito la exclusion |

### 2.2 Fuentes para identificar candidatos

| Fuente | Uso |
|--------|-----|
| `factConsumoHistoria` (ultimos 6 meses) | Identificar articulos con consumo reciente no en lista |
| `factStockEPSA` | Verificar stock existente |
| `factComprasEnProceso` | Verificar compras en curso |
| Formulas de produccion activas | Identificar componentes obligatorios |
| Excel de Rosana (365 articulos) | Lista base autorizada |

---

## 3. Diseno de la pagina

### 3.1 Seccion A: KPIs de estado de la lista

| KPI | Medida | Color |
|-----|--------|-------|
| Articulos en monitoreo | `COUNTROWS(FILTER(dimArticuloMonitoreo, [En Monitoreo]))` | Neutral |
| Nuevos candidatos | `COUNTROWS(CandidatosNuevos)` | Amarillo |
| Candidatos a baja | `COUNTROWS(CandidatosBaja)` | Rojo |
| Articulos sin proveedor asignado | `COUNTROWS(FILTER(dimArticulo, ISBLANK([Proveedor Articulo])))` | Rojo |

### 3.2 Seccion B: Tabla de articulos en monitoreo

Columnas:
- Codigo
- Descripcion
- Proveedor
- Pais
- Fecha Alta
- Motivo Inclusion
- En Monitoreo (si/no)
- Accion: Boton para solicitar baja

### 3.3 Seccion C: Candidatos a inclusion (NUEVOS)

**Logica:** Articulos que:
- NO estan en `dimArticuloMonitoreo`
- TIENEN consumo en los ultimos 6 meses
- O son componentes de formulas activas
- O tienen stock existente > 0

Columnas:
- Codigo
- Descripcion
- Proveedor
- Pais
- Consumo ultimos 6 meses
- Stock actual
- En formula activa (si/no)
- Accion: Boton para solicitar alta

### 3.4 Seccion D: Candidatos a baja

**Logica:** Articulos que:
- SI estan en `dimArticuloMonitoreo`
- NO tienen consumo en los ultimos 12 meses
- Stock existencia = 0
- No hay compras en proceso

Columnas:
- Codigo
- Descripcion
- Proveedor
- Ultimo consumo (fecha)
- Stock actual
- Fecha Alta en lista
- Dias en lista sin movimiento
- Accion: Boton para solicitar baja

### 3.5 Seccion E: Consulta de articulo

**Buscador:** Input para buscar cualquier articulo por codigo o nombre.

**Resultados:**
- Informacion basica (codigo, nombre, proveedor, pais)
- Stock existencia y proyectado
- Consumo mensual
- Cobertura actual
- Historial de compras (ultimas 12 recepciones)
- Historial de consumo (ultimos 12 meses)
- Estado en lista de monitoreo

---

## 4. Medidas DAX propuestas

### 4.1 Candidatos Nuevos

```dax
Candidatos Nuevos = 
VAR ArticulosEnLista = VALUES(dimArticuloMonitoreo[Articulo Codigo])
VAR ArticulosConConsumo = 
    CALCULATETABLE(
        VALUES(factConsumoHistoria[Consumo Articulo Código]),
        factConsumoHistoria[Consumo Fecha] >= DATE(YEAR(TODAY())-1, MONTH(TODAY()), DAY(TODAY()))
    )
VAR ArticulosConStock = 
    FILTER(
        VALUES(dimArticulo[Artículo Código]),
        [Stock Existencia] > 0
    )
VAR ArticulosEnFormula = 
    // Requiere tabla de formulas de produccion
    VALUES(dimFormula[Articulo Componente Codigo])
RETURN
    EXCEPT(
        UNION(ArticulosConConsumo, ArticulosConStock, ArticulosEnFormula),
        ArticulosEnLista
    )
```

### 4.2 Candidatos a Baja

```dax
Candidatos Baja = 
VAR ArticulosEnLista = VALUES(dimArticuloMonitoreo[Articulo Codigo])
VAR ArticulosSinConsumo = 
    EXCEPT(
        ArticulosEnLista,
        CALCULATETABLE(
            VALUES(factConsumoHistoria[Consumo Articulo Código]),
            factConsumoHistoria[Consumo Fecha] >= DATE(YEAR(TODAY())-1, MONTH(TODAY()), DAY(TODAY()))
        )
    )
VAR ArticulosSinStock = 
    FILTER(
        ArticulosEnLista,
        [Stock Existencia] = 0 && [Stock Compras] = 0
    )
RETURN
    INTERSECT(ArticulosSinConsumo, ArticulosSinStock)
```

### 4.3 Dias en Lista Sin Movimiento

```dax
Dias en Lista Sin Movimiento = 
VAR FechaAlta = MAX(dimArticuloMonitoreo[Fecha Alta])
VAR UltimoConsumo = MAX(factConsumoHistoria[Consumo Fecha])
RETURN
    IF(
        ISBLANK(UltimoConsumo),
        DATEDIFF(FechaAlta, TODAY(), DAY),
        DATEDIFF(UltimoConsumo, TODAY(), DAY)
    )
```

---

## 5. Implementacion propuesta

### Fase 1: Tabla auxiliar en SQL

Crear tabla `EPSA_BI.dbo.ComprasExteriores_Monitoreo`:

```sql
CREATE TABLE EPSA_BI.dbo.ComprasExteriores_Monitoreo (
    ArticuloCodigo VARCHAR(50) PRIMARY KEY,
    EnMonitoreo BIT NOT NULL DEFAULT 1,
    FechaAlta DATE NOT NULL DEFAULT GETDATE(),
    FechaBaja DATE NULL,
    MotivoInclusion VARCHAR(255),
    UsuarioAlta VARCHAR(100),
    UsuarioBaja VARCHAR(100)
);
```

### Fase 2: Poblar tabla inicial

Insertar los ~365 articulos del Excel de Rosana:

```sql
INSERT INTO EPSA_BI.dbo.ComprasExteriores_Monitoreo (ArticuloCodigo, MotivoInclusion, UsuarioAlta)
SELECT cod_articulo, 'Lista base Excel Rosana', 'Sistemas'
FROM ... -- Importar desde Excel
```

### Fase 3: Integrar en modelo Power BI

1. Agregar tabla `ComprasExteriores_Monitoreo` al modelo
2. Crear relacion con `dimArticulo`
3. Crear las medidas DAX propuestas
4. Construir la pagina de gestion

### Fase 4: Proceso de alta/baja

Crear procedimiento almacenado para:
- Alta de articulo
- Baja de articulo
- Auditoria de cambios

---

## 6. Consideraciones

### Seguridad
- Solo usuarios autorizados (Jefe de Compras, Sistemas) pueden modificar la lista
- Los cambios quedan registrados en tabla de auditoria

### Refresh
- La tabla `ComprasExteriores_Monitoreo` se refresca con el modelo
- Los candidatos a inclusion/baja se calculan en tiempo real

### Limitaciones
- Las formulas de produccion activas requieren una fuente de datos adicional (no esta actualmente en el modelo)
- El Excel de Rosana debe importarse periodicamente para mantener la lista base sincronizada
