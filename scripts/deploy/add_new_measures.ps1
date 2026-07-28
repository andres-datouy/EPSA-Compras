# Add new measures [A Pedir Txt] and [Meses Cobertura] via AMO
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    # Find Medidas_Consumo table (where A Pedir Sugerido lives)
    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }
    if (-not $table) { $output += "ERROR: Medidas_Consumo table not found"; $ssas.Disconnect(); return $output }

    # --- Meses Cobertura ---
    $existingMC = $table.Measures | Where-Object { $_.Name -eq "Meses Cobertura" }
    if (-not $existingMC) {
        $mc = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $mc.Name = "Meses Cobertura"
        $mc.Expression = "DIVIDE ( [Stock Mínimo], [Consumo Promedio por Mes Activo] )"
        $mc.FormatString = "#,0.00"
        $mc.Description = "Cuántos meses de consumo cubre el stock mínimo configurado. Stock Mínimo / Consumo Promedio por Mes Activo. Permite validar si el SM es adecuado respecto al Lead Time"
        $table.Measures.Add($mc)
        $output += "ADDED: [Meses Cobertura]"
    } else {
        $output += "EXISTS: [Meses Cobertura]"
    }

    # --- A Pedir Txt ---
    $existingAPT = $table.Measures | Where-Object { $_.Name -eq "A Pedir Txt" }
    if (-not $existingAPT) {
        $apt = New-Object Microsoft.AnalysisServices.Tabular.Measure
        $apt.Name = "A Pedir Txt"
        $apt.Expression = @'
VAR E = [Stock Existencia]
VAR SP = [Stock Compras]
VAR CP = [Consumo Planificado Cantidad]
VAR CDP = [Cantidad Requerida por Demanda Pendiente]
VAR SM = [Stock Mínimo]
RETURN
"AP = " & FORMAT(E, "#,0") & "e + " & FORMAT(SP, "#,0") & "sp - (" & FORMAT(CP, "#,0") & "cp + " & FORMAT(CDP, "#,0") & "cdp) - " & FORMAT(SM, "#,0") & "sm"
'@
        $apt.Description = "Representación textual del cálculo de A Pedir: muestra cada operando con su sigla y valor para interpretación visual"
        $table.Measures.Add($apt)
        $output += "ADDED: [A Pedir Txt]"
    } else {
        $output += "EXISTS: [A Pedir Txt]"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"

    # Verify
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $t2 = $db2.Model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }
    $output += "Medidas_Consumo measures: $($t2.Measures.Count)"
    foreach ($m in $t2.Measures) {
        $output += "  [$($m.Name)] - $($m.DataType)"
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
