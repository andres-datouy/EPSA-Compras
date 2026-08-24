# Redefine [Lead Time Proceso Interno Dias] como PEOR CASO (Issue #38 / pedido usuario 2026-08-19).
# MAXX en vez de AVERAGEX; sin filtro de proveedor (REMOVEFILTERS dimProveedor);
# excluye OC Proveedor = "EXLER"; respeta slicer de fecha; incluye empresa EXLER si esta en el contexto.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    $table = $model.Tables.Find("Medidas_Compras")
    $m = $table.Measures.Find("Lead Time Proceso Interno Dias")
    if (-not $m) { throw "Measure [Lead Time Proceso Interno Dias] not found in Medidas_Compras" }

    $newExpr = @'
VAR t =
    CALCULATETABLE (
        factRecepcionesHistoria,
        REMOVEFILTERS ( dimProveedor ),
        factRecepcionesHistoria[OC Proveedor] <> "EXLER"
    )
RETURN
    MAXX (
        t,
        VAR FechaInicio = factRecepcionesHistoria[Compra Fecha Inicio Proceso Interno Desde Solicitud]
        VAR FechaRecepcion = factRecepcionesHistoria[RecepcionFecha]
        RETURN
            IF (
                NOT ISBLANK ( FechaInicio ) && NOT ISBLANK ( FechaRecepcion ),
                DATEDIFF ( FechaInicio, FechaRecepcion, DAY )
            )
    ) + 0
'@

    $oldExpr = $m.Expression
    $m.Expression = $newExpr
    $m.Description = "Peor caso (maximo) de dias desde el inicio del proceso (MIN solicitud, OC, compra) hasta la recepcion, por articulo. Considera todos los proveedores (REMOVEFILTERS dimProveedor, por consolidadores como Giesser/Mercurius) y excluye OC Proveedor = EXLER. Respeta el slicer de fecha. Redefinido 2026-08-19 a pedido del usuario; antes AVERAGEX. Alimenta [Lead Time Promedio Dias], [Lead Time Meses] y las coberturas."

    $m2 = $table.Measures.Find("Lead Time Promedio Dias")
    if ($m2) {
        $m2.Description = "Lead time de planificacion PEOR CASO (la compra mas demorada del articulo, todos los proveedores excepto EXLER), en dias. Equivale a [Lead Time Proceso Interno Dias]; alimenta [Lead Time Meses] y las coberturas. Redefinido 2026-08-19: antes promedio, ahora maximo. [On Time Delivery %] sigue usando la columna [Lead Time Dias] base OC."
    }

    $db.Model.SaveChanges()
    Write-Output "UPDATED: Lead Time Proceso Interno Dias (+ descripcion de Lead Time Promedio Dias)"
    Write-Output "OLD: $oldExpr"
    Write-Output "NEW: $($m.Expression)"

    $server.Disconnect()
}
