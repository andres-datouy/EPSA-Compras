$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA;Integrated Security=SSPI")
    $conn.Open()

    # Test simple measures that the failing ones depend on
    $tests = @(
        "EVALUATE ROW(""Val"", [Stock Existencia])",
        "EVALUATE ROW(""Val"", [Stock Mínimo])",
        "EVALUATE ROW(""Val"", [Gap Stock])",
        "EVALUATE ROW(""Val"", [Stock Debajo Mínimo])",
        "EVALUATE ROW(""Val"", [Consumo Promedio por Mes Activo])",
        "EVALUATE ROW(""Val"", [Lead Time Promedio Dias])",
        "EVALUATE ROW(""Val"", [Cantidad Requerida por Demanda Pendiente])"
    )

    foreach ($dax in $tests) {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $dax
        $cmd.CommandTimeout = 60
        try {
            $reader = $cmd.ExecuteReader()
            if ($reader.Read()) {
                $val = $reader[0]
                if ($val -is [double]) { $val = [math]::Round($val, 2) }
                Write-Output "$dax => $val"
            }
            $reader.Close()
        } catch {
            $msg = $_.Exception.Message
            if ($msg.Length -gt 300) { $msg = $msg.Substring(0, 300) }
            Write-Output "$dax => ERROR: $msg"
        }
    }

    $conn.Close()
}
