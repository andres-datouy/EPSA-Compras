$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    $newMeasures = @(
        "Medidas_Compras~Gastado USD~SUMX(factRecepcionesHistoria, factRecepcionesHistoria[RecepcionCantidad] * factRecepcionesHistoria[OCPrecioUSD])"
        "Medidas_Compras~Gastado MO~SUM(factRecepcionesHistoria[OCTotalMO])"
        "Medidas_Compras~Gastado Exterior USD~CALCULATE([Gastado USD], dimProveedor[Pais Nombre] <> ""Uruguay"")"
        "Medidas_Compras~% Gastado Exterior~DIVIDE([Gastado Exterior USD], [Gastado USD], 0)"
        "Medidas_Compras~Precio Unitario Promedio USD~DIVIDE([Gastado USD], SUM(factRecepcionesHistoria[RecepcionCantidad]), 0)"
    )

    $added = 0
    $updated = 0
    $table = $model.Tables.Find("Medidas_Compras")

    foreach ($def in $newMeasures) {
        $parts = $def -split "~", 3
        $measureName = $parts[1]
        $expression = $parts[2]

        $existing = $table.Measures.Find($measureName)
        if ($existing) {
            $existing.Expression = $expression
            $updated++
            Write-Output "UPDATED: $measureName"
        } else {
            $measure = New-Object Microsoft.AnalysisServices.Tabular.Measure
            $measure.Name = $measureName
            $measure.Expression = $expression
            $table.Measures.Add($measure)
            $added++
            Write-Output "ADDED: $measureName"
        }
    }

    Write-Output "Added: $added, Updated: $updated"
    if ($added -gt 0 -or $updated -gt 0) {
        $db.Model.SaveChanges()
        Write-Output "Model saved successfully."
    }

    $server.Disconnect()
}
