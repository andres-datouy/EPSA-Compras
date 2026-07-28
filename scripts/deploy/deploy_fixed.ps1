$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Fix database_staging.json and deploy
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$pass = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", $pass)

# Read and fix database_staging.json locally (inyectando password desde .env.local)
$raw = Get-Content "d:\Andres\Dev\EPSA-Compras\model\database_staging.json" -Raw -Encoding UTF8
if (-not $sqlPass) { throw "SQL_PASSWORD no encontrado en .env.local" }
$raw = $raw.Replace("__SQL_PASSWORD__", $sqlPass)
$json = $raw | ConvertFrom-Json

# Calendario relationships are valid - DAX calculated table with proper Fecha key
# (Previously stripped during migration - no longer needed)
Write-Host "Relationships: $($json.model.relationships.Count) (keeping all)" -ForegroundColor Yellow

# Serialize back
$fixed = $json | ConvertTo-Json -Depth 100
[System.IO.File]::WriteAllText("d:\Andres\Dev\EPSA-Compras\model\database_staging_fixed.json", $fixed, [System.Text.Encoding]::UTF8)
Write-Host "Fixed model written." -ForegroundColor Green

# Copy to server
Copy-Item "d:\Andres\Dev\EPSA-Compras\model\database_staging_fixed.json" "\\192.168.2.47\C$\temp\ssas_deploy\database_staging.json" -Force
Write-Host "Copied to server." -ForegroundColor Green

# Deploy
$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    
    $modelJson = Get-Content "C:\temp\ssas_deploy\database_staging.json" -Raw -Encoding UTF8
    $dbName = "Compras_EPSA"
    
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    Write-Output "Connected."
    
    $existingDb = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    if ($existingDb) {
        Write-Output "Dropping existing..."
        $existingDb.Drop()
        $ssas.Refresh()
    }
    
    $tmsl = "{`"createOrReplace`":{`"object`":{`"database`":`"$dbName`"},`"database`":$modelJson}}"
    Write-Output "Deploying..."
    
    $xmlaResult = $ssas.Execute($tmsl)
    Write-Output "ContainsErrors: $($xmlaResult.ContainsErrors)"
    
    foreach ($msg in $xmlaResult.Messages) {
        Write-Output "ERROR: $($msg.Description) (code: $($msg.ErrorCode))"
    }
    
    if (-not $xmlaResult.ContainsErrors) {
        $ssas.Refresh()
        $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
        Write-Output "DEPLOYED! Tables: $($db.Model.Tables.Count)"
        
        # Set data source credentials
        Write-Output "Setting credentials..."
        foreach ($ds in $db.Model.DataSources) {
            $ds.Credential = New-Object Microsoft.AnalysisServices.Tabular.Credential
            $ds.Credential.AuthenticationKind = "UsernamePassword"
            $ds.Credential.Username = "app_compras"
            $ds.Credential.Password = $using:sqlPass
            Write-Output "  Set creds for: $($ds.Name)"
        }
        $db.Model.SaveChanges()
        Write-Output "Credentials saved."
        
        # Process
        Write-Output "Processing..."
        $processTmsl = "{`"refresh`":{`"type`":`"full`",`"objects`":[{`"database`":`"$dbName`"}]}}"
        $processResult = $ssas.Execute($processTmsl)
        Write-Output "Process ContainsErrors: $($processResult.ContainsErrors)"
        foreach ($msg in $processResult.Messages) {
            Write-Output "PROCESS ERROR: $($msg.Description)"
        }
        
        # Row counts
        $ssas.Refresh()
        $db2 = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
        Write-Output "`nRow counts:"
        foreach ($table in $db2.Model.Tables) {
            $p = $table.Partitions[0]
            if ($p) {
                Write-Output "  $($table.Name): state=$($p.State)"
            }
        }
    }
    
    $ssas.Disconnect()
}

Write-Host ($result -join "`n") -ForegroundColor White
