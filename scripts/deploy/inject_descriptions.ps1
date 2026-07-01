# inject_descriptions.ps1
# Post-deploy: inject measure descriptions into SSAS via AMO
# SSAS 2017 TMSL doesn't persist measure descriptions, so we set them via AMO after deploy

$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

# Read descriptions from the staging JSON
$jsonPath = Join-Path $PSScriptRoot "..\..\model\database_staging.json"
$json = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

# Build a hashtable: measureName -> description
$descMap = @{}
foreach ($table in $json.model.tables) {
    if ($table.measures) {
        foreach ($m in $table.measures) {
            if ($m.description) {
                $descMap[$m.name] = $m.description
            }
        }
    }
}

Write-Host "Descriptions to inject: $($descMap.Count)" -ForegroundColor Cyan

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($descMap)

    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $svr = New-Object Microsoft.AnalysisServices.Tabular.Server
    $svr.Connect("Data Source=localhost:2383")
    $db = $svr.Databases.FindByName("Compras_EPSA")

    $output = @()
    $updated = 0
    foreach ($t in $db.Model.Tables) {
        foreach ($m in $t.Measures) {
            if ($descMap.ContainsKey($m.Name)) {
                $m.Description = $descMap[$m.Name]
                $updated++
                $output += "  SET: $($m.Name)"
            }
        }
    }

    $db.Model.SaveChanges()
    $output += "Updated $updated measures. SaveChanges OK."

    $svr.Disconnect()
    return $output
} -ArgumentList (,$descMap)

Write-Host ($result -join "`n") -ForegroundColor White
