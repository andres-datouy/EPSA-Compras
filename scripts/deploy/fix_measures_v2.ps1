$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    # Use COUNTROWS(FILTER(...)) pattern instead of CALCULATE(COUNTROWS(VALUES(...)), condition)
    $fixes = @{
        "Medidas_Stock~Articulos en Riesgo" = 'COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Existencia] > 0 && DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo], 0) < DIVIDE([Lead Time Promedio Dias], 30, 0)))'

        "Medidas_Stock~Articulos Criticos" = 'COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Debajo Mínimo] = "CRÍTICO"))'

        "Medidas_Stock~Articulos Sin Stock con Demanda" = 'COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Existencia] <= 0 && [Cantidad Requerida por Demanda Pendiente] > 0))'

        "Medidas_Stock~Stock Muerto COUNT" = 'VAR Last12M = DATESINPERIOD(Calendario[Fecha], MAX(Calendario[Fecha]), -12, MONTH) VAR ArticlesWithConsumption = CALCULATETABLE(VALUES(factConsumoHistoria[Consumo Artículo Código]), Last12M) RETURN COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Existencia] > 0 && NOT dimArticulo[Artículo Código] IN ArticlesWithConsumption))'

        "Medidas_Stock~Stock Exceso Valor USD" = 'VAR AvgPrice = DIVIDE([Gastado USD], SUM(factRecepcionesHistoria[RecepcionCantidad]), 0) RETURN SUMX(FILTER(VALUES(dimArticulo[Artículo Código]), DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo], 0) > 12), ([Stock Existencia] - 12 * [Consumo Promedio por Mes Activo]) * AvgPrice)'
    }

    $updated = 0
    foreach ($key in $fixes.Keys) {
        $parts = $key -split "~", 2
        $tableName = $parts[0]
        $measureName = $parts[1]
        $expression = $fixes[$key]

        $table = $model.Tables.Find($tableName)
        $measure = $table.Measures.Find($measureName)
        if ($measure) {
            $measure.Expression = $expression
            $updated++
            Write-Output "FIXED: ${tableName}.${measureName}"
        }
    }

    Write-Output "Updated: $updated"
    $db.Model.SaveChanges()
    Write-Output "Model saved."
    $server.Disconnect()
}
