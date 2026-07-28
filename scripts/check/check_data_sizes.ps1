# Check Proveedores column data and test excluding it
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    
    # Check Proveedores column data
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT TOP 5 LEN(ISNULL(Proveedores,'')) as l, ISNULL(LEFT(Proveedores,200),'NULL') as sample FROM stg_dimArticulo ORDER BY LEN(ISNULL(Proveedores,'')) DESC"
    $reader = $cmd.ExecuteReader()
    Write-Output "=== Proveedores samples ==="
    while ($reader.Read()) {
        Write-Output "  len=$($reader['l']) sample='$($reader['sample'])'"
    }
    $reader.Close()
    
    # Check max lengths of ALL string columns
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = @"
SELECT 
  MAX(LEN(ISNULL(cod_articulo,''))) as cod_articulo_max,
  MAX(LEN(ISNULL(nom_articulo,''))) as nom_articulo_max,
  MAX(LEN(ISNULL(catalogo,''))) as catalogo_max,
  MAX(LEN(ISNULL(nom_tipoart,''))) as nom_tipoart_max,
  MAX(LEN(ISNULL(marca_dsc,''))) as marca_dsc_max,
  MAX(LEN(ISNULL(nom_clasifart,''))) as nom_clasifart_max,
  MAX(LEN(ISNULL(nom_familia_art,''))) as nom_familia_art_max,
  MAX(LEN(ISNULL(nom_subfam_art,''))) as nom_subfam_art_max,
  MAX(LEN(ISNULL(nom_grupoart,''))) as nom_grupoart_max,
  MAX(LEN(ISNULL(nom_usofinal,''))) as nom_usofinal_max,
  MAX(LEN(ISNULL(ProveedorArticuloNombre,''))) as ProveedorArticuloNombre_max,
  MAX(LEN(ISNULL(ProveedorPaisNombre,''))) as ProveedorPaisNombre_max,
  MAX(DATALENGTH(ISNULL(Proveedores,''))) as Proveedores_max_bytes
FROM stg_dimArticulo
"@
    $reader2 = $cmd2.ExecuteReader()
    Write-Output ""
    Write-Output "=== Max lengths ==="
    if ($reader2.Read()) {
        for ($i = 0; $i -lt $reader2.FieldCount; $i++) {
            Write-Output "  $($reader2.GetName($i)): $($reader2[$i])"
        }
    }
    $reader2.Close()
    
    $conn.Close()
}

$result | ForEach-Object { Write-Host $_ }
