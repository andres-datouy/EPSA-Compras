# Test direct SQL query and check SSAS column metadata
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    # Load AMO
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

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    
    # Check column properties for dimArticulo
    $table = $db.Model.Tables | Where-Object { $_.Name -eq "dimArticulo" }
    Write-Output "=== dimArticulo columns ==="
    foreach ($col in $table.Columns) {
        if ($col.DataType -eq "String") {
            $ml = $col.MaxLength
            Write-Output "  $($col.Name): type=$($col.DataType), maxLength=$ml, sourceCol=$($col.SourceColumn)"
        }
    }
    
    # Check factStockEPSA for comparison (this one worked)
    $table2 = $db.Model.Tables | Where-Object { $_.Name -eq "factStockEPSA" }
    Write-Output ""
    Write-Output "=== factStockEPSA columns (reference - works) ==="
    foreach ($col in $table2.Columns) {
        if ($col.DataType -eq "String") {
            $ml = $col.MaxLength
            Write-Output "  $($col.Name): type=$($col.DataType), maxLength=$ml, sourceCol=$($col.SourceColumn)"
        }
    }
    
    $ssas.Disconnect()
}

$result | ForEach-Object { Write-Host $_ }
