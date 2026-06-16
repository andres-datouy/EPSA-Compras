# Verify fiscal year boundary using OLE DB (same approach as verify_dax.ps1)
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $dax = "EVALUATE FILTER(ADDCOLUMNS(CALENDAR(DATE(2025,1,29), DATE(2025,2,5)), ""FY"", LOOKUPVALUE(Calendario[Año Fiscal], Calendario[Fecha], [Date]), ""FMN"", LOOKUPVALUE(Calendario[Fiscal Month Number], Calendario[Fecha], [Date])), TRUE()) ORDER BY [Date]"
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $dax
    $r = $cmd.ExecuteReader()
    $rows = @()
    while ($r.Read()) {
        $rows += "$($r[0].ToString('yyyy-MM-dd'))  FY=$($r[1])  FMN=$($r[2])"
    }
    $r.Close()
    $conn.Close()
    return $rows
}

Write-Host "`n=== Fiscal Year Boundary Test ===" -ForegroundColor Cyan
Write-Host "Expecting: Jan 29-31 -> FY 2024, FMN 12 | Feb 1-5 -> FY 2025, FMN 1" -ForegroundColor Yellow
$result | ForEach-Object { Write-Host $_ }
