# SSAS row count check using AMO + ADOMD
$amoPath = "$env:TEMP\amo_v2\lib\net8.0"
$adomdPath = "$env:TEMP\adomd\lib\net45"

# Load AMO
Add-Type -Path "$amoPath\Microsoft.AnalysisServices.Core.dll" -ErrorAction SilentlyContinue
Add-Type -Path "$amoPath\Microsoft.AnalysisServices.Tabular.dll"

# Load ADOMD
Add-Type -Path "$adomdPath\Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue

$ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
$ssas.Connect("Data Source=192.168.2.47:2383")

$db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
Write-Host "Database: $($db.Name)" -ForegroundColor Green
Write-Host "Last Processed: $($db.LastProcessed)" -ForegroundColor Green
Write-Host ""

# Use ADOMD for DAX queries
$conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
$conn.ConnectionString = "Data Source=192.168.2.47:2383;Catalog=Compras_EPSA"
$conn.Open()

$tables = @(
    "dimArticulo", "dimProveedor", "factComprasEnProceso",
    "factConsumoHistoria", "factConsumoPlanificado",
    "factDemandaPendientePlanificacion", "factRecepcionesHistoria",
    "factStockEPSA", "Calendario"
)

Write-Host "=== POST-REFRESH SSAS ROW COUNTS ===" -ForegroundColor Cyan
Write-Host ("{0,-42} {1,10}" -f "Table", "Rows")
Write-Host ("-" * 55)

foreach ($tName in $tables) {
    try {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "EVALUATE ROW(""c"", COUNTROWS('$tName'))"
        $r = $cmd.ExecuteReader()
        $count = "?"
        if ($r.Read()) { $count = $r[0] }
        $r.Close()
        Write-Host ("{0,-42} {1,10}" -f $tName, $count) -ForegroundColor White
    } catch {
        Write-Host ("{0,-42} {1,10}" -f $tName, "ERR") -ForegroundColor Red
    }
}

$conn.Close()
$ssas.Disconnect()
