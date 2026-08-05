# Auditoria de cobertura de MOQ (Lote Minimo Compra) en stg_dimArticulo (solo lectura)
# Responde la pregunta de validacion 4 / ADR de MOQ: cuanto cubre el campo ERP del universo monitoreado.
$e = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=', 2)[1]
$sqlPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=', 2)[1]
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($sqlPwd)
    $out = @()
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPwd;Connect Timeout=8")
    $conn.Open()

    $q1 = @"
SELECT COUNT(*) AS Total,
       SUM(CASE WHEN lote_min_cpra > 0 THEN 1 ELSE 0 END) AS ConMOQ,
       SUM(CASE WHEN lote_min_cpra > 1 THEN 1 ELSE 0 END) MOQ_Mayor_1,
       SUM(CASE WHEN lote_min_cpra <= 0 THEN 1 ELSE 0 END) AS SinMOQ
FROM dbo.stg_dimArticulo
"@
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $q1
    $r = $cmd.ExecuteReader()
    while ($r.Read()) { $out += ("GLOBAL: total={0} conMOQ={1} (de los cuales >1: {2}) sinMOQ={3}" -f $r["Total"], $r["ConMOQ"], $r["MOQ_Mayor_1"], $r["SinMOQ"]) }
    $r.Close()

    $q2 = @"
SELECT COUNT(*) AS Total,
       SUM(CASE WHEN lote_min_cpra > 0 THEN 1 ELSE 0 END) AS ConMOQ,
       SUM(CASE WHEN lote_min_cpra <= 0 THEN 1 ELSE 0 END) AS SinMOQ,
       SUM(CASE WHEN stock_minimo > 0 AND lote_min_cpra > 0 THEN 1 ELSE 0 END) StockMinConMOQ,
       SUM(CASE WHEN stock_minimo > 0 AND lote_min_cpra <= 0 THEN 1 ELSE 0 END) StockMinSinMOQ
FROM dbo.stg_dimArticulo
WHERE ISNULL(ProveedorPaisNombre, '') <> 'Uruguay'
"@
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $q2
    $r = $cmd.ExecuteReader()
    while ($r.Read()) { $out += ("EXTERIOR: total={0} conMOQ={1} sinMOQ={2} | con StockMin>0: conMOQ={3} sinMOQ={4}" -f $r["Total"], $r["ConMOQ"], $r["SinMOQ"], $r["StockMinConMOQ"], $r["StockMinSinMOQ"]) }
    $r.Close()

    $q3 = @"
SELECT TOP 10 cod_articulo, RTRIM(nom_articulo) AS nombre, stock_minimo, lote_min_cpra, RTRIM(ProveedorArticuloNombre) AS prov
FROM dbo.stg_dimArticulo
WHERE ISNULL(ProveedorPaisNombre, '') <> 'Uruguay' AND stock_minimo > 0 AND lote_min_cpra <= 0
ORDER BY cod_articulo
"@
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $q3
    $r = $cmd.ExecuteReader()
    $out += "MUESTRA exterior con StockMin>0 y SIN MOQ:"
    while ($r.Read()) { $out += ("  {0} | {1} | stkMin={2} | {3}" -f $r["cod_articulo"], $r["nombre"], $r["stock_minimo"], $r["prov"]) }
    $r.Close()

    $conn.Close()
    return $out
} -ArgumentList $sqlPass

Write-Host ($result -join "`n")
