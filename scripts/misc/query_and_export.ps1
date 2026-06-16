# query_and_export.ps1
# Queries Power BI Desktop directly via ADOMD and exports full datasets
$ErrorActionPreference = "Stop"

$projectRoot = "d:\Andres\Dev\EPSA-Compras"
$outputDir = "$projectRoot\docs\deliverables"

# Find Power BI port
$pbiProcess = Get-Process msmdsrv -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $pbiProcess) { Write-Error "Power BI Desktop is not running"; exit 1 }

$port = (Get-NetTCPConnection -OwningProcess $pbiProcess.Id -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -gt 1024 } | Select-Object -First 1).LocalPort
Write-Host "Power BI SSAS on port: $port" -ForegroundColor Cyan

# Load ADOMD
$adomdPath = Get-ChildItem "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.AnalysisServices.AdomdClient" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $adomdPath) {
    # Try NuGet
    $adomdPath = Get-ChildItem "$env:USERPROFILE\.nuget\packages\microsoft.analysisservices.adomdclient.retail.amd64" -Recurse -Filter "Microsoft.AnalysisServices.AdomdClient.dll" -ErrorAction SilentlyContinue | Select-Object -Last 1
}
if ($adomdPath) {
    [System.Reflection.Assembly]::LoadFrom($adomdPath.FullName) | Out-Null
    Write-Host "ADOMD loaded from: $($adomdPath.FullName)" -ForegroundColor Green
} else {
    Write-Warning "ADOMD not found in GAC/NuGet. Trying Add-Type..."
    Add-Type -AssemblyName "Microsoft.AnalysisServices.AdomdClient"
}

function Invoke-DaxQuery {
    param([string]$Query, [int]$Port)
    
    $connStr = "Data Source=localhost:$Port;Initial Catalog=''"
    $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($connStr)
    $conn.Open()
    
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $Query
    $reader = $cmd.ExecuteReader()
    
    $results = @()
    while ($reader.Read()) {
        $row = @{}
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $row[$reader.GetName($i)] = $reader.GetValue($i)
        }
        $results += [PSCustomObject]$row
    }
    $reader.Close()
    $conn.Close()
    return $results
}

# Query 1: Stock Minimo > 0, not pt/prvta
Write-Host "`nQuery 1: Stock Minimo > 0 (not pt, not prvta)..." -ForegroundColor Yellow
$q1 = @"
EVALUATE
ADDCOLUMNS(
    FILTER(dimArticulo, dimArticulo[Artículo Stock Mínimo] > 0 && dimArticulo[Tipo Artículo Código] <> "pt" && dimArticulo[Tipo Artículo Código] <> "prvta"),
    "ConsumoPromedio", [Consumo Promedio por Mes Activo],
    "StockExistencia", [Stock Existencia],
    "AlertaCobertura", [Alerta Cobertura],
    "CoberturaMeses", [Cobertura Meses sobre Existencia]
)
ORDER BY dimArticulo[Clase Nombre], dimArticulo[Artículo Código]
"@
$data1 = Invoke-DaxQuery -Query $q1 -Port $port
Write-Host "  Got $($data1.Count) rows" -ForegroundColor Green

# Query 2: Foreign + Active Consumption
Write-Host "`nQuery 2: Foreign + Active Consumption..." -ForegroundColor Yellow
$q2 = @"
EVALUATE
ADDCOLUMNS(
    FILTER(dimArticulo, dimArticulo[ProveedorPais] <> "UY" && dimArticulo[ProveedorPais] <> "" && [Consumo Promedio por Mes Activo] > 0),
    "ConsumoPromedio", [Consumo Promedio por Mes Activo],
    "StockExistencia", [Stock Existencia],
    "AlertaCobertura", [Alerta Cobertura],
    "CoberturaMeses", [Cobertura Meses sobre Existencia]
)
ORDER BY dimArticulo[Clase Nombre], dimArticulo[Artículo Código]
"@
$data2 = Invoke-DaxQuery -Query $q2 -Port $port
Write-Host "  Got $($data2.Count) rows" -ForegroundColor Green

# Export to CSV for Excel processing
$csv1 = "$outputDir\sheet1_stockmin.csv"
$csv2 = "$outputDir\sheet2_foreign.csv"

$data1 | Select-Object @(
    @{N='Codigo';E={$_.'dimArticulo[Artículo Código]'}},
    @{N='Nombre';E={$_.'dimArticulo[Artículo Nombre]'}},
    @{N='TipoArticulo';E={$_.'dimArticulo[Tipo Artículo Código]'}},
    @{N='Clase';E={$_.'dimArticulo[Clase Nombre]'}},
    @{N='TipoComponente';E={$_.'dimArticulo[TipoComponente]'}},
    @{N='Proveedor';E={$_.'dimArticulo[Proveedor Nombre]'}},
    @{N='ProveedorPais';E={$_.'dimArticulo[ProveedorPais]'}},
    @{N='StockMinimo';E={$_.'dimArticulo[Artículo Stock Mínimo]'}},
    @{N='Plazo';E={$_.'dimArticulo[plazo]'}},
    @{N='UnidadStock';E={$_.'dimArticulo[Unidad Stock]'}},
    @{N='ConsumoPromedio';E={if($_.'[ConsumoPromedio]'){[math]::Round([double]$_.'[ConsumoPromedio]',2)}else{$null}}},
    @{N='StockExistencia';E={if($_.'[StockExistencia]'){[math]::Round([double]$_.'[StockExistencia]',2)}else{$null}}},
    @{N='AlertaCobertura';E={$_.'[AlertaCobertura]'}},
    @{N='CoberturaMeses';E={if($_.'[CoberturaMeses]'){[math]::Round([double]$_.'[CoberturaMeses]',1)}else{$null}}}
) | Export-Csv -Path $csv1 -NoTypeInformation -Encoding UTF8

$data2 | Select-Object @(
    @{N='Codigo';E={$_.'dimArticulo[Artículo Código]'}},
    @{N='Nombre';E={$_.'dimArticulo[Artículo Nombre]'}},
    @{N='TipoArticulo';E={$_.'dimArticulo[Tipo Artículo Código]'}},
    @{N='Clase';E={$_.'dimArticulo[Clase Nombre]'}},
    @{N='TipoComponente';E={$_.'dimArticulo[TipoComponente]'}},
    @{N='Proveedor';E={$_.'dimArticulo[Proveedor Nombre]'}},
    @{N='ProveedorPais';E={$_.'dimArticulo[ProveedorPais]'}},
    @{N='StockMinimo';E={$_.'dimArticulo[Artículo Stock Mínimo]'}},
    @{N='Plazo';E={$_.'dimArticulo[plazo]'}},
    @{N='UnidadStock';E={$_.'dimArticulo[Unidad Stock]'}},
    @{N='ConsumoPromedio';E={if($_.'[ConsumoPromedio]'){[math]::Round([double]$_.'[ConsumoPromedio]',2)}else{$null}}},
    @{N='StockExistencia';E={if($_.'[StockExistencia]'){[math]::Round([double]$_.'[StockExistencia]',2)}else{$null}}},
    @{N='AlertaCobertura';E={$_.'[AlertaCobertura]'}},
    @{N='CoberturaMeses';E={if($_.'[CoberturaMeses]'){[math]::Round([double]$_.'[CoberturaMeses]',1)}else{$null}}}
) | Export-Csv -Path $csv2 -NoTypeInformation -Encoding UTF8

Write-Host "`nCSVs exported:" -ForegroundColor Green
Write-Host "  $csv1 ($($data1.Count) rows)"
Write-Host "  $csv2 ($($data2.Count) rows)"

# Now build the Excel with ImportExcel
Import-Module ImportExcel

$excelPath = "$outputDir\EPSA_Compras_Exterior_Conciliacion.xlsx"
if (Test-Path $excelPath) { Remove-Item $excelPath -Force }

# Sheet 1
$sheet1Data = Import-Csv $csv1
$sheet1Data | Export-Excel -Path $excelPath -WorksheetName "StockMin_729" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium2

# Sheet 2
$sheet2Data = Import-Csv $csv2
$sheet2Data | Export-Excel -Path $excelPath -WorksheetName "Foreign_Consumo_737" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium6

# Sheet 3: Rosana's Excel with cross-reference
$excelRosana = "$projectRoot\docs\excel\Pedidos a exterior 2026.04.09.xlsx"
$rosanaData = Import-Excel -Path $excelRosana -WorksheetName "actual"

$codesS1 = @{}; $sheet1Data | ForEach-Object { $codesS1[$_.Codigo.Trim()] = $true }
$codesS2 = @{}; $sheet2Data | ForEach-Object { $codesS2[$_.Codigo.Trim()] = $true }

$codeCol = 'Codigo '  # From previous run we know it has trailing space
$sheet3Data = $rosanaData | Select-Object *, @{
    N='En_StockMin_729'; E={ $c = $_.$codeCol; if ($c -and $codesS1.ContainsKey($c.ToString().Trim())) {"SI"} else {"NO"} }
}, @{
    N='En_Foreign_737'; E={ $c = $_.$codeCol; if ($c -and $codesS2.ContainsKey($c.ToString().Trim())) {"SI"} else {"NO"} }
}

$sheet3Data | Export-Excel -Path $excelPath -WorksheetName "Excel_Rosana_329" -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium9

Write-Host "`n=== Excel complete: $excelPath ===" -ForegroundColor Green
Write-Host "  Sheet 1: StockMin_729 = $($sheet1Data.Count) rows"
Write-Host "  Sheet 2: Foreign_Consumo_737 = $($sheet2Data.Count) rows"
Write-Host "  Sheet 3: Excel_Rosana_329 = $($sheet3Data.Count) rows"

# Clean temp CSVs
Remove-Item $csv1, $csv2 -Force -ErrorAction SilentlyContinue
