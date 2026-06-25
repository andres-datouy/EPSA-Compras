$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    # Check existing measure expressions
    $tables = @("Medidas_Stock", "Medidas_Compras", "Medidas_Consumo")
    foreach ($tName in $tables) {
        $t = $model.Tables.Find($tName)
        if ($t) {
            Write-Output "=== $tName ==="
            foreach ($m in $t.Measures) {
                Write-Output "  $($m.Name): $($m.Expression)"
            }
        }
    }

    # Check relationships involving factRecepcionesHistoria and dimProveedor
    Write-Output "`n=== RELATIONSHIPS ==="
    foreach ($r in $model.Relationships) {
        if ($r.FromTable.Name -in @("factRecepcionesHistoria","factConsumoHistoria","factStockEPSA") -or
            $r.ToTable.Name -in @("dimProveedor","dimArticulo")) {
            Write-Output "$($r.FromTable.Name)[$($r.FromColumn.Name)] -> $($r.ToTable.Name)[$($r.ToColumn.Name)]"
        }
    }

    $server.Disconnect()
}
