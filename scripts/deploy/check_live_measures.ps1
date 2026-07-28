# Check what measures actually exist in Medidas_Compras on the live SSAS server
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" -ErrorAction SilentlyContinue | Where-Object { $_ -match "SSAS_PASS" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")

    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    if (-not $db) {
        $output += "ERROR: Database Compras_EPSA not found"
        $ssas.Disconnect()
        return $output
    }

    # Check Medidas_Compras table
    $tbl = $db.Model.Tables["Medidas_Compras"]
    if (-not $tbl) {
        $output += "ERROR: Table Medidas_Compras not found"
        $ssas.Disconnect()
        return $output
    }

    $output += "=== Medidas_Compras measures ($($tbl.Measures.Count) total) ==="
    foreach ($m in $tbl.Measures) {
        $output += "  $($m.Name)"
    }

    # Specifically check for the two measures
    $output += ""
    $output += "=== Checking specific measures ==="
    $m1 = $tbl.Measures | Where-Object { $_.Name -eq "Meses Cobertura del Stock Minimo" }
    $m2 = $tbl.Measures | Where-Object { $_.Name -eq "Cobertura sobre Stock Minimo vs Lead Time" }
    if ($m1) { $output += "FOUND: Meses Cobertura del Stock Minimo" } else { $output += "MISSING: Meses Cobertura del Stock Minimo" }
    if ($m2) { $output += "FOUND: Cobertura sobre Stock Minimo vs Lead Time" } else { $output += "MISSING: Cobertura sobre Stock Minimo vs Lead Time" }

    # Check all tables for these measures
    if (-not $m1 -or -not $m2) {
        $output += ""
        $output += "=== Searching all tables ==="
        foreach ($t in $db.Model.Tables) {
            foreach ($m in $t.Measures) {
                if ($m.Name -like "*Cobertura*" -or $m.Name -like "*Lead Time*") {
                    $output += "  $($t.Name).$($m.Name)"
                }
            }
        }
    }

    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
