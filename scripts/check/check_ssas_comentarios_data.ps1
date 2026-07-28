# Valida datos de Comentarios en SSAS vs staging (solo lectura)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$ssasResult = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()

    $dax = @"
EVALUATE
ROW(
    "TotalArticulos", COUNTROWS(dimArticulo),
    "ConComentarios", COUNTROWS(FILTER(dimArticulo, NOT ISBLANK(dimArticulo[Comentarios]) && TRIM(dimArticulo[Comentarios]) <> ""))
)
"@

    # Usar ADOMD para query DAX
    $adomdPath = Get-ChildItem "C:\Program Files\Microsoft.NET\ADOMD.NET" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $adomdPath) {
        $adomdPath = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
    }
    Add-Type -Path $adomdPath.FullName
    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=Compras_EPSA")
    $conn.Open()
    $acmd = $conn.CreateCommand()
    $acmd.CommandText = $dax
    $reader = $acmd.ExecuteReader()
    while ($reader.Read()) {
        $output += ("SSAS dimArticulo -> Total: {0} | Con Comentarios: {1}" -f $reader.GetValue(0), $reader.GetValue(1))
    }
    $reader.Close()

    # Muestra de 3 comentarios
    $acmd.CommandText = @"
EVALUATE
SELECTCOLUMNS(
    TOPN(3, FILTER(dimArticulo, NOT ISBLANK(dimArticulo[Comentarios]) && TRIM(dimArticulo[Comentarios]) <> ""), dimArticulo[Artículo Código], ASC),
    "Codigo", dimArticulo[Artículo Código],
    "Comentario", LEFT(dimArticulo[Comentarios], 70)
)
"@
    $reader = $acmd.ExecuteReader()
    while ($reader.Read()) {
        $output += ("  {0} | {1}" -f $reader.GetValue(0), $reader.GetValue(1))
    }
    $reader.Close()
    $conn.Close()
    return $output
}

Write-Host ($ssasResult -join "`n") -ForegroundColor White
Write-Host "`nEsperado desde staging: Total 3369 | Con Comentarios 88" -ForegroundColor Yellow
