# Check actual SP definition and fix linked server name
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=10"
    $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
    $conn.Open()
    
    # Get SP definition
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.sp_refresh_factStockEPSA'))"
    $spDef = $cmd.ExecuteScalar()
    
    $conn.Close()
    return $spDef
}

Write-Host "=== Current SP Definition ===" -ForegroundColor Cyan
Write-Host $result -ForegroundColor White
