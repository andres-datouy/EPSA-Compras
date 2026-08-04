# Diagnostico de la via de consulta DAX en el server: aisla si el problema es
# el cliente ADOMD, la version del assembly, o el uso de EffectiveUserName.
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $out = @()
    $dax = 'EVALUATE ROW("Articulos", COUNTROWS(dimArticulo))'

    function Probar($etiqueta, $dllPath, $connStr) {
        $r = @("--- $etiqueta ---", "    cs: $connStr")
        try {
            Add-Type -Path $dllPath
            $asm = [Microsoft.AnalysisServices.AdomdClient.AdomdConnection].Assembly.GetName().Version
            $r += "    assembly cargado: $asm"
            $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($connStr)
            $conn.Open()
            $cmd = $conn.CreateCommand(); $cmd.CommandText = $dax
            $rd = $cmd.ExecuteReader()
            while ($rd.Read()) { $r += "    OK -> $($rd.GetName(0))=$($rd.GetValue(0))" }
            $rd.Close(); $conn.Close()
        } catch {
            $ex = $_.Exception
            $r += "    FALLO: $($ex.GetType().Name): $($ex.Message)"
            $inner = $ex.InnerException
            $nivel = 1
            while ($inner) { $r += "    inner[$nivel]: $($inner.GetType().Name): $($inner.Message)"; $inner = $inner.InnerException; $nivel++ }
        }
        return $r
    }

    # El GAC tiene la version instalada real (14.0.6.482); ADOMD 17.0 solo existe
    # en el Update Cache del instalador, no hay una instalacion propiamente dicha.
    $gac = "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient\v4.0_14.0.0.0__89845dcd8080cc91\Microsoft.AnalysisServices.AdomdClient.dll"

    # 1) ADOMD del GAC, conexion normal (como el propio schaaf_ssas, admin)
    $out += Probar "1) GAC 14.0, sin EffectiveUserName" $gac "Data Source=localhost:2383;Catalog=Compras_EPSA"

    # 2) Igual pero apuntando a la instancia con nombre en lugar del puerto
    $out += Probar "2) GAC 14.0, instancia con nombre" $gac "Data Source=EXLER-SERVER\SSAS;Catalog=Compras_EPSA"

    # 3) Con EffectiveUserName (autorizacion evaluada como la cuenta de lectura)
    $out += Probar "3) GAC 14.0, con EffectiveUserName" $gac "Data Source=localhost:2383;Catalog=Compras_EPSA;EffectiveUserName=EXLER-SERVER\bi_compras"

    return $out
}
Write-Host ($result -join "`n")
