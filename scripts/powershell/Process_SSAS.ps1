# Process_SSAS.ps1 — se ejecuta en 192.168.2.47 (SQL Agent CmdExec)
# Process full del modelo tabular Compras_EPSA contra la instancia SSAS local (puerto 2383).
# Usa ADOMD.NET del GAC (sin AMO): TMSL refresh es DML y funciona aunque el motor DDL falle (issue #30).
# Sale con exit 0 en exito, exit 1 en fallo (SQL Agent lo usa para el flujo de alertas Teams).
# Deploy: copiar a C:\Scripts\Process_SSAS.ps1 en el servidor (via scripts/deploy/deploy_process_ssas_job.ps1).

$ErrorActionPreference = "Stop"
$dbName = "Compras_EPSA"
$started = Get-Date

try {
    $gac = "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_14.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"
    Add-Type -Path $gac

    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383")
    $conn.Open()

    $cmd = $conn.CreateCommand()
    $cmd.CommandTimeout = 7200
    $cmd.CommandText = @"
{
  "refresh": {
    "type": "full",
    "objects": [
      { "database": "$dbName" }
    ]
  }
}
"@
    # TMSL refresh no devuelve rowset: ExecuteNonQuery (ExecuteReader falla con
    # "The result set returned by the server is not a rowset"). Lanza excepcion si hay error.
    $cmd.ExecuteNonQuery() | Out-Null
    $conn.Close()

    # Verificacion: max fecha de consumo servida por el modelo debe estar a <= 2 dias de hoy
    $conn2 = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=$dbName")
    $conn2.Open()
    $cmd2 = $conn2.CreateCommand()
    $cmd2.CommandText = "EVALUATE ROW(""MaxFact"", MAX(factConsumoHistoria[Consumo Fecha]))"
    $r2 = $cmd2.ExecuteReader()
    $maxFact = $null
    if ($r2.Read()) { $maxFact = [datetime]$r2[0] }
    $r2.Close()
    $conn2.Close()

    $ageDays = ((Get-Date) - $maxFact).Days
    if ($ageDays -gt 2) {
        Write-Error "Process terminado pero el modelo sigue atrasado: max consumo = $maxFact ($ageDays dias). Revisar staging."
        exit 1
    }

    $elapsed = [math]::Round(((Get-Date) - $started).TotalMinutes, 1)
    Write-Output "OK: $dbName procesado en $elapsed min. Max consumo = $($maxFact.ToString('dd/MM/yyyy'))"
    exit 0
} catch {
    Write-Error "Process_SSAS fallo: $($_.Exception.Message)"
    exit 1
}
