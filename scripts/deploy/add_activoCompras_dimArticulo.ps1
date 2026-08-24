# Opcion B - Agrega columna "Activo Compras" a dimArticulo en SSAS (Compras_EPSA)
# Pre-requisitos (EN ORDEN):
#   1. Vista actualizada en 2.7: scripts/sql/epsa_bi/alter_vw_DimArticuloEPSA_add_activo_cmp.sql
#   2. Staging migrado y refrescado: scripts/sql/ssas_staging/03b_dimArticulo_add_ActivoCompras.sql
# Pasos:
#   1. Actualiza query de la particion (agrega RTRIM([activo_cmp]) AS [Activo Compras])
#   2. Agrega DataColumn "Activo Compras"
#   3. Procesa dimArticulo (Full) para cargar datos
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
    if ($q -notmatch '\[activo_cmp\]') {
        $newQ = $q -replace 'CAST\(\[Comentarios\] AS NVARCHAR\(4000\)\) AS \[Comentarios\] FROM', 'CAST([Comentarios] AS NVARCHAR(4000)) AS [Comentarios], RTRIM([activo_cmp]) AS [Activo Compras] FROM'
        if ($newQ -eq $q) { throw "No se pudo insertar activo_cmp en la query de la particion" }
        $part.Source.Query = $newQ
        $output += "1. UPDATED partition query (+ Activo Compras)"
    } else {
        $output += "1. SKIP: partition query ya incluye activo_cmp"
    }

    # 2. Agregar columna
    $col = $tbl.Columns | Where-Object { $_.Name -eq "Activo Compras" }
    if (-not $col) {
        $newCol = New-Object Microsoft.AnalysisServices.Tabular.DataColumn
        $newCol.Name = "Activo Compras"
        $newCol.SourceColumn = "Activo Compras"
        $newCol.DataType = [Microsoft.AnalysisServices.Tabular.DataType]::String
        $newCol.SummarizeBy = [Microsoft.AnalysisServices.Tabular.AggregateFunction]::None
        $newCol.Description = "Indicador de articulo activo para compras (activo_cmp de Nodum ct_articulos). S = activo, N = inactivo. El reporte filtra por defecto S para mostrar solo articulos vigentes de compra."
        $tbl.Columns.Add($newCol)
        $output += "2. ADDED column: Activo Compras"
    } else {
        $output += "2. SKIP: columna Activo Compras ya existe"
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
    $c2 = $t2.Columns | Where-Object { $_.Name -eq "Activo Compras" }
    $output += ""
    $output += "=== VERIFICACION ==="
    $output += "Columna Activo Compras: $(if ($c2) { 'EXISTS - State=' + $c2.State } else { 'NOT FOUND' })"
    $output += "Particion State: $($t2.Partitions[0].State)"
    $output += "Relationships: $($db2.Model.Relationships.Count)"

    # Esperado: S = 3362, N = 9 (total 3371)
    # NOTA: TOM Model no tiene ExecuteQuery; la verificacion DAX se hace con ADOMD del GAC
    # (mismo patron que scripts/powershell/Process_SSAS.ps1 y scripts/check/check_frescura_datos.ps1).
    $gac = "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_14.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"
    Add-Type -Path $gac
    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=Compras_EPSA")
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = 'EVALUATE SUMMARIZECOLUMNS(dimArticulo[Activo Compras], "cant", COUNTROWS(dimArticulo))'
    $reader = $cmd.ExecuteReader()
    $output += "--- Distribucion Activo Compras ---"
    while ($reader.Read()) { $output += "  $($reader.GetValue(0)) = $($reader.GetValue(1))" }
    $reader.Close()
    $conn.Close()

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
