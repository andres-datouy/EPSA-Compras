# Add Calendario + Measure tables to database_staging.json
$ErrorActionPreference = "Stop"

$stagingPath = "d:\Andres\Dev\EPSA-Compras\model\database_staging.json"
$exportPath = "d:\Andres\Dev\EPSA-Compras\pbix\model_export.json"

$staging = Get-Content $stagingPath -Raw -Encoding UTF8 | ConvertFrom-Json
$export = Get-Content $exportPath -Raw -Encoding UTF8 | ConvertFrom-Json

$existingNames = $staging.model.tables | ForEach-Object { $_.name }
Write-Host "Existing tables: $($existingNames -join ', ')" -ForegroundColor Gray

# Helper: create TMSL table object for measure-only table
function New-MeasureTable {
    param([string]$Name, [array]$Measures)
    
    $table = [PSCustomObject]@{
        name = $Name
        lineageTag = [guid]::NewGuid().ToString()
        columns = @(
            [PSCustomObject]@{
                type = "rowNumber"
                name = "RowNumber-$([guid]::NewGuid().ToString().Substring(0,8).ToUpper())"
                dataType = "int64"
                isHidden = $true
                isUnique = $true
                isKey = $true
                isNullable = $false
            }
        )
        partitions = @(
            [PSCustomObject]@{
                name = $Name
                mode = "import"
                state = "ready"
                source = [PSCustomObject]@{
                    type = "calculated"
                    expression = "ROW(""Dummy"", 1)"
                }
            }
        )
        measures = @()
    }
    
    foreach ($m in $Measures) {
        $measure = [PSCustomObject]@{
            name = $m.Name
            expression = $m.Expression
            formatString = if ($m.FormatString) { $m.FormatString } else { "#,0.00" }
            lineageTag = [guid]::NewGuid().ToString()
        }
        $table.measures += $measure
    }
    
    return $table
}

# 1. Add Calendario as calculated table
if ("Calendario" -notin $existingNames) {
    Write-Host "`nAdding Calendario..." -ForegroundColor Yellow
    $calTable = [PSCustomObject]@{
        name = "Calendario"
        lineageTag = [guid]::NewGuid().ToString()
        columns = @(
            [PSCustomObject]@{ type = "rowNumber"; name = "RowNumber-$([guid]::NewGuid().ToString().Substring(0,8).ToUpper())"; dataType = "int64"; isHidden = $true; isUnique = $true; isKey = $true; isNullable = $false }
            [PSCustomObject]@{ name = "Fecha"; dataType = "dateTime"; sourceColumn = "Fecha"; formatString = "dd/mm/yyyy" }
            [PSCustomObject]@{ name = "Año Fiscal"; dataType = "string"; sourceColumn = "Año Fiscal" }
            [PSCustomObject]@{ name = "Año Fiscal Número"; dataType = "int64"; sourceColumn = "Año Fiscal Número"; formatString = "0" }
            [PSCustomObject]@{ name = "Año Mes"; dataType = "string"; sourceColumn = "Año Mes" }
            [PSCustomObject]@{ name = "Año Mes Número"; dataType = "int64"; sourceColumn = "Año Mes Número"; formatString = "0" }
            [PSCustomObject]@{ name = "Fiscal Month"; dataType = "string"; sourceColumn = "Fiscal Month" }
            [PSCustomObject]@{ name = "Fiscal Month Number"; dataType = "int64"; sourceColumn = "Fiscal Month Number"; formatString = "0" }
            [PSCustomObject]@{ name = "Fiscal Month in Quarter Number"; dataType = "int64"; sourceColumn = "Fiscal Month in Quarter Number"; formatString = "0" }
            [PSCustomObject]@{ name = "Trimestre del año fiscal"; dataType = "string"; sourceColumn = "Trimestre del año fiscal" }
            [PSCustomObject]@{ name = "Trimestre del Año Fiscal Número"; dataType = "double"; sourceColumn = "Trimestre del Año Fiscal Número" }
            [PSCustomObject]@{ name = "Trimestre Fiscal"; dataType = "string"; sourceColumn = "Trimestre Fiscal" }
            [PSCustomObject]@{ name = "Year Month Key"; dataType = "int64"; sourceColumn = "Year Month Key"; formatString = "0" }
        )
        partitions = @(
            [PSCustomObject]@{
                name = "Calendario"
                mode = "import"
                state = "ready"
                source = [PSCustomObject]@{
                    type = "calculated"
                    expression = @"
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
                }
            }
        )
    }
    
    # Add hierarchy for Fiscal Year-Quarter
    $hierarchy = [PSCustomObject]@{
        name = "Fiscal Year-Quarter"
        levels = @(
            [PSCustomObject]@{ name = "Year"; ordinal = 0; column = "Trimestre Fiscal" }
            [PSCustomObject]@{ name = "Quarter"; ordinal = 1; column = "Trimestre del año fiscal" }
        )
    }
    $calTable | Add-Member -NotePropertyName "hierarchies" -NotePropertyValue @($hierarchy)
    
    $staging.model.tables += $calTable
    Write-Host "  Added Calendario" -ForegroundColor Green
}

# 2. Add measure tables from model_export
$measureTableNames = @("Medidas_Stock", "Medidas_Consumo", "Medidas_Consumo_Planificado", "Medidas_DemandaPendiente", "Medidas_Compras")

foreach ($tableName in $measureTableNames) {
    if ($tableName -in $existingNames) {
        Write-Host "  Skipping $tableName (exists)" -ForegroundColor Gray
        continue
    }
    
    $origTable = $export.Tables | Where-Object { $_.Name -eq $tableName }
    if (-not $origTable -or -not $origTable.Measures) {
        Write-Host "  WARNING: $tableName not found in export" -ForegroundColor Red
        continue
    }
    
    $measures = @()
    foreach ($m in $origTable.Measures) {
        $measures += [PSCustomObject]@{
            Name = $m.Name
            Expression = $m.Expression
            FormatString = if ($m.FormatString) { $m.FormatString } else { "#,0.00" }
        }
    }
    
    $newTable = New-MeasureTable -Name $tableName -Measures $measures
    $staging.model.tables += $newTable
    Write-Host "  Added $tableName ($($measures.Count) measures)" -ForegroundColor Green
}

# 3. Save
Write-Host "`nSaving..." -ForegroundColor Yellow
$json = $staging | ConvertTo-Json -Depth 50 -Compress:$false
[System.IO.File]::WriteAllText($stagingPath, $json, (New-Object System.Text.UTF8Encoding($true)))
Write-Host "Saved $stagingPath ($($staging.model.tables.Count) tables)" -ForegroundColor Green
