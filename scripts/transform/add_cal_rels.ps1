# Add Calendario relationships to SSAS model via AMO
$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SSAS_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

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

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    Write-Output "Tables: $($db.Model.Tables.Count), Relationships: $($db.Model.Relationships.Count)"

    # Define Calendario relationships
    $rels = @(
        @{ FromTable = "factConsumoHistoria"; FromColumn = "Consumo Fecha"; ToColumn = "Fecha" }
        @{ FromTable = "factStockEPSA"; FromColumn = "Stock Fecha_Corte"; ToColumn = "Fecha" }
        @{ FromTable = "factConsumoPlanificado"; FromColumn = "Consumo Planificado Fecha Planificacion"; ToColumn = "Fecha" }
        @{ FromTable = "factRecepcionesHistoria"; FromColumn = "RecepcionFecha"; ToColumn = "Fecha" }
    )
    
    foreach ($r in $rels) {
        $fromTable = $db.Model.Tables | Where-Object { $_.Name -eq $r.FromTable }
        $toTable = $db.Model.Tables | Where-Object { $_.Name -eq "Calendario" }
        $fromCol = $fromTable.Columns | Where-Object { $_.Name -eq $r.FromColumn }
        $toCol = $toTable.Columns | Where-Object { $_.Name -eq $r.ToColumn }
        
        if (-not $fromCol -or -not $toCol) {
            Write-Output "  SKIP: $($r.FromTable).$($r.FromColumn) -> Calendario.$($r.ToColumn) (column not found)"
            continue
        }
        
        # Check if relationship already exists
        $existing = $db.Model.Relationships | Where-Object { 
            $_.FromColumn -eq $fromCol -and $_.ToColumn -eq $toCol 
        }
        if ($existing) {
            Write-Output "  EXISTS: $($r.FromTable).$($r.FromColumn) -> Calendario.Fecha"
            continue
        }
        
        $rel = New-Object Microsoft.AnalysisServices.Tabular.SingleColumnRelationship
        $rel.FromColumn = $fromCol
        $rel.ToColumn = $toCol
        $rel.IsActive = $true
        $rel.Name = "$($r.FromTable)-Calendario-$($r.FromColumn)"
        $db.Model.Relationships.Add($rel)
        Write-Output "  ADDED: $($r.FromTable).$($r.FromColumn) -> Calendario.Fecha"
    }
    
    try {
        $db.Model.SaveChanges()
        Write-Output "`nRelationships saved!"
    } catch {
        Write-Output "`nSaveChanges FAILED: $_"
    }
    
    $ssas.Disconnect()
}

$result | ForEach-Object { Write-Host $_ }
