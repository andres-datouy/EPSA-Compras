# Deploy with detailed TMSL error output
$pass = "Saas 244050@"
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

Copy-Item "d:\Andres\Dev\EPSA-Compras\model\database_staging.json" "\\192.168.2.47\C$\temp\ssas_deploy\" -Force

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $amoPaths = @("$env:ProgramFiles\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll",
        "$env:ProgramFiles\Microsoft SQL Server\*\OLAP\bin\Microsoft.AnalysisServices.Tabular.dll")
    foreach ($pattern in $amoPaths) {
        $dll = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
        if ($dll) {
            $amoDir = Split-Path $dll.FullName
            foreach ($dep in @("Microsoft.AnalysisServices.Core.dll","Microsoft.AnalysisServices.Tabular.dll","Microsoft.AnalysisServices.Tabular.Json.dll")) {
                $depPath = Join-Path $amoDir $dep
                if (Test-Path $depPath) { try { Add-Type -Path $depPath -ErrorAction SilentlyContinue } catch {} }
            }
            break
        }
    }

    $modelJson = Get-Content "C:\temp\ssas_deploy\database_staging.json" -Raw -Encoding UTF8
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    
    $tmsl = @"
{
  "createOrReplace": {
    "object": { "database": "Compras_EPSA" },
    "database": $modelJson
  }
}
"@
    
    try {
        $result = $ssas.Execute($tmsl)
        Write-Output "Result type: $($result.GetType().FullName)"
        Write-Output "ContainsErrors: $($result.ContainsErrors)"
        if ($result.Messages) {
            foreach ($msg in $result.Messages) {
                Write-Output "MSG: $($msg.Description)"
                Write-Output "MSG Type: $($msg.MessageType)"
                Write-Output "---"
            }
        }
    } catch {
        Write-Output "EXCEPTION: $_"
        Write-Output "INNER: $($_.Exception.InnerException.Message)"
    }
    
    $ssas.Disconnect()
}

$result | ForEach-Object { Write-Host $_ }
