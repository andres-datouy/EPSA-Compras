# Rename [Meses Cobertura] -> [Meses Cobertura del Stock Minimo] in SSAS
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    $m = $table.Measures | Where-Object { $_.Name -eq "Meses Cobertura" }
    if ($m) {
        $m.Name = "Meses Cobertura del Stock Minimo"
        $output += "RENAMED: [Meses Cobertura] -> [Meses Cobertura del Stock Minimo]"
    } else {
        $output += "NOT FOUND: [Meses Cobertura] (may already be renamed)"
    }

    # Update Cobertura vs Lead Time to reference new name
    $cvlt = $table.Measures | Where-Object { $_.Name -eq "Cobertura vs Lead Time" }
    if ($cvlt) {
        $cvlt.Expression = "[Meses Cobertura del Stock Minimo] - [Lead Time Meses]"
        $output += "UPDATED: [Cobertura vs Lead Time] expression"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
