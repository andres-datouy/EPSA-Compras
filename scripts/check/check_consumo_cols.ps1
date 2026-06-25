$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;Integrated Security=True;Connect Timeout=30"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()

    # Check actual column names
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT TOP 1 * FROM dbo.stg_factConsumo"
    $cmd.CommandTimeout = 10
    $reader = $cmd.ExecuteReader()
    $schema = $reader.GetSchemaTable()
    Write-Output "=== stg_factConsumo columns ==="
    foreach ($row in $schema.Rows) { Write-Output "  $($row['ColumnName'])" }
    $reader.Close()
    $conn.Close()
}
