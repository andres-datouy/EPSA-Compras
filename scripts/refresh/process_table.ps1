# Process single table to isolate error
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$tableName = $args[0]
if (-not $tableName) { $tableName = "factStockEPSA" }

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($tableName)
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
    
    $table = $db.Model.Tables | Where-Object { $_.Name -eq $tableName }
    if (-not $table) {
        Write-Output "Table '$tableName' not found. Available: $($db.Model.Tables.Name -join ', ')"
        $ssas.Disconnect()
        return
    }
    
    Write-Output "Processing table: $tableName"
    try {
        $table.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full)
        $db.Model.SaveChanges()
        Write-Output "SUCCESS!"
    } catch {
        Write-Output "ERROR: $_"
    }
    
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq $dbName }
    $t = $db.Model.Tables | Where-Object { $_.Name -eq $tableName }
    $p = $t.Partitions[0]
    Write-Output "State: $($p.State)"
    
    $ssas.Disconnect()
} -ArgumentList $tableName

$result | ForEach-Object { Write-Host $_ }
