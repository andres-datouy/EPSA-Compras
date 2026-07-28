# Prueba credenciales app_compras via WinRM (SQL solo accesible desde el servidor)
$e = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=',2)[1]
$sqlPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=',2)[1]
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($p1, $p2)
    $out = @()
    foreach ($c in @(@("SQL_PASSWORD", $p1), @("SSAS_PASSWORD(legacy)", $p2))) {
        $name, $pwd = $c
        try {
            $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$pwd;Connect Timeout=8")
            $conn.Open()
            $out += "app_compras con ${name}: OK"
            $conn.Close()
        } catch {
            $out += "app_compras con ${name}: FALLO"
        }
    }
    return $out
} -ArgumentList $sqlPass, $pass
Write-Host ($result -join "`n")
