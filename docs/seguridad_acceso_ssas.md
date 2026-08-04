# Seguridad y acceso al modelo SSAS Compras_EPSA

## Version: 1.0
## Fecha: 2026-05-18
## Dirigido a: administracion tecnica de la solucion

---

## 1. Por que el acceso depende de una cuenta local del servidor

Tres restricciones del entorno se combinan y determinan el diseno:

1. **SSAS solo autentica con Windows.** A diferencia del motor SQL (que tiene logins propios como `app_compras`), Analysis Services no tiene tabla de usuarios: autentica via SSPI contra el token de Windows del cliente. En consecuencia, los permisos del modelo se expresan como principales de Windows, no como usuarios de base de datos.
2. **El servidor no esta en un dominio.** `EXLER-SERVER` pertenece al grupo de trabajo `WORKGROUP` (`PartOfDomain = False`). Sin Active Directory no hay autoridad de identidad compartida: la unica base que el servidor puede consultar para validar una identidad es su propia SAM local. Por eso el principal del rol debe ser una **cuenta local del servidor**.
3. **La cuenta no existe en las PCs de los usuarios.** En grupo de trabajo, NTLM valida usuario+clave contra la SAM del servidor. Hay dos formas de lograrlo:
   - `runas /netonly` (**la elegida**): el usuario tipea la clave una vez por sesion y no hay que crear nada en su PC.
   - Cuenta espejo: crear la misma cuenta con la misma clave en cada PC. Evita tipear la clave, pero obliga a mantener las claves sincronizadas en cada equipo.

Lo que **no** funciona como alternativa: un login de SQL Server, guardar la credencial en el Administrador de credenciales de Windows, o un "usuario de Power BI".

## 2. Configuracion implementada

| Elemento | Valor |
|---|---|
| Cuenta Windows | `EXLER-SERVER\bi_compras` (local, grupo `Usuarios` unicamente) |
| Privilegios | Sin `Administradores`, sin `Usuarios de escritorio remoto`, clave sin vencimiento |
| Rol SSAS | `Lectura_Compras`, permiso `Read` sobre `Compras_EPSA` |
| Miembro del rol | `EXLER-SERVER\bi_compras` |
| Acceso a SQL | **Ninguno.** El modelo es Import: las particiones se cargan con `app_compras`; los usuarios consultan solo la cache tabular |
| Clave | En `.env.local` (`BI_COMPRAS_PASSWORD`), archivo excluido de git |

Antes de este cambio el modelo tenia **cero roles**, lo que significa que unicamente los administradores de la instancia podian consultarlo: los usuarios finales estaban efectivamente bloqueados.

## 3. Scripts

| Script | Funcion |
|---|---|
| `scripts/deploy/create_usuario_bi_compras.ps1` | Crea/actualiza la cuenta local. Idempotente; verifica que no quede en grupos privilegiados |
| `scripts/deploy/create_rol_lectura_compras.ps1` | Crea el rol y agrega el miembro via AMO. Idempotente |
| `scripts/check/verify_acceso_bi_compras.ps1` | Verificacion en tres planos (ver seccion 5) |
| `scripts/check/check_ssas_security_context.ps1` | Diagnostico: dominio, usuarios locales, grupos, servicio SSAS, roles del modelo |

## 4. Regla dual-JSON

El rol quedo replicado en `model/database_staging.json` y `model/database_staging_fixed.json` (propiedad `roles` del objeto `model`). **Es obligatorio**: los scripts de deploy publican el JSON con `createOrReplace`, por lo que un deploy completo con un JSON sin `roles` borraria el rol y volveria a dejar el modelo accesible solo para administradores.

Para dar acceso individual a futuro (por ejemplo cuentas nominales por persona) se agregan miembros al **mismo** rol, tanto via AMO como en ambos JSON. No hace falta crear roles nuevos.

## 5. Como verificar el acceso

`scripts/check/verify_acceso_bi_compras.ps1` prueba tres cosas distintas, y conviene entender por que estan separadas:

- **A. Autenticacion** — logon de red NTLM desde la estacion de trabajo con las credenciales reales, via SMB (`IPC$`), que es el unico servicio que acepta credenciales explicitas por linea de comandos.
- **B. Autorizacion** — en el servidor se hace `LogonUser` + impersonacion de `bi_compras` y se consulta el modelo **con su token**. Es el test end-to-end real: si el rol no existiera o la cuenta no fuera miembro, MSOLAP rechaza la conexion.
- **C. Control negativo** — impersonando la misma cuenta se intenta leer `$SYSTEM.DISCOVER_SESSIONS`, reservada a administradores. Debe ser denegada; si devolviera datos, la cuenta tendria mas permisos de los previstos.

Resultado de la verificacion inicial: autenticacion aceptada; lectura correcta (3.369 articulos, 1.843 filas de stock, 231.335 consumos); DMV de administrador denegada explicitamente para `EXLER-SERVER\bi_compras`.

## 6. Limitaciones conocidas

- **Sin trazabilidad individual.** Al ser una cuenta compartida, los logs de SSAS registran a las tres personas como `bi_compras`. Si alguien deja el area, hay que rotar la clave para todos. Migrar a cuentas nominales es directo (agregar miembros al rol existente).
- **`EffectiveUserName` no es utilizable en esta instancia.** Al conectar con esa propiedad la instancia responde `The following system error occurred:` sin detalle. Se descarto como metodo de prueba; la impersonacion real es mejor porque tambien valida el logon.
- **El cliente ADOMD debe cargarse por ruta completa.** `Add-Type -AssemblyName "Microsoft.AnalysisServices.AdomdClient"` resuelve a la version 9.0.242.0 (era SQL 2005), que no esta instalada, y falla con `FileNotFoundException`. La version instalada esta en el GAC (`14.0.6.482`): en el servidor no hay una instalacion de ADOMD 17.0, solo copias dentro del `Update Cache` del instalador.
- **La descripcion de una cuenta local admite 48 caracteres como maximo.** Superarlo hace fallar `New-LocalUser` con un error de validacion de argumento.
