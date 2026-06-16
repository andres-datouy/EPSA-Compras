# Reglas de Negocio: Compras al Exterior

## Version: 1.0
## Estado: Borrador — Pendiente validacion con Gerencia
## Fecha: 2026-05-18

---

## 1. Alcance del reporte

### 1.1 Objetivo
El reporte de **Compras al Exterior** tiene como objetivo centralizar el monitoreo de articulos cuyo abastecimiento requiere planificacion especial debido a:
- Lead times extendidos (compras internacionales)
- Dependencia de proveedores externos
- Necesidad de mantener stock de seguridad

### 1.2 Definicion operativa de "Compra al Exterior"
Una compra se considera "al exterior" cuando cumple **al menos una** de las siguientes condiciones:

| Criterio | Descripcion | Fuente de datos |
|----------|-------------|-----------------|
| C1 | El proveedor por defecto del articulo tiene pais de origen != "Uruguay" | `dimArticulo[ProveedorPaisNombre]` |
| C2 | El articulo figura en la lista de articulos monitoreados de Compras Exteriores (Excel Rosana) | Lista externa a validar |
| C3 | El articulo es componente obligatorio de una formula de produccion activa y su proveedor es del exterior | Cruce con formulas de produccion |

> **Nota:** Los articulos con proveedor local (UY) que encarguen al exterior por cuenta del comprador (ej: GSSA, intermediarios) tambien se consideran "exterior" para efectos de este reporte.

---

## 2. Criterios de inclusion en la lista de monitoreo

### 2.1 Lista base (365 articulos)
La lista de ~365 articulos proviene del Excel de Rosana (`Pedidos a exterior 2026.04.09.xlsx`). Esta lista es la **autoridad inicial** para determinar que articulos se monitorean.

**Regla R1:** Todo articulo que figure en el Excel de Rosana debe incluirse en el reporte.

### 2.2 Articulos de formulas de produccion activas

**Regla R2:** Se incluyen los componentes obligatorios de formulas de produccion que se encuentren actualmente en uso.

**Subcriterios:**
- **R2.1** Formulas de pedidos recientes (ultimos 6 meses)
- **R2.2** Formulas del presupuesto de GSSA (vigente)
- **R2.3** Formulas historicas que se siguen produciendo

**Exclusion:** Si una formula fue discontinuada y no hay pedidos recientes, sus componentes no se incluyen automaticamente.

### 2.3 Repuestos y articulos criticos

**Regla R3:** Se incluyen articulos que, aunque no componen formulas de produccion activas, son vitales por:
- Ser repuestos de maquinas importantes (con stock minimo definido)
- Tener consumo relevante historico
- Ser identificados por el area de Compras como criticos

### 2.4 Articulos con proveedor local que encarga al exterior

**Regla R4:** Si un articulo tiene proveedor local (UY) pero el proveedor encarga la materia prima o el producto terminado al exterior, el articulo se incluye en el monitoreo con las mismas consideraciones de lead time y cobertura.

> **Ejemplo:** Un proveedor uruguayo que importa componentes de China debe tener el mismo nivel de seguimiento que un proveedor directo de China.

### 2.5 Propuesta: Atributo explicito en ERP (pendiente aprobacion)

**Regla R5-propuesta:** Se propone agregar un campo `MonitoreoComprasExterior` en ct_articulos (o tabla auxiliar `ComprasExteriores_Monitoreo`) para explicitar la asignacion de responsabilidad por area.

> Ver documento completo: `docs/propuesta_alcance_monitoreo.md`

---

## 3. Criterios de exclusion de la lista

### 3.1 Articulos discontinuados

**Regla R5:** Un articulo se excluye de la lista cuando:
- Ha sido oficialmente discontinuado por el proveedor
- No tiene consumo en los ultimos 12 meses
- No hay stock existente ni compras en proceso
- No esta en ninguna formula de produccion activa

### 3.2 Articulos con abastecimiento local seguro

**Regla R6:** Un articulo puede excluirse si:
- Tiene proveedor local (UY) con stock de seguridad garantizado
- El lead time local es menor a 15 dias
- No hay riesgo de desabastecimiento demostrable

> **Nota:** La exclusion debe ser aprobada por el responsable de Compras Exteriores.

---

## 4. Clasificacion de alertas

### 4.1 Niveles de alerta

| Nivel | Condicion | Accion requerida |
|-------|-----------|------------------|
| **CRITICO (PEDIR)** | `Cobertura < Lead Time` | Ordenar inmediatamente. Stock insuficiente para cubrir el lead time. |
| **ATENCION** | `Lead Time <= Cobertura < Lead Time + 1 mes` | Planificar compra. El stock cubre el lead time pero no hay margen de seguridad. |
| **OK** | `Cobertura >= Lead Time + 1 mes` | Sin accion requerida. Cobertura suficiente. |

### 4.2 Cobertura utilizada

El reporte muestra **dos** coberturas:

1. **Cobertura sobre Existencia:** `Stock Existencia / Consumo Promedio Mensual`
2. **Cobertura sobre Existencia + Proyectado:** `(Stock Existencia + Stock Proyectado) / Consumo Promedio Mensual`

**Regla R7:** La alerta principal usa la **Cobertura sobre Existencia** como medida conservadora. La cobertura proyectada se usa como referencia secundaria.

---

## 5. Calculo de "Cantidad a Pedir"

### 5.1 Formula base (pendiente validacion con Rosana)

```
Cantidad a Pedir = MAX(0, Necesidad - Stock Proyectado)

Donde:
  Necesidad = Consumo Promedio Mensual * (Lead Time en meses + Meses de Seguridad)
  Meses de Seguridad = 1 (configurable por articulo)
```

### 5.2 Ajustes manuales

**Regla R8:** La cantidad calculada por formula es una **sugerencia**. El comprador puede ajustarla manualmente considerando:
- Minimos de compra (MOQ)
- Presentacion del producto (cajas, pallets)
- Consolidacion con otros articulos del mismo proveedor
- Oportunidades de flete compartido
- Condiciones comerciales especiales

---

## 6. Roles y responsabilidades

| Rol | Responsabilidad | Acceso al reporte |
|-----|-----------------|-------------------|
| **Compras Exteriores (Rosana)** | Monitoreo diario, toma de decisiones de compra, ajuste de cantidades | Lectura + escritura (comentarios) |
| **Jefe de Compras** | Aprobacion de compras mayores, validacion de alertas, exclusion/inclusion de articulos | Lectura + administracion |
| **Gerencia** | Revision mensual de KPIs, aprobacion de politicas | Lectura |
| **Sistemas / BI** | Mantenimiento del modelo, actualizacion de datos, soporte tecnico | Administracion tecnica |

---

## 7. Proceso de actualizacion de la lista

### 7.1 Alta de nuevo articulo

**Solicitante:** Area de Compras o Produccion

**Flujo:**
1. Identificar articulo que cumple criterios de inclusion (R1-R4)
2. Completar formulario de alta con:
   - Codigo de articulo
   - Proveedor por defecto
   - Lead time estimado
   - Stock minimo sugerido
   - Motivo de inclusion
3. Aprobacion del Jefe de Compras
4. Sistemas actualiza la lista en el modelo
5. El articulo aparece en el reporte desde el siguiente refresh

### 7.2 Baja de articulo

**Solicitante:** Area de Compras

**Flujo:**
1. Justificar exclusion segun criterios R5-R6
2. Aprobacion del Jefe de Compras
3. El articulo se marca como "No monitoreado" (no se elimina historicamente)
4. Sistemas actualiza la lista en el modelo

### 7.3 Dashboard de control de lista

Se propone crear una pagina adicional en el reporte para:
- Ver articulos actualmente monitoreados
- Identificar articulos nuevos (con demanda reciente no en lista)
- Identificar articulos candidatos a baja (sin demanda + sin stock)
- Gestionar altas y bajas

---

## 8. Definiciones

| Termino | Definicion |
|---------|------------|
| **Stock Existencia** | Cantidad fisica disponible en EPSA (estados "existencia" y "stkaf") |
| **Stock Proyectado** | Stock Existencia + Compras en proceso |
| **Consumo Promedio Mensual Activo** | Promedio de consumo en meses con movimiento (excluye recepciones) |
| **Lead Time** | Dias promedio entre OC y recepcion, calculado historicamente |
| **Cobertura** | Meses de stock disponibles al ritmo de consumo actual |
| **MOQ** | Minimo de compra (Minimum Order Quantity) |
| **GSSA** | Gerencia de Suministros y Servicios Auxiliares |

---

## 9. Historial de cambios

| Version | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2026-05-18 | Sistemas / BI | Documento inicial con reglas de inclusion, exclusion, alertas y roles |
