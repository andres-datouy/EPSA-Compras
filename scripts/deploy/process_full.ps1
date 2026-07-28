$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $output += "Starting full process of all tables..."

    # Queue refresh for all tables
    foreach ($t in $model.Tables) {
        $t.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
        $output += "  Queued: $($t.Name)"
    }

    # Save and process
    try {
        $model.SaveChanges()
        $output += "All tables processed successfully."
    } catch {
        $output += "Process error: $_"
    }

    # Verify final state
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $output += ""
    $output += "=== FINAL TABLE STATES ==="
    foreach ($t in $db2.Model.Tables) {
        $p = $t.Partitions[0]
        if ($p) { $output += "  $($t.Name): $($p.State)" }
    }

    # Verify hierarchies still intact
    $cal = $db2.Model.Tables["Calendario"]
    $output += ""
    $output += "Hierarchies: $($cal.Hierarchies.Count)"
    $output += "Relationships: $($db2.Model.Relationships.Count)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
