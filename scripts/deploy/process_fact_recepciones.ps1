# Process factRecepcionesHistoria table to recalculate Lead Time Dias calculated column
# Uses WinRM to run AMO commands on the remote SSAS server

$pass = Get-Content "$PSScriptRoot\..\..\.env.local" -ErrorAction SilentlyContinue | Where-Object { $_ -match "SSAS_PASS" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Write-Host "Processing factRecepcionesHistoria table (recalculate Lead Time Dias)..." -ForegroundColor Cyan

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $output += "Connected to SSAS"

    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if (-not $db) {
        $output += "ERROR: Database Compras_EPSA not found"
        $ssas.Disconnect()
        return $output
    }
    $output += "Found database: $($db.Name)"

    $tbl = $db.Model.Tables["factRecepcionesHistoria"]
    if (-not $tbl) {
        $output += "ERROR: Table factRecepcionesHistoria not found"
        $ssas.Disconnect()
        return $output
    }
    $output += "Found table: $($tbl.Name)"

    # Check the calculated column
    $calcCol = $tbl.Columns | Where-Object { $_.Name -eq "Lead Time Dias" }
    if ($calcCol) {
        $output += "Found calculated column: $($calcCol.Name) (type: $($calcCol.Type))"
    } else {
        $output += "WARNING: Lead Time Dias column not found in table"
    }

    # Process via TMSL - recalculates calculated columns
    $output += "Sending TMSL process command..."
    try {
        $tmsl = @"
{
  "refresh": {
    "type": "automatic",
    "objects": [
      {
        "database": "Compras_EPSA",
        "table": "factRecepcionesHistoria"
      }
    ]
  }
}
"@
        $r = $ssas.Execute($tmsl)
        if ($r -and $r.ContainsErrors) {
            foreach ($m in $r.Messages) {
                $output += "ERROR: $($m.Text)"
            }
        } else {
            $output += "SUCCESS: Table processed. Lead Time Dias recalculated."
        }
    } catch {
        $output += "EXCEPTION: $_"
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
