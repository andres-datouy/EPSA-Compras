# Muestra expresiones DAX de medidas clave (solo lectura)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $names = @("A Pedir Txt","A Pedir Sugerido","Cobertura sobre Stock Minimo vs Lead Time","Stock Util E+C-CP-CD","Meses Cobertura del Stock Minimo","Cobertura Meses sobre Existencia","Stock Proyectado","Lead Time Meses")
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    foreach ($t in $db.Model.Tables) {
        foreach ($m in $t.Measures) {
            if ($names -contains $m.Name) {
                $output += "### [$($m.Name)] (tabla: $($t.Name), format: $($m.FormatString))"
                $output += $m.Expression.Trim()
                $output += ""
            }
        }
    }
    $ssas.Disconnect()
    return $output
}
Write-Host ($result -join "`n")
