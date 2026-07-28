$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $svr = New-Object Microsoft.AnalysisServices.Tabular.Server
    $svr.Connect("Data Source=localhost:2383")
    $db = $svr.Databases.FindByName("Compras_EPSA")

    $output = @()
    foreach ($t in $db.Model.Tables) {
        if ($t.Measures.Count -gt 0) {
            $output += "--- $($t.Name) ---"
            foreach ($m in $t.Measures) {
                $desc = if ($m.Description) { $m.Description } else { "[SIN DESCRIPCION]" }
                $output += "  $($m.Name): $desc"
            }
        }
    }
    $svr.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
