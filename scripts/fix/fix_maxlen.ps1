# Check actual maxLength values and try setting them explicitly
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $amoPaths = @("$env:ProgramFiles\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll",
        "$env:ProgramFiles\Microsoft SQL Server\*\OLAP\bin\Microsoft.AnalysisServices.Tabular.dll")
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
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    
    # Check all string columns' maxLength using reflection or direct property access
    $table = $db.Model.Tables | Where-Object { $_.Name -eq "dimArticulo" }
    Write-Output "=== Checking Artículo Nombre column properties ==="
    $col = $table.Columns | Where-Object { $_.Name -eq "Artículo Nombre" }
    Write-Output "  Name: $($col.Name)"
    Write-Output "  DataType: $($col.DataType)"
    Write-Output "  MaxLength property: $($col.MaxLength)"
    Write-Output "  MaxLength type: $($col.MaxLength.GetType().FullName)"
    
    # Try setting maxLength explicitly
    Write-Output ""
    Write-Output "Setting maxLength to 4000 on all string columns..."
    foreach ($c in $table.Columns) {
        if ($c.DataType -eq "String") {
            $c.MaxLength = 4000
        }
    }
    $db.Model.SaveChanges()
    Write-Output "Done. Now trying refresh..."
    
    try {
        $table.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full)
        $db.Model.SaveChanges()
        Write-Output "SUCCESS!"
    } catch {
        Write-Output "STILL FAILS: $_"
    }
    
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $t = $db.Model.Tables | Where-Object { $_.Name -eq "dimArticulo" }
    $p = $t.Partitions[0]
    Write-Output "State: $($p.State)"
    
    $ssas.Disconnect()
}

$result | ForEach-Object { Write-Host $_ }
