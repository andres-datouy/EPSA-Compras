# Update Calendario fiscal year via WinRM using TMSL
$ErrorActionPreference = "Stop"

# Load .env.local
$envVars = @{}
Get-Content "$PSScriptRoot\..\.env.local" | ForEach-Object {
    $line = $_.Trim()
    if ($line -and $line -notmatch '^#' -and $line -match '^([^=]+)=(.*)$') {
        $envVars[$Matches[1]] = $Matches[2]
    }
}

$ssasUser = $envVars["SSAS_USER"]
$ssasPassword = $envVars["SSAS_PASSWORD"]
$ssasHostname = $envVars["SSAS_HOSTNAME"]
$ssasServer = $envVars["SSAS_SERVER"].Split(':')[0]

$securePassword = ConvertTo-SecureString $ssasPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$ssasHostname\$ssasUser", $securePassword)

Write-Host "Updating Calendario fiscal year (July->Feb) via WinRM..." -ForegroundColor Cyan

$result = Invoke-Command -ComputerName $ssasServer -Credential $credential -Authentication Negotiate -ScriptBlock {
    param($newDax)
    
    # Load AMO on remote server
    $amoDll = Get-ChildItem "C:\Program Files\Microsoft SQL Server" -Recurse -Filter "Microsoft.AnalysisServices.Tabular.dll" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*OLAP*" -or $_.FullName -like "*SDK*" -or $_.FullName -like "*DTS*" -or $_.FullName -like "*Setup Bootstrap*" } |
        Sort-Object FullName -Descending | Select-Object -First 1
    
    if ($amoDll) {
        $dir = Split-Path $amoDll.FullName
        foreach ($dep in @("Microsoft.AnalysisServices.Core.dll", "Microsoft.AnalysisServices.Tabular.dll", "Microsoft.AnalysisServices.Tabular.Json.dll")) {
            $p = Join-Path $dir $dep
            if (Test-Path $p) { try { Add-Type -Path $p -ErrorAction SilentlyContinue } catch {} }
        }
        Write-Output "Loaded AMO from: $dir"
    } else {
        try { Add-Type -AssemblyName "Microsoft.AnalysisServices.Tabular" } catch { throw "AMO not available" }
    }

    # Connect to local SSAS
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server
    $server.Connect("Data Source=localhost:2383")
    
    $db = $server.Databases.FindByName("Compras_EPSA")
    if (-not $db) { throw "Database not found" }
    
    $calTable = $db.Model.Tables | Where-Object { $_.Name -eq "Calendario" }
    if (-not $calTable) { throw "Calendario table not found" }
    
    $partition = $calTable.Partitions | Where-Object { $_.Name -eq "Calendario" }
    if (-not $partition) { throw "Calendario partition not found" }
    
    Write-Output "Updating Calendario DAX expression..."
    $partition.Source.Expression = $newDax
    $db.Model.SaveChanges()
    Write-Output "DAX updated successfully!"
    
    # Process using TMSL (avoid strongly-typed RefreshRequest)
    Write-Output "Processing Calendario via TMSL..."
    $tmsl = @"
{
    "refresh": {
        "type": "full",
        "objects": [
            {
                "database": "Compras_EPSA",
                "table": "Calendario"
            }
        ]
    }
}
"@
    $server.Execute($tmsl)
    Write-Output "Calendario processed successfully!"
    
    $server.Disconnect($true)
    Write-Output "Done! Fiscal year now starts February 1."
} -ArgumentList @"
VAR BaseCalendar = CALENDARAUTO(1)
RETURN
GENERATE(
    BaseCalendar,
    VAR CurrentDate = [Date]
    VAR FiscalMonthNum = IF(MONTH(CurrentDate) >= 2, MONTH(CurrentDate) - 1, MONTH(CurrentDate) + 11)
    VAR FiscalYearNum = IF(MONTH(CurrentDate) >= 2, YEAR(CurrentDate), YEAR(CurrentDate) - 1)
    VAR FiscalQuarterNum = INT((FiscalMonthNum - 1) / 3) + 1
    VAR FiscalMonthInQ = FiscalMonthNum - (FiscalQuarterNum - 1) * 3
    RETURN ROW(
        "Fecha", CurrentDate,
        "Año Fiscal Número", FiscalYearNum,
        "Año Fiscal", "FY " & FiscalYearNum,
        "Fiscal Month Number", FiscalMonthNum,
        "Fiscal Month", FORMAT(DATE(2000, FiscalMonthNum, 1), "MMMM"),
        "Fiscal Month in Quarter Number", FiscalMonthInQ,
        "Trimestre del Año Fiscal Número", FiscalQuarterNum * 1.0,
        "Trimestre del año fiscal", "Q" & FiscalQuarterNum,
        "Trimestre Fiscal", "FY" & FiscalYearNum & " Q" & FiscalQuarterNum,
        "Año Mes Número", YEAR(CurrentDate) * 100 + MONTH(CurrentDate),
        "Año Mes", FORMAT(CurrentDate, "YYYY-MMM"),
        "Year Month Key", YEAR(CurrentDate) * 100 + MONTH(CurrentDate)
    )
)
"@

Write-Host $result -ForegroundColor Green
