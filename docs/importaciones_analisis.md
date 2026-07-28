# Analisis: Importaciones en Curso (Roberta — Importaciones)

## Version: 1.0
## Fecha: 2026-07-14
## Archivo: `docs/excel/importaciones en curso 19 06 2026.xlsx`
## Responsable: Roberta (Jefa de Importaciones)

---

## 1. Descripcion General

Este archivo es el **log activo de importaciones** que Roberta mantiene actualizado. Registra cada linea de factura/orden de compra en proceso de importacion, desde la emision hasta el ingreso a stock.

**Es la fuente de verdad para:**
- Fechas estimadas de llegada de mercaderia a EPSA (ETA)
- Estado de cada importacion en el pipeline
- Prevision de gasto en USD para despachos aduaneros
- Seguimiento logistico (BL/AWB, forwarder, modal, bultos, peso)

**Actualizacion:** Roberta lo actualiza manualmente de forma continua. El archivo refleja el estado al 19/06/2026.

---

## 2. Estructura del Archivo

### 2.1 Hojas
| Hoja | Filas | Columnas | Descripcion |
|------|-------|----------|-------------|
| 19 06 2026 | 85 datos + 1 header | 34 (A-AH) | Log principal de importaciones activas |
| Resumen | 4 datos + 1 header | 9 (A-I) | Vista filtrada de llegadas inminentes |

### 2.2 Columnas (34)

| Col | Nombre | Tipo | Descripcion | Cobertura |
|-----|--------|------|-------------|-----------|
| A | EMPRESA | String | EPSA o GSSA (empresa que compra) | 85/85 (100%) |
| B | PROVEEDOR | String | Nombre del proveedor | 85/85 (100%) |
| C | ORIGEN | String | Pais de origen | 82/85 (96%) |
| D | FECHA DE PO | Date | Fecha de la orden de compra | 6/85 (7%) |
| E | PO | Mixed | Numero de orden de compra | ~65/85 |
| F | INCOTERM | String | Termino comercial (EXW, FCA, FOB, CIP) | 69/85 (81%) |
| G | FACTURA | String | Numero de factura comercial | ~60/85 |
| H | FECHA FACTURA | Date | Fecha de la factura | 40/85 (47%) |
| I | MONEDA | String | EUR o USD | 78/85 (92%) |
| J | VALOR FACTURA | Number | Monto de la factura en moneda original | 78/85 (92%) |
| K | PLAZO DE PAGO | String | Condiciones de pago | 74/85 (87%) |
| L | VTO (FECHA) | Mixed | Fecha de vencimiento del pago | ~35 fechas + textos "pagado" |
| M | CARPETA | Int | Numero de carpeta de importacion | ~65/85 |
| N | PREVISION EMBARQUE | Date | Fecha prevista de embarque | 57/85 (67%) |
| O | ETD | Date | Estimated Time of Departure | 45/85 (53%) |
| P | ETA | Date | **Estimated Time of Arrival a EPSA** | 73/85 (86%) |
| Q | FECHA NECESIDAD | Date/Mixed | Fecha en que se necesita la mercaderia | 7/85 (8%) |
| R | INGRESO A STOCK | String | Referencia de ingreso ("PF" o "RBOL Ref...") | 7/85 (8%) |
| S | OBSERVACIONES | String | Notas libres (BL, buque, comentarios) | ~35/85 |
| T | % | Number | Porcentaje (uso esporadico) | 1/85 |
| U | FLETE | Number | Costo de flete | 17/85 |
| V | GSTOS | Number | Gastos de importacion | 14/85 |
| W | **ESTADO** | String | Estado del workflow de importacion | 85/85 (100%) |
| X | BL/AWB | String | Numero de conocimiento de embarque | ~50/85 |
| Y | MODAL | String | Tipo de transporte (MARITIMO/aereo/Terrestre) | 74/85 (87%) |
| Z | FORWARDER | String | Agente de carga | 46/85 (54%) |
| AA | DUA | String | Documento Unico Aduanero | 0/85 |
| AB | BULTOS | Int | Cantidad de bultos/packages | 48/85 (56%) |
| AC | TIPO | String | Tipo de embalaje (pallet, cajas, BULTOS) | ~50/85 |
| AD | PESO | Number | Peso en kg | 53/85 (62%) |
| AE | CIERRE (FECHA) | Date | Fecha de cierre (vacia al momento) | 0/85 |
| AF | Equivalente en USD | Number | Valor facturado convertido a USD | 85/85 (100%) |
| AG | prevision de USD para despacho | Number | Prevision de costo en USD para despacho aduanero | 85/85 (100%) |
| AH | semana del año | Int | Numero de semana ISO del ano | 85/85 (100%) |

---

## 3. Workflow de Estados

Roberta maneja 6 estados que reflejan el ciclo de vida de una importacion:

```
AGENDA DE PAGOS → COORDINAR → PROGRAMADA → TRANSITO → ARRIBADA → (ingreso a stock)
```

| Estado | Cantidad | Descripcion |
|--------|----------|-------------|
| **AGENDA DE PAGOS** | 11 | La factura esta registrada, pendiente de pago |
| **COORDINAR** | 22 | Pendiente de coordinacion logistica (cotizacion, pick up, etc.) |
| **PROGRAMADA** | 21 | Embarque programado, fecha ETD definida |
| **TRANSITO** | 22 | Mercaderia en transito (embarcada, en viaje) |
| **ARRIBADA** | 4 | Llego a destino, pendiente ingreso a stock |
| **supramar** | 5 | Caso especial (probablemente proveedor Supramar) |

**Estados relevantes para Produccion:**
- TRANSITO → mercaderia en camino, ETA disponible
- ARRIBADA → llego, pronto disponible
- PROGRAMADA → salida confirmada, ETA estimada

---

## 4. Datos Cuantitativos

### 4.1 Volumenes
| Metrica | Valor |
|---------|-------|
| Lineas activas | 85 |
| Valor total facturado (original) | EUR ~700K + USD ~440K |
| Equivalente USD total | ~$1,282,718 |
| Prevision USD para despacho | ~$783,610 |
| Proveedores distintos | 50 |
| Paises de origen | 19 |

### 4.2 Top Proveedores
| Proveedor | Lineas | Pais |
|-----------|--------|------|
| IHT | 7 | España |
| Plasticos Durex-Aspirator | 7 | España |
| POLYMED | 6 | India |
| TELEFLEX USA | 5 | USA |
| INT AIR | 3 | Francia |
| WIPAK | 3 | Finlandia |
| KLS MARTIN | 3 | Alemania |
| BQ MEDICAL | 3 | China |
| Day engineering | 2 | India |

### 4.3 Distribucion por Empresa
| Empresa | Lineas | % |
|---------|--------|---|
| EPSA | 47 | 55% |
| GSSA | 34 | 40% |
| EPSA-supramar | 4 | 5% |

### 4.4 Modal de Transporte
| Modal | Lineas | % |
|-------|--------|---|
| MARITIMO | ~65 | 88% |
| Aereo | ~8 | 11% |
| Terrestre | 1 | 1% |

### 4.5 Rangos de Fechas
| Columna | Desde | Hasta |
|---------|-------|-------|
| PREVISION EMBARQUE | 2025-05-19 | 2026-12-04 |
| ETD | 2025-09-06 | 2026-06-28 |
| **ETA** | **2026-06-14** | **2026-12-31** |
| FECHA NECESIDAD | 2025-07-01 | 2026-12-01 |

---

## 5. Relacion con Gaps Identificados

### 5.1 Gap 3.2: Fechas de Llegada (RESUELTO)

**Este archivo ES la fuente que buscabamos.** La columna P (ETA) contiene exactamente la "Fecha de llegada estimada a EPSA" que Roberta mantiene y que Produccion necesita.

**Cobertura:** 73 de 85 filas (86%) tienen ETA.

### 5.2 Gap 3.1: Comentarios de Proveedor (PARCIAL)

La columna S (OBSERVACIONES) contiene notas operativas por envio, no por proveedor. Ejemplos:
- "BL: ME26000114/1 - WELU5386606" (numero de BL)
- "YA SE HIZO PICK UP"
- "COTIZANDO"
- "The 0,40 mm coils could be send in week 25..." (detalle de producto)
- "aguradar BL" (esperando BL)

No es exactamente la tabla de comentarios que propusimos (comentarios permanentes por proveedor), pero es util para contexto.

### 5.3 Nuevos Datos Identificados

| Dato | Relevancia | Uso |
|------|-----------|-----|
| ETA (col P) | **CRITICA** | Fecha de llegada para Produccion |
| ESTADO (col W) | **CRITICA** | Saber en que etapa esta cada importacion |
| PREVISION EMBARQUE (col N) | ALTA | Planificar cuando sale la mercaderia |
| ETD (col O) | ALTA | Fecha real de salida |
| EQUIVALENTE USD (col AF) | ALTA | Prevision de gasto de Compras |
| PREVISION USD DESPACHO (col AG) | ALTA | Prevision de costo aduanero |
| CARPETA (col M) | MEDIA | Vinculo con factComprasEnProceso |
| PLAZO DE PAGO (col K) | MEDIA | Flujo de caja |
| FECHA NECESIDAD (col Q) | MEDIA | Priorizar urgencias |
| FLETE (col U) + GSTOS (col V) | BAJA | Analisis de costos |

---

## 6. Limitaciones para Integracion al Modelo

### 6.1 Granularidad: Envio vs Articulo
Cada fila es una **linea de factura/envio**, NO un articulo individual. No hay columna de codigo de articulo.

**Implicancia:** Para vincular con el modelo (que es a nivel articulo), necesitamos:
1. Cruzar por numero de Carpeta (col M) con `factComprasEnProceso` (que tiene articulos por OC)
2. O cruzar por numero de PO (col E) con las OC del ERP
3. O aceptar que esta tabla se integra a nivel de envio/OC, no por articulo

### 6.2 Fechas Mixtas
La columna L (VTO) tiene tanto fechas como texto ("pagado 23 03"). Requiere limpieza.

### 6.3 Inconsistencias de Formato
- ORIGEN: "España" / "España" / "CHINA" / "china" (case inconsistente)
- MODAL: "MARITIMO" / "maritimo" / "aereo" / "Maritimo"
- PROVEEDOR: "Day engineering" / "Day Engineering"

### 6.4 Columna CARPETA como Vinculo Principal
La columna M (CARPETA) es el numero de carpeta de importacion. En `factComprasEnProceso` existe `CompraEP Tipo = 'Carpeta Import'` — este es el puente natural entre el log de Roberta y el modelo.

---

## 7. Estrategia de Integracion (Diferida)

> **Decision clave:** Los archivos Excel de Roberta y Rosana NO se toman como fuente directa del modelo semantico.
> Son archivos de trabajo que pueden cambiar estructura, tipos de datos y contenido en cualquier momento.

### 7.1 Principio

Los datos que actualmente viven en Excel deben migrar a estructuras oficiales:

| Dato en Excel | Destino oficial | Tipo de estructura |
|---------------|-----------------|--------------------|
| Comentarios de proveedor | Formulario en Nodum | Tabla de mantenimiento (cod_proveedor, comentario, fecha, es_vigente, prioridad) |
| Fechas de llegada (ETA) | CRM de carpeta en Nodum | Modulo de seguimiento de importaciones |
| MOQ (minimo de compra) | Campo `Lote Minimo Compra` en Nodum | Campo existente en ERP, pendiente auditoria |
| Estado de envio | CRM de carpeta en Nodum | Estado del workflow de importacion |

### 7.2 Comentarios de Proveedor — Diseño Nodum

Formulario en Nodum con dos niveles:

**Nivel Proveedor:**
| Campo | Tipo | Descripcion |
|-------|------|-------------|
| cod_proveedor | FK | Vinculo a dimProveedor |
| comentario | NVARCHAR(MAX) | Texto libre |
| fecha | DATE | Fecha del comentario |
| es_vigente | BIT | Si el comentario sigue activo |
| prioridad | INT | Orden de importancia (1=alta) |

**Nivel Proveedor-Articulo:**
| Campo | Tipo | Descripcion |
|-------|------|-------------|
| cod_proveedor | FK | Proveedor |
| cod_articulo | FK | Articulo especifico |
| comentario | NVARCHAR(MAX) | Nota especifica del articulo |
| fecha | DATE | Fecha |
| es_vigente | BIT | Vigente |
| prioridad | INT | Prioridad |

**Consumo en modelo:** CONCATENATEX de comentarios vigentes ordenados por prioridad.

### 7.3 CRM de Carpeta / Importaciones — Diseño Nodum

El objetivo es que Roberta tenga un CRM de la carpeta/OC que reemplace su Excel:

**Entidad: Carpeta Importacion**
| Campo | Descripcion |
|-------|-------------|
| Numero Carpeta | Identificador unico |
| Empresa | EPSA / GSSA |
| Proveedor | Nombre del proveedor |
| Pais Origen | Pais |
| PO / Factura | Documentos asociados |
| Moneda / Valor | Datos financieros |
| Incoterm | Termino comercial |
| Prevision Embarque | Fecha prevista de embarque |
| ETD | Fecha real/estimada de salida |
| **ETA** | **Fecha estimada de llegada a EPSA** |
| Fecha Necesidad | Cuando se necesita la mercaderia |
| Estado | Workflow (Coordinar/Programada/Transito/Arribada) |
| BL/AWB | Documento de transporte |
| Modal | Maritimo/Aereo/Terrestre |
| Forwarder | Agente de carga |
| Bultos / Peso | Logistica |
| Equivalente USD | Prevision financiera |
| Prevision Despacho USD | Costo aduanero estimado |

**Beneficios para Roberta:**
- No mantiene un Excel con toda la informacion
- Datos estructurados, validados
- Historico automatico
- Consultas por proveedor, estado, fechas

**Beneficios para Rosana y Produccion:**
- Ven el estado de las compras en tiempo real
- Consultan ETA sin interrumpir a Roberta
- Power BI presenta la info sin reportar manualmente

### 7.4 Flujo futuro

```
Roberta registra en Nodum (CRM Carpeta)
         ↓
Staging ETL desde Nodum → staging_compras
         ↓
SSAS consume staging tables
         ↓
Power BI (Live Connection) muestra datos
         ↓
Rosana/Produccion consultan sin interrumpir a Roberta
```

### 7.5 Estado actual

Por ahora este analisis sirve como **relevamiento** de la informacion que Roberta maneja,
para guiar el diseño de las estructuras en Nodum. No se crean tablas de staging ni se modifica el modelo semantico.

---

## 9. Archivo de Analisis Complementario

| Archivo | Ubicacion |
|---------|------------|
| Analisis de estructura (este doc) | `docs/importaciones_analisis.md` |
| Excel original | `docs/excel/importaciones en curso 19 06 2026.xlsx` |
