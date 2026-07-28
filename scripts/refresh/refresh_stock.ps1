# Refresh just factStockEPSA in SSAS
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Tabular.dll")
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    
    $tmsl = '{"refresh": {"type": "full", "objects": [{"database": "Compras_EPSA", "table": "factStockEPSA"}]}}'
    
    try {
        $result = $server.Execute($tmsl)
        $output += "factStockEPSA refresh initiated"
        foreach ($r in $result) {
            if ($r.Messages) { $output += "  $($r.Messages)" }
        }
        $output += "Refresh completed"
    } catch {
        $err = $_.Exception.Message
        if ($err.Length -gt 500) { $err = $err.Substring(0, 500) }
        $output += "ERROR: $err"
    }
    
    # Verify row count via DAX
    $connStr = "Provider=MSOLAP;Data Source=localhost:2383;Initial Catalog=Compras_EPSA"
    $conn = New-Object System.Data.OleDb.OleDbConnection($connStr)
    $conn.Open()
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "EVALUATE ROW(""count"", COUNTROWS(factStockEPSA))"
    try {
        $r = $cmd.ExecuteReader()
        if ($r.Read()) { $output += "SSAS factStockEPSA rows: $($r[0])" }
        $r.Close()
    } catch { $output += "Verify ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))" }
    
    # Check stock measures
    $measures = @("Stock Existencia", "Stock Compras", "Stock Mínimo", "Gap Stock", "Cobertura Meses sobre Existencia")
    foreach ($m in $measures) {
        $cmd2 = $conn.CreateCommand()
        $cmd2.CommandText = "EVALUATE {[$m]}"
        try {
            $r2 = $cmd2.ExecuteReader()
            if ($r2.Read()) { $output += "  [$m]: $($r2[0])" }
            $r2.Close()
        } catch { $output += "  [$m]: ERROR" }
    }
    
    $conn.Close()
    $server.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
