# Quick DAX verification of measures
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $queries = @(
        @{ Name = "Stock Existencia"; Dax = "EVALUATE {[Stock Existencia]}" }
        @{ Name = "Stock Compras"; Dax = "EVALUATE {[Stock Compras]}" }
        @{ Name = "Stock Mínimo"; Dax = "EVALUATE {[Stock Mínimo]}" }
        @{ Name = "Consumos (count)"; Dax = "EVALUATE {[Consumos]}" }
        @{ Name = "Sumatoria Consumo"; Dax = "EVALUATE {[Sumatoria Movs Consumo Sin Recepciones]}" }
        @{ Name = "Calendario rows"; Dax = "EVALUATE ROW(""rows"", COUNTROWS(Calendario))" }
        @{ Name = "Cobertura Meses"; Dax = "EVALUATE {[Cobertura Meses sobre Existencia]}" }
    )
    
    foreach ($q in $queries) {
        try {
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = $q.Dax
            $r = $cmd.ExecuteReader()
            if ($r.Read()) {
                Write-Output "  $($q.Name): $($r[0])"
            }
            $r.Close()
        } catch {
            Write-Output "  $($q.Name): ERROR - $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
        }
    }
    
    $conn.Close()
}

Write-Host "=== DAX Measure Verification ===" -ForegroundColor Cyan
$result | ForEach-Object { Write-Host $_ }
