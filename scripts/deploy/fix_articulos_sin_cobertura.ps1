# Fix Articulos Sin Cobertura Suficiente measure - correct column name with accents

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $model = $db.Model
    $tblStock = $model.Tables | Where-Object { $_.Name -eq "Medidas_Stock" }

    $m = $tblStock.Measures | Where-Object { $_.Name -eq "Articulos Sin Cobertura Suficiente" }
    if ($m) {
        $m.Expression = @"
VAR LTMeses = [Lead Time Meses]
RETURN
COUNTX(
    FILTER(
        VALUES(dimArticulo[Artículo Código]),
        [Dias Cobertura Necesidad] < LTMeses * 30
    ),
    dimArticulo[Artículo Código]
)
"@
        $output += "FIXED: [Articulos Sin Cobertura Suficiente] - now uses dimArticulo[Artículo Código]"
    } else {
        $output += "SKIP: measure not found"
    }

    $model.SaveChanges()
    $output += "SaveChanges OK"
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
