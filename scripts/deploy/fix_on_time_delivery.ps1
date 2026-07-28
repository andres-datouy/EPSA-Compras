# Fix On Time Delivery measure to use RELATED(dimArticulo[plazo])

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tblCompras = $model.Tables | Where-Object { $_.Name -eq "Medidas_Compras" }

    $m = $tblCompras.Measures | Where-Object { $_.Name -eq "On Time Delivery %" }
    if ($m) {
        $m.Expression = @"
VAR TotalRecep = COUNTROWS(factRecepcionesHistoria)
VAR OnTime =
    COUNTROWS(
        FILTER(
            factRecepcionesHistoria,
            NOT ISBLANK(factRecepcionesHistoria[Lead Time Dias]) &&
            NOT ISBLANK(RELATED(dimArticulo[plazo])) &&
            factRecepcionesHistoria[Lead Time Dias] <= RELATED(dimArticulo[plazo])
        )
    )
RETURN
DIVIDE(OnTime, TotalRecep)
"@
        $output += "FIXED: [On Time Delivery %] - now uses RELATED(dimArticulo[plazo])"
    } else {
        $output += "SKIP: measure not found"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
