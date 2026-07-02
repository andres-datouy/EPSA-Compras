# Add measure [Lead Time Meses] via AMO
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }
    if (-not $table) { $output += "ERROR: Medidas_Consumo table not found"; $ssas.Disconnect(); return $output }

    $measureName = "Lead Time Meses"
    $existing = $table.Measures | Where-Object { $_.Name -eq $measureName }
    if (-not $existing) {
        $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m.Name = $measureName
        $m.Expression = "DIVIDE ( [Lead Time Promedio Dias], 30, 0 )"
        $m.FormatString = "#,0.00"
        $m.Description = "Lead time promedio del proveedor expresado en meses (días / 30)"
        $table.Measures.Add($m)
        $output += "ADDED: [$measureName]"
    } else {
        $output += "EXISTS: [$measureName]"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
