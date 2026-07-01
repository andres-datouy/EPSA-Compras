$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $output = @()

    $output += "=== TABLE STATES ==="
    foreach ($t in $db.Model.Tables) {
        $p = $t.Partitions[0]
        if ($p) { $output += "  $($t.Name): $($p.State)" }
    }

    $cal = $db.Model.Tables["Calendario"]
    $output += ""
    $output += "=== CALENDARIO HIERARCHIES ($($cal.Hierarchies.Count)) ==="
    foreach ($h in $cal.Hierarchies) {
        $levels = ($h.Levels | ForEach-Object { "$($_.Name) [$($_.Column.Name)]" }) -join " > "
        $output += "  $($h.Name): $levels"
    }

    $output += ""
    $output += "=== RELATIONSHIPS ($($db.Model.Relationships.Count)) ==="
    foreach ($r in $db.Model.Relationships) {
        $output += "  $($r.FromTable.Name).$($r.FromColumn.Name) -> $($r.ToTable.Name).$($r.ToColumn.Name)"
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
