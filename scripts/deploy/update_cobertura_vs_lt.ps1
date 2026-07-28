# Update [Cobertura vs Lead Time] to use [Meses Cobertura] measure
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model

    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    # Verify Meses Cobertura exists
    $mc = $table.Measures | Where-Object { $_.Name -eq "Meses Cobertura" }
    if ($mc) {
        $output += "FOUND: [Meses Cobertura] = $($mc.Expression)"
    } else {
        $output += "MISSING: [Meses Cobertura]"
        $ssas.Disconnect(); return $output
    }

    # Update Cobertura vs Lead Time to reference [Meses Cobertura]
    $cvlt = $table.Measures | Where-Object { $_.Name -eq "Cobertura vs Lead Time" }
    if ($cvlt) {
        $cvlt.Expression = @"
VAR LT_Meses = DIVIDE ( [Lead Time Promedio Dias], 30, 0 )
RETURN
[Meses Cobertura] - LT_Meses
"@
        $output += "UPDATED: [Cobertura vs Lead Time] now uses [Meses Cobertura]"
    } else {
        $output += "MISSING: [Cobertura vs Lead Time]"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
