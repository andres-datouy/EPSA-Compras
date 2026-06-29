# Add Calendario hierarchies + relationships via AMO, then process affected tables
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")

    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $calTable = $model.Tables["Calendario"]

    $hasChanges = $false

    # Add hierarchies if missing
    if (-not ($calTable.Hierarchies | Where-Object { $_.Name -eq "Fiscal Year-Quarter" })) {
        $h1 = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
        $h1.Name = "Fiscal Year-Quarter"
        foreach ($lvl in @(
            @{ Name="Year"; Ordinal=0; Col="Año Fiscal" },
            @{ Name="Quarter"; Ordinal=1; Col="Trimestre del año fiscal" },
            @{ Name="Month"; Ordinal=2; Col="Año Mes" }
        )) {
            $l = New-Object Microsoft.AnalysisServices.Tabular.Level
            $l.Name = $lvl.Name; $l.Ordinal = $lvl.Ordinal
            $l.Column = $calTable.Columns[$lvl.Col]
            $h1.Levels.Add($l)
        }
        $calTable.Hierarchies.Add($h1)
        $output += "Added: Fiscal Year-Quarter"
        $hasChanges = $true
    } else { $output += "Exists: Fiscal Year-Quarter" }

    if (-not ($calTable.Hierarchies | Where-Object { $_.Name -eq "Fiscal Year-Month" })) {
        $h2 = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
        $h2.Name = "Fiscal Year-Month"
        foreach ($lvl in @(
            @{ Name="Year"; Ordinal=0; Col="Año Fiscal" },
            @{ Name="Month"; Ordinal=1; Col="Año Mes" }
        )) {
            $l = New-Object Microsoft.AnalysisServices.Tabular.Level
            $l.Name = $lvl.Name; $l.Ordinal = $lvl.Ordinal
            $l.Column = $calTable.Columns[$lvl.Col]
            $h2.Levels.Add($l)
        }
        $calTable.Hierarchies.Add($h2)
        $output += "Added: Fiscal Year-Month"
        $hasChanges = $true
    } else { $output += "Exists: Fiscal Year-Month" }

    # Add relationships if missing
    $relDefs = @(
        @{ Name="factConsumoHistoria-Calendario"; From="factConsumoHistoria"; FromCol="Consumo Fecha" },
        @{ Name="factStockEPSA-Calendario"; From="factStockEPSA"; FromCol="Stock Fecha_Corte" },
        @{ Name="factConsumoPlanificado-Calendario"; From="factConsumoPlanificado"; FromCol="Consumo Planificado Fecha Planificacion" },
        @{ Name="factRecepcionesHistoria-Calendario"; From="factRecepcionesHistoria"; FromCol="RecepcionFecha" }
    )
    # Always refresh these tables to ensure relationship indexes are built
    $affectedTables = @("Calendario", "factConsumoHistoria", "factStockEPSA", "factConsumoPlanificado", "factRecepcionesHistoria")
    foreach ($rd in $relDefs) {
        if (-not ($model.Relationships | Where-Object { $_.Name -eq $rd.Name })) {
            $rel = New-Object Microsoft.AnalysisServices.Tabular.SingleColumnRelationship
            $rel.Name = $rd.Name
            $rel.FromColumn = $model.Tables[$rd.From].Columns[$rd.FromCol]
            $rel.ToColumn = $calTable.Columns["Fecha"]
            $model.Relationships.Add($rel)
            $output += "Added rel: $($rd.Name)"
            $hasChanges = $true
        } else { $output += "Exists rel: $($rd.Name)" }
    }

    if ($hasChanges) {
        # Save metadata changes
        $model.SaveChanges()
        $output += "Saved metadata changes."
    }

    # Always refresh affected tables to ensure relationship indexes are built
    foreach ($tName in ($affectedTables | Select-Object -Unique)) {
        $t = $model.Tables[$tName]
        $t.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
        $output += "Queued refresh: $tName"
    }
    $model.SaveChanges()
    $output += "Processing complete."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $cal2 = $db2.Model.Tables["Calendario"]
    $output += "Calendario hierarchies: $($cal2.Hierarchies.Count)"
    foreach ($h in $cal2.Hierarchies) {
        $output += "  $($h.Name): $($h.Levels.Count) levels"
    }
    $output += "Total relationships: $($db2.Model.Relationships.Count)"

    foreach ($table in $db2.Model.Tables) {
        $p = $table.Partitions[0]
        if ($p) { $output += "  $($table.Name): $($p.State)" }
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
