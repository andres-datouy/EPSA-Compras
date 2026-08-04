# Publicación a Producción: PBIX Live Connection en SharePoint

## Version: 1.0
## Fecha: 2026-05-18
## Camino corto de distribución del rol Comprador (Rosana, Roberta, Johnny)

---

## 1. Arquitectura de la solución

```
SSAS Compras_EPSA (192.168.2.47:2383)
        ↑ Live Connection (sin datos embebidos)
PBIX "Compras EPSA - Compradores v<AAAA.MM>.pbix"
        ↑ publicado read-only
Biblioteca SharePoint
        ↓ descarga
PC del usuario → runas /netonly con EXLER-SERVER\bi_compras → Power BI Desktop
```

Decisiones tomadas:
- El **PBIP queda como artefacto de desarrollo** (git). No se distribuye: es una carpeta, no se puede servir desde SharePoint y exige feature preview en cada PC.
- El **PBIX Live Connection es el entregable**: un solo archivo, con la conexión a SSAS embebida (texto, sin credenciales) y todo el reporte.
- La **protección contra ediciones** la dan: permisos read-only de SharePoint (el usuario solo descarga copias) + rol SSAS `Lectura_Compras` (modelo y datos intocables). Ver `docs/seguridad_acceso_ssas.md`.

---

## 2. Generación del PBIX (paso manual + validación automática)

> La automatización COM (`PowerBI.Application`) fue evaluada y **descartada**: la instalación MSI de Desktop en esta máquina no registra el objeto COM (verificado en registro, 2026-05-18). El guardado es manual y toma ~1 minuto.

1. Abrir `EPSA-Compras.pbip` en Power BI Desktop (desde el repo, sin cambios pendientes de commit).
2. Verificar que el reporte carga contra SSAS (esquina inferior: "Conectado en vivo").
3. **Archivo → Guardar como** → tipo **"Archivo de Power BI (*.pbix)"**.
4. Nombre y ubicación:
   ```
   export\Compras EPSA - Compradores v<AAAA.MM>.pbix
   ```
   (el mes en el nombre actúa como versión para SharePoint)
5. Cerrar Desktop **sin guardar cambios** sobre el PBIP (el proyecto no debe modificarse en este paso).
6. Validar el artefacto:
   ```powershell
   pwsh -File scripts\build\validar_pbix_generado.ps1
   ```
   El script verifica: tamaño, estructura interna, conexión embebida a `192.168.2.47/Compras_EPSA`, ausencia de credenciales y presencia de la página "Programacion Compras Exterior".
7. Recién con validación OK, publicar (sección 3).

**Nota:** el PBIX generado NO se commitea a git (es un artefacto binario derivado); vive en `export/` y en SharePoint. Si se desea trazabilidad de binarios, usar GitHub Releases.

---

## 3. Prueba de humo antes de publicar (una vez por versión)

En la propia PC:

```cmd
runas /netonly /user:EXLER-SERVER\bi_compras "C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
```

Abrir el PBIX recién generado desde Desktop. Debe mostrar datos sin pedir credenciales de SSAS (la credencial de red es la de `bi_compras`). Si pide autenticación o da error de conexión, NO publicar.

---

## 4. Configuración de SharePoint (una vez)

1. Crear una **biblioteca de documentos**, p.ej. `BI Compras - Producción`.
2. **Permisos**: romper herencia; el área de Compras (Rosana, Roberta, Johnny) con **Lectura**; Sistemas/Administración con **Control total**. Sin permiso de edición ni de carga para los usuarios finales.
3. Activar **control de versiones** (versiones mayores) para conservar el historial de PBIX publicados.
4. Subir:
   - `Compras EPSA - Compradores v<AAAA.MM>.pbix`
   - `Compras EPSA - Modelo SSAS.odc` (Excel en vivo)
   - `manual_usuario_compras_exterior.md` (o su PDF) con el procedimiento de acceso con `runas /netonly`
5. Desactivar la opción de abrir en el navegador para el `.pbix` si apareciera (no aplica a Live Connection; el archivo solo se descarga y abre en Desktop).

### Actualización de versión (recurrencia)
Cuando cambie el reporte en el PBIP:
1. Regenerar el PBIX (sección 2) con el nuevo mes.
2. Validar (sección 2.6) y prueba de humo (sección 3).
3. Subir el nuevo archivo a la biblioteca; **no borrar el anterior** (queda como rollback por el control de versiones).
4. Avisar al área que hay versión nueva (descarga + reemplazo local).

---

## 5. Entrega a los usuarios

Cada usuario necesita (una vez):

| Item | Como |
|---|---|
| Power BI Desktop (instalación MSI, no Store) | Ya existente o instalación estándar |
| Cuenta `EXLER-SERVER\bi_compras` + contraseña | Entrega en persona / canal seguro; NUNCA por email ni chat. La define Administración |
| Procedimiento `runas /netonly` | Sección 1.2 del manual de usuario |
| Acceso de lectura a la biblioteca | Permisos SharePoint (sección 4.2) |

Recordarles: la contraseña de `bi_compras` **no se valida contra el servidor al escribirla en runas**; un error de tipeo recién aparece al conectar ("las credenciales no son válidas"). En ese caso repetir el runas con la contraseña correcta.

---

## 6. Qué puede y qué no puede hacer el usuario final

| El usuario | ...porque |
|---|---|
| NO puede modificar el modelo semántico ni los datos | Rol SSAS `Lectura_Compras` (solo Read) |
| NO puede romper la copia publicada | SharePoint es read-only; siempre puede re-descargar |
| SÍ puede editar su copia descargada (visuales, medidas de reporte) | Desktop no tiene modo solo-lectura; es su copia local |
| NO puede ver modelos a los que no tiene rol | Autorización de SSAS |
| SÍ depende de estar en la LAN | Live Connection a servidor on-premise |

Si en el futuro se necesita "a prueba de edición total" en navegador, evaluar la alternativa web (ver `docs/estudio_superset_cubejs.md`).

---

## 7. Troubleshooting

| Sintoma | Causa probable | Acción |
|---|---|---|
| "No se puede conectar al servidor" | Sin runas /netonly, o contraseña mal tipeada | Repetir runas verificando la contraseña |
| Pide credenciales de SSAS al abrir | Sesión runas cerrada o expirada | Cerrar Desktop y relanzar con runas |
| Datos en blanco en medidas de stock | Refresh de staging caído | Verificar jobs SQL Agent / `stg_refresh_log` |
| El PBIX abre pero dice "guardado con versión anterior" | Desktop del usuario viejo | Actualizar Power BI Desktop |

---

## 8. Backlog asociado

- Rotación de passwords (`schaaf_ssas`, `app_compras`, `sa`): el valor viejo permanece en el historial de GitHub.
- Regularizar licenciamiento: las instancias BI son **Developer Edition** (ver `docs/estudio_superset_cubejs.md` §6).
