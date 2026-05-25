# Create GitHub Issues via REST API (avoids GraphQL rate limit)
# Account: acunarro-epsa
$token = $env:GH_PAT_EPSA
if (-not $token) {
    Write-Host "Error: Set GH_PAT_EPSA environment variable" -ForegroundColor Red
    exit 1
}

$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github+json"
}
$baseUrl = "https://api.github.com/repos/acunarro-epsa/EPSA-Compras/issues"

$issues = @(
    @{
        title = "Panel de Decision - Compras al Exterior (Rosana)"
        body = @"
## Descripcion
Rosana del departamento de Compras utiliza dos archivos Excel para decidir las compras al exterior. Se requiere construir un reporte en Power BI que centralice la informacion, automatice los calculos y ahorre horas de trabajo manual.

## Alcance aprobado
- Criterio "Compras al Exterior": articulos cuyo proveedor tiene ``dimProveedor[Pais Nombre] != 'Uruguay'``
- Lead time: usar medida historica del modelo PBIX (``Lead Time Promedio Dias``)
- ETAFPA: fuera de alcance (deposito discontinuado)
- Consolidacion Mercurius: fuera de alcance por ahora
- Calculo "A pedir": se trabajara sobre casos de uso con Rosana antes de implementar
- Cada cambio al modelo PBIX requiere aprobacion explicita

## Implementado
- [x] Denormalizacion de proveedor en dimArticulo
- [x] Fix de auto-exist entre factRecepcionesHistoria y factConsumoHistoria
- [x] Medidas con COALESCE: Stock Existencia, Stock Compras, Stock Proyectado, Consumo Promedio, Cobertura
- [x] Medida ``Diferencia Cobertura Lead Time``
- [x] Medida ``Alerta Cobertura`` (PEDIR / Atencion / OK)
- [x] Medida ``Cobertura Meses sobre Existencia + Proyectado``
- [x] Formato condicional (rojo/amarillo/verde)
- [x] Tabla "C.Ext. Proveedor - Articulo" con 19 columnas

## Pendiente
- [ ] Validar numeros con Rosana (comparar Excel vs PBIX)
- [ ] Ajustar umbrales de alerta con Rosana
- [ ] Agregar KPI cards
- [ ] Definir e implementar calculo "A pedir"
- [ ] Agregar grafico de tendencia de consumo (drill-through)

## Criterios de aceptacion
- Rosana valida que los numeros coinciden con su Excel
- Alerta "PEDIR" se activa en los mismos articulos que Rosana marcaria
- El reporte reemplaza el uso diario de los Excel
"@
        labels = @("enhancement", "power-bi", "compras-exterior", "in-progress", "high-priority")
    },
    @{
        title = "Validar numeros con Rosana - Excel vs PBIX"
        body = @"
## Descripcion
Comparar 5-10 articulos del Excel de Rosana contra el reporte PBIX para validar que los calculos son correctos.

## Tareas
- [ ] Seleccionar 5-10 articulos representativos (con alerta PEDIR, Atencion, y OK)
- [ ] Comparar: Stock Existencia, Consumo Promedio, Cobertura Meses, Lead Time
- [ ] Documentar diferencias encontradas
- [ ] Corregir medidas DAX si hay discrepancias

## Criterios de aceptacion
- Los valores del PBIX coinciden con el Excel de Rosana (tolerancia < 5%)
- Rosana confirma que los datos reflejan su realidad operativa
- Diferencias documentadas y explicadas

## Prioridad
Inmediata - esta semana. Bloquea el resto del desarrollo.
"@
        labels = @("validation", "compras-exterior", "high-priority")
    },
    @{
        title = "Ajustar umbrales de Alerta Cobertura"
        body = @"
## Descripcion
Confirmar con Rosana si los umbrales actuales de la medida ``Alerta Cobertura`` son correctos:
- **PEDIR**: Diferencia < 0 (cobertura menor al lead time)
- **Atencion**: Diferencia < 1 mes
- **OK**: Diferencia >= 1 mes

## Tareas
- [ ] Revisar con Rosana articulos clasificados como "PEDIR" y validar que son correctos
- [ ] Revisar articulos "OK" que ella consideraria deben pedirse
- [ ] Ajustar umbrales en la medida DAX si necesario
- [ ] Actualizar formato condicional si cambian los cortes

## Criterios de aceptacion
- Rosana aprueba la clasificacion de alertas
- No hay falsos negativos (articulos que deberian tener alerta y no la tienen)

## Dependencia
Requiere completar primero la validacion de numeros (#2)
"@
        labels = @("validation", "dax", "compras-exterior", "high-priority")
    },
    @{
        title = "Agregar KPI cards al dashboard"
        body = @"
## Descripcion
Agregar tarjetas KPI en la parte superior del reporte Page 1 para dar visibilidad rapida del estado general.

## KPIs requeridos
- [ ] Total articulos compras exterior
- [ ] Articulos con alerta "PEDIR" (count + % del total)
- [ ] Stock proyectado total (valor)
- [ ] Articulos sin datos de proveedor

## Criterios de aceptacion
- Las cards se muestran correctamente en la parte superior de Page 1
- Los numeros son consistentes con la tabla detallada
- Formato visual coherente con el tema del reporte
"@
        labels = @("enhancement", "power-bi", "dashboard", "ui-ux")
    },
    @{
        title = "Revisar articulos con 'Sin datos de Proveedor'"
        body = @"
## Descripcion
Hay articulos que aparecen con proveedor "S/P" o sin datos de proveedor en la vista de compras al exterior. Se necesita investigar y corregir.

## Tareas
- [ ] Identificar articulos sin proveedor asignado en dimArticulo
- [ ] Verificar si el proveedor existe en dimProveedor pero no esta vinculado
- [ ] Determinar si son articulos activos o descontinuados
- [ ] Corregir la asignacion o excluirlos del reporte si corresponde

## Criterios de aceptacion
- Todos los articulos activos de compras exterior tienen proveedor asignado
- Los articulos sin proveedor estan documentados y justificados
- La medida de KPI refleja cuantos articulos tienen este problema
"@
        labels = @("data-quality", "data-model", "compras-exterior")
    },
    @{
        title = "Definir formula 'A pedir' con Rosana - casos de uso"
        body = @"
## Descripcion
Trabajar con Rosana sobre casos de uso reales para definir la formula exacta del calculo "A pedir" (cantidad recomendada a ordenar).

## Variables a considerar
- Consumo mensual promedio
- Lead time del proveedor (en meses)
- Stock actual (existencia)
- Stock proyectado (ordenes en curso)
- Minimos de compra (MOQ / presentacion)
- Factor de seguridad / stock minimo deseado

## Tareas
- [ ] Seleccionar 5 articulos ejemplo con Rosana
- [ ] Para cada uno, calcular manualmente el "A pedir" que ella definiria
- [ ] Generalizar la formula a partir de los ejemplos
- [ ] Validar formula con 10 articulos adicionales
- [ ] Documentar formula aprobada

## Criterios de aceptacion
- Formula definida y aprobada por Rosana
- Funciona para articulos con y sin stock minimo
- Contempla restricciones de packaging/MOQ

## Dependencia
Requiere validacion de numeros completada (#2)
"@
        labels = @("enhancement", "compras-exterior", "dax", "high-priority")
    },
    @{
        title = "Implementar medida DAX 'A pedir'"
        body = @"
## Descripcion
Una vez definida y aprobada la formula con Rosana, implementar la medida DAX en el modelo Power BI.

## Tareas
- [ ] Crear medida DAX ``A Pedir`` segun formula aprobada
- [ ] Agregar columna a la tabla principal del reporte
- [ ] Agregar formato condicional (resaltar cuando A Pedir > 0)
- [ ] Validar resultados con los ejemplos de Rosana
- [ ] Agregar a KPI cards si corresponde

## Criterios de aceptacion
- La medida produce resultados identicos a los calculados manualmente con Rosana
- Rosana aprueba los valores para al menos 20 articulos
- La medida se ejecuta en tiempo razonable (< 3 seg)

## Dependencia
Requiere definicion de formula aprobada (#6)
"@
        labels = @("enhancement", "dax", "power-bi", "compras-exterior")
    },
    @{
        title = "Grafico tendencia de consumo - drill-through"
        body = @"
## Descripcion
Agregar un grafico de linea que muestre el consumo mensual de los ultimos 12 meses para un articulo seleccionado. Implementar como drill-through desde la tabla principal.

## Tareas
- [ ] Crear pagina drill-through "Detalle Articulo"
- [ ] Agregar grafico de linea: consumo mensual ultimos 12 meses
- [ ] Agregar informacion contextual: proveedor, lead time, stock actual
- [ ] Configurar drill-through desde la tabla de Page 1
- [ ] Agregar boton de "volver" a Page 1

## Criterios de aceptacion
- Click derecho en cualquier articulo permite hacer drill-through
- El grafico muestra los ultimos 12 meses de consumo con tendencia
- La informacion contextual es legible y util
"@
        labels = @("enhancement", "power-bi", "dashboard", "ui-ux")
    },
    @{
        title = "Detalle de ordenes de compra en curso"
        body = @"
## Descripcion
Mostrar el detalle de las ordenes de compra activas (factComprasEnProceso) para cada articulo, permitiendo ver que esta en camino y cuando se espera.

## Tareas
- [ ] Definir con Rosana que informacion de OC necesita ver
- [ ] Crear tooltip o expandible con detalle de OC activas por articulo
- [ ] Mostrar: numero OC, cantidad, fecha esperada, proveedor
- [ ] Integrar con la columna "Stock Proyectado" existente

## Criterios de aceptacion
- Rosana puede ver rapidamente que ordenes estan en curso para un articulo
- Los montos coinciden con el "En Camino" de su Excel
- No agrega complejidad excesiva a la tabla principal
"@
        labels = @("enhancement", "power-bi", "compras-exterior", "data-import")
    },
    @{
        title = "Arquitectura de Despliegue y Refresh Automatizado"
        body = @"
## Descripcion
Definir y implementar la estrategia de despliegue del reporte para que los usuarios finales puedan acceder sin actualizacion manual.

## Opciones evaluadas
- **Power BI Service** (~USD 50/mes para 5 usuarios) - recomendada cuando haya presupuesto
- **SSAS Tabular + Live Connection** (USD 0 con SQL Server Standard 2019) - ideal tecnica largo plazo
- **Power Automate Desktop** (USD 0) - RPA para refresh automatico del PBIX
- **Open source** (Cube.dev, Metabase, Superset) - descartado

## Decisiones pendientes
- [ ] Definir presupuesto disponible
- [ ] Decidir si migrar modelo a SSAS Tabular o mantener PBIX
- [ ] Decidir mecanismo de refresh (RPA vs SSAS vs PBI Service)
- [ ] Definir SLA de actualizacion de datos (diario? horario?)

## Criterios de aceptacion
- Estrategia definida y aprobada por la organizacion
- Plan de implementacion con timeline
- Costos estimados y aprobados
"@
        labels = @("architecture", "ssas", "backlog")
    },
    @{
        title = "Evaluar migracion a SSAS Tabular"
        body = @"
## Descripcion
Evaluar la viabilidad tecnica de migrar el modelo Power BI a SSAS Tabular para centralizar los datos y habilitar live connection.

## Tareas
- [ ] Verificar licencia SQL Server Standard 2019 disponible
- [ ] Evaluar hardware/servidor disponible para SSAS
- [ ] Estimar esfuerzo de migracion del modelo .bim
- [ ] Definir estrategia de particiones y procesamiento incremental
- [ ] Crear POC con un subconjunto de tablas

## Criterios de aceptacion
- Documento de viabilidad tecnica con pros/contras
- POC funcional con al menos 2 fact tables
- Estimacion de tiempo y recursos para migracion completa

## Dependencia
Requiere decision de arquitectura (#10)
"@
        labels = @("architecture", "ssas", "backlog")
    },
    @{
        title = "Campo de comentarios/alertas manuales por articulo"
        body = @"
## Descripcion
Rosana necesita poder agregar notas sobre articulos (ej: "en desuso", "sustituido por X", "discontinuado por proveedor"). Actualmente esto lo hace en una columna del Excel.

## Opciones
- Columna en una tabla auxiliar (Excel/SharePoint) vinculada al modelo
- Write-back via Power Apps embebido
- Tabla de notas en base de datos

## Tareas
- [ ] Definir con Rosana que tipo de notas necesita
- [ ] Elegir mecanismo de almacenamiento
- [ ] Implementar la integracion con el modelo
- [ ] Agregar columna/tooltip en el reporte

## Criterios de aceptacion
- Rosana puede ver notas/comentarios junto a cada articulo
- Las notas persisten entre actualizaciones del modelo
- Mecanismo de edicion es simple y no requiere Power BI Desktop
"@
        labels = @("enhancement", "compras-exterior", "backlog")
    },
    @{
        title = "Page 2: Consolidacion Europa (Mercurius)"
        body = @"
## Descripcion
Cuando Rosana lo requiera, construir una segunda pagina del reporte enfocada en la consolidacion de pedidos a Europa via Mercurius.

## Estado
**FUERA DE ALCANCE** actualmente. Se documenta para futuro.

## Contexto
- Mercurius es el consolidador para proveedores europeos
- Requiere agrupar articulos por proveedor europeo y calcular volumenes minimos
- La logica es diferente a las compras directas

## Criterios de aceptacion
- Rosana solicita explicitamente esta funcionalidad
- Se define el alcance antes de implementar
- No interfiere con Page 1 existente
"@
        labels = @("enhancement", "compras-exterior", "backlog")
    },
    @{
        title = "Publicar version estable del PBIX en SharePoint"
        body = @"
## Descripcion
Guardar la version validada del archivo PBIX en la ubicacion compartida de SharePoint para que otros usuarios puedan acceder.

## Tareas
- [ ] Definir ubicacion en SharePoint para el PBIX
- [ ] Documentar instrucciones de acceso y actualizacion para usuarios
- [ ] Crear versionado (fecha en nombre o carpeta de versiones)
- [ ] Definir proceso de publicacion de nuevas versiones

## Criterios de aceptacion
- El PBIX esta accesible en SharePoint para los usuarios autorizados
- Hay un proceso claro para publicar actualizaciones
- La version publicada esta validada por Rosana

## Dependencia
Requiere validacion completa de numeros (#2) y umbrales (#3)
"@
        labels = @("documentation", "backlog")
    }
)

$created = 0
foreach ($issue in $issues) {
    $body = @{
        title = $issue.title
        body = $issue.body
        labels = $issue.labels
    } | ConvertTo-Json -Depth 3

    try {
        $response = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body -ContentType "application/json; charset=utf-8"
        Write-Host "Created #$($response.number): $($response.title)" -ForegroundColor Green
        $created++
        Start-Sleep -Milliseconds 500
    } catch {
        Write-Host "FAILED: $($issue.title) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nCreated $created/$($issues.Count) issues" -ForegroundColor Cyan
