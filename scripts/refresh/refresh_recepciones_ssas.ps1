# Refresh SSAS factRecepcionesHistoria partition and verify
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Tabular.dll")
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Core.dll")
    
    $output = @()
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    
    $db = $server.Databases.FindByName("Compras_EPSA")
    if (-not $db) { $output += "Database not found!"; return $output }
    
    $model = $db.Model
    
    # Find the factRecepcionesHistoria table
    $table = $model.Tables["factRecepcionesHistoria"]
    if (-not $table) { $output += "Table factRecepcionesHistoria not found!"; return $output }
    
    $output += "Found table: $($table.Name)"
    $output += "Partitions: $($table.Partitions.Count)"
    
    # Refresh only this table
    $output += "`nRefreshing factRecepcionesHistoria..."
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    $request = New-Object Microsoft.AnalysisServices.Tabular.JsonWebRequest
    $request.RequestType = "refresh"
    $request.RefreshType = [Microsoft.AnalysisServices.Tabular.RefreshType]::Full
    $table.RequestRefresh([Microsoft.AnalysisServices.Tabular.RefreshType]::Full)
    
    $saveResult = $model.SaveChanges()
    $sw.Stop()
    
    $output += "  Refresh completed in $($sw.Elapsed.TotalSeconds.ToString('F1')) seconds"
    if ($saveResult.Impact) {
        $output += "  Impact: $($saveResult.Impact | Out-String)"
    }
    
    # Verify row count via DAX
    $output += "`nVerifying row count via DAX..."
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "EVALUATE ROW(""Count"", COUNTROWS('factRecepcionesHistoria'))"
    $r = $cmd.ExecuteReader()
    if ($r.Read()) {
        $output += "  SSAS factRecepcionesHistoria rows: $($r[0])"
    }
    $r.Close()
    
    # Also check min/max dates
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "EVALUATE ROW(""MinDate"", MINX('factRecepcionesHistoria', [RecepcionFecha]), ""MaxDate"", MAXX('factRecepcionesHistoria', [RecepcionFecha]))"
    $r2 = $cmd2.ExecuteReader()
    if ($r2.Read()) {
        $output += "  Min RecepcionFecha: $($r2[0])"
        $output += "  Max RecepcionFecha: $($r2[1])"
    }
    $r2.Close()
    
    $conn.Close()
    $server.Disconnect()
    
    $output += "`nSSAS REFRESH COMPLETE!"
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
