# Deploy model to SSAS - pass JSON via Invoke-Command with chunked writing
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$session = New-PSSession -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate

# Ensure temp dir
Invoke-Command -Session $session -ScriptBlock {
    if (-not (Test-Path "C:\temp")) { New-Item -ItemType Directory -Path "C:\temp" | Out-Null }
    Remove-Item "C:\temp\model_deploy.json" -ErrorAction SilentlyContinue
}

# Read and encode model (inyectando password del datasource desde .env.local)
$modelPath = "d:\Andres\Dev\EPSA-Compras\model\database_staging.json"
$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $sqlPass) { throw "SQL_PASSWORD no encontrado en .env.local" }
$modelText = [System.IO.File]::ReadAllText($modelPath)
$modelText = $modelText.Replace("__SQL_PASSWORD__", $sqlPass)
$modelBytes = [System.Text.Encoding]::UTF8.GetBytes($modelText)
$modelB64 = [Convert]::ToBase64String($modelBytes)
Write-Host "Model encoded: $($modelB64.Length) chars" -ForegroundColor Cyan

# Send in chunks (WinRM has ~500KB limit per message)
$chunkSize = 400000
$totalChunks = [Math]::Ceiling($modelB64.Length / $chunkSize)
Write-Host "Sending $totalChunks chunks..." -ForegroundColor Cyan

for ($i = 0; $i -lt $totalChunks; $i++) {
    $start = $i * $chunkSize
    $len = [Math]::Min($chunkSize, $modelB64.Length - $start)
    $chunk = $modelB64.Substring($start, $len)
    
    Invoke-Command -Session $session -ArgumentList $chunk, $i -ScriptBlock {
        param($data, $chunkNum)
        Add-Content -Path "C:\temp\model_deploy.b64" -Value $data -NoNewline
    }
    Write-Host "  Chunk $($i+1)/$totalChunks sent" -ForegroundColor Gray
}

# Decode and deploy on server
$result = Invoke-Command -Session $session -ScriptBlock {
    $output = @()
    
    # Decode base64
    $b64 = Get-Content "C:\temp\model_deploy.b64" -Raw
    $output += "Base64 received: $($b64.Length) chars"
    
    $modelBytes = [Convert]::FromBase64String($b64)
    $modelJson = [System.Text.Encoding]::UTF8.GetString($modelBytes)
    $output += "Model decoded: $($modelJson.Length) chars"
    
    # Save for reference
    [System.IO.File]::WriteAllText("C:\temp\model_deploy.json", $modelJson, [System.Text.Encoding]::UTF8)
    
    # Load AMO
    $amoDir = "C:\Program Files\Microsoft SQL Server\170\DTS\Binn"
    Add-Type -Path (Join-Path $amoDir "Microsoft.AnalysisServices.Tabular.dll")
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    $output += "Connected to SSAS"
    
    # Build TMSL createOrReplace
    $tmsl = "{`"createOrReplace`":{`"object`":{`"database`":`"Compras_EPSA`"},`"database`":$modelJson}}"
    $output += "TMSL size: $($tmsl.Length) chars"
    
    try {
        $result = $server.Execute($tmsl)
        $output += "SUCCESS: Model deployed to SSAS"
        foreach ($r in $result) {
            if ($r.Messages) { $output += "  $($r.Messages)" }
        }
    } catch {
        $err = $_.Exception.Message
        if ($err.Length -gt 1000) { $err = $err.Substring(0, 1000) }
        $output += "ERROR: $err"
    }
    
    $server.Disconnect()
    return $output
}

Remove-PSSession $session

Write-Host "`n$($result -join "`n")" -ForegroundColor White
