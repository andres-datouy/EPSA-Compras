# Verify Calendario hierarchy exists in SSAS
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    # Load AMO
    $amoDll = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*OLAP*" -or $_.FullName -like "*SDK*" -or $_.FullName -like "*DTS*" -or $_.FullName -like "*Setup Bootstrap*" } |
        Sort-Object FullName -Descending | Select-Object -First 1
    
    if ($amoDll) {
        $dir = Split-Path $amoDll.FullName
        foreach ($dep in @("Microsoft.AnalysisServices.Core.dll", "Microsoft.AnalysisServices.Tabular.dll", "Microsoft.AnalysisServices.Tabular.Json.dll")) {
            $p = Join-Path $dir $dep
            if (Test-Path $p) { try { Add-Type -Path $p -ErrorAction SilentlyContinue } catch {} }
        }
    }

    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    
    if (-not $db) {
        Write-Output "Database not found!"
        $server.Disconnect($true)
        return
    }
    
    $calTable = $db.Model.Tables | Where-Object { $_.Name -eq "Calendario" }
    if (-not $calTable) {
        Write-Output "Calendario table not found!"
        $server.Disconnect($true)
        return
    }
    
    Write-Output "=== Calendario Hierarchies ==="
    foreach ($hier in $calTable.Hierarchies) {
        Write-Output "Hierarchy: $($hier.Name)"
        foreach ($level in $hier.Levels) {
            Write-Output "  Level $($level.Ordinal): $($level.Name) (Column: $($level.Column.Name))"
        }
    }
    
    Write-Output "`n=== Calendario Columns ==="
    foreach ($col in $calTable.Columns) {
        Write-Output "  Column: $($col.Name) (Type: $($col.GetType().Name))"
    }
    
    $server.Disconnect($true)
}

Write-Host $result
