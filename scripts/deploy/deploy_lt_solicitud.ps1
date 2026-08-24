# Redefine [Lead Time Promedio Dias] to base Solicitud (Issue #38 / pedido Rosana 2026-08-19).
# Alcance: solo medidas. La columna [Lead Time Dias] y [On Time Delivery %] quedan base OC.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("localhost:2383")
    $db = $server.Databases.FindByName("Compras_EPSA")
    $model = $db.Model

    $table = $model.Tables.Find("Medidas_Compras")
    $m = $table.Measures.Find("Lead Time Promedio Dias")
    if (-not $m) { throw "Measure [Lead Time Promedio Dias] not found in Medidas_Compras" }

    $oldExpr = $m.Expression
    $m.Expression = "[Lead Time Proceso Interno Dias]"
    $m.Description = "Promedio de dias desde la solicitud interna (MIN solicitud, OC, compra) hasta la recepcion. Redefinido 2026-08-19 a pedido de Rosana para incluir el proceso interno; base anterior: MIN(OC Fecha, Compra Fecha). Equivale a [Lead Time Proceso Interno Dias]; alimenta [Lead Time Meses] y las coberturas. [On Time Delivery %] sigue usando la columna [Lead Time Dias] base OC."

    $db.Model.SaveChanges()
    Write-Output "UPDATED: Lead Time Promedio Dias"
    Write-Output "OLD: $oldExpr"
    Write-Output "NEW: $($m.Expression)"

    $server.Disconnect()
}
