$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

# --- Pre-deploy validation ---
Write-Host "Running pre-deploy validation..." -ForegroundColor Cyan
& "$PSScriptRoot\validate_model.ps1" -ModelFile "$PSScriptRoot\..\..\model\database_staging.json"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Validation failed. Deploy aborted. Fix errors and retry."
    exit 1
}
Write-Host "" -ForegroundColor White

$json = Get-Content "$PSScriptRoot\..\..\model\database_staging.json" -Raw -Encoding UTF8

# Inyectar password del datasource desde .env.local (el JSON versionado usa placeholder)
$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $sqlPass) { throw "SQL_PASSWORD no encontrado en .env.local" }
$json = $json.Replace("__SQL_PASSWORD__", $sqlPass)

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($jsonContent)
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")

    $dbName = "Compras_EPSA"
    $output += "Connected to SSAS. Deploying $dbName..."

    $tmsl = @"
{
  "createOrReplace": {
    "object": {
      "database": "$dbName"
    },
    "database": $jsonContent
  }
}
"@

    try {
        $r = $ssas.Execute($tmsl)
        if ($r -and $r.ContainsErrors) {
            foreach ($m in $r.Messages) {
                $output += "ERROR: $($m.Text)"
            }
        } else {
            $output += "TMSL deploy OK"
        }
    } catch {
        $output += "EXCEPTION: $_"
    }

    # Verify hierarchies
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    if ($db) {
        $cal = $db.Model.Tables["Calendario"]
        $output += "Calendario hierarchies: $($cal.Hierarchies.Count)"
        foreach ($h in $cal.Hierarchies) {
            $output += "  $($h.Name): $($h.Levels.Count) levels"
        }
        $output += "Total relationships: $($db.Model.Relationships.Count)"
        $output += "Total tables: $($db.Model.Tables.Count)"
    }

    $ssas.Disconnect()
    return $output
} -ArgumentList $json

Write-Host ($result -join "`n") -ForegroundColor White

# Post-deploy: inject measure descriptions (SSAS 2017 TMSL doesn't persist description field)
Write-Host "`nInjecting measure descriptions..." -ForegroundColor Cyan
& "$PSScriptRoot\inject_descriptions.ps1"
