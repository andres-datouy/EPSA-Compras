# Inspecciona (solo lectura) la tabla dimArticulo en el modelo SSAS vivo:
# columnas actuales + definicion de la particion
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $tbl = $db.Model.Tables | Where-Object { $_.Name -eq "dimArticulo" }

    $output += "=== COLUMNAS dimArticulo ==="
    foreach ($c in $tbl.Columns) {
        $output += ("{0} | {1} | source={2}" -f $c.Name, $c.DataType, $c.SourceColumn)
    }

    $output += ""
    $output += "=== PARTICIONES ==="
    foreach ($p in $tbl.Partitions) {
        $output += ("Nombre: {0} | Mode: {1} | SourceType: {2}" -f $p.Name, $p.Mode, $p.Source.GetType().Name)
        if ($p.Source -is [Microsoft.AnalysisServices.Tabular.QueryPartitionSource]) {
            $output += "Query:"
            $output += $p.Source.Query
        } elseif ($p.Source -is [Microsoft.AnalysisServices.Tabular.MPartitionSource]) {
            $output += "Expression M:"
            $output += $p.Source.Expression
        }
    }
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n")
