# Deploy new DAX measures for Direction storytelling to SSAS Compras_EPSA
# Measures cover: Spend Analysis, Risk, Efficiency, Opportunities

$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    # Define new measures
    # Format: TableName~MeasureName~DAXExpression
    $newMeasures = @(
        # === CHAPTER 1: EL PANORAMA (Spend Analysis) ===
        # Total spend in USD from purchase history
        "Medidas_HistoriaCompra~Gastado USD~SUMX(factRecepcionesHistoria, factRecepcionesHistoria[RecepcionCantidad] * factRecepcionesHistoria[OCPrecioUSD])"

        # Total spend in local currency
        "Medidas_HistoriaCompra~Gastado MO~SUM(factRecepcionesHistoria[OCTotalMO])"

        # Spend on exterior suppliers (country != Uruguay)
        "Medidas_HistoriaCompra~Gastado Exterior USD~CALCULATE([Gastado USD], dimProveedor[Pais Nombre] <> ""Uruguay"")"

        # Percentage of spend from exterior
        "Medidas_HistoriaCompra~% Gastado Exterior~DIVIDE([Gastado Exterior USD], [Gastado USD], 0)"

        # Average price per unit in USD
        "Medidas_HistoriaCompra~Precio Unitario Promedio USD~DIVIDE([Gastado USD], SUM(factRecepcionesHistoria[RecepcionCantidad]), 0)"

        # === CHAPTER 2: EL RIESGO (Risk Analysis) ===
        # Articles at risk (coverage < lead time in months)
        "Medidas_Stock~Articulos en Riesgo~CALCULATE(COUNTROWS(VALUES(dimArticulo[Articulo Codigo])), AND([Stock Existencia] > 0, DIVIDE([Stock Existencia], [Consumo Promedio por Mes Activo], 0) < DIVIDE([Lead Time Promedio Dias], 30, 0)))"

        # Critical articles (stock below minimum)
        "Medidas_Stock~Articulos Criticos~CALCULATE(COUNTROWS(VALUES(dimArticulo[Articulo Codigo])), [Stock Debajo Minimo] = ""CRITICO"")"

        # Articles with zero stock and pending demand
        "Medidas_Stock~Articulos Sin Stock con Demanda~CALCULATE(COUNTROWS(VALUES(dimArticulo[Articulo Codigo])), AND([Stock Existencia] <= 0, [Cantidad Requerida por Demanda Pendiente] > 0))"

        # === CHAPTER 3: LA EFICIENCIA (Buying Performance) ===
        # Lead time coefficient of variation (consistency measure)
        "Medidas_Compras~Lead Time CV~VAR AvgLT = [Lead Time Promedio Dias] VAR StdDevLT = SQRT(SUMX(factRecepcionesHistoria, POWER(DATEDIFF(DAY, factRecepcionesHistoria[OCFecha], factRecepcionesHistoria[RecepcionFecha]) - AvgLT, 2)) / COUNTROWS(factRecepcionesHistoria)) RETURN DIVIDE(StdDevLT, AvgLT, 0)"

        # === CHAPTER 4: LA OPORTUNIDAD (Optimization) ===
        # Dead stock: articles with 0 consumption in last 12 months but stock > 0
        "Medidas_Stock~Stock Muerto COUNT~VAR Last12M = DATESINPERIOD(Calendario[Fecha], MAX(Calendario[Fecha]), -12, MONTH) VAR ArticlesWithConsumption = CALCULATETABLE(VALUES(factConsumoHistoria[Consumo Articulo Codigo]), Last12M) RETURN CALCULATE(COUNTROWS(VALUES(dimArticulo[Articulo Codigo])), AND([Stock Existencia] > 0, NOT dimArticulo[Articulo Codigo] IN ArticlesWithConsumption))"

        # Excess stock value: articles with coverage > 12 months
        "Medidas_Stock~Stock Exceso Valor USD~VAR AvgPrice = DIVIDE([Gastado USD], SUM(factRecepcionesHistoria[RecepcionCantidad]), 0) RETURN SUMX(VALUES(dimArticulo[Articulo Codigo]), VAR Stock = [Stock Existencia] VAR ConsumoMensual = [Consumo Promedio por Mes Activo] VAR Cobertura = DIVIDE(Stock, ConsumoMensual, 0) VAR Exceso = IF(Cobertura > 12, Stock - (12 * ConsumoMensual), 0) RETURN Exceso * AvgPrice)"

        # On-time delivery percentage (within expected lead time)
        "Medidas_Compras~On-Time %~VAR AvgLT = [Lead Time Promedio Dias] VAR OnTimeOrders = CALCULATE(COUNTROWS(factRecepcionesHistoria), DATEDIFF(DAY, factRecepcionesHistoria[OCFecha], factRecepcionesHistoria[RecepcionFecha]) <= AvgLT * 1.2) RETURN DIVIDE(OnTimeOrders, COUNTROWS(factRecepcionesHistoria), 0)"
    )

    $added = 0
    $updated = 0
    $errors = @()

    foreach ($def in $newMeasures) {
        $parts = $def -split "~", 3
        $tableName = $parts[0]
        $measureName = $parts[1]
        $expression = $parts[2]

        $table = $model.Tables.Find($tableName)
        if (-not $table) {
            $errors += "Table not found: $tableName"
            continue
        }

        $existing = $table.Measures.Find($measureName)
        if ($existing) {
            $existing.Expression = $expression
            $updated++
            Write-Output "UPDATED: $tableName.$measureName"
        } else {
            $measure = New-Object Microsoft.AnalysisServices.Tabular.Measure
            $measure.Name = $measureName
            $measure.Expression = $expression
            $table.Measures.Add($measure)
            $added++
            Write-Output "ADDED: $tableName.$measureName"
        }
    }

    Write-Output "`nAdded: $added, Updated: $updated, Errors: $($errors.Count)"
    if ($errors.Count -gt 0) { $errors | ForEach-Object { Write-Output "ERROR: $_" } }

    # Save changes
    if ($added -gt 0 -or $updated -gt 0) {
        $db.Model.SaveChanges()
        Write-Output "Model saved successfully."
    }

    $server.Disconnect()
}
