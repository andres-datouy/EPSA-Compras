# =====================================================
# Deploy SSAS Model using schaaf_ssas credentials
# Reads credentials from .env.local and uses PS Remoting
# to run deployment on the SSAS server directly
# =====================================================

param(
    [string]$EnvFile = "$PSScriptRoot\..\.env.local",
    [switch]$SkipProcess = $false
)

$ErrorActionPreference = "Stop"

# --- Load .env.local ---
Write-Host "Loading credentials from: $EnvFile" -ForegroundColor Yellow
$envVars = @{}
Get-Content $EnvFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and $line -notmatch '^#' -and $line -match '^([^=]+)=(.*)$') {
        $envVars[$Matches[1]] = $Matches[2]
    }
}

$ssasUser = $envVars["SSAS_USER"]
$ssasPassword = $envVars["SSAS_PASSWORD"]
$ssasHostname = $envVars["SSAS_HOSTNAME"]
$ssasServer = $envVars["SSAS_SERVER"]

if (-not $ssasUser -or -not $ssasPassword) {
    Write-Error "SSAS_USER and SSAS_PASSWORD must be set in $EnvFile"
    exit 1
}

Write-Host "SSAS User: $ssasHostname\$ssasUser" -ForegroundColor Green
Write-Host "SSAS Server: $ssasServer" -ForegroundColor Green

# --- Build credential ---
$securePassword = ConvertTo-SecureString $ssasPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$ssasHostname\$ssasUser", $securePassword)

# --- Copy model files to server ---
$remoteBase = "\\$($envVars['SSAS_SERVER'].Split(':')[0])\C$\temp\ssas_deploy"
Write-Host "Staging files to: $remoteBase" -ForegroundColor Yellow

# Create remote directory
if (-not (Test-Path $remoteBase)) {
    New-Item -ItemType Directory -Path $remoteBase -Force | Out-Null
}

# Copy model and scripts
Copy-Item "$PSScriptRoot\..\model\database_staging.json" "$remoteBase\" -Force
Copy-Item "$PSScriptRoot\deploy_model.ps1" "$remoteBase\" -Force

Write-Host "Files staged." -ForegroundColor Green

# --- Build deploy arguments ---
$skipArg = if ($SkipProcess) { "-SkipProcess" } else { "" }

# --- Execute remotely via PowerShell Remoting ---
Write-Host "Deploying on server as $ssasHostname\$ssasUser..." -ForegroundColor Yellow
Write-Host ""

try {
    $result = Invoke-Command -ComputerName $ssasServer.Split(':')[0] -Credential $credential -Authentication Negotiate -ScriptBlock {
        param($remoteBase, $serverAddr, $skipArg)
        $scriptPath = "$remoteBase\deploy_model.ps1"
        $modelPath = "$remoteBase\database_staging.json"
        # When running on the server, use localhost + port
        $localPort = $serverAddr.Split(':')[1]
        $localServer = "localhost:$localPort"
        $deployArgs = @("-Server", $localServer, "-ModelFile", $modelPath)
        if ($skipArg) { $deployArgs += "-SkipProcess" }
        
        # Execute deploy script
        & powershell.exe -ExecutionPolicy Bypass -File $scriptPath @deployArgs
    } -ArgumentList $remoteBase, $ssasServer, $skipArg
    
    Write-Host $result
    Write-Host ""
    Write-Host "Deployment process finished." -ForegroundColor Cyan
} catch {
    Write-Error "Remote deployment failed: $_"
    Write-Host ""
    Write-Host "TROUBLESHOOTING:" -ForegroundColor Yellow
    Write-Host "1. Ensure WinRM is enabled on server: Enable-PSRemoting -Force" -ForegroundColor Gray
    Write-Host "2. Ensure firewall allows TCP 5985/5986" -ForegroundColor Gray
    Write-Host "3. Or try the manual runas approach:" -ForegroundColor Gray
    Write-Host "   runas /netonly /user:$ssasHostname\$ssasUser `"powershell -File $PSScriptRoot\deploy_model.ps1 -SkipProcess`"" -ForegroundColor White
    exit 1
}
