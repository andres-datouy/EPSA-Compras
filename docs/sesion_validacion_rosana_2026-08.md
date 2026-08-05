# Kit de Sesion de Validacion — Rosana (Rol Comprador, Produccion)

## Version: 1.0 | Fecha: 2026-08-05
## Documentos base: `validacion_rosana_vs_modelo.md` v2.0 (§6 preguntas, §8 as-is) | `estrategia_validacion_compradores.md` (Fases 3 y 4)

---

## 1. Objetivo y criterio de exito

Certificar en una sesion de trabajo que Rosana puede **tomar una decision de compra completa sin abrir su Excel**, usando la pagina "Programacion Compras Exterior" del PBIX live connection.

Criterio de exito (Fase 4): walkthrough completo con un caso real + prueba ciega de 3 articulos + 9 preguntas respondidas + fricciones registradas como issues.

## 2. Que llevar a la sesion

| Elemento | Detalle |
|---|---|
| PC con el PBIX | `export\EPSA-Compras v202608.pbix` abierto con `runas /netonly /user:EXLER-SERVER\bi_compras` (o `scripts\check\humo_pbix_bi_compras.ps1`) |
| Excel de Rosana | Su "Pedidos a exterior" vigente, SOLO como referencia y para la prueba ciega |
| Pagina abierta | "Programacion Compras Exterior" con el slicer de Proveedor Preferido listo |
| Datos duros | Resultados de `scripts/check/check_moq_coverage.ps1` (MOQ ERP vacio) y conteos de universo (exterior 1.867 / con StockMin>0 395) |
| Registro | Este documento (completar respuestas in situ) + `docs/issues.md` para fricciones |

## 3. Agenda (90 min)

| # | Bloque | Min | Que se hace |
|---|--------|-----|-------------|
| 1 | Walkthrough del flujo | 25 | Rosana ejecuta SU proceso real con un proveedor que este por pedir, usando solo el reporte: slicer → alerta → coberturas → comentarios → stock → A Pedir Sugerido → detalle con documento Nodum. Andres no toca el mouse; anota fricciones |
| 2 | Las 9 preguntas | 35 | §4 de este documento; se completa respuesta y decision por cada una |
| 3 | Prueba ciega | 20 | Rosana elige 3 articulos que YA decidio en el Excel; se verifica que el reporte la hubiera llevado a la misma decision (o mejor, justificando diferencias) |
| 4 | Acuerdos | 10 | Priorizacion de gaps (Cobertura Post Pedido / a la Llegada / MOQ), responsable y fecha; proxima sesion si aplica |

## 4. Hoja de respuestas (completar en sesion)

| # | Pregunta | Respuesta de Rosana | Decision / Issue |
|---|----------|---------------------|------------------|
| 1 | ~~ETAFPA~~ | Cerrada pre-sesion: fuera de alcance (deposito discontinuado) | — |
| 2 | Buffer de alerta: ¿4 meses fijos o variable por proveedor? | | |
| 3 | ¿Cuando overridea el consumo promedio y con que criterio? | | |
| 4 | ¿A Pedir siempre manual o a veces formula? Factores (MOQ, flete, presupuesto, consolidacion) | | |
| 5 | ¿Los comentarios de la vista ERP alcanzan o falta informacion? | | |
| 6 | ¿Usa la cobertura a la llegada (Z) para decidir? ¿Que significa para ella? | | |
| 7 | ¿Lead Time de su Excel es total (pedido→llega) o solo proveedor? | | |
| 8 | MOQ: ¿sus valores de "Presentacion y minimos" son por articulo o por articulo+proveedor? ¿Donde mantenerlos fuera del Excel? | | |
| 9 | ¿Cuando el stock en deposito NO cuenta para su decision? (reservado, calidad, ubicacion) | | |

## 5. Guia del walkthrough (checklist observable)

- [ ] Filtra por Proveedor Preferido y reconoce el universo (¿falta/sobra algun articulo vs su Excel?)
- [ ] Identifica los articulos en PEDIR sin ayuda
- [ ] Interpreta Alerta + las tres coberturas (Minimo vs LT / Proyectado / Util) sin explicacion previa
- [ ] Encuentra y usa Comentarios
- [ ] Entiende Stock Proyectado y Stock Util (descuento de OP y demanda pendiente)
- [ ] Usa A Pedir Sugerido como punto de partida y ajusta cantidad
- [ ] Rastrea una cifra hasta su documento Nodum en las tablas de detalle
- [ ] Menciona sin que se le pregunte: MOQ/presentacion, cobertura post-pedido, cobertura a la llegada (→ confirma prioridad de gaps)

## 6. Prueba ciega (3 articulos)

| Articulo | Decision real de Rosana (Excel) | Que dice el reporte | ¿Coincide? / Justificacion |
|----------|--------------------------------|---------------------|----------------------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

## 7. Post-sesion

1. Volcar fricciones a `docs/issues.md` (una por issue, con prioridad acordada).
2. Actualizar `validacion_rosana_vs_modelo.md` §6/§7 con respuestas y decisiones.
3. Implementar en orden: `[Cobertura Post Pedido]` (parametro A Pedir) → `[Cumple MOQ]`/`[A Pedir con MOQ]` (fuente suplementaria) → `[Cobertura a la Llegada]` (ETA Nodum).
4. Segunda sesion corta de sign-off (Fase 4) con los gaps implementados.
