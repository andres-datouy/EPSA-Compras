# Full SSAS refresh from current partition sources
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Write-Host "Starting full SSAS refresh on 192.168.2.47..." -ForegroundColor Yellow
$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    # Find AMO on server
    $amoPaths = @(
        "C:\Program Files\Microsoft SQL Server\170\DTS\Binn",
        "C:\Program Files\Microsoft SQL Server\160\SDK\Assemblies",
        "C:\Program Files (x86)\Microsoft SQL Server\170\DTS\Binn"
    )
    $loaded = $false
    foreach ($p in $amoPaths) {
        $tabDll = Join-Path $p "Microsoft.AnalysisServices.Tabular.dll"
        if (Test-Path $tabDll) {
            try {
                Add-Type -Path (Join-Path $p "Microsoft.AnalysisServices.Core.dll") -ErrorAction SilentlyContinue
                Add-Type -Path $tabDll
                $loaded = $true
                break
            } catch {}
        }
    }
    if (-not $loaded) {
        # Search broadly
        $found = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
        if ($found) {
            $dir = Split-Path $found.FullName
            Add-Type -Path (Join-Path $dir "Microsoft.AnalysisServices.Core.dll") -ErrorAction SilentlyContinue
            Add-Type -Path $found.FullName
            $loaded = $true
        }
    }
    if (-not $loaded) { return "ERROR: Cannot load AMO on server" }
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    
    $tmsl = '{"refresh": {"type": "full", "objects": [{"database": "Compras_EPSA"}]}}'
    
    try {
        $result = $server.Execute($tmsl)
        
        # Get row counts after refresh
        # Find ADOMD client
        $adPaths = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Sort-Object FullName -Descending
        foreach ($ad in $adPaths) {
            try { Add-Type -Path $ad.FullName -ErrorAction SilentlyContinue; if ([System.Type]::GetType("Microsoft.AnalysisServices.AdomdClient.AdomdConnection")) { break } } catch {}
        }
        
        $output = @()
        if ($result -and $result.ContainsErrors) {
            $output += "REFRESH COMPLETED WITH ERRORS:"
            foreach ($msg in $result.Messages) {
                $output += "  $($msg.Text)"
            }
        } else {
            $output += "REFRESH COMPLETED SUCCESSFULLY"
        }
        
        # Row counts via ADOMD
        try {
            $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
            $conn.ConnectionString = "Data Source=localhost:2383;Catalog=Compras_EPSA"
            $conn.Open()
            
            $tables = @(
                @{ Name = "dimArticulo"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimArticulo'))" }
                @{ Name = "dimProveedor"; DAX = "EVALUATE ROW(""c"", COUNTROWS('dimProveedor'))" }
                @{ Name = "factComprasEnProceso"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factComprasEnProceso'))" }
                @{ Name = "factConsumoHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoHistoria'))" }
                @{ Name = "factConsumoPlanificado"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factConsumoPlanificado'))" }
                @{ Name = "factDemandaPendientePlanificacion"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factDemandaPendientePlanificacion'))" }
                @{ Name = "factRecepcionesHistoria"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factRecepcionesHistoria'))" }
                @{ Name = "factStockEPSA"; DAX = "EVALUATE ROW(""c"", COUNTROWS('factStockEPSA'))" }
            )
            
            $output += ""
            $output += "=== POST-REFRESH SSAS ROW COUNTS ==="
            $output += "{0,-42} {1,10}" -f "Table", "Rows"
            $output += ("-" * 55)
            foreach ($t in $tables) {
                try {
                    $cmd = $conn.CreateCommand()
                    $cmd.CommandText = $t.DAX
                    $r = $cmd.ExecuteReader()
                    $count = "ERR"
                    if ($r.Read()) { $count = $r[0] }
                    $r.Close()
                    $output += "{0,-42} {1,10}" -f $t.Name, $count
                } catch {
                    $output += "{0,-42} {1,10}" -f $t.Name, "ERR"
                }
            }
            $conn.Close()
        } catch {
            $output += "ADOMD query failed: $($_.Exception.Message)"
        }
        
        $server.Disconnect()
        return $output
    } catch {
        $server.Disconnect()
        return "ERROR: $($_.Exception.Message)"
    }
}

Write-Host ""
if ($result -is [array]) {
    Write-Host ($result -join "`n") -ForegroundColor White
} else {
    Write-Host $result -ForegroundColor $(if ($result -match "^ERROR") { "Red" } else { "Green" })
}
