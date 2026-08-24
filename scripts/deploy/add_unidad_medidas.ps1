# Agrega 3 medidas de texto "c/ Unidad" que muestran el valor formateado junto al
# simbolo de la unidad de stock del articulo (dimArticulo[Unidad Stock]):
#   Medidas_Stock[Stock Existencia c/ Unidad]
#   Medidas_Stock[Stock Compras c/ Unidad]
#   Medidas_Consumo[Sumatoria Movs Consumo c/ Unidad]
# Motivo: pedido del usuario (2026-08-24) para el tooltip TT Detalle Articulo.
# Solo metadata (medidas calculadas): SaveChanges, sin refresh de datos.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $exprUnidad = @'
VAR v = {0}
VAR u = SELECTEDVALUE ( dimArticulo[Unidad Stock] )
RETURN FORMAT ( v, "#,0.00" ) & IF ( ISBLANK ( u ), "", " " & u )
'@

    $defs = @(
        @{ Table = "Medidas_Stock";     Name = "Stock Existencia c/ Unidad";         Base = "[Stock Existencia]";                          Desc = "Stock de existencia formateado junto al simbolo de la unidad de stock del articulo (ej. 9.294,00 KG). Pedido usuario 2026-08-24" },
        @{ Table = "Medidas_Stock";     Name = "Stock Compras c/ Unidad";            Base = "[Stock Compras]";                             Desc = "Stock en proceso de compra formateado junto al simbolo de la unidad de stock del articulo (ej. 10.000,00 KG). Pedido usuario 2026-08-24" },
        @{ Table = "Medidas_Consumo";   Name = "Sumatoria Movs Consumo c/ Unidad";   Base = "[Sumatoria Movs Consumo Sin Recepciones]";    Desc = "Consumo del periodo formateado junto al simbolo de la unidad de stock del articulo (ej. 13,07 KG). Pedido usuario 2026-08-24" }
    )

    foreach ($d in $defs) {
        $tbl = $model.Tables[$d.Table]
        $existing = $tbl.Measures | Where-Object { $_.Name -eq $d.Name }
        if ($existing) {
            $output += "SKIP: $($d.Table)[$($d.Name)] ya existe"
            continue
        }
        $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m.Name = $d.Name
        $m.Expression = ($exprUnidad -replace '\{0\}', $d.Base)
        $m.Description = $d.Desc
        $m.DataType = [Microsoft.AnalysisServices.Tabular.DataType]::String
        $tbl.Measures.Add($m)
        $output += "ADDED: $($d.Table)[$($d.Name)]"
    }

    $model.SaveChanges()
    $output += "Saved metadata changes."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    foreach ($d in $defs) {
        $m2 = $db2.Model.Tables[$d.Table].Measures | Where-Object { $_.Name -eq $d.Name }
        if ($m2) { $output += "VERIFY: $($d.Table)[$($d.Name)] presente, DataType=$($m2.DataType)" }
        else { $output += "VERIFY FAILED: $($d.Table)[$($d.Name)] NO presente" }
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
