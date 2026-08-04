# Diagnostico de contexto de seguridad del server SSAS (solo lectura)
# Responde: dominio vs workgroup, usuarios locales, grupos, config de auth de SSAS
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()

    $cs = Get-CimInstance Win32_ComputerSystem
    $out += "=== IDENTIDAD DEL SERVIDOR ==="
    $out += "Nombre        : $($cs.Name)"
    $out += "Dominio/Grupo : $($cs.Domain)"
    $out += "PartOfDomain  : $($cs.PartOfDomain)"

    $out += ""
    $out += "=== USUARIOS LOCALES ==="
    foreach ($u in (Get-LocalUser | Sort-Object Name)) {
        $out += "$($u.Name) | Enabled=$($u.Enabled) | PwdExpires=$($u.PasswordExpires) | Desc=$($u.Description)"
    }

    $out += ""
    $out += "=== EXISTE bi_compras? ==="
    $bi = Get-LocalUser -Name "bi_compras" -ErrorAction SilentlyContinue
    $out += if ($bi) { "SI existe (Enabled=$($bi.Enabled))" } else { "NO existe" }

    $out += ""
    $out += "=== GRUPOS LOCALES (relevantes) ==="
    foreach ($g in (Get-LocalGroup | Where-Object { $_.Name -match "Admin|Usuarios|Users|SQL|SSAS|BI" })) {
        $members = (Get-LocalGroupMember -Group $g.Name -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) -join ", "
        $out += "$($g.Name): $members"
    }

    $out += ""
    $out += "=== SERVICIO SSAS ==="
    foreach ($s in (Get-Service | Where-Object { $_.Name -match "MSOLAP|MSSQLServerOLAPService|SSAS" })) {
        $out += "$($s.Name) | Status=$($s.Status) | StartType=$($s.StartType)"
        $wmi = Get-CimInstance Win32_Service -Filter "Name='$($s.Name)'" -ErrorAction SilentlyContinue
        if ($wmi) { $out += "  Cuenta del servicio: $($wmi.StartName)" }
    }

    $out += ""
    $out += "=== SSAS: modelo, roles y admins ==="
    try {
        Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
        $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
        $ssas.Connect("Data Source=localhost:2383")
        $out += "Instancia: $($ssas.Name) | Version: $($ssas.Version) | Modo: $($ssas.ServerMode)"
        foreach ($db in $ssas.Databases) {
            $out += "DB: $($db.Name) | Roles: $($db.Model.Roles.Count)"
            foreach ($r in $db.Model.Roles) {
                $out += "  ROL $($r.Name) | Permiso=$($r.ModelPermission) | Miembros=$($r.Members.Count)"
                foreach ($m in $r.Members) { $out += "    - $($m.MemberName)" }
            }
        }
        $ssas.Disconnect()
    } catch {
        $out += "ERROR AMO: $($_.Exception.Message)"
    }

    return $out
}
Write-Host ($result -join "`n")
