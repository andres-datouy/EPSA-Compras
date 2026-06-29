# Add Calendario hierarchies and relationships via AMO after deployment
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

    # Add Fiscal Year-Quarter hierarchy
    if (-not ($calTable.Hierarchies | Where-Object { $_.Name -eq "Fiscal Year-Quarter" })) {
        $h1 = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
        $h1.Name = "Fiscal Year-Quarter"
        $l1 = New-Object Microsoft.AnalysisServices.Tabular.Level
        $l1.Name = "Year"
        $l1.Ordinal = 0
        $l1.Column = $calTable.Columns["Año Fiscal"]
        $h1.Levels.Add($l1)
        $l2 = New-Object Microsoft.AnalysisServices.Tabular.Level
        $l2.Name = "Quarter"
        $l2.Ordinal = 1
        $l2.Column = $calTable.Columns["Trimestre del año fiscal"]
        $h1.Levels.Add($l2)
        $l3 = New-Object Microsoft.AnalysisServices.Tabular.Level
        $l3.Name = "Month"
        $l3.Ordinal = 2
        $l3.Column = $calTable.Columns["Año Mes"]
        $h1.Levels.Add($l3)
        $calTable.Hierarchies.Add($h1)
        $output += "Added hierarchy: Fiscal Year-Quarter"
    }

    # Add Fiscal Year-Month hierarchy
    if (-not ($calTable.Hierarchies | Where-Object { $_.Name -eq "Fiscal Year-Month" })) {
        $h2 = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
        $h2.Name = "Fiscal Year-Month"
        $l4 = New-Object Microsoft.AnalysisServices.Tabular.Level
        $l4.Name = "Year"
        $l4.Ordinal = 0
        $l4.Column = $calTable.Columns["Año Fiscal"]
        $h2.Levels.Add($l4)
        $l5 = New-Object Microsoft.AnalysisServices.Tabular.Level
        $l5.Name = "Month"
        $l5.Ordinal = 1
        $l5.Column = $calTable.Columns["Año Mes"]
        $h2.Levels.Add($l5)
        $calTable.Hierarchies.Add($h2)
        $output += "Added hierarchy: Fiscal Year-Month"
    }

    # Add relationships
    $relDefs = @(
        @{ Name="factConsumoHistoria-Calendario"; From="factConsumoHistoria"; FromCol="Consumo Fecha"; To="Calendario"; ToCol="Fecha" },
        @{ Name="factStockEPSA-Calendario"; From="factStockEPSA"; FromCol="Stock Fecha_Corte"; To="Calendario"; ToCol="Fecha" },
        @{ Name="factConsumoPlanificado-Calendario"; From="factConsumoPlanificado"; FromCol="Consumo Planificado Fecha Planificacion"; To="Calendario"; ToCol="Fecha" },
        @{ Name="factRecepcionesHistoria-Calendario"; From="factRecepcionesHistoria"; FromCol="RecepcionFecha"; To="Calendario"; ToCol="Fecha" }
    )

    foreach ($rd in $relDefs) {
        if (-not ($model.Relationships | Where-Object { $_.Name -eq $rd.Name })) {
            $rel = New-Object Microsoft.AnalysisServices.Tabular.SingleColumnRelationship
            $rel.Name = $rd.Name
            $rel.FromColumn = $model.Tables[$rd.From].Columns[$rd.FromCol]
            $rel.ToColumn = $model.Tables[$rd.To].Columns[$rd.ToCol]
            $model.Relationships.Add($rel)
            $output += "Added relationship: $($rd.Name)"
        } else {
            $output += "Relationship already exists: $($rd.Name)"
        }
    }

    # Save
    $model.SaveChanges()
    $output += "Changes saved."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $cal2 = $db2.Model.Tables["Calendario"]
    $output += "Calendario hierarchies: $($cal2.Hierarchies.Count)"
    foreach ($h in $cal2.Hierarchies) {
        $output += "  $($h.Name): $($h.Levels.Count) levels"
    }
    $output += "Total relationships: $($db2.Model.Relationships.Count)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
