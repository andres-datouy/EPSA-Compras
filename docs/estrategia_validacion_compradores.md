# Estrategia de Validacion del Modelo — Rol Compradores

## Version: 1.0
## Fecha: 2026-05-18
## Objetivo: Certificar que el rol Compradores (Rosana) tiene su flujo de trabajo resuelto en Power BI, con datos correctos y toda la informacion de su Excel "Pedidos a exterior" representada.
## Documento base: `docs/validacion_rosana_vs_modelo.md` (mapeo columna por columna)

---

## 1. Principio Rector

> El Excel de Rosana NO es fuente de datos. Es el **caso de prueba de referencia**: si el reporte responde todo lo que el Excel responde (con datos de Nodum/estructuras oficiales), el rol Compradores esta cubierto.

Criterio de exito global: **Rosana puede tomar una decision de compra completa sin abrir el Excel.**

---

## 2. Fases de la Estrategia

### Fase 0 — Prerequisitos Tecnicos (antes de validar con Rosana)

| # | Accion | Como verificar | Estado |
|---|--------|----------------|--------|
| 0.1 | Ejecutar `scripts/sql/ssas_staging/03a_dimArticulo_add_Comentarios.sql` en 192.168.2.47 | El paso 4 del script devuelve filas con Comentarios no nulos | ✅ Verificado 2026-05-18: 88 articulos con comentarios; job FULL diario recarga OK |
| 0.2 | Deploy de columna `dimArticulo[Comentarios]` al modelo SSAS vivo (particion SQL + DataColumn, via `scripts/deploy/add_comentarios_dimArticulo.ps1`) | Columna State=Ready en el modelo | ✅ Deployado 2026-05-18 (relaciones=10, jerarquias Calendario=2 intactas) |
| 0.3 | Refresh de dimArticulo en SSAS | DAX: 3.369 filas / 88 con Comentarios = staging exacto | ✅ Validado 2026-05-18 (`scripts/check/check_ssas_comentarios_data.ps1`) |
| 0.4 | Reabrir PBIP (skill `refrescar-pbip`) y verificar columna en panel de campos | Campo visible en el reporte | ✅ PBIP reabierto 2026-05-18 — verificar visualmente en panel de campos |

> Nota tecnica: el modelo vivo usa **particion SQL nativa** (no la expresion M de `model/tables/dimArticulo.json`, que es solo referencia del export original). `Comentarios` se agrego con `CAST(... AS NVARCHAR(4000))` siguiendo el patron de `Proveedores` (limitacion nvarchar(max) en SSAS). Cambio replicado en `database_staging.json` y `database_staging_fixed.json` (regla de doble JSON).

### Fase 1 — Flujo de Trabajo del Comprador (reemplaza la comparacion Excel vs modelo)

> Decision 2026-05-18: NO se hace comparacion celda a celda contra el Excel de Rosana — es una copia con antiguedad y su uso es referencial. En su lugar se construye el flujo de trabajo en Power BI y cada dato se verifica contra Nodum o reporte fuente (Fase 1.3).

**Pagina nueva dedicada: "Programacion Compras Exterior"** (decision: no evolucionar "Stock Minimo Vs Lead Time", que queda como esta).

> Estado 2026-05-18: IMPLEMENTADO. Pagina clonada de "Stock Minimo Vs Lead Time" (id `e244718f235796748fbf`, script `scripts/deploy/clone_pagina_programacion_compras.ps1`) + slicer de Clase + tabla de decision ampliada (Alerta, Stock Proyectado, Coberturas nuevas, A Pedir Sugerido, Lead Time Meses, Comentarios). Medidas nuevas deployadas a SSAS (`scripts/deploy/add_cobertura_flujo_compradores.ps1`) y replicadas en ambos JSON: `Cobertura Meses sobre Stock Proyectado`, `Cobertura Meses sobre Stock Util`, `Alerta Cobertura` (smoke test: 645 PEDIR / 147 Atencion / 653 OK). Export: `export/Compras EPSA - Modelo SSAS.odc`. **Pendiente:** el modelo NO tiene roles de seguridad — para que Rosana conecte desde Excel hay que crear un rol Read con su cuenta de Windows.

#### 1.1 Seleccion del universo de trabajo
- Slicer **Proveedor** (`Proveedor Articulo Full`) — camino normal
- Slicer **Clase** (`dimArticulo[Clase]`) — para cuando el proveedor visible es el consolidador y no el real
- Slicer **Articulo** multi-select con busqueda — armar conjuntos arbitrarios de articulos
- TextSlicer **Proveedores** — busca el proveedor real dentro de la lista concatenada

#### 1.2 Tabla de decision (preguntas en orden de decision)
| Pregunta | Medida/Columna |
|---|---|
| ¿Cual es el minimo? | `Articulo Stock Minimo` |
| ¿Cuanto tarda? | `Lead Time Promedio Dias` / `Lead Time Meses` |
| ¿Cuanto consumo? | `Consumo Promedio por Mes Activo` |
| ¿Cuanto tengo + viene? | `Stock Existencia` + `Stock Compras` (= Stock Proyectado) |
| ¿Cuanto comprometido en OP en curso? | `Consumo Planificado Cantidad` |
| ¿Cuanto pide la demanda sin OP? | `Cantidad Requerida por Demanda Pendiente` |
| ¿Que me queda neto? | `Stock Util E+C-CP-CD` |
| ¿Cuanta cobertura? | `Cobertura Meses sobre Existencia`, `Meses Cobertura del Stock Minimo`, `Cobertura sobre Stock Minimo vs Lead Time` + **nueva: Cobertura sobre Stock Util** (descuenta OP y demanda pendiente) |
| ¿Pido? ¿Cuanto? | `Alerta Cobertura` + `A Pedir Sugerido` + `dimArticulo[Comentarios]` |

#### 1.3 Verificacion contra Nodum (drill de auditoria)
Al seleccionar un articulo en la tabla de decision, paneles de detalle muestran los registros fuente con Nº de documento Nodum: consumos, recepciones, compras en proceso, OP planificadas, demanda por pedido, stock por deposito. Cada cifra agregada es rastreable a su documento.

#### 1.4 Export para Rosana
**Decision: Excel conectado en vivo a SSAS** (tabla dinamica sobre el cubo, estilo Analyze in Excel). Rosana trabaja en su entorno natural con datos siempre frescos; respeta la regla de gobernanza (SSAS unica fuente). Complemento: export nativo del visual siempre disponible.

### Fase 1b — Validacion de Correctitud de Datos (contra Nodum/fuente, no contra Excel)

Para una muestra de articulos del flujo real, verificar cada medida contra su fuente en Nodum o reporte oficial (queries SQL a las vistas EPSA_BI / tablas Nodum). El Excel de Rosana se usa solo como referencia de razonabilidad, no como patron de igualdad.

### Fase 2 — Cierre de Gaps Funcionales

Orden de implementacion segun impacto en el flujo de decision:

| Prioridad | Gap | Solucion | Dependencia |
|-----------|-----|----------|-------------|
| 1 | Cobertura Post Pedido (col Y) | Medida `[Cobertura Post Pedido]` con parametro what-if "A Pedir" | Validar formula con Rosana (Preg. 6) |
| 2 | Cobertura a la Llegada (col Z) | Medida `[Cobertura a la Llegada]` | ETA de carpetas de importacion (Nodum) |
| 3 | Buffer de alerta (col V: LT+4 vs LT+1) | Parametrizar buffer en `[Alerta Cobertura]` | Respuesta a Preg. 2 |
| 4 | Stock ETAFPA (col R) | Verificar vista en EPSA_BI; ampliar factStockEPSA o nueva medida | Respuesta a Preg. 1 |
| 5 | Comentarios estructurados | Formulario Nodum (proveedor+articulo, vigencia, prioridad) | Respuesta a Preg. 5; col Comentarios ya cubre lo basico |

### Fase 3 — Sesion de Validacion con Rosana

**Formato:** sesion de trabajo con Power BI abierto + su Excel al lado.

1. **Responder las 7 preguntas** de `validacion_rosana_vs_modelo.md` §6 (ETAFPA, buffer, overrides de consumo, A Pedir, comentarios, cobertura a la llegada, lead time).
2. **Walkthrough del flujo** (§4.2): Rosana ejecuta su proceso real de decision de compra usando solo el reporte, con un caso real de un proveedor que este por pedir.
3. **Prueba ciega:** elegir 3 articulos que Rosana ya decidio en el Excel y verificar que el reporte la hubiese llevado a la misma decision (o a una mejor, con justificacion).
4. Registrar cada friccion como issue en `docs/issues.md`.

### Fase 4 — Criterios de Aceptacion (Sign-off del rol Compradores)

- [ ] Todos los datos de las columnas A-Z del Excel estan representados o formalmente descartados con acuerdo de Rosana
- [ ] Muestra de Fase 1 sin errores de datos (solo diferencias metodologicas documentadas)
- [ ] Las 7 preguntas de validacion respondidas y decisiones registradas
- [ ] Rosana completa el flujo de decision de un pedido real sin abrir el Excel
- [ ] Alertas "PEDIR" del reporte coinciden (o mejoran justificadamente) con las del Excel
- [ ] Gaps restantes registrados con plan y prioridad en `docs/issues.md`

---

## 3. Riesgos y Mitigaciones

| Riesgo | Mitigacion |
|--------|------------|
| Excel es snapshot (2026.04.09) y el modelo es actual | Comparar consumo/LT (estables); para stock, explicar delta con movimientos del periodo |
| Overrides manuales de Rosana no replicables | No replicar: documentar criterio y evaluar campo de override futuro en Nodum |
| LT calculado difiere del experiencial | Mostrar ambos en la sesion; decidir por proveedor cual gobierna la alerta |
| Comentarios en vista ERP son por articulo, no por proveedor+articulo | Aceptar como v1; formulario Nodum como v2 si Rosana lo requiere |

---

## 4. Proximos Pasos Inmediatos

1. Completar Fase 0 (deploy + refresh + verificacion en PBIP)
2. Construir el script DAX de extraccion de muestra para Fase 1
3. Ejecutar comparacion Fase 1 y registrar resultados en este documento (§5, a crear)
4. Agendar sesion con Rosana (Fase 3) llevando resultados de Fase 1
