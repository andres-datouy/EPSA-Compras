# Crea la cuenta Windows local generica de lectura BI en EXLER-SERVER.
#
# Contexto: EXLER-SERVER esta en WORKGROUP (sin Active Directory) y SSAS solo
# acepta autenticacion Windows (SSPI). La unica autoridad de identidad que el
# servidor puede validar es su propia base SAM local, por lo que el principal
# del rol de lectura debe ser una cuenta local del server.
#
# La cuenta se crea SIN privilegios: solo grupo "Usuarios" (habilita el logon de
# red que NTLM necesita), sin Administradores y sin Escritorio remoto.
# No requiere ningun permiso sobre SQL: el modelo es Import y las particiones se
# cargan con app_compras; los usuarios solo consultan la cache tabular.
#
# Idempotente: si la cuenta ya existe solo ajusta grupo y flags.
$ErrorActionPreference = "Stop"

$envFile = "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = Get-Content $envFile | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }

$biPass = Get-Content $envFile | Where-Object { $_ -match "^BI_COMPRAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $biPass) {
    throw "BI_COMPRAS_PASSWORD no encontrado en .env.local. Agregar la linea 'BI_COMPRAS_PASSWORD=<clave>' antes de ejecutar."
}

$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($clave)
    $out = @()
    $nombre = "bi_compras"
    $secure = ConvertTo-SecureString $clave -AsPlainText -Force

    $user = Get-LocalUser -Name $nombre -ErrorAction SilentlyContinue
    if ($user) {
        Set-LocalUser -Name $nombre -Password $secure -PasswordNeverExpires $true
        $out += "Usuario ya existia: contrasena y flags actualizados"
    } else {
        New-LocalUser -Name $nombre `
            -Password $secure `
            -FullName "BI Compras (lectura)" `
            -Description "Lectura BI Compras_EPSA (cuenta del area)" `
            -PasswordNeverExpires `
            -UserMayNotChangePassword | Out-Null
        $out += "Usuario CREADO: $nombre"
    }

    # Grupo Usuarios: otorga el derecho de logon de red que requiere NTLM
    $enUsuarios = Get-LocalGroupMember -Group "Usuarios" -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -eq "EXLER-SERVER\$nombre" }
    if (-not $enUsuarios) {
        Add-LocalGroupMember -Group "Usuarios" -Member $nombre
        $out += "Agregado al grupo 'Usuarios'"
    } else {
        $out += "Ya pertenece al grupo 'Usuarios'"
    }

    # Verificacion de privilegios: NO debe estar en Administradores ni en RDP
    foreach ($g in @("Administradores", "Usuarios de escritorio remoto")) {
        $esMiembro = Get-LocalGroupMember -Group $g -ErrorAction SilentlyContinue |
                     Where-Object { $_.Name -eq "EXLER-SERVER\$nombre" }
        $out += if ($esMiembro) { "ALERTA: pertenece a '$g' (deberia removerse)" } else { "OK: no pertenece a '$g'" }
    }

    # Validacion de la credencial contra la SAM local
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext("Machine")
    $valida = $ctx.ValidateCredentials($nombre, $clave)
    $out += "Validacion de credencial en SAM local: $(if ($valida) { 'OK' } else { 'FALLO' })"

    $u = Get-LocalUser -Name $nombre
    $out += "Estado final -> Enabled=$($u.Enabled) | PasswordExpires=$($u.PasswordExpires) | Desc=$($u.Description)"
    return $out
} -ArgumentList $biPass

Write-Host ($result -join "`n")
