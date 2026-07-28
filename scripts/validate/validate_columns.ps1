# Get SSAS model schema via TMSL DISCOVER
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # Load AMO with proper dependency loading
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    $output += "AMO dir: $amoDir"
    
    # Try loading with full path resolution
    $dllFiles = @(
        "Microsoft.AnalysisServices.Core.dll",
        "Microsoft.AnalysisServices.Tabular.dll"
    )
    foreach ($dll in $dllFiles) {
        $path = Join-Path $amoDir $dll
        if (Test-Path $path) {
            try { Add-Type -Path $path; $output += "  Loaded: $dll" } 
            catch { $output += "  Failed: $dll - $($_.Exception.Message)" }
        } else {
            $output += "  Missing: $dll"
        }
    }
    
    # Try connecting with named instance
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    try {
        $server.Connect("Data Source=localhost:2383")
        $output += "Connected to SSAS"
    } catch {
        # Try without port
        try {
            $server.Connect("Data Source=localhost\SSAS")
            $output += "Connected to SSAS (named instance)"
        } catch {
            $output += "Connection failed: $($_.Exception.Message)"
            return $output
        }
    }
    
    $db = $server.Databases.FindByName("Compras_EPSA")
    if ($db -eq $null) { $output += "DB not found"; return $output }
    $output += "DB: $($db.Name), Tables: $($db.Model.Tables.Count)"
    $output += ""
    
    foreach ($table in $db.Model.Tables) {
        $tn = $table.Name
        if ($tn -like "_*" -or $tn -like "DateTableTemplate*") { continue }
        
        $output += "=== [$tn] ==="
        foreach ($col in $table.Columns) {
            $ct = $col.GetType().Name
            $output += "  COL: $($col.Name) | $ct | $($col.DataType)"
        }
        foreach ($m in $table.Measures) {
            $output += "  MEAS: $($m.Name)"
        }
        foreach ($h in $table.Hierarchies) {
            $levels = ($h.Levels | ForEach-Object { $_.Name }) -join " > "
            $output += "  HIER: $($h.Name) ($levels)"
        }
        $output += ""
    }
    
    $server.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
