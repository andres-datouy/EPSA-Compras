# Proceso de Compra: EPFLEX / Day Engineering (Alambres)

## Version: 1.0
## Fecha: 2026-05-18
## Categoria: Proveedor en transicion

---

## 1. Situacion Actual

**EPFLEX** (proveedor de alambres de acero 4310 y aluminio) esta siendo **reemplazado por Day Engineering**.

**Implicancia:**
- Los codigos EPFLEX quedan en desuso progresivamente
- Las nuevas compras se hacen con codigos Day Engineering
- Durante la transicion puede haber stock residual de codigos viejos

**Productos involucrados:**
- Alambres de acero inoxidable 4310 (diametros 0.2 a 1.5mm, largos 370 a 850mm)
- Alambres de aluminio 2.6mm (largos 525 y 600mm)

**Uso en Produccion:**
- Mandriles para cateteres ureterales N°1 y N°2
- Componentes de dispositivos medicos varios

---

## 2. Proceso de Validacion y Compra Paso a Paso

### PASO 1: Abrir reporte y seleccionar proveedor

1. Abrir `EPSA-Compras.pbip` en Power BI Desktop
2. Ir a pagina **"Stock Minimo Vs Lead Time"**
3. En slicer Proveedor, buscar y seleccionar:
   - **"EPFLEX"** (para ver codigos viejos y stock residual)
   - **"Day Engineering"** (para ver codigos nuevos y compras activas)
4. Si no aparece ninguno: informar a Sistemas (puede que el proveedor no este registrado en dimProveedor)

### PASO 2: Revisar estado de cada articulo

Para cada articulo en la tabla filtrada, verificar:

| Columna | Que buscar | Si hay problema |
|---------|-----------|-----------------|
| Existencia | ¿Hay stock? | Si = 0, urgente |
| Consumo Promedio Mes Activo | ¿Se consume regularmente? | Si = 0, verificar si sigue en uso |
| Cobertura Meses | ¿Cuantos meses dura? | Si < LT, alerta PEDIR |
| Lead Time Dias | ¿Cuantos dias tarda? | Si vacio, no hay historial |
| Alerta Cobertura | ¿PEDIR, Atencion u OK? | PEDIR = actuar ahora |
| Stock Compras | ¿Hay OC activas? | Si > 0, verificar fecha llegada |
| A Pedir Sugerido | ¿Cuanto ordenar? | Base para la decision |

### PASO 3: Verificar transicion de codigos

Para cada codigo EPFLEX, consultar la tabla de mapeo:

| Si el codigo EPFLEX tiene... | Accion |
|------------------------------|--------|
| Stock > 0 y consumo activo | Seguir usando hasta agotar; planificar compra con codigo Day Eng. |
| Stock > 0 y sin consumo | Verificar si el articulo ya no se usa; evaluar descarte |
| Stock = 0 y codigo Day Eng. existe | Comprar directamente con codigo Day Eng. |
| Stock = 0 y codigo Day Eng. NO existe | Solicitar alta del codigo Day Eng. en Nodum (ERP) |

### PASO 4: Verificar codigo Day Engineering en el modelo

1. En el slicer Articulo, buscar el codigo Day Engineering correspondiente
2. Si aparece: revisar sus datos (stock, consumo, LT)
3. Si NO aparece: el codigo no esta en dimArticulo → necesita alta en ERP
4. Informar a Produccion y Compras la necesidad de alta

### PASO 5: Consultar con Roberta (Importaciones)

Preguntar:
- ¿Hay pedidos en transito para alambres?
- ¿Cual es la fecha estimada de llegada a EPSA?
- ¿Hay demoras en aduana o transporte?

### PASO 6: Decidir cantidad a comprar

Basandose en la columna "A Pedir Sugerido":

```
Ejemplo:
Articulo: Alambre 0.3x709 (codigo Day Eng: 267092001995)
A Pedir Sugerido: 3,000 unidades
MOQ Day Engineering: (verificar)
Presentacion: Bobinas de 1,000 unidades

Decision:
- Si MOQ = 1,000 → pedir 3,000 (cumple MOQ y es multiplo)
- Si MOQ = 5,000 → pedir 5,000 (ajustar al minimo)
- Si hay 2 articulos del mismo proveedor → consolidar en 1 envio
```

### PASO 7: Coordinar con Rosana (Compras Exteriores)

Informar:
- Articulo(s) a comprar (codigo Day Engineering)
- Cantidad decidida
- Urgencia (basada en cobertura y fecha de agotamiento)
- Si hay oportunidad de consolidar con otros articulos

### PASO 8: Registrar comentarios

Una vez completada la compra, registrar (en el Excel de Rosana por ahora):
- Fecha de emision de OC
- Proveedor efectivo (Day Engineering)
- Cantidad pedida
- Fecha estimada de llegada (informada por Roberta)
- Cualquier observacion sobre el proveedor

---

## 3. Checklist para Reunion de Validacion

Llevar impresa a la reunion con la Administradora de Produccion:

### Articulos EPFLEX (codigos viejos)

| # | Codigo | Stock PBIP | Stock Fisico | Consumo | ¿Se sigue usando? | Accion |
|---|--------|-----------|-------------|---------|-------------------|--------|
| 1 | 267092001988 | ___ | ___ | ___ | Si / No | |
| 2 | 267092001989 | ___ | ___ | ___ | Si / No | |
| 3 | 267092001990 | ___ | ___ | ___ | Si / No | |
| 4 | 267092001991 | ___ | ___ | ___ | Si / No | |
| 5 | 267092730130 | ___ | ___ | ___ | Si / No | |
| 6 | 267092730140 | ___ | ___ | ___ | Si / No | |
| 7 | 267927300150 | ___ | ___ | ___ | Si / No | |
| 8 | 267092770010 | ___ | ___ | ___ | Si / No | |
| 9 | 267092770030 | ___ | ___ | ___ | Si / No | |
| 10 | 267062000000 | ___ | ___ | ___ | Si / No | |

### Articulos Day Engineering (codigos nuevos)

| # | Codigo | ¿Existe en PBIP? | Stock | Consumo | LT | MOQ | Observaciones |
|---|--------|-----------------|-------|---------|-----|-----|---------------|
| 1 | 267092001995 | Si / No | ___ | ___ | ___ | ___ | |
| 2 | 267025000000 | Si / No | ___ | ___ | ___ | ___ | |
| 3 | 267092730005 | Si / No | ___ | ___ | ___ | ___ | |
| 4 | 267092002000 | Si / No | ___ | ___ | ___ | ___ | |
| 5 | 267092002100 | Si / No | ___ | ___ | ___ | ___ | |
| 6 | 267092002200 | Si / No | ___ | ___ | ___ | ___ | |
| 7 | 267092770031 | Si / No | ___ | ___ | ___ | ___ | |
| 8 | 267092002300 | Si / No | ___ | ___ | ___ | ___ | |
| 9 | 267062001000 | Si / No | ___ | ___ | ___ | ___ | |
| 10 | 267065001000 | Si / No | ___ | ___ | ___ | ___ | |

### Preguntas para Produccion

- [ ] ¿EPFLEX sigue activo o ya se compro solo a Day Engineering?
- [ ] ¿Los codigos Day Engineering estan dados de alta en Nodum?
- [ ] ¿El stock de codigos EPFLEX se sigue usando?
- [ ] ¿Hay MOQ diferente entre EPFLEX y Day Engineering?
- [ ] ¿El lead time de Day Engineering es similar al de EPFLEX?
- [ ] ¿Roberta tiene fechas de llegada para alambres?
- [ ] ¿Hay comentarios relevantes sobre estos proveedores?

---

## 4. Historial de Cambios

| Version | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2026-05-18 | Documento inicial |
