# Estudio: Apache Superset y Cube.js como capa web sobre los datos de Compras

## Version: 1.0 (estudio preliminar — a validar en laboratorio)
## Fecha: 2026-05-18
## Objetivo: Evaluar una capa de visualización en navegador, sin licencias Power BI, que no permita al usuario final editar la semántica. Alternativa de mediano plazo al PBIX publicado en SharePoint.

---

## 1. Contexto y criterio de éxito

- Hoy: SSAS Tabular `Compras_EPSA` como modelo semántico único (medidas DAX), distribución vía PBIX Live Connection read-only en SharePoint.
- Buscado: dashboards/KPIs/slicers en **navegador**, a prueba de edición por el usuario, sin costo de Power BI Service/Fabric.
- Restricciones verificadas en el entorno (2026-05-18): workgroup sin dominio, Windows 10 Pro como servidor BI, .NET 10 e IIS disponibles, instancias BI en **Developer Edition**.

## 2. Hallazgo clave: ninguna de las dos herramientas habla MSOLAP nativamente

| Herramienta | Conexión a SSAS Tabular | Consecuencia |
|---|---|---|
| **Apache Superset** | ❌ Sin soporte nativo (issue apache/superset#30184 abierto). Solo drivers DB-API/SQLAlchemy → pymssql/pyodbc contra base **relacional** | Superset consultaría el **staging SQL** (`staging_compras`, 192.168.2.47:1435), no SSAS |
| **Apache Cube (Cube.js)** | ❌ Sin driver SSAS; capa semántica propia en JavaScript/YAML sobre SQL | Igual: contra staging; el esquema de Cube es **otra capa semántica** |

**Implicancia de gobernanza (decisión pendiente):** con cualquiera de las dos, las ~40 medidas DAX del modelo SSAS **no se reutilizan**; habría que reimplementarlas como SQL (vistas/CTEs en staging) o como cubos de Cube. Eso duplica la lógica de negocio y rompe el principio "SSAS única fuente de verdad semántica". Alternativa que sí reutiliza DAX: app web propia contra SSAS vía ADOMD (ASP.NET Core ya está instalado en el server).

## 3. Arquitectura posible (si se sigue igual)

```
staging_compras (SQL)  ←  Superset (dashboards, SQL Lab)
        ↑                        ↑
  Cube.js (opcional: API REST/GraphQL + pre-agregados)
        ↑
  Nodum/EPSA_BI → jobs SQL Agent (ya existen)
```

- **Superset solo**: alcanza para dashboards con parámetros, filtros cruzados básicos, alertas por email, export.
- **Cube.js + Superset**: agrega API para otras apps y cache de agregados; solo se justifica si además del dashboard se quieren consumir los datos desde otra aplicación.

## 4. Dimensionamiento de VM

Las dos herramientas son contenedores Linux (Docker) con Postgres de metadatos y Redis (Superset). No cachean datos de negocio por defecto: consultan en vivo.

### Escenario: 3-6 usuarios concurrentes (área Compras)

| Recurso | Mínimo | Recomendado | Notas |
|---|---|---|---|
| vCPU | 2 | **4** | Gunicorn workers + Postgres metadatos + Redis |
| RAM | 4 GB | **8 GB** | Superset consume ~1-2 GB; Cube.js agrega ~1 GB si se incluye |
| Disco | 40 GB | **80 GB** | SO + imágenes Docker (~4 GB) + Postgres metadatos (<2 GB) + logs. **No se necesita storage de datos** (se consulta en vivo al staging) |
| SO | Ubuntu Server 22.04/24.04 LTS o Debian 12 | igual | Docker CE + docker compose |
| Red | LAN 192.168.2.0/24, salida a 192.168.2.47:1435 | igual | Si se quisiera ir contra SSAS (msmdpump HTTP), también 192.168.2.47:2383/80 |

### Escenario futuro: 20-30 usuarios
8 vCPU / 16 GB RAM / 120 GB. A ese volumen conviene además un Postgres dedicado (no en la misma VM).

### Costo estimado (referencia)
VM en hypervisor propio (ya hay servidor físico): costo marginal ~0. En nube: una VM 4 vCPU/8 GB ronda USD 30-60/mes — más barato que Power BI Service por usuario, pero con operación propia.

## 5. Autenticación en workgroup (punto de fricción)

Superset autentica con usuarios propios (base de datos), LDAP u OIDC. **Sin dominio/LDAP no hay SSO Windows transparente**: cada usuario tendría usuario+contraseña de Superset, o habría que montar un reverse proxy con NTLM/Kerberos (complejo en workgroup). Es el punto donde la comparación con Power BI Desktop + `runas /netonly` deja de ser gratis.

## 6. Bloqueante de licenciamiento (heredado, no nuevo)

La VM web es producción. Las instancias de datos que la alimentan son **Developer Edition** (motor 1435 y SSAS, verificado 2026-05-18), licenciadas solo para desarrollo/prueba. Antes de declarar producción —con Power BI, Superset o lo que sea— hay que regularizar la licencia SQL Server Standard con EPSA.

## 7. Plan de laboratorio propuesto (si se decide avanzar)

1. VM de prueba con los mínimos de §4 (puede ser una VM en el hardware existente, aislada).
2. Instalar Superset con docker compose; conectar a `staging_compras` por pymssql con usuario SQL de solo lectura.
3. Prototipar **3 medidas clave** como SQL: `Stock Existencia`, `Consumo Promedio por Mes Activo`, `Alerta Cobertura` — medir el esfuerzo de reimplentación vs sus versiones DAX.
4. Evaluar la experiencia de login sin dominio (usuarios locales de Superset).
5. Medir latencia de la tabla de decisión (~2.000 artículos × 20 columnas) contra staging.
6. Recién entonces decidir: Superset, Cube.js, app web ASP.NET Core propia, o quedarse con el PBIX en SharePoint.

## 8. Recomendación provisional

Mantener el **PBIX Live Connection en SharePoint como solución vigente** (costo 0, semántica DAX intacta, ya documentado en `docs/publicacion_pbix_sharepoint.md`). Este estudio queda abierto para cuando aparezca alguna de estas necesidades: consumo desde navegador obligatorio, más de ~10 usuarios, o integración de los datos con otra aplicación (ahí Cube.js gana sentido).
