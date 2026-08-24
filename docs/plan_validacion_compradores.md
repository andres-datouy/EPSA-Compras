# Plan de Validacion con Compradores — Walkthrough "Adios Excel"

## Version: 1.0
## Fecha: 2026-08-06
## Estado: En ejecucion
## Vinculado a: Issue #1 (validacion pendiente), Issue #19 (relevamiento), Issue #26 (formula A Pedir)

---

## 1. Objetivo

Validar con los compradores (Rosana primero, luego el resto del area) que el reporte **Compras al Exterior**:
1. Responde todas las preguntas que hoy responden con el Excel `Pedidos a exterior`.
2. Les permite trabajar un ciclo completo de compra **sin abrir el Excel**.
3. Genera confianza en los numeros (cada cifra rastreable a un documento Nodum).

**Criterio de exito (salida):** el area completa un ciclo de compra real (semana tipo) usando solo el reporte, sin discrepancias sin resolver, y da OK formal.

---

## 2. Fase 0 — Preparacion (antes de cada sesion)

- [ ] Verificar frescura de datos: `scripts/check/check_frescura_datos.ps1` (staging y SSAS al dia; el job `Staging_Process_SSAS` corre 09:30 y 14:15).
- [ ] Tener a mano el Excel de Rosana (`docs/excel/Pedidos a exterior 2026.04.09.xlsx`) para comparar columna a columna.
- [ ] Preparar el reporte abierto con la cuenta del area (`runas /netonly /user:EXLER-SERVER\bi_compras`, segun manual v2.2 seccion 1.2) — **que lo abra ella**, no nosotros: la autonomia de acceso es parte de la prueba.
- [ ] Preparar los 3 articulos de referencia ya documentados en `requerimiento_compras_exterior.md`:
  | Articulo | Consumo | Stock | Lead Time | Cobertura | Aviso Excel |
  |----------|---------|-------|-----------|-----------|-------------|
  | Martech Temporary pacing cath | 4.658/mes | 16.169 | 5 meses | 3 meses | PEDIR |
  | Martech Canula c/alas | 3.704/mes | 3.031 | — | 1 mes | PEDIR |
  | KDL Male luer | 27.509/mes | 124.046 + 200.000 en camino | — | 12 meses | OK |

---

## 3. Fase 1 — Estructura de la sesion de walkthrough (~60-90 min)

### Bloque A — Autonomia de acceso (10 min)
- Abre el reporte sola con `runas` + `bi_compras`.
- **Observar, no ayudar** salvo que se trabe: cada traba es un hallazgo de documentacion/manual.

### Bloque B — Replicar su rutina diaria (20 min)
Que haga en voz alta lo que hace todas las semanas con el Excel:
1. "¿Que tengo que comprar esta semana?" → pagina **Programacion Compras Exterior**, filtro `Alerta = PEDIR`, ordenar por criticidad (manual 4.1).
2. "¿Cuanto pido de cada uno?" → columna **A Pedir Sugerido**.
3. "¿Que mas le compro a este proveedor para consolidar?" → filtro Proveedor (manual 4.3).

**Registrar:** ¿llega a la misma conclusion que con el Excel? ¿Tarda mas o menos? ¿Que le falta ver?

### Bloque C — Verificacion numero a numero (30 min) — el corazon de la validacion
Elegir 5-10 articulos del Excel de Rosana (los 3 de referencia + los que ella elija) y cruzar columna por columna contra la tabla de decision:

| Columna Excel | Equivalente en el reporte | Veredicto |
|---------------|---------------------------|-----------|
| Proveedor | Proveedor Preferido / ProveedorArticuloNombre | |
| Codigo / Descripcion | Articulo | |
| comentarios | Comentarios (Nodum dimArticulo) | |
| Presentacion y minimos (MOQ) | **GAP conocido** — no esta en el modelo | |
| lead time | Lead Time Promedio Dias / Meses (calculado del historial, no maestro) | |
| consumo mensual historico | Consumo Promedio por Mes Activo (+ historia) | |
| Stock | Existencia | |
| stock ETAFPA | **FUERA DE ALCANCE aprobado** (deposito discontinuado) — confirmar que ya no aplica | |
| En Camino | Stock Compras (compras en proceso) | |
| Meses cobertura | Cobertura Meses sobre Stock Proyectado / Stock Util | |
| aviso | Alerta (PEDIR / Atencion / OK) | |
| A pedir | A Pedir Sugerido | |
| cobertura a la llegada | **GAP conocido** — no existe la medida | |

Para cada discrepancia: rastrear a Nodum con el **Paso 3** del manual (click en articulo → paneles de documentos fuente). Si el reporte rastrea bien y el Excel no, el reporte gana; si el numero no cierra, va al registro de hallazgos.

### Bloque D — Decisiones pendientes (15 min) — Issue #26
Aprovechar la sesion para destrabar con ella:
- [ ] ¿Meses de Cobertura es dato maestro o derivado? (Opcion A vs B del Issue #26)
- [ ] ¿Cuantos meses de seguridad sobre el lead time? (hoy fijo 1 mes)
- [ ] ¿La formula de A Pedir actual (`MAX(0, Consumo x (LT+1) - StockNeto)`) coincide con como decide ella? Ajustar con casos reales (con y sin stock minimo).
- [ ] Umbrales de la alerta: ¿PEDIR/Atencion/OK con los cortes actuales le sirven?

### Bloque E — Salida del flujo: exportar (10 min)
- Export puntual de la tabla de decision (menu `...` → Exportar datos).
- Excel en vivo via `export\Compras EPSA - Modelo SSAS.odc` (si necesita su tabla dinamica propia).
- **Pregunta de cierre:** "¿Hay algo que hagas con tu Excel que no pudiste hacer hoy?" — lo que surja es backlog.

---

## 4. Fase 2 — Registro de hallazgos

Cada hallazgo se registra en la tabla de esta seccion y luego se decide si es issue de GitHub o fix directo.

| # | Fecha | Hallazgo | Tipo | Severidad | Estado / Resolucion |
|---|-------|----------|------|-----------|---------------------|
| 1 | 2026-08-06 | Slicer Artículo (Programación Compras Exterior) muestra "(En blanco)": la demanda pendiente explota BOM completa y 1.109 códigos de componentes (semi 5.698 filas, tubos 901, pt 297) no existen en dimArticulo (alcance compras = matpri + consu). SSAS crea la blank row sintética por RI. | dato | media | RESUELTO (2026-08-06): la blank row se alimentaba de 3 facts con claves fuera de alcance: demanda (1.109 códigos), consumo (1.639 códigos / 115.237 filas) y recepciones (60 códigos / 276 filas). Se agregó filtro `WHERE EXISTS` contra stg_dimArticulo en las 3 particiones (JSONs del modelo + deploy AMO). Verificado en SSAS: las 6 facts relacionadas a dimArticulo tienen 100% de sus filas con artículo real. Las recepciones huérfanas fueron estudiadas: todas fuera del alcance compras (consu varios/combustibles 46 cód., matpri discontinuados 11, 1 servicio, 1 bien de uso, 1 repuesto) — se ignoran por diseño. Desglose por tipo de lo excluido: demanda = semi 5.698 / tubos 901 / pt 297 filas; consumo = semi 1.156 cód. (85.526 filas) + tubos 483 cód. (29.711 filas), todos existen en ct_articulos (consumo interno de fabricación, no compras); recepciones = 0 filas de semi/pt/tubos en toda la historia (verificado). Detalle en docs/issues.md (nota #30). |
| 2 | 2026-08-06 | Slicer "Proveedor Preferido" muestra solo "(En blanco)": la columna calculada `dimArticulo[Proveedor Artículo Full]` quedó stubeada con `BLANK()` en la migración PBIX→SSAS (commit 76c8cdc), aunque staging y la partición traen el dato completo (204 proveedores). | dato | media | RESUELTO (2026-08-06): restaurada la expresión original `[Proveedor Codigo] & "- " & [Proveedor Nombre]` en ambos JSONs + deploy AMO + refresh. Verificado: 204 valores distintos, 0 blanks. Detalle en docs/issues.md (#32). |
| 3 | 2026-08-07 | Medidas numéricas muestran "(En blanco)" en vez de 0 cuando el contexto de filtro no tiene datos (Consumo Promedio por Mes Activo, Meses Cobertura del Stock Minimo, Cobertura sobre Stock Minimo vs Lead Time, Existencia, Stock Compras, Stock Proyectado, Cobertura Meses sobre Stock Proyectado, etc.). Criterio acordado: mostrar 0 como caso general. | UX | baja | RESUELTO (2026-08-07): criterio 0-instead-of-blank aplicado a todas las medidas numéricas de las 5 tablas de medidas (68 medidas auditadas, ~55 expresiones con `+ 0`) en ambos JSONs + deploy AMO. Alerta Cobertura conserva el blanco intencional para artículos sin consumo (guard `[Meses con Consumo] = 0`). Verificado con artículo sin consumo ni stock (970010105225): todas las medidas nombradas dan 0; el semáforo queda en blanco. Side-fix: 3 medidas estaban en Medidas_Compras en los JSON pero en Medidas_Consumo en SSAS — se alinearon los JSON a SSAS. Drift restante tambien resuelto: criterio 0 aplicado a `% Stock Muerto sobre Total` y a las 5 medidas de `factVencimientos`, e incorporados a ambos JSON. Detalle en docs/issues.md (#33). |
| 4 | 2026-08-07 | La columna Alerta totaliza: la fila "Total" muestra "OK" (la medida se evaluaba en el contexto de total), y todos los estados se ven del mismo color, dificultando la lectura del semaforo. Pedido: que la columna no totalice y colores por valor (OK verde, PEDIR naranja, Atencion amarillo). | UX | baja | RESUELTO (2026-08-07): guard `NOT(ISINSCOPE(dimArticulo[Artículo Código])) → BLANK()` en `Alerta Cobertura` (ambos JSONs + deploy AMO; verificado por ADOMD: total = blanco, filas de detalle intactas). Formato condicional fontColor en el visual de la tabla (PBIR `values.fontColor` con `Conditional.Cases` por igualdad): OK #00E676, PEDIR #FF9800, Atencion #FFEB3B, resto blanco por defecto. Los colores se ven al refrescar Desktop (`/refrescar-pbip`). Detalle en docs/issues.md (#34). |

**Tipos:**
- **dato**: el numero no coincide con Nodum/Excel → investigar ETL o medida (bloqueante).
- **gap**: falta un dato o medida que ella necesita → evaluar fuente en Nodum (politica: nada de Excel como fuente).
- **UX**: funciona pero no lo encuentra o le resulta incomodo → mejora de reporte.
- **doc**: el manual no cubre la duda o esta desactualizado → actualizar `manual_usuario_compras_exterior.md` (versionar).

---

## 5. Fase 3 — Loop de mejora (por cada iteracion)

1. Priorizar hallazgos de la sesion (bloqueantes de datos primero).
2. Corregir: modelo/medidas → deploy + validacion estructural; manual → bump de version con changelog; UX → PBIR + `/refrescar-pbip`.
3. Nueva sesion de walkthrough focalizada solo en lo corregido (15-30 min).
4. Repetir hasta cumplir el criterio de exito.

---

## 6. Fase 4 — Cierre y aceptacion

- [ ] Rosana trabaja 1 ciclo de compra completo solo con el reporte.
- [ ] Sin hallazgos bloqueantes abiertos en la tabla de la seccion 4.
- [ ] OK formal de Rosana (y del Jefe de Compras).
- [ ] Cerrar Issue #1 con la aceptacion; actualizar Issue #19 (Comercio Exterior → Completo).
- [ ] Decidir con el resto del area si se agenda el relevamiento de Produccion/Logistica (Issue #19).

---

## 7. Calendario sugerido

| Sesion | Contenido | Duracion |
|--------|-----------|----------|
| 1 | Bloques A-C completos + D inicial | 90 min |
| 2 | Fixes de la sesion 1 + bloque D restante + E | 45 min |
| 3+ | Focalizadas en hallazgos pendientes | 30 min |
| Final | Acompañar un ciclo de compra real | el que requiera |
