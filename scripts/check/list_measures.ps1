$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    # List all measures
    Write-Output "=== MEASURES ==="
    foreach ($t in $model.Tables) {
        foreach ($m in $t.Measures) {
            Write-Output "$($t.Name)~$($m.Name)~$($m.Expression)"
        }
    }

    # List columns in factRecepcionesHistoria
    Write-Output "`n=== factRecepcionesHistoria columns ==="
    $t = $model.Tables.Find("factRecepcionesHistoria")
    if ($t) { foreach ($c in $t.Columns) { Write-Output "$($c.Name) ($($c.DataType))" } }

    # List columns in factStockEPSA
    Write-Output "`n=== factStockEPSA columns ==="
    $t = $model.Tables.Find("factStockEPSA")
    if ($t) { foreach ($c in $t.Columns) { Write-Output "$($c.Name) ($($c.DataType))" } }

    # List columns in factConsumoHistoria
    Write-Output "`n=== factConsumoHistoria columns ==="
    $t = $model.Tables.Find("factConsumoHistoria")
    if ($t) { foreach ($c in $t.Columns) { Write-Output "$($c.Name) ($($c.DataType))" } }

    # List columns in dimProveedor
    Write-Output "`n=== dimProveedor columns ==="
    $t = $model.Tables.Find("dimProveedor")
    if ($t) { foreach ($c in $t.Columns) { Write-Output "$($c.Name) ($($c.DataType))" } }

    $server.Disconnect()
}
