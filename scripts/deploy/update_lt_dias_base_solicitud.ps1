# Cambia la base de [Lead Time Dias] en factRecepcionesHistoria:
# antes  = RecepcionFecha - MIN(OC Fecha, Compra Fecha)          (columna Con Proveedor)
# ahora  = RecepcionFecha - MIN(SolicitudFecha, OC Fecha, Compra Fecha) (columna Interno Desde Solicitud)
# Decision del usuario 2026-08-24 al revisar la pagina Detalle Lead Time Recepciones (Issue #40):
# el reloj debe arrancar en la mejor fecha entre Solicitud, OC y Compra.
# Columna calculada => requiere refresh Full de la tabla para recalcular.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tbl = $model.Tables["factRecepcionesHistoria"]
    $col = $tbl.Columns["Lead Time Dias"]

    $newExpr = "`nVAR FechaInicio = factRecepcionesHistoria[Compra Fecha Inicio Proceso Interno Desde Solicitud]`nVAR FechaRecepcion = factRecepcionesHistoria[RecepcionFecha]`nRETURN`nIF(`n    NOT ISBLANK ( FechaInicio ) && NOT ISBLANK ( FechaRecepcion ),`n    DATEDIFF ( FechaInicio, FechaRecepcion, DAY )`n)`n"
    if ($col.Expression -ne $newExpr) {
        $col.Expression = $newExpr
        $output += "UPDATED: factRecepcionesHistoria[Lead Time Dias] -> base Interno Desde Solicitud"
    } else {
        $output += "SKIP: expresion ya actualizada"
    }

    $model.SaveChanges()
    $output += "Saved metadata changes."

    $tbl.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full, $null)
    $model.SaveChanges()
    $output += "Processing complete (recalc columna + refresh tabla)."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $col2 = $db2.Model.Tables["factRecepcionesHistoria"].Columns["Lead Time Dias"]
    $output += "VERIFY expr contiene 'Interno Desde Solicitud': $($col2.Expression -match 'Interno Desde Solicitud')"
    $output += "Partition state: $($db2.Model.Tables['factRecepcionesHistoria'].Partitions[0].State)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
