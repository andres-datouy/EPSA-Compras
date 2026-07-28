$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    
    $targets = @(
        'Dias Cobertura Stock Actual',
        'Consumo Promedio Diario',
        'Dias Cobertura Necesidad',
        'Articulos Sin Cobertura Suficiente',
        'Compras En Proceso USD',
        'Valor Stock Existencia USD',
        'Articulos Debajo Minimo',
        'Total Articulos Activos',
        '% Articulos Debajo Minimo',
        'Brecha Stock Minimo USD',
        'Articulos Sin SM Configurado',
        'Consumo Anual Cantidad',
        'Rotacion Inventario',
        'Dias Sin Consumo',
        'Stock Muerto USD',
        'Articulos Stock Muerto',
        'Stock Valor Total USD',
        '% Stock Muerto',
        'Ultima Fecha Consumo',
        'Gasto Recepciones USD',
        'Compras Totales USD YTD',
        'Compras Totales USD LY',
        'Variacion Compras %',
        'Proveedor Concentracion %',
        'On Time Delivery %',
        'Gasto Promedio Mensual USD',
        'Costo Unitario Promedio USD',
        'Gasto Proyectado Mes',
        'Recepcion Cantidad Total',
        'Ticket Promedio USD',
        'Stock Existencia',
        'Stock Compras',
        'Gap Stock',
        'E + C - CP - CD - SM',
        'A Pedir Sugerido',
        'Cantidad Recepciones',
        'Lead Time Meses',
        'Lead Time Promedio Dias',
        'Consumo Promedio por Mes Activo',
        'Stock Proyectado',
        'Consumo Planificado Cantidad',
        'Cantidad Requerida por Demanda Pendiente',
        'Meses Cobertura del Stock Minimo',
        'Cobertura sobre Stock Minimo vs Lead Time',
        'Stock Util E+C-CP-CD',
        'Lead Time Proceso Interno Dias',
        'Dias Transcurridos En Proceso Promedio',
        'Dias Hasta Fecha Entrega Promedio',
        'Compras En Proceso Vencidas',
        'Ultima Recepcion Fecha'
    )
    
    foreach ($t in $model.Tables) {
        foreach ($m in $t.Measures) {
            if ($targets -contains $m.Name) {
                Write-Output "MEASURE: $($m.Name) -> $($t.Name)"
            }
        }
        foreach ($c in $t.Columns) {
            if ($targets -contains $c.Name) {
                Write-Output "COLUMN: $($c.Name) -> $($t.Name)"
            }
        }
    }
    
    # Check not found
    $allMeasureNames = @()
    foreach ($t in $model.Tables) {
        foreach ($m in $t.Measures) { $allMeasureNames += $m.Name }
        foreach ($c in $t.Columns) { $allMeasureNames += $c.Name }
    }
    
    foreach ($t2 in $targets) {
        if ($allMeasureNames -notcontains $t2) {
            Write-Output "MISSING: $t2"
        }
    }
    
    $ssas.Disconnect()
}

Write-Host ($result -join "`n") -ForegroundColor White
