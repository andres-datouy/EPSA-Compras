# Fix database_staging.json and deploy
$pass = ConvertTo-SecureString "Saas 244050@" -AsPlainText -Force
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", $pass)

# Read and fix database_staging.json locally
$raw = Get-Content "d:\Andres\Dev\EPSA-Compras\model\database_staging.json" -Raw -Encoding UTF8
$json = $raw | ConvertFrom-Json

# Remove dangling Calendario relationships
if ($json.model.relationships) {
    $before = $json.model.relationships.Count
    $relsToKeep = @()
    foreach ($rel in $json.model.relationships) {
        if ($rel.fromTable -eq "Calendario" -or $rel.toTable -eq "Calendario") {
            Write-Host "  REMOVED relationship: $($rel.name)" -ForegroundColor Red
        } else {
            $relsToKeep += $rel
        }
    }
    $json.model.relationships = $relsToKeep
    Write-Host "Relationships: $before -> $($relsToKeep.Count)" -ForegroundColor Yellow
}

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
            $ds.Credential.Password = "Saas 244050@"
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
