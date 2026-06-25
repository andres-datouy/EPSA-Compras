# SSAS row counts via ADOMD (Windows PowerShell / .NET Framework)
Add-Type -Path "$env:TEMP\adomd\lib\net45\Microsoft.AnalysisServices.AdomdClient.dll"

$conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
$conn.ConnectionString = "Data Source=192.168.2.47:2383;Catalog=Compras_EPSA"
$conn.Open()

Write-Host "=== POST-REFRESH SSAS ROW COUNTS ===" -ForegroundColor Cyan
Write-Host ("{0,-42} {1,10}" -f "Table", "Rows")
Write-Host ("-" * 55)

$tables = @(
    "dimArticulo", "dimProveedor", "factComprasEnProceso",
    "factConsumoHistoria", "factConsumoPlanificado",
    "factDemandaPendientePlanificacion", "factRecepcionesHistoria",
    "factStockEPSA", "Calendario"
)

foreach ($t in $tables) {
    try {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "EVALUATE ROW(""c"", COUNTROWS('$t'))"
        $r = $cmd.ExecuteReader()
        $count = "?"
        if ($r.Read()) { $count = $r[0] }
        $r.Close()
        Write-Host ("{0,-42} {1,10}" -f $t, $count) -ForegroundColor White
    } catch {
        Write-Host ("{0,-42} {1,10}" -f $t, "ERR: $($_.Exception.Message.Substring(0, [Math]::Min(50, $_.Exception.Message.Length)))") -ForegroundColor Red
    }
}

# Last data update
$cmd2 = $conn.CreateCommand()
$cmd2.CommandText = "SELECT LAST_DATA_UPDATE FROM `$system.MDSCHEMA_CUBES WHERE CUBE_NAME='Model'"
$r2 = $cmd2.ExecuteReader()
if ($r2.Read()) {
    Write-Host ""
    Write-Host "Last Data Update: $($r2[0])" -ForegroundColor Green
}
$r2.Close()

$conn.Close()
