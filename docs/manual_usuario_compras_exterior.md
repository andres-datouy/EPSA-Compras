# Manual de Usuario: Reporte Compras al Exterior

## Version: 1.0
## Fecha: 2026-05-18
## Dirigido a: Area de Compras (Rosana y equipo)

---

## 1. Introduccion

Este manual explica como usar el reporte **Compras al Exterior** en Power BI para monitorear articulos que requieren compra internacional.

### 1.1 Que reemplaza este reporte?
- El Excel `Pedidos a exterior 2026.04.09.xlsx`
- Las busquedas manuales de stock en el ERP
- Los calculos manuales de cobertura

### 1.2 Acceso al reporte
- El archivo PBIX se encuentra en SharePoint: `[ruta de SharePoint]`
- Abrir con Power BI Desktop (gratuito)
- Los datos se actualizan cuando se abre el archivo y se presiona "Actualizar"

---

## 2. Estructura del reporte

### 2.1 Pagina: Compras al Exterior

Esta pagina muestra una tabla con todos los articulos a monitorear.

#### Filtros disponibles (parte superior)
| Filtro | Para que sirve |
|--------|---------------|
| Pais Origen | Filtra por pais del proveedor (excluye Uruguay por defecto) |
| Tipo Componente | Filtra componentes obligatorios vs opcionales |
| Proveedor | Filtra por nombre del proveedor |
| Articulo | Busca un articulo especifico |

#### Tabla principal
La tabla muestra 19 columnas. Las mas importantes son:

| Columna | Que significa | Como usarla |
|---------|---------------|-------------|
| **Alerta Cobertura** | Estado del articulo: PEDIR / Atencion / OK | Si dice "PEDIR" (rojo), hay que ordenar. Si dice "Atencion" (amarillo), planificar compra. |
| **Diferencia Cobertura Lead Time** | Cuanto excede o falta el stock vs el lead time | Negativo (rojo) = falta stock. Positivo (verde) = sobra stock. |
| **Stock Existencia** | Cuanto hay ahora en EPSA | Comparar con el stock minimo. |
| **Stock Proyectado** | Stock actual + compras en camino | Mejor estimador de disponibilidad futura. |
| **Consumo Promedio por Mes Activo** | Cuanto se consume por mes | Base para calcular cuanto ordenar. |
| **Lead Time Promedio Dias** | Dias promedio de demora del proveedor | Se calcula del historial de recepciones. |
| **Cobertura Meses sobre Existencia** | Cuantos meses dura el stock actual | Si es menor al lead time = alerta. |

---

## 3. Como interpretar las alertas

### 3.1 Alerta "PEDIR" (rojo)

**Significado:** El stock actual no cubre el lead time del proveedor. Si no se ordena ahora, puede haber faltante.

**Accion:**
1. Verificar la cantidad sugerida en el campo "A pedir" (cuando esté disponible)
2. Considerar el minimo de compra (MOQ)
3. Verificar si hay oportunidad de consolidar con otros articulos del mismo proveedor
4. Generar la orden de compra

### 3.2 Alerta "Atencion" (amarillo)

**Significado:** El stock cubre el lead time, pero no hay margen de seguridad. Cualquier demora o consumo inesperado puede generar faltante.

**Accion:**
1. Planificar la compra para el proximo ciclo
2. No es urgente, pero no debe posponerse

### 3.3 Alerta "OK" (verde)

**Significado:** El stock cubre el lead time con al menos 1 mes de seguridad.

**Accion:**
1. No requiere accion inmediata
2. Revisar en el proximo ciclo de monitoreo

---

## 4. Casos de uso tipicos

### 4.1 "Que tengo que comprar esta semana?"

1. Aplicar filtro: `Alerta Cobertura = "PEDIR"`
2. Ordenar por `Diferencia Cobertura Lead Time` (de menor a mayor)
3. Los primeros son los mas criticos
4. Para cada uno, verificar `Stock Existencia` y `Consumo Promedio`

### 4.2 "Cuanto debo pedir de un articulo?"

> Nota: Esta funcionalidad está en desarrollo. Consultar con Sistemas.

Formula manual provisional:
```
Cantidad a Pedir = Consumo Mensual * (Lead Time en meses + 1) - Stock Proyectado
```

Ajustar considerando:
- Minimo de compra del proveedor
- Presentacion (cajas, pallets)
- Consolidacion con otros articulos

### 4.3 "Hay articulos de un proveedor que puedo consolidar?"

1. Filtrar por proveedor (ej: "Martech")
2. Ver todos sus articulos
3. Revisar cuales tienen alerta PEDIR o Atencion
4. Sumar las cantidades a pedir
5. Evaluar si conviene un solo envio

### 4.4 "Un articulo aparece con proveedor 'Sin datos'"

Esto significa que el articulo no tiene proveedor asignado en el ERP.

**Accion:**
1. Verificar en el ERP si el articulo tiene proveedor por defecto
2. Si es un articulo nuevo, solicitar alta de proveedor
3. Comunicar a Sistemas para actualizar la vista

---

## 5. Preguntas frecuentes

### P: Los numeros no coinciden con mi Excel
R: El reporte toma datos directamente del ERP. Si hay diferencias, verificar:
- Fecha de ultima actualizacion del ERP
- Si el articulo tiene movimientos recientes no reflejados
- Comunicar a Sistemas para validar

### P: Un articulo deberia estar en la lista pero no aparece
R: Verificar si cumple los criterios de inclusion (ver Reglas de Negocio). Si cumple y no aparece, solicitar alta mediante el proceso establecido.

### P: Un articulo aparece pero ya no lo compro al exterior
R: Solicitar baja mediante el proceso establecido. El articulo se marcara como "No monitoreado".

### P: El lead time no coincide con lo que yo se
R: El lead time se calcula del historial de recepciones. Si cambio recientemente, comunicar a Sistemas para actualizar.

### P: Puedo guardar mis filtros?
R: Si. Power BI Desktop permite guardar filtros con "Bookmarks" (Marcadores). Consultar la seccion avanzada.

---

## 6. Glosario

| Termino | Significado |
|---------|-------------|
| **Lead Time** | Tiempo entre ordenar y recibir |
| **Cobertura** | Cuantos meses de stock hay |
| **Stock Proyectado** | Stock actual + lo que viene en camino |
| **MOQ** | Minimo de compra |
| **Consolidacion** | Juntar varios articulos en un solo envio |

---

## 7. Soporte

| Problema | Contacto |
|----------|----------|
| Error en el reporte | Sistemas / BI |
| Datos incorrectos | Sistemas / BI + Compras |
| Nuevo articulo a incluir | Jefe de Compras |
| Articulo a excluir | Jefe de Compras |
| Dudas sobre interpretacion | Rosana (referente de Compras) |
