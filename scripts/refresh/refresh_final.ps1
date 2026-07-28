# Final SSAS refresh to sync with current staging data
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Tabular.dll")
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    
    # Full database refresh
    $tmsl = '{"refresh": {"type": "full", "objects": [{"database": "Compras_EPSA"}]}}'
    
    try {
        $result = $server.Execute($tmsl)
        $server.Disconnect()
        return "SUCCESS: Full refresh completed"
    } catch {
        $server.Disconnect()
        return "ERROR: $($_.Exception.Message.Substring(0, [Math]::Min(200, $_.Exception.Message.Length)))"
    }
}

Write-Host $result -ForegroundColor Green
