# Fase 0 - Agrega columna Comentarios a dimArticulo en SSAS (Compras_EPSA)
# 1. Actualiza query de la particion (agrega CAST Comentarios NVARCHAR(4000))
# 2. Agrega DataColumn "Comentarios"
# 3. Procesa dimArticulo (Full) para cargar datos
# Idempotente: si la columna ya existe, no duplica.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tbl = $model.Tables | Where-Object { $_.Name -eq "dimArticulo" }

    # 1. Actualizar query de la particion
    $part = $tbl.Partitions["dimArticulo"]
    $q = $part.Source.Query
    if ($q -notmatch '\[Comentarios\]') {
        $newQ = $q -replace 'RTRIM\(\[TipoComponente\]\) AS \[TipoComponente\] FROM', 'RTRIM([TipoComponente]) AS [TipoComponente], CAST([Comentarios] AS NVARCHAR(4000)) AS [Comentarios] FROM'
        if ($newQ -eq $q) { throw "No se pudo insertar Comentarios en la query de la particion" }
        $part.Source.Query = $newQ
        $output += "1. UPDATED partition query (+ Comentarios)"
    } else {
        $output += "1. SKIP: partition query ya incluye Comentarios"
    }

    # 2. Agregar columna
    $col = $tbl.Columns | Where-Object { $_.Name -eq "Comentarios" }
    if (-not $col) {
        $newCol = New-Object Microsoft.AnalysisServices.Tabular.DataColumn
        $newCol.Name = "Comentarios"
        $newCol.SourceColumn = "Comentarios"
        $newCol.DataType = [Microsoft.AnalysisServices.Tabular.DataType]::String
        $newCol.SummarizeBy = [Microsoft.AnalysisServices.Tabular.AggregateFunction]::None
        $newCol.Description = "Comentarios libres por articulo desde vw_Compras_DimArticuloEPSA (equivalente cols D/W del Excel de Rosana)."
        $tbl.Columns.Add($newCol)
        $output += "2. ADDED column: Comentarios"
    } else {
        $output += "2. SKIP: columna Comentarios ya existe"
    }

    # 3. Guardar cambios estructurales
    $model.SaveChanges()
    $output += "3. SaveChanges OK"

    # 4. Procesar dimArticulo Full para cargar datos
    $tbl.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
    $model.SaveChanges()
    $output += "4. dimArticulo procesado (Full)"

    # 5. Verificacion
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $t2 = $db2.Model.Tables["dimArticulo"]
    $c2 = $t2.Columns | Where-Object { $_.Name -eq "Comentarios" }
    $output += ""
    $output += "=== VERIFICACION ==="
    $output += "Columna Comentarios: $(if ($c2) { 'EXISTS - State=' + $c2.State } else { 'NOT FOUND' })"
    $output += "Particion State: $($t2.Partitions[0].State)"
    $output += "Relationships: $($db2.Model.Relationships.Count)"
    $output += "Calendario Hierarchies: $($db2.Model.Tables['Calendario'].Hierarchies.Count)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
