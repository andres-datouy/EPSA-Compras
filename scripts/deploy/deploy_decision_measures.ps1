$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    $newMeasures = @(
        @("Medidas_Compras", "A Pedir Sugerido", 'MAX(0, [Consumo Promedio por Mes Activo] * (DIVIDE([Lead Time Promedio Dias], 30, 0) + 1) - [Stock Proyectado])'),
        @("Medidas_Compras", "Alerta Cobertura", 'VAR Cobertura = [Cobertura Meses sobre Existencia] VAR LT_Meses = DIVIDE([Lead Time Promedio Dias], 30, 0) RETURN SWITCH(TRUE(), Cobertura < LT_Meses, "CRÍTICO", Cobertura < LT_Meses + 1, "ATENCIÓN", "OK")')
    )

    $added = 0
    foreach ($m in $newMeasures) {
        $table = $model.Tables.Find($m[0])
        $existing = $table.Measures.Find($m[1])
        if ($existing) {
            $existing.Expression = $m[2]
            Write-Output "UPDATED: $($m[0]).$($m[1])"
        } else {
            $measure = New-Object Microsoft.AnalysisServices.Tabular.Measure
            $measure.Name = $m[1]
            $measure.Expression = $m[2]
            $table.Measures.Add($measure)
            Write-Output "ADDED: $($m[0]).$($m[1])"
        }
        $added++
    }

    $db.Model.SaveChanges()
    Write-Output "Model saved. Total: $added"
    $server.Disconnect()
}
