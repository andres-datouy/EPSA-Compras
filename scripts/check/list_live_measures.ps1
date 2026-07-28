# Lista medidas del modelo vivo agrupadas por tabla (solo lectura)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    foreach ($t in $db.Model.Tables | Where-Object { $_.Measures.Count -gt 0 }) {
        $output += "=== $($t.Name) ($($t.Measures.Count)) ==="
        foreach ($m in $t.Measures | Sort-Object Name) { $output += "  [$($m.Name)]" }
    }
    $ssas.Disconnect()
    return $output
}
Write-Host ($result -join "`n")
