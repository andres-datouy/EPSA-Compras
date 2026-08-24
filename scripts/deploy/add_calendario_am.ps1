# Agrega columna calculada derivada "Año Mes AM" (FORMAT yyMM, ej. "2604") a la tabla Calendario en SSAS.
# Motivo: eje de categorias del grafico de consumo en pagina tooltip TT Detalle Articulo
# (labels AAMM cortos en vez de "2026-abr" o 202604). Issue #39 / pedido usuario 2026-08-21.
# La columna sale del ROW() de la particion calculada; se agrega el DataColumn + sortByColumn
# y se refresca la tabla para recalcular.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $calTable = $model.Tables["Calendario"]

    $part = $calTable.Partitions[0]
    if ($part.Source.Expression -notmatch 'Año Mes AM') {
        $oldExpr = $part.Source.Expression
        $newExpr = $oldExpr.Replace(
            '"Año Mes", FORMAT(CurrentDate, "YYYY-MMM"),',
            '"Año Mes", FORMAT(CurrentDate, "YYYY-MMM"),' + "`r`n" + '        "Año Mes AM", FORMAT(CurrentDate, "yyMM"),')
        if ($newExpr -eq $oldExpr) { throw "Ancla ROW no encontrada en la expresion de Calendario" }
        $part.Source.Expression = $newExpr
        $output += "UPDATED: partition expression (+ Año Mes AM)"
    } else {
        $output += "SKIP: partition expression ya contiene Año Mes AM"
    }

    if (-not ($calTable.Columns | Where-Object { $_.Name -eq "Año Mes AM" })) {
        $col = New-Object Microsoft.AnalysisServices.Tabular.DataColumn
        $col.Name = "Año Mes AM"
        $col.SourceColumn = "Año Mes AM"
        $col.DataType = [Microsoft.AnalysisServices.Tabular.DataType]::String
        $col.SortByColumn = $calTable.Columns["Año Mes Número"]
        $calTable.Columns.Add($col)
        $output += "ADDED: columna Año Mes AM (sortByColumn = Año Mes Número)"
    } else {
        $output += "SKIP: columna Año Mes AM ya existe"
    }

    $model.SaveChanges()
    $output += "Saved metadata changes."

    $calTable.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
    $model.SaveChanges()
    $output += "Processing complete (recalc + refresh)."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $cal2 = $db2.Model.Tables["Calendario"]
    $col2 = $cal2.Columns | Where-Object { $_.Name -eq "Año Mes AM" }
    if ($col2) { $output += "VERIFY: columna presente, DataType=$($col2.DataType)" } else { $output += "VERIFY FAILED: columna NO presente" }
    $output += "Partition state: $($cal2.Partitions[0].State)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
