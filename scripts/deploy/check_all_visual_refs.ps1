# Check all visual MEASURE references against the LIVE SSAS model
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" -ErrorAction SilentlyContinue | Where-Object { $_ -match "SSAS_PASS" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

# First, get the live model structure from SSAS
$liveModel = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }

    $result = @{}
    foreach ($t in $db.Model.Tables) {
        $measures = @()
        foreach ($m in $t.Measures) { $measures += $m.Name }
        $cols = @()
        foreach ($c in $t.Columns) { $cols += $c.Name }
        $result[$t.Name] = @{ Measures = $measures; Columns = $cols }
    }

    $ssas.Disconnect()
    return $result
}

# Build lookups from live model
$measureLookup = @{}
$columnLookup = @{}
foreach ($tname in $liveModel.Keys) {
    $measureLookup[$tname] = @{}
    foreach ($m in $liveModel[$tname].Measures) {
        $measureLookup[$tname][$m] = $true
    }
    $columnLookup[$tname] = @{}
    foreach ($c in $liveModel[$tname].Columns) {
        $columnLookup[$tname][$c] = $true
    }
}

# Scan all visual.json files
$pagesDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages"
$pageDirs = Get-ChildItem -Path $pagesDir -Directory

$errors = @()
foreach ($pageDir in $pageDirs) {
    $pageJsonFile = Join-Path $pageDir.FullName "page.json"
    $pageName = "unknown"
    if (Test-Path $pageJsonFile) {
        $pj = Get-Content $pageJsonFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $pageName = $pj.displayName
    }

    $visualsDir = Join-Path $pageDir.FullName "visuals"
    if (-not (Test-Path $visualsDir)) { continue }

    $visualDirs = Get-ChildItem -Path $visualsDir -Directory
    foreach ($vDir in $visualDirs) {
        $vFile = Join-Path $vDir.FullName "visual.json"
        if (-not (Test-Path $vFile)) { continue }

        $vContent = Get-Content $vFile -Raw -Encoding UTF8
        $pattern = '"Measure":\s*\{[^}]*"SourceRef":\s*\{[^}]*"Entity":\s*"([^"]+)"[^}]*\}[^}]*"Property":\s*"([^"]+)"'
        $found = [regex]::Matches($vContent, $pattern)

        foreach ($match in $found) {
            $entity = $match.Groups[1].Value
            $prop = $match.Groups[2].Value

            $isMeasure = ($measureLookup.ContainsKey($entity) -and $measureLookup[$entity].ContainsKey($prop))
            $isColumn = ($columnLookup.ContainsKey($entity) -and $columnLookup[$entity].ContainsKey($prop))

            if (-not $isMeasure -and -not $isColumn) {
                # Search where it actually exists
                $foundElsewhere = $false
                foreach ($tname in $measureLookup.Keys) {
                    if ($measureLookup[$tname].ContainsKey($prop)) {
                        $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> WRONG TABLE! Should be '$tname'"
                        $foundElsewhere = $true
                        break
                    }
                }
                if (-not $foundElsewhere) {
                    foreach ($tname in $columnLookup.Keys) {
                        if ($columnLookup[$tname].ContainsKey($prop)) {
                            $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> WRONG TABLE! Found as column in '$tname'"
                            $foundElsewhere = $true
                            break
                        }
                    }
                }
                if (-not $foundElsewhere) {
                    if (-not $measureLookup.ContainsKey($entity) -and -not $columnLookup.ContainsKey($entity)) {
                        $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | Table '$entity' does NOT exist in live model"
                    } else {
                        $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> NOT FOUND anywhere in live model"
                    }
                }
            }
        }
    }
}

if ($errors.Count -eq 0) {
    Write-Host "ALL CLEAR: All visual measure references match the live SSAS model." -ForegroundColor Green
} else {
    Write-Host "FOUND $($errors.Count) MISMATCHES:" -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host "  $e" -ForegroundColor Yellow
    }
}
# Check all visual MEASURE references (not hierarchies) against actual model measures
$modelJson = Get-Content "d:\Andres\Dev\EPSA-Compras\model\database_staging_fixed.json" -Raw -Encoding UTF8
$model = $modelJson | ConvertFrom-Json

# Build lookup: TableName -> set of measure names
$measureLookup = @{}
$columnLookup = @{}
foreach ($table in $model.model.tables) {
    $tname = $table.name
    $measureLookup[$tname] = @{}
    if ($table.measures) {
        foreach ($m in $table.measures) {
            $measureLookup[$tname][$m.name] = $true
        }
    }
    $columnLookup[$tname] = @{}
    if ($table.columns) {
        foreach ($c in $table.columns) {
            $columnLookup[$tname][$c.name] = $true
        }
    }
}

# Scan all visual.json files
$pagesDir = "d:\Andres\Dev\EPSA-Compras\EPSA-Compras.Report\definition\pages"
$pageDirs = Get-ChildItem -Path $pagesDir -Directory

$errors = @()
foreach ($pageDir in $pageDirs) {
    $pageJsonFile = Join-Path $pageDir.FullName "page.json"
    $pageName = "unknown"
    if (Test-Path $pageJsonFile) {
        $pj = Get-Content $pageJsonFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $pageName = $pj.displayName
    }

    $visualsDir = Join-Path $pageDir.FullName "visuals"
    if (-not (Test-Path $visualsDir)) { continue }

    $visualDirs = Get-ChildItem -Path $visualsDir -Directory
    foreach ($vDir in $visualDirs) {
        $vFile = Join-Path $vDir.FullName "visual.json"
        if (-not (Test-Path $vFile)) { continue }

        $vContent = Get-Content $vFile -Raw -Encoding UTF8
        # Match ONLY Measure context: "Measure": { "Expression": { "SourceRef": { "Entity": "X" } }, "Property": "Y" }
        $pattern = '"Measure":\s*\{[^}]*"SourceRef":\s*\{[^}]*"Entity":\s*"([^"]+)"[^}]*\}[^}]*"Property":\s*"([^"]+)"'
        $found = [regex]::Matches($vContent, $pattern)

        foreach ($match in $found) {
            $entity = $match.Groups[1].Value
            $prop = $match.Groups[2].Value

            $isMeasure = $false
            $isColumn = $false
            $entityExists = $false

            if ($measureLookup.ContainsKey($entity)) {
                $entityExists = $true
                if ($measureLookup[$entity].ContainsKey($prop)) {
                    $isMeasure = $true
                }
            }
            if ($columnLookup.ContainsKey($entity)) {
                $entityExists = $true
                if ($columnLookup[$entity].ContainsKey($prop)) {
                    $isColumn = $true
                }
            }

            if (-not $entityExists) {
                $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | Table '$entity' does NOT exist in model"
            }
            elseif (-not $isMeasure -and -not $isColumn) {
                $foundElsewhere = $false
                foreach ($tname in $measureLookup.Keys) {
                    if ($measureLookup[$tname].ContainsKey($prop)) {
                        $foundElsewhere = $true
                        $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> NOT in '$entity' but FOUND in '$tname'"
                        break
                    }
                }
                if (-not $foundElsewhere) {
                    foreach ($tname in $columnLookup.Keys) {
                        if ($columnLookup[$tname].ContainsKey($prop)) {
                            $foundElsewhere = $true
                            $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> NOT in '$entity' but FOUND as column in '$tname'"
                            break
                        }
                    }
                }
                if (-not $foundElsewhere) {
                    $errors += "PAGE [$pageName] | VISUAL $($vDir.Name) | $entity.$prop -> NOT FOUND ANYWHERE in model"
                }
            }
        }
    }
}

if ($errors.Count -eq 0) {
    Write-Host "ALL CLEAR: No broken measure/column references found in any visual." -ForegroundColor Green
} else {
    Write-Host "FOUND $($errors.Count) BROKEN REFERENCES:" -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host "  $e" -ForegroundColor Yellow
    }
}
