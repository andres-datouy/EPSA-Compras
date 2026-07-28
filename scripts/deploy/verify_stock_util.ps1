$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $t = $db.Model.Tables | Where-Object { $_.Name -eq "Medidas_Stock" }
    $m = $t.Measures | Where-Object { $_.Name -eq "Stock Util E+C-CP-CD" }
    if ($m) {
        Write-Output "FOUND: $($m.Name)"
        Write-Output "Expression: $($m.Expression)"
    } else {
        Write-Output "NOT FOUND in Medidas_Stock"
        # Also check all tables
        foreach ($tbl in $db.Model.Tables) {
            $found = $tbl.Measures | Where-Object { $_.Name -eq "Stock Util E+C-CP-CD" }
            if ($found) { Write-Output "FOUND in table: $($tbl.Name)" }
        }
    }
    $ssas.Disconnect()
}
