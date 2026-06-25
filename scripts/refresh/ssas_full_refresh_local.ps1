# SSAS Full Refresh using local AMO v19.114 (pwsh)
# Connects directly to 192.168.2.47:2383

$ErrorActionPreference = "Stop"

# Load AMO v19.114 from NuGet
$amoPath = "$env:TEMP\amo_v2\lib\net8.0"
if (-not (Test-Path "$amoPath\Microsoft.AnalysisServices.Tabular.dll")) {
    Write-Host "Downloading AMO v19.114..." -ForegroundColor Yellow
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.AnalysisServices" -OutFile "$env:TEMP\amo_v2.nupkg" -UseBasicParsing
    $dir = "$env:TEMP\amo_v2"
    if (Test-Path $dir) { Remove-Item $dir -Recurse -Force }
    Expand-Archive -Path "$env:TEMP\amo_v2.nupkg" -DestinationPath $dir -Force
}

Add-Type -Path "$amoPath\Microsoft.AnalysisServices.Core.dll" -ErrorAction SilentlyContinue
Add-Type -Path "$amoPath\Microsoft.AnalysisServices.Tabular.dll"
Write-Host "AMO loaded from: $amoPath" -ForegroundColor Green

# Connect
$serverAddr = "192.168.2.47:2383"
Write-Host "Connecting to: $serverAddr" -ForegroundColor Yellow
$ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
$ssas.Connect("Data Source=$serverAddr")
Write-Host "Connected. Version: $($ssas.Version)" -ForegroundColor Green

# Execute full refresh
$dbName = "Compras_EPSA"
Write-Host "Starting full refresh of '$dbName'..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Gray

$tmsl = @"
{
  "refresh": {
    "type": "full",
    "objects": [
      { "database": "$dbName" }
    ]
  }
}
"@

$startTime = Get-Date
try {
    $result = $ssas.Execute($tmsl)
    $elapsed = (Get-Date) - $startTime
    
    if ($result -and $result.ContainsErrors) {
        Write-Host "REFRESH COMPLETED WITH ERRORS ($([math]::Round($elapsed.TotalMinutes,1)) min):" -ForegroundColor Red
        foreach ($msg in $result.Messages) {
            Write-Host "  $($msg.Text)" -ForegroundColor Red
        }
    } else {
        Write-Host "REFRESH COMPLETED SUCCESSFULLY ($([math]::Round($elapsed.TotalMinutes,1)) min)" -ForegroundColor Green
    }
} catch {
    Write-Error "TMSL refresh failed: $_"
    $ssas.Disconnect()
    exit 1
}

# Get row counts via ADOMD
Write-Host ""
Write-Host "=== POST-REFRESH SSAS ROW COUNTS ===" -ForegroundColor Cyan

Add-Type -Path "$amoPath\Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue
if (-not ([System.Type]::GetType("Microsoft.AnalysisServices.AdomdClient.AdomdConnection"))) {
    # Try alternate path
    $adDll = "$amoPath\Microsoft.AnalysisServices.AdomdClient.dll"
    if (-not (Test-Path $adDll)) {
        Write-Host "ADOMD not in AMO package, skipping row counts." -ForegroundColor Yellow
        $ssas.Disconnect()
        exit 0
    }
    Add-Type -Path $adDll
}

try {
    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
    $conn.ConnectionString = "Data Source=$serverAddr;Catalog=$dbName"
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
    
    Write-Host ("{0,-42} {1,10}" -f "Table", "Rows")
    Write-Host ("-" * 55)
    foreach ($t in $tables) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $t.DAX
            $r = $cmd.ExecuteReader()
            $count = "ERR"
            if ($r.Read()) { $count = $r[0] }
            $r.Close()
            Write-Host ("{0,-42} {1,10}" -f $t.Name, $count) -ForegroundColor White
        } catch {
            Write-Host ("{0,-42} {1,10}" -f $t.Name, "ERR") -ForegroundColor Red
        }
    }
    
    # Last processed time
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT LAST_DATA_UPDATE FROM `$system.MDSCHEMA_CUBES WHERE CUBE_NAME='Model'"
    $r2 = $cmd2.ExecuteReader()
    if ($r2.Read()) {
        Write-Host ""
        Write-Host "Last Data Update: $($r2[0])" -ForegroundColor Green
    }
    $r2.Close()
    $conn.Close()
} catch {
    Write-Host "ADOMD query failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

$ssas.Disconnect()
Write-Host ""
Write-Host "Done." -ForegroundColor Cyan
