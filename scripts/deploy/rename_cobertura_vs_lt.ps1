# Rename [Cobertura vs Lead Time] -> [Cobertura sobre Stock Minimo vs Lead Time]
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    $m = $table.Measures | Where-Object { $_.Name -eq "Cobertura vs Lead Time" }
    if ($m) {
        $m.Name = "Cobertura sobre Stock Minimo vs Lead Time"
        Write-Output "RENAMED: [Cobertura vs Lead Time] -> [Cobertura sobre Stock Minimo vs Lead Time]"
    } else {
        Write-Output "NOT FOUND: [Cobertura vs Lead Time]"
    }

    $model.SaveChanges()
    Write-Output "SaveChanges OK"
    $ssas.Disconnect()
}

Write-Host ($result -join "`n") -ForegroundColor White
