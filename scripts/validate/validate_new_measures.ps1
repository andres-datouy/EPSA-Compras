$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA;Integrated Security=SSPI")
    $conn.Open()

    $measures = @(
        "Gastado USD",
        "Gastado Exterior USD",
        "% Gastado Exterior",
        "Articulos Criticos",
        "Articulos en Riesgo",
        "Stock Muerto COUNT",
        "Lead Time CV",
        "On-Time %",
        "Stock Exceso Valor USD",
        "Articulos Sin Stock con Demanda"
    )

    foreach ($m in $measures) {
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "EVALUATE ROW(""Value"", [$m])"
        $cmd.CommandTimeout = 120
        try {
            $reader = $cmd.ExecuteReader()
            if ($reader.Read()) {
                $val = $reader[0]
                if ($val -is [double]) { $val = [math]::Round($val, 2) }
                Write-Output "$m = $val"
            } else {
                Write-Output "$m = NO DATA"
            }
            $reader.Close()
        } catch {
            $msg = $_.Exception.Message
            if ($msg.Length -gt 200) { $msg = $msg.Substring(0, 200) }
            Write-Output "$m = ERROR: $msg"
        }
    }

    $conn.Close()
}
