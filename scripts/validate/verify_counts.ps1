# Verify row counts via ADOMD connection with MSOLAP provider
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $tables = @("factConsumoHistoria","dimArticulo","factStockEPSA","factConsumoPlanificado","factDemandaPendientePlanificacion","factRecepcionesHistoria","dimProveedor","factComprasEnProceso")
    
    Write-Output "=== DAX Row Counts ==="
    foreach ($t in $tables) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "EVALUATE ROW(""c"", COUNTROWS('$t'))"
            $r = $cmd.ExecuteReader()
            if ($r.Read()) {
                Write-Output "  $t`: $($r[0]) rows"
            }
            $r.Close()
        } catch {
            Write-Output "  $t`: ERROR - $_"
        }
    }
    
    $conn.Close()
}

$result | ForEach-Object { Write-Host $_ }
