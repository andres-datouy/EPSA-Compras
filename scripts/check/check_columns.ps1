$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    $tables = @("factRecepcionesHistoria", "dimProveedor", "dimArticulo", "factConsumoHistoria", "Medidas_Stock", "Medidas_Compras")
    foreach ($tName in $tables) {
        $t = $model.Tables.Find($tName)
        if ($t) {
            Write-Output "=== $tName ==="
            foreach ($c in $t.Columns) { Write-Output "  COL: $($c.Name) ($($c.DataType))" }
            foreach ($m in $t.Measures) { Write-Output "  MSR: $($m.Name)" }
        } else {
            Write-Output "=== $tName === NOT FOUND"
        }
    }

    $server.Disconnect()
}
