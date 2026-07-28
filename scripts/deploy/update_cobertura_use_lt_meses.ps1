# Update [Cobertura vs Lead Time] to use [Lead Time Meses]
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $table = $model.Tables | Where-Object { $_.Name -eq "Medidas_Consumo" }

    $cvlt = $table.Measures | Where-Object { $_.Name -eq "Cobertura vs Lead Time" }
    if ($cvlt) {
        $cvlt.Expression = "[Meses Cobertura] - [Lead Time Meses]"
        $model.SaveChanges()
        Write-Output "UPDATED: [Cobertura vs Lead Time] = [Meses Cobertura] - [Lead Time Meses]"
    } else {
        Write-Output "MISSING: [Cobertura vs Lead Time]"
    }
    $ssas.Disconnect()
}

Write-Host ($result -join "`n") -ForegroundColor White
