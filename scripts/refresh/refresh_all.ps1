# Refresh all SSAS tables after model redeployment
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # Load AMO
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Tabular.dll")
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    $output += "Connected to SSAS"
    
    # Refresh entire database
    $tmsl = '{"refresh": {"type": "full", "objects": [{"database": "Compras_EPSA"}]}}'
    
    try {
        $result = $server.Execute($tmsl)
        $output += "Full refresh initiated"
        foreach ($r in $result) {
            if ($r.Messages) { $output += "  $($r.Messages)" }
            if ($r.StatusCode -ne 0) { $output += "  StatusCode: $($r.StatusCode)" }
        }
        $output += "Refresh completed"
    } catch {
        $err = $_.Exception.Message
        if ($err.Length -gt 500) { $err = $err.Substring(0, 500) }
        $output += "ERROR: $err"
    }
    
    $server.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
