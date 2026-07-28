# EPSA Compras — Tarjetas de Referencia Rapida por Rol

## Version: 1.0
## Fecha: 2026-05-18

> Imprimir esta pagina para tener como referencia rapida en el puesto de trabajo.

---

## TARJETA 1: Administradora de Produccion

### Paginas que uso
| Pagina | Frecuencia | Para que |
|--------|-----------|----------|
| **Stock Minimo Vs Lead Time** | DIARIA | Decision de compra y validacion de datos |
| Suficiencia Stock Produccion | Al inicio del dia | Panorama general |
| Proveedor - Articulo | Cuando investigo un proveedor | Detalle de OC y recepciones |
| Compras x Stock Minimo | Semanal | Ver deficits |

### Mi flujo diario
```
1. Abrir reporte → Pagina "Stock Minimo Vs Lead Time"
2. Filtrar por Alerta = "PEDIR" → ver que es critico
3. Para cada articulo critico:
   a. Validar existencia (¿coincide con deposito?)
   b. Revisar consumo (¿es representativo?)
   c. Ver compras en proceso (¿hay OC activas?)
   d. Consultar fecha llegada con Roberta
4. Definir cantidades a pedir (columna "A Pedir Sugerido")
5. Ajustar por MOQ y presentacion
6. Coordinar con Rosana para emitir OC
```

### Datos clave que valido
- **Existencia:** stock fisico actual
- **Consumo Promedio Mes Activo:** velocidad de consumo
- **Cobertura:** meses que dura el stock
- **Lead Time:** dias de demora del proveedor
- **Alerta:** PEDIR (rojo) / Atencion (amarillo) / OK (verde)
- **A Pedir Sugerido:** cantidad recomendada

### A quien contacto
| Necesidad | Contacto |
|-----------|----------|
| Fecha de llegada de mercaderia | Roberta (Importaciones) |
| Emitir orden de compra | Rosana (Compras Exteriores) |
| Dato incorrecto en reporte | Sistemas / BI |
| Articulo nuevo a monitorear | Jefe de Compras |

---

## TARJETA 2: Compras Exteriores (Rosana)

### Paginas que uso
| Pagina | Frecuencia | Para que |
|--------|-----------|----------|
| **Stock Minimo Vs Lead Time** | DIARIA | Panel de decision principal |
| Proveedor - Articulo | Por pedido | Detalle del proveedor |
| Direccion - Compras | Mensual | Reporte a Gerencia |
| Prevision de Gasto | Planificacion | Estimacion de gasto |

### Mi flujo diario
```
1. Abrir reporte → Filtrar Alerta = "PEDIR"
2. Ordenar por Diferencia Cobertura LT (menor = mas critico)
3. Para cada articulo:
   a. Ver "A Pedir Sugerido"
   b. Ajustar por MOQ del proveedor
   c. Consolidar con otros articulos del mismo proveedor
   d. Evaluar flete compartido
4. Emitir ordenes de compra en ERP
5. Informar a Roberta para seguimiento de importacion
6. Marcar articulos atendidos (bookmark o nota)
```

### Mis filtros habituales
- **Pais:** Excluir Uruguay (para ver solo exterior)
- **Proveedor:** Para consolidar pedidos por proveedor
- **Alerta:** PEDIR para priorizar

### Consolidacion por proveedor
1. Filtrar por proveedor
2. Ver todos los articulos con alerta PEDIR o Atencion
3. Sumar cantidades → evaluar un solo envio
4. Verificar que el volumen/peso sea viable para el transporte

---

## TARJETA 3: Jefe de Compras

### Paginas que uso
| Pagina | Frecuencia | Para que |
|--------|-----------|----------|
| **Stock Minimo Vs Lead Time** | 2-3 veces/semana | Supervision y aprobacion |
| Compras x Stock Minimo | Semanal | Detectar deficits sistemicos |
| Stock Minimo - Deficit | Semanal | Priorizar inversiones |
| Direccion - Compras | Mensual | Reporte a Direccion |

### Mi flujo de supervision
```
1. Revisar alertas PEDIR que llevan > 1 semana sin resolver
2. Validar que Rosana esta gestionando las compras criticas
3. Aprobar compras mayores (arriba de cierto umbral USD)
4. Revisar articulos en Atencion antes de que pasen a PEDIR
5. Verificar cobertura general por pais/proveedor
```

### Decisiones que tomo
- Aprobar/rechazar compras grandes
- Incluir/excluir articulos del monitoreo
- Definir meses de seguridad por tipo de articulo
- Priorizar entre departamentos (Produccion vs Mantenimiento)

---

## TARJETA 4: Direccion / Gerencia

### Paginas que uso
| Pagina | Frecuencia | Para que |
|--------|-----------|----------|
| **Direccion - Compras** | Mensual | KPIs ejecutivos |
| Prevision de Gasto | Trimestral | Planificacion financiera |
| Rotacion y Stock Muerto | Trimestral | Capital inmovilizado |

### KPIs que reviso
| KPI | Que indica | Meta |
|-----|-----------|------|
| Articulos en PEDIR | Urgencias no resueltas | 0 |
| Cobertura promedio | Salud general del stock | > LT + 1 mes |
| Stock muerto | Capital inmovilizado | Minimizar |
| On-Time % | Performance de proveedores | > 85% |

### Mi flujo mensual
```
1. Revisar dashboard "Direccion - Compras"
2. Ver tendencia de gasto por pais y proveedor
3. Identificar oportunidades de ahorro (Pareto 80/20)
4. Evaluar concentracion de proveedores (riesgo)
5. Tomar decisiones estrategicas de sourcing
```

---

## TARJETA 5: Proceso de Compra — Resumen Visual

```
┌─────────────────────────────────────────────────────────────┐
│                 PROCESO DE COMPRA EPSA                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. DETECTAR NECESIDAD                                      │
│     Pagina: Stock Min Vs LT → Filtro: PEDIR                 │
│                                                             │
│  2. VALIDAR DATOS                                           │
│     Existencia + Consumo + Cobertura + LT                   │
│                                                             │
│  3. CONSULTAR LLEGADAS                                      │
│     Roberta → Fechas estimadas de llegada                   │
│                                                             │
│  4. CALCULAR CANTIDAD                                       │
│     Columna: A Pedir Sugerido                               │
│     Ajustar: MOQ + Presentacion + Consolidacion             │
│                                                             │
│  5. EMITIR OC                                               │
│     Rosana → Orden de Compra en ERP                         │
│                                                             │
│  6. SEGUIMIENTO                                             │
│     Roberta → Fecha llegada estimada                        │
│     Reporte → Stock Compras (cuando OC esta activa)         │
│                                                             │
│  7. RECEPCION                                               │
│     Deposito → Confirma llegada en ERP                      │
│     Reporte → Existencia se actualiza                       │
│                                                             │
│  8. VALIDAR COBERTURA                                       │
│     Reporte → Alerta cambia a OK                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Simbolos y Colores del Reporte

| Color/Simbolo | Significado | Accion |
|---------------|-------------|--------|
| ROJO (PEDIR) | Cobertura < Lead Time | Ordenar urgente |
| AMARILLO (Atencion) | LT ≤ Cobertura < LT+1 | Planificar compra |
| VERDE (OK) | Cobertura ≥ LT+1 | Sin accion |
| CRITICO | Stock < Minimo | Riesgo de desabastecimiento |
| Stock Compras > 0 | Hay pedidos en camino | Verificar fecha llegada |

---

## Contactos Rapidos

| Rol | Persona | Para que |
|-----|---------|----------|
| Compras Exteriores | Rosana | Emitir OC, consultar proveedores |
| Importaciones | Roberta | Fechas de llegada, estado importacion |
| Administracion Produccion | (Admin Prod.) | Necesidades de componentes, prioridades |
| Jefe de Compras | — | Aprobaciones, inclusion/exclusion articulos |
| Sistemas / BI | — | Errores en datos, problemas tecnicos |
