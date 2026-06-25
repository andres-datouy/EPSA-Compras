$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    # Fixed measures with correct column names (spaces, accents)
    $fixes = @{
        # === Medidas_Compras ===
        "Medidas_Compras~Gastado USD" = 'SUMX(factRecepcionesHistoria, factRecepcionesHistoria[RecepcionCantidad] * factRecepcionesHistoria[OC PrecioUSD])'
        "Medidas_Compras~Gastado MO" = 'SUM(factRecepcionesHistoria[OC Total MO])'
        "Medidas_Compras~Gastado Exterior USD" = 'CALCULATE([Gastado USD], dimProveedor[País Nombre] <> "Uruguay")'
        "Medidas_Compras~Lead Time CV" = 'VAR AvgLT = [Lead Time Promedio Dias] VAR StdDevLT = STDEV.P(factRecepcionesHistoria[Lead Time Dias]) RETURN DIVIDE(StdDevLT, AvgLT, 0)'
        "Medidas_Compras~On-Time %" = 'VAR AvgLT = [Lead Time Promedio Dias] VAR OnTimeOrders = CALCULATE(COUNTROWS(factRecepcionesHistoria), factRecepcionesHistoria[Lead Time Dias] <= AvgLT * 1.2) RETURN DIVIDE(OnTimeOrders, COUNTROWS(factRecepcionesHistoria), 0)'
        # === Medidas_Stock ===
        "Medidas_Stock~Articulos en Riesgo" = 'CALCULATE(COUNTROWS(VALUES(dimArticulo[Artículo Código])), AND([Stock Existencia] > 0, DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo], 0) < DIVIDE([Lead Time Promedio Dias], 30, 0)))'
        "Medidas_Stock~Articulos Criticos" = 'CALCULATE(COUNTROWS(VALUES(dimArticulo[Artículo Código])), [Stock Debajo Mínimo] = "CRÍTICO")'
        "Medidas_Stock~Articulos Sin Stock con Demanda" = 'CALCULATE(COUNTROWS(VALUES(dimArticulo[Artículo Código])), AND([Stock Existencia] <= 0, [Cantidad Requerida por Demanda Pendiente] > 0))'
        "Medidas_Stock~Stock Muerto COUNT" = 'VAR Last12M = DATESINPERIOD(Calendario[Fecha], MAX(Calendario[Fecha]), -12, MONTH) VAR ArticlesWithConsumption = CALCULATETABLE(VALUES(factConsumoHistoria[Consumo Artículo Código]), Last12M) RETURN CALCULATE(COUNTROWS(VALUES(dimArticulo[Artículo Código])), AND([Stock Existencia] > 0, NOT dimArticulo[Artículo Código] IN ArticlesWithConsumption))'
        "Medidas_Stock~Stock Exceso Valor USD" = 'VAR AvgPrice = DIVIDE([Gastado USD], SUM(factRecepcionesHistoria[RecepcionCantidad]), 0) RETURN SUMX(VALUES(dimArticulo[Artículo Código]), VAR Stock = [Stock Existencia] VAR ConsumoMensual = [Consumo Promedio por Mes Activo] VAR Cobertura = DIVIDE(Stock, ConsumoMensual, 0) VAR Exceso = IF(Cobertura > 12, Stock - (12 * ConsumoMensual), 0) RETURN Exceso * AvgPrice)'
    }

    $updated = 0
    $errors = @()

    foreach ($key in $fixes.Keys) {
        $parts = $key -split "~", 2
        $tableName = $parts[0]
        $measureName = $parts[1]
        $expression = $fixes[$key]

        $table = $model.Tables.Find($tableName)
        if (-not $table) { $errors += "Table not found: $tableName"; continue }

        $measure = $table.Measures.Find($measureName)
        if ($measure) {
            $measure.Expression = $expression
            $updated++
            Write-Output "FIXED: $tableName.$measureName"
        } else {
            $errors += "Measure not found: $tableName.$measureName"
        }
    }

    Write-Output "`nUpdated: $updated, Errors: $($errors.Count)"
    if ($errors.Count -gt 0) { $errors | ForEach-Object { Write-Output "ERROR: $_" } }

    $db.Model.SaveChanges()
    Write-Output "Model saved."

    $server.Disconnect()
}
