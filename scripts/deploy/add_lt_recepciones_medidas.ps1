# Agrega 3 medidas de resumen de Lead Time REAL (base recepciones, columna OC [Lead Time Dias])
# para la pagina "Detalle Lead Time Recepciones":
#   Medidas_Compras[Lead Time Promedio Dias Recepciones]      (AVERAGEX de la columna)
#   Medidas_Compras[Lead Time Promedio Dias Recepciones P90]  (percentil 90)
#   Medidas_Compras[Lead Time Meses Recepciones]              (dias/30)
# No toca la cadena de planificacion peor-caso ([Lead Time Proceso Interno Dias] / [Lead Time Promedio Dias]).
# Motivo: pedido del usuario (2026-08-24). Solo metadata: SaveChanges, sin refresh de datos.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $defs = @(
        @{ Name = "Lead Time Promedio Dias Recepciones";
           Expr = "AVERAGEX ( factRecepcionesHistoria, factRecepcionesHistoria[Lead Time Dias] ) + 0";
           Fmt  = "0";
           Desc = "Promedio real de dias de lead time de las recepciones en contexto (columna [Lead Time Dias] = RecepcionFecha - MIN(OC Fecha, Compra Fecha)). Respeta filtros de proveedor y fecha. Pagina Detalle Lead Time Recepciones. Pedido usuario 2026-08-24" },
        @{ Name = "Lead Time Promedio Dias Recepciones P90";
           Expr = "VAR p = PERCENTILEX.INC ( factRecepcionesHistoria, factRecepcionesHistoria[Lead Time Dias], 0.9 )`nRETURN IF ( ISBLANK ( p ), 0, CONVERT ( p, DOUBLE ) )";
           Fmt  = "0";
           Desc = "Percentil 90 de los dias de lead time de las recepciones en contexto. Lectura de la cola (casos lentos) sin el extremo maximo. CONVERT a DOUBLE porque este build de SSAS no soporta DOUBLE() como funcion. Pagina Detalle Lead Time Recepciones. Pedido usuario 2026-08-24" },
        @{ Name = "Lead Time Meses Recepciones";
           Expr = "DIVIDE ( [Lead Time Promedio Dias Recepciones], 30, 0 )";
           Fmt  = "#,0.00";
           Desc = "Promedio real de lead time de las recepciones expresado en meses (dias / 30). Pagina Detalle Lead Time Recepciones. Pedido usuario 2026-08-24" }
    )

    $tbl = $model.Tables["Medidas_Compras"]
    foreach ($d in $defs) {
        $existing = $tbl.Measures | Where-Object { $_.Name -eq $d.Name }
        if ($existing) {
            if ($existing.Expression -ne $d.Expr -or $existing.FormatString -ne $d.Fmt) {
                $existing.Expression = $d.Expr
                $existing.FormatString = $d.Fmt
                $existing.Description = $d.Desc
                $output += "UPDATED: Medidas_Compras[$($d.Name)]"
            } else {
                $output += "SKIP: Medidas_Compras[$($d.Name)] ya existe"
            }
            continue
        }
        $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $m.Name = $d.Name
        $m.Expression = $d.Expr
        $m.FormatString = $d.Fmt
        $m.Description = $d.Desc
        $tbl.Measures.Add($m)
        $output += "ADDED: Medidas_Compras[$($d.Name)]"
    }

    $model.SaveChanges()
    $output += "Saved metadata changes."

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    foreach ($d in $defs) {
        $m2 = $db2.Model.Tables["Medidas_Compras"].Measures | Where-Object { $_.Name -eq $d.Name }
        if ($m2) { $output += "VERIFY: Medidas_Compras[$($d.Name)] presente, DataType=$($m2.DataType), Format=$($m2.FormatString)" }
        else { $output += "VERIFY FAILED: Medidas_Compras[$($d.Name)] NO presente" }
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
