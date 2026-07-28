# Add measure [Cobertura vs Lead Time] via AMO
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
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

    $measureName = "Cobertura vs Lead Time"
    $existing = $table.Measures | Where-Object { $_.Name -eq $measureName }
    if (-not $existing) {
        $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m.Name = $measureName
        $m.Expression = @"
VAR MesesCobertura = DIVIDE ( [Stock Mínimo], [Consumo Promedio por Mes Activo], 0 )
VAR LT_Meses = DIVIDE ( [Lead Time Promedio Dias], 30, 0 )
RETURN
MesesCobertura - LT_Meses
"@
        $m.FormatString = "#,0.00"
        $m.Description = "Diferencia entre meses de cobertura del stock mínimo y el lead time del proveedor. Positivo = SM cubre LT. Negativo = déficit en meses. Usar con filtro Obligatorio=SI"
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
