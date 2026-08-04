# Crea el rol de solo lectura del modelo Compras_EPSA y le agrega la cuenta
# generica del area de Compras.
#
# Por que un rol: SSAS expresa permisos como principales de Windows. Con 0 roles
# definidos solo los administradores de la instancia pueden consultar el modelo,
# por lo que sin este rol los usuarios finales no pueden abrir el reporte.
#
# El rol es la unidad de permiso: para dar acceso individual a futuro basta
# agregar mas miembros a este mismo rol, sin modificar el modelo.
#
# Idempotente: si el rol existe verifica permiso y miembros sin duplicar.
$ErrorActionPreference = "Stop"

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()
    $rolNombre = "Lectura_Compras"
    $miembro = "EXLER-SERVER\bi_compras"

    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if (-not $db) { throw "No se encontro la base Compras_EPSA" }

    $rol = $db.Model.Roles | Where-Object { $_.Name -eq $rolNombre }
    if (-not $rol) {
        $rol = New-Object Microsoft.AnalysisServices.Tabular.ModelRole
        $rol.Name = $rolNombre
        $rol.Description = "Solo lectura del modelo de Compras. Cuenta generica del area (programacion de compras al exterior)."
        $rol.ModelPermission = [Microsoft.AnalysisServices.Tabular.ModelPermission]::Read
        $db.Model.Roles.Add($rol)
        $out += "ROL CREADO: $rolNombre (permiso Read)"
    } else {
        if ($rol.ModelPermission -ne [Microsoft.AnalysisServices.Tabular.ModelPermission]::Read) {
            $rol.ModelPermission = [Microsoft.AnalysisServices.Tabular.ModelPermission]::Read
            $out += "ROL existente: permiso corregido a Read"
        } else {
            $out += "ROL ya existia con permiso Read: $rolNombre"
        }
    }

    $yaEsMiembro = $rol.Members | Where-Object { $_.MemberName -eq $miembro }
    if (-not $yaEsMiembro) {
        $m = New-Object Microsoft.AnalysisServices.Tabular.WindowsModelRoleMember
        $m.MemberName = $miembro
        $rol.Members.Add($m)
        $out += "MIEMBRO AGREGADO: $miembro"
    } else {
        $out += "MIEMBRO ya presente: $miembro"
    }

    $db.Model.SaveChanges() | Out-Null

    # Verificacion leyendo de nuevo desde el servidor
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $out += ""
    $out += "=== ESTADO EN EL SERVIDOR ==="
    foreach ($r in $db2.Model.Roles) {
        $out += "ROL $($r.Name) | Permiso=$($r.ModelPermission)"
        foreach ($mm in $r.Members) { $out += "  Miembro: $($mm.MemberName) | SID=$($mm.IdentityProvider)$($mm.MemberID)" }
    }
    $ssas.Disconnect()
    return $out
}
Write-Host ($result -join "`n")
