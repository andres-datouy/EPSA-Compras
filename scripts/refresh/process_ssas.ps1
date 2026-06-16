# Process SSAS - detailed error capture
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $amoPaths = @(
        "$env:ProgramFiles\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll",
        "$env:ProgramFiles\Microsoft SQL Server\*\OLAP\bin\Microsoft.AnalysisServices.Tabular.dll",
        "$env:ProgramFiles\Microsoft SQL Server\*\SDK\Assemblies\Microsoft.AnalysisServices.Tabular.dll"
    )
    foreach ($pattern in $amoPaths) {
        $dll = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
        if ($dll) {
            $amoDir = Split-Path $dll.FullName
            foreach ($dep in @("Microsoft.AnalysisServices.Core.dll","Microsoft.AnalysisServices.Tabular.dll","Microsoft.AnalysisServices.Tabular.Json.dll")) {
                $depPath = Join-Path $amoDir $dep
                if (Test-Path $depPath) { try { Add-Type -Path $depPath -ErrorAction SilentlyContinue } catch {} }
            }
            break
        }
    }

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    
    $dbName = "Compras_EPSA"
    $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    Write-Output "DB State: $($db.State), Tables: $($db.Model.Tables.Count)"
    
    # Try AMO refresh approach instead of TMSL
    try {
        $db.Model.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full)
        $db.Model.SaveChanges()
        Write-Output "SUCCESS: Processing completed!"
    } catch {
        Write-Output "SAVE CHANGES ERROR: $_"
        Write-Output "INNER: $($_.Exception.InnerException)"
        Write-Output "INNER2: $($_.Exception.InnerException.InnerException)"
        if ($_.Exception.InnerException.InnerException) {
            Write-Output "INNER3: $($_.Exception.InnerException.InnerException.InnerException)"
        }
    }
    
    # Check state
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    Write-Output ""
    Write-Output "=== FINAL STATE ==="
    foreach ($table in $db.Model.Tables) {
        $p = $table.Partitions[0]
        $state = if ($p) { $p.State } else { "NoPartition" }
        Write-Output "  $($table.Name): $state"
    }
    
    $ssas.Disconnect()
}

$result | ForEach-Object { Write-Host $_ }
