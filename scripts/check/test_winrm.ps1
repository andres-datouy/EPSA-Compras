$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT t.name AS tbl, STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY c.column_id) AS cols FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id WHERE t.name LIKE 'stg_%' GROUP BY t.name ORDER BY t.name"
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        Write-Output "=== $($reader['tbl']) ==="
        Write-Output "  $($reader['cols'])"
    }
    $reader.Close()
    $conn.Close()
}

$result | ForEach-Object { Write-Host $_ }
