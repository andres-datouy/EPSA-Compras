# Fase 1 flujo Compradores - Agrega 3 medidas de cobertura/alerta a Medidas_Consumo
# 1. [Cobertura Meses sobre Stock Proyectado]  (E + C) / consumo mensual
# 2. [Cobertura Meses sobre Stock Util]        (E + C - CP - CD) / consumo mensual
# 3. [Alerta Cobertura]                        semaforo PEDIR / Atencion / OK vs Lead Time
# Idempotente. Buffer de seguridad = 1 mes (pendiente validar con Rosana si corresponde otro).
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $tbl = $db.Model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    $defs = @(
        @{
            Name = "Cobertura Meses sobre Stock Proyectado"
            Expression = "DIVIDE ( [Stock Proyectado], [Consumo Promedio por Mes Activo] )"
            Format = "#,0.00"
            Description = "Meses de cobertura considerando existencia mas compras en camino (Stock Proyectado / Consumo Promedio por Mes Activo). Responde: con lo que tengo y lo que viene, cuantos meses cubro."
        },
        @{
            Name = "Cobertura Meses sobre Stock Util"
            Expression = "DIVIDE ( [Stock Util E+C-CP-CD], [Consumo Promedio por Mes Activo] )"
            Format = "#,0.00"
            Description = "Meses de cobertura sobre el stock util neto de compromisos: existencia + compras en camino - consumo planificado en OP - demanda pendiente, dividido el consumo promedio mensual. Es la cobertura mas conservadora para decidir compras."
        },
        @{
            Name = "Alerta Cobertura"
            Expression = @"
VAR Cob = [Cobertura Meses sobre Stock Util]
VAR LT = [Lead Time Meses]
VAR MesesSeguridad = 1
RETURN
SWITCH (
    TRUE (),
    ISBLANK ( Cob ) || ISBLANK ( LT ), BLANK (),
    Cob < LT, "PEDIR",
    Cob < LT + MesesSeguridad, "Atencion",
    "OK"
)
"@
            Format = ""
            Description = "Semaforo de decision de compra: PEDIR si la cobertura util es menor al lead time; Atencion si es menor a lead time + 1 mes de seguridad; OK en el resto. Buffer de seguridad pendiente de validacion con Compradores."
        }
    )

    foreach ($d in $defs) {
        $existing = $tbl.Measures | Where-Object { $_.Name -eq $d.Name }
        if (-not $existing) {
            $m = New-Object Microsoft.AnalysisServices.Tabular.Measure
            $m.Name = $d.Name
            $m.Expression = $d.Expression
            if ($d.Format) { $m.FormatString = $d.Format }
            $m.Description = $d.Description
            $tbl.Measures.Add($m)
            $output += "ADDED: [$($d.Name)]"
        } else {
            $output += "SKIP (ya existe): [$($d.Name)]"
        }
    }

    $db.Model.SaveChanges()
    $output += "SaveChanges OK"

    # Verificacion
    $ssas.Refresh()
    $db2 = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $t2 = $db2.Model.Tables["Medidas_Consumo"]
    $output += ""
    $output += "Medidas_Consumo ahora tiene $($t2.Measures.Count) medidas"
    $ssas.Disconnect()
    return $output
}
Write-Host ($result -join "`n") -ForegroundColor White
