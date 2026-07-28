# Lista roles y miembros del modelo Compras_EPSA (solo lectura)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if ($db.Model.Roles.Count -eq 0) {
        $output += "SIN ROLES definidos en el modelo"
    }
    foreach ($r in $db.Model.Roles) {
        $output += "ROL: $($r.Name) | Permiso: $($r.ModelPermission)"
        foreach ($m in $r.Members) { $output += "  Miembro: $($m.MemberName)" }
        if ($r.Members.Count -eq 0) { $output += "  (sin miembros)" }
    }
    $ssas.Disconnect()
    return $output
}
Write-Host ($result -join "`n")
