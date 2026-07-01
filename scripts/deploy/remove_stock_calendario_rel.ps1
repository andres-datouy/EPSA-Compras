# Remove the factStockEPSA-Calendario relationship from the live SSAS model.
# Stock is a snapshot table — it should NOT be filtered by the date slicer.
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")

    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $relName = "factStockEPSA-Calendario"
    $rel = $model.Relationships | Where-Object { $_.Name -eq $relName }

    if ($rel) {
        $model.Relationships.Remove($rel)
        $model.SaveChanges()
        $output += "Removed relationship: $relName"

        # Refresh factStockEPSA to rebuild indexes without the relationship
        $t = $model.Tables["factStockEPSA"]
        $t.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
        $model.SaveChanges()
        $output += "Refreshed: factStockEPSA"
    } else {
        $output += "Relationship not found (already removed?): $relName"
    }

    # Verify remaining relationships to Calendario
    $calRels = $model.Relationships | Where-Object { $_.ToColumn.Table.Name -eq "Calendario" }
    $output += "Remaining Calendario relationships: $($calRels.Count)"
    foreach ($r in $calRels) {
        $output += "  $($r.Name): $($r.FromColumn.Table.Name)[$($r.FromColumn.Name)] -> Calendario"
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
