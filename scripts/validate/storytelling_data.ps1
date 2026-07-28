$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA;Integrated Security=SSPI")
    $conn.Open()

    $queries = @{
        "Spend by Year" = 'EVALUATE SUMMARIZECOLUMNS(Calendario[Año Fiscal], "Gastado_USD", [Gastado USD], "Gastado_MO", [Gastado MO]) ORDER BY Calendario[Año Fiscal]'
        "Spend by Country Top10" = 'EVALUATE TOPN(10, SUMMARIZECOLUMNS(dimProveedor[País Nombre], "Gastado_USD", [Gastado USD]), [Gastado_USD], DESC)'
        "Top 10 Articles by Spend" = 'EVALUATE TOPN(10, SUMMARIZECOLUMNS(dimArticulo[Artículo Código], dimArticulo[Artículo Nombre], "Gastado_USD", [Gastado USD]), [Gastado_USD], DESC)'
        "Spend by Class Top10" = 'EVALUATE TOPN(10, SUMMARIZECOLUMNS(dimArticulo[Clase Nombre], "Gastado_USD", [Gastado USD]), [Gastado_USD], DESC)'
        "Lead Time by Country" = 'EVALUATE SUMMARIZECOLUMNS(dimProveedor[País Nombre], "LeadTime_Dias", [Lead Time Promedio Dias], "Recepciones", [Cantidad Recepciones]) ORDER BY [Recepciones] DESC'
        "Active Suppliers by Year" = 'EVALUATE SUMMARIZECOLUMNS(Calendario[Año Fiscal], "Proveedores", COUNTROWS(SUMMARIZE(factRecepcionesHistoria, factRecepcionesHistoria[OC Proveedor]))) ORDER BY Calendario[Año Fiscal]'
        "Consumption by Year" = 'EVALUATE SUMMARIZECOLUMNS(Calendario[Año Fiscal], "Consumo", [Consumo Cantidad Absoluta]) ORDER BY Calendario[Año Fiscal]'
        "Recepciones Count" = 'EVALUATE ROW("Total", [Cantidad Recepciones])'
    }

    foreach ($name in $queries.Keys) {
        Write-Output "=== $name ==="
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $queries[$name]
        $cmd.CommandTimeout = 120
        try {
            $reader = $cmd.ExecuteReader()
            $headers = @()
            for ($i = 0; $i -lt $reader.FieldCount; $i++) { $headers += $reader.GetName($i) }
            Write-Output ($headers -join "`t")
            while ($reader.Read()) {
                $vals = @()
                for ($i = 0; $i -lt $reader.FieldCount; $i++) {
                    $v = $reader[$i]
                    if ($v -is [double]) { $v = [math]::Round($v, 2) }
                    $vals += "$v"
                }
                Write-Output ($vals -join "`t")
            }
            $reader.Close()
        } catch {
            $msg = $_.Exception.Message
            if ($msg.Length -gt 200) { $msg = $msg.Substring(0, 200) }
            Write-Output "ERROR: $msg"
        }
        Write-Output ""
    }

    $conn.Close()
}
