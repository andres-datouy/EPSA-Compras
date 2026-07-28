# Process factVencimientos table
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" -ErrorAction SilentlyContinue | Where-Object { $_ -match "SSAS_PASS" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $output += "Connected to SSAS"

    $tmsl = @"
{
  "refresh": {
    "type": "automatic",
    "objects": [
      {
        "database": "Compras_EPSA",
        "table": "factVencimientos"
      }
    ]
  }
}
"@
    try {
        $r = $ssas.Execute($tmsl)
        if ($r -and $r.ContainsErrors) {
            foreach ($m in $r.Messages) { $output += "ERROR: $($m.Text)" }
        } else {
            $output += "SUCCESS: factVencimientos processed"
        }
    } catch {
        $output += "EXCEPTION: $_"
    }

    # Verify
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $tbl = $db.Model.Tables["factVencimientos"]
    if ($tbl) {
        $output += "Table: $($tbl.Name), Measures: $($tbl.Measures.Count), Columns: $($tbl.Columns.Count)"
        foreach ($m in $tbl.Measures) { $output += "  Measure: $($m.Name)" }
    } else {
        $output += "ERROR: Table factVencimientos not found!"
    }
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
