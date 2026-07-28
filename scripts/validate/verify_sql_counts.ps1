# Compare SSAS vs SQL row counts
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
SELECT 'stg_factConsumo' as tbl, COUNT(*) as cnt FROM stg_factConsumo
UNION ALL SELECT 'stg_dimArticulo', COUNT(*) FROM stg_dimArticulo
UNION ALL SELECT 'stg_factStockEPSA', COUNT(*) FROM stg_factStockEPSA
UNION ALL SELECT 'stg_factConsumoPlanificado', COUNT(*) FROM stg_factConsumoPlanificado
UNION ALL SELECT 'stg_factDemandaPendiente', COUNT(*) FROM stg_factDemandaPendiente
UNION ALL SELECT 'stg_factRecepcionesHistoria', COUNT(*) FROM stg_factRecepcionesHistoria
UNION ALL SELECT 'stg_dimProveedor', COUNT(*) FROM stg_dimProveedor
UNION ALL SELECT 'stg_factComprasEnProceso', COUNT(*) FROM stg_factComprasEnProceso
ORDER BY tbl
"@
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        Write-Output "  $($reader['tbl']): $($reader['cnt']) rows"
    }
    $reader.Close()
    $conn.Close()
}

Write-Host "=== SQL Source Row Counts ===" -ForegroundColor Cyan
$result | ForEach-Object { Write-Host $_ }
