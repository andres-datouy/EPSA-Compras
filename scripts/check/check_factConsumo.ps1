# Check stg_factConsumo columns
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "Data Source=localhost,1435;Initial Catalog=staging_compras;Integrated Security=SSPI;TrustServerCertificate=True"
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT c.name, t.name as type_name FROM sys.columns c JOIN sys.types t ON c.user_type_id = t.user_type_id WHERE c.object_id = OBJECT_ID('dbo.stg_factConsumo') ORDER BY c.column_id"
    $reader = $cmd.ExecuteReader()
    while ($reader.Read()) {
        Write-Output "  $($reader['name']): $($reader['type_name'])"
    }
    $reader.Close()
    $conn.Close()
}

$result | ForEach-Object { Write-Host $_ }
