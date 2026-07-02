# Add measure [Stock Util E+C-CP-CD] via AMO
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Stock" }
    if (-not $table) { $output += "ERROR: Medidas_Stock table not found"; $ssas.Disconnect(); return $output }

    $measureName = "Stock Util E+C-CP-CD"
    $existing = $table.Measures | Where-Object { $_.Name -eq $measureName }
    if (-not $existing) {
        $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m.Name = $measureName
        $m.Expression = @"
[Stock Existencia] + [Stock Compras] - [Consumo Planificado Cantidad] - [Cantidad Requerida por Demanda Pendiente]
"@
        $m.FormatString = "#,0.00"
        $m.Description = "Stock disponible sin descontar stock mínimo. Existencia + Compras - Consumo Planificado - Demanda Pendiente"
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
