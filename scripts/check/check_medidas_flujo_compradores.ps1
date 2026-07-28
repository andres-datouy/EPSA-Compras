# Smoke test DAX de las 3 medidas nuevas del flujo Compradores (solo lectura)
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    $adomd = Get-ChildItem "C:\Program Files\Microsoft.NET\ADOMD.NET" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
    Add-Type -Path $adomd.FullName
    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:2383;Catalog=Compras_EPSA")
    $conn.Open()

    $dax = @"
EVALUATE
TOPN (
    10,
    ADDCOLUMNS (
        FILTER (
            VALUES ( dimArticulo[Artículo Código] ),
            [Consumo Promedio por Mes Activo] > 0
        ),
        "CobProyectado", [Cobertura Meses sobre Stock Proyectado],
        "CobUtil", [Cobertura Meses sobre Stock Util],
        "LTMeses", [Lead Time Meses],
        "Alerta", [Alerta Cobertura]
    ),
    [Cobertura Meses sobre Stock Util], ASC
)
"@
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $dax
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        $output += "{0} | Proy={1:N2} | Util={2:N2} | LT={3:N2} | {4}" -f $reader.GetValue(0), $reader.GetValue(1), $reader.GetValue(2), $reader.GetValue(3), $reader.GetValue(4)
    }
    $reader.Close()

    # Conteo de alertas
    $dax2 = @"
EVALUATE
SUMMARIZECOLUMNS (
    "PEDIR",    COUNTX ( FILTER ( VALUES ( dimArticulo[Artículo Código] ), [Alerta Cobertura] = "PEDIR" ), 1 ),
    "Atencion", COUNTX ( FILTER ( VALUES ( dimArticulo[Artículo Código] ), [Alerta Cobertura] = "Atencion" ), 1 ),
    "OK",       COUNTX ( FILTER ( VALUES ( dimArticulo[Artículo Código] ), [Alerta Cobertura] = "OK" ), 1 )
)
"@
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = $dax2
    $reader2 = $cmd2.ExecuteReader()
    while ($reader2.Read()) {
        $output += ""
        $output += "Alertas -> PEDIR: {0} | Atencion: {1} | OK: {2}" -f $reader2.GetValue(0), $reader2.GetValue(1), $reader2.GetValue(2)
    }
    $reader2.Close()
    $conn.Close()
    return $output
}
Write-Host ($result -join "`n")
