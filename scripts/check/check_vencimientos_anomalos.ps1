# tmp: exporta a CSV todas las filas de stg_factVencimientos con fec_venc anomala
# Rango "sano": 2000-01-01 .. 2045-12-31 (fechas fuera = centinelas o basura en cpt_lote)
$e = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local"
$pass = (($e | Where-Object { $_ -match '^SSAS_PASSWORD=' }) -split '=', 2)[1]
$sqlPass = (($e | Where-Object { $_ -match '^SQL_PASSWORD=' }) -split '=', 2)[1]
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$rows = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($sqlPwd)
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=$sqlPwd;Connect Timeout=10")
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandTimeout = 180
    $cmd.CommandText = @"
SELECT v.cod_articulo, ISNULL(RTRIM(a.nom_articulo),'') AS nom_articulo, v.nro_lote,
       CAST(v.cantidad AS NUMERIC(18,2)) AS cantidad, CONVERT(VARCHAR(10), v.fec_venc, 120) AS fec_venc,
       CASE
           WHEN v.fec_venc <= '1925-12-31' THEN 'CENTINELA (sin vencimiento)'
           WHEN v.fec_venc >= '2046-01-01' THEN 'FUTURO BASURA (sin vencimiento real)'
           ELSE 'OTRO'
       END AS categoria
FROM dbo.stg_factVencimientos v
LEFT JOIN dbo.stg_dimArticulo a ON a.cod_articulo = v.cod_articulo COLLATE DATABASE_DEFAULT
WHERE v.fec_venc < '2000-01-01' OR v.fec_venc > '2045-12-31'
ORDER BY v.fec_venc, v.cod_articulo
"@
    $out = New-Object System.Collections.ArrayList
    $r = $cmd.ExecuteReader()
    while ($r.Read()) {
        [void]$out.Add([pscustomobject]@{
            cod_articulo = "$($r[0])".Trim()
            nom_articulo = "$($r[1])"
            nro_lote     = "$($r[2])"
            cantidad     = $r[3]
            fec_venc     = "$($r[4])"
            categoria    = "$($r[5])"
        })
    }
    $r.Close()
    $conn.Close()
    $out
} -ArgumentList $sqlPass

$csv = "d:\Andres\Dev\EPSA-Compras\docs\vencimientos_anomalos_2026-08-06.csv"
$rows | Export-Csv -Path $csv -NoTypeInformation -Delimiter ";" -Encoding UTF8
Write-Host "Total filas anomalas: $($rows.Count)"
Write-Host "Por categoria:"
$rows | Group-Object categoria | ForEach-Object { Write-Host ("  {0}: {1} lotes, cantidad={2:N2}" -f $_.Name, $_.Count, (($_.Group | Measure-Object cantidad -Sum).Sum)) }
Write-Host "CSV: $csv"
