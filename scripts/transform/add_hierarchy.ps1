# Add hierarchy to Calendario table in SSAS via WinRM
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Write-Host "Adding Calendario hierarchy via WinRM..." -ForegroundColor Cyan

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
    if (-not $db) { throw "Database not found" }
    
    $calTable = $db.Model.Tables | Where-Object { $_.Name -eq "Calendario" }
    if (-not $calTable) { throw "Calendario table not found" }
    
    # Check if hierarchy already exists
    $existingHier = $calTable.Hierarchies | Where-Object { $_.Name -eq "Jerarquía Fiscal" }
    if ($existingHier) {
        Write-Output "Hierarchy 'Jerarquía Fiscal' already exists. Removing..."
        $calTable.Hierarchies.Remove($existingHier)
    }
    
    # Create hierarchy: Año Fiscal -> Trimestre del año fiscal -> Año Mes
    $hier = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
    $hier.Name = "Jerarquía Fiscal"
    $hier.Description = "Año Fiscal > Trimestre > Mes"
    
    # Level 1: Año Fiscal
    $level1 = New-Object Microsoft.AnalysisServices.Tabular.Level
    $level1.Name = "Año Fiscal"
    $level1.Ordinal = 0
    $col1 = $calTable.Columns | Where-Object { $_.Name -eq "Año Fiscal" }
    if (-not $col1) { throw "Column 'Año Fiscal' not found" }
    $level1.Column = $col1
    $hier.Levels.Add($level1)
    
    # Level 2: Trimestre del año fiscal
    $level2 = New-Object Microsoft.AnalysisServices.Tabular.Level
    $level2.Name = "Trimestre del año fiscal"
    $level2.Ordinal = 1
    $col2 = $calTable.Columns | Where-Object { $_.Name -eq "Trimestre del año fiscal" }
    if (-not $col2) { throw "Column 'Trimestre del año fiscal' not found" }
    $level2.Column = $col2
    $hier.Levels.Add($level2)
    
    # Level 3: Año Mes
    $level3 = New-Object Microsoft.AnalysisServices.Tabular.Level
    $level3.Name = "Año Mes"
    $level3.Ordinal = 2
    $col3 = $calTable.Columns | Where-Object { $_.Name -eq "Año Mes" }
    if (-not $col3) { throw "Column 'Año Mes' not found" }
    $level3.Column = $col3
    $hier.Levels.Add($level3)
    
    $calTable.Hierarchies.Add($hier)
    $db.Model.SaveChanges()
    Write-Output "Hierarchy 'Jerarquía Fiscal' created: Año Fiscal > Trimestre del año fiscal > Año Mes"
    
    # Also add a calendar (non-fiscal) hierarchy
    $existingHier2 = $calTable.Hierarchies | Where-Object { $_.Name -eq "Jerarquía Calendario" }
    if ($existingHier2) {
        $calTable.Hierarchies.Remove($existingHier2)
    }
    
    $hier2 = New-Object Microsoft.AnalysisServices.Tabular.Hierarchy
    $hier2.Name = "Jerarquía Calendario"
    $hier2.Description = "Año > Trimestre Fiscal > Mes Fiscal"
    
    # Use Año Fiscal Número for sorting, then Año Mes
    $l1 = New-Object Microsoft.AnalysisServices.Tabular.Level
    $l1.Name = "Año Fiscal"
    $l1.Ordinal = 0
    $l1.Column = $col1
    $hier2.Levels.Add($l1)
    
    $l2 = New-Object Microsoft.AnalysisServices.Tabular.Level
    $l2.Name = "Fiscal Month"
    $l2.Ordinal = 1
    $colFM = $calTable.Columns | Where-Object { $_.Name -eq "Fiscal Month" }
    if ($colFM) { $l2.Column = $colFM; $hier2.Levels.Add($l2) }
    
    $calTable.Hierarchies.Add($hier2)
    $db.Model.SaveChanges()
    Write-Output "Hierarchy 'Jerarquía Calendario' created: Año Fiscal > Fiscal Month"
    
    # List all hierarchies
    Write-Output "`nAll hierarchies in Calendario:"
    foreach ($h in $calTable.Hierarchies) {
        $levels = ($h.Levels | ForEach-Object { $_.Name }) -join " > "
        Write-Output "  $($h.Name): $levels"
    }
    
    $server.Disconnect($true)
}

Write-Host $result -ForegroundColor Green
