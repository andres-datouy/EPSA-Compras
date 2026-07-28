# Set credentials and process SSAS database
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$pass = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", $pass)

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    Write-Output "Connected."
    
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if (-not $db) {
        Write-Output "ERROR: Database not found!"
        $ssas.Disconnect()
        return
    }
    
    Write-Output "Database found. Tables: $($db.Model.Tables.Count)"
    
    # Set credentials using TMSL alter command
    $alterTmsl = @"
{
  "createOrReplace": {
    "object": {
      "database": "Compras_EPSA",
      "dataSource": "staging_compras"
    },
    "dataSource": {
      "name": "staging_compras",
      "type": "provider",
      "connectionString": "Data Source=192.168.2.47,1435;Initial Catalog=staging_compras;Provider=MSOLEDBSQL;User ID=app_compras;Password=__SQL_PASSWORD__;Persist Security Info=false",
      "impersonationMode": "impersonateServiceAccount"
    }
  }
}
"@
    
    Write-Output "Setting data source credentials via TMSL..."
    $alterResult = $ssas.Execute($alterTmsl)
    Write-Output "Alter ContainsErrors: $($alterResult.ContainsErrors)"
    foreach ($msg in $alterResult.Messages) {
        Write-Output "ALTER MSG: $($msg.Description)"
    }
    
    # Process all tables
    Write-Output "Processing database..."
    $processTmsl = @"
{
  "refresh": {
    "type": "full",
    "objects": [
      { "database": "Compras_EPSA" }
    ]
  }
}
"@
    
    $processResult = $ssas.Execute($processTmsl)
    Write-Output "Process ContainsErrors: $($processResult.ContainsErrors)"
    foreach ($msg in $processResult.Messages) {
        Write-Output "PROCESS: $($msg.Description) (code: $($msg.ErrorCode))"
    }
    
    # Check results
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    Write-Output "`nTable states:"
    foreach ($table in $db2.Model.Tables) {
        $p = $table.Partitions[0]
        if ($p) {
            Write-Output "  $($table.Name): $($p.State)"
        }
    }
    
    $ssas.Disconnect()
}

Write-Host ($result -join "`n") -ForegroundColor White
