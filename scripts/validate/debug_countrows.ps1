$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA;Integrated Security=SSPI")
    $conn.Open()

    # Test simpler COUNTROWS patterns
    $tests = @(
        @("Count articles", "EVALUATE ROW(""Val"", COUNTROWS(VALUES(dimArticulo[Artículo Código])))"),
        @("Count critico with FILTER", "EVALUATE ROW(""Val"", COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Debajo Mínimo] = ""CRÍTICO"")))"),
        @("Count stock > 0", "EVALUATE ROW(""Val"", COUNTROWS(FILTER(VALUES(dimArticulo[Artículo Código]), [Stock Existencia] > 0)))"),
        @("Stock bajo minimo sample", "EVALUATE TOPN(3, SUMMARIZECOLUMNS(dimArticulo[Artículo Código], ""StockDeb"", [Stock Debajo Mínimo]), [StockDeb], ASC)")
    )

    foreach ($t in $tests) {
        $name = $t[0]
        $dax = $t[1]
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $dax
        $cmd.CommandTimeout = 120
        try {
            $reader = $cmd.ExecuteReader()
            $rows = 0
            while ($reader.Read()) {
                $vals = @()
                for ($i = 0; $i -lt $reader.FieldCount; $i++) { $vals += "$($reader[$i])" }
                Write-Output "${name}: $($vals -join ', ')"
                $rows++
            }
            if ($rows -eq 0) { Write-Output "${name}: NO ROWS" }
            $reader.Close()
        } catch {
            $msg = $_.Exception.Message
            if ($msg.Length -gt 400) { $msg = $msg.Substring(0, 400) }
            Write-Output "${name}: ERROR: $msg"
        }
    }

    $conn.Close()
}
