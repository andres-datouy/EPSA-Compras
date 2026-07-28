# Check SQL column types and sample data
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    
    # All columns for dimArticulo
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = @"
SELECT c.name, t.name as type_name, c.max_length, c.precision, c.scale, c.collation_name
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.stg_dimArticulo')
ORDER BY c.column_id
"@
    $reader = $cmd.ExecuteReader()
    Write-Output "=== stg_dimArticulo columns ==="
    while ($reader.Read()) {
        Write-Output "  $($reader['name']): $($reader['type_name'])($($reader['max_length'])) collation=$($reader['collation_name'])"
    }
    $reader.Close()
    
    # Sample top 3 longest nom_articulo values
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT TOP 3 nom_articulo, LEN(nom_articulo) as l, DATALENGTH(nom_articulo) as dl FROM stg_dimArticulo ORDER BY LEN(nom_articulo) DESC"
    $reader2 = $cmd2.ExecuteReader()
    Write-Output ""
    Write-Output "=== Top 3 longest nom_articulo ==="
    while ($reader2.Read()) {
        Write-Output "  len=$($reader2['l']) datalen=$($reader2['dl']) value='$($reader2['nom_articulo'])'"
    }
    $reader2.Close()
    
    $conn.Close()
}

$result | ForEach-Object { Write-Host $_ }
