# Extract Calendario and measure table details for SSAS model
$modelExport = Get-Content "d:\Andres\Dev\EPSA-Compras\pbix\model_export.json" -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "=== Calendario Table ===" -ForegroundColor Cyan
$cal = $modelExport.Tables | Where-Object { $_.Name -eq "Calendario" }
if ($cal) {
    Write-Host "  Partition Expression: $($cal.Partitions[0].Expression)"
    Write-Host "  Columns:"
    foreach ($c in $cal.Columns) {
        if ($c.Expression) {
            Write-Host "    CALC: $($c.Name) [$($c.DataType)] = $($c.Expression.Substring(0, [Math]::Min(100, $c.Expression.Length)))"
        } else {
            Write-Host "    DATA: $($c.Name) [$($c.DataType)]"
        }
    }
}

Write-Host "`n=== Measure Tables ===" -ForegroundColor Cyan
$measureTables = $modelExport.Tables | Where-Object { $_.Measures -and $_.Measures.Count -gt 0 }
foreach ($mt in $measureTables) {
    Write-Host "`n--- $($mt.Name) ---" -ForegroundColor Yellow
    Write-Host "  Measures:"
    foreach ($m in $mt.Measures) {
        Write-Host "    $($m.Name) [$($m.DataType)] Format='$($m.FormatString)'"
        Write-Host "    = $($m.Expression)"
        Write-Host ""
    }
}
