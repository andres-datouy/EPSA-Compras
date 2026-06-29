# Verify staging table columns match SSAS model column names
$ssasUser = "EXLER-SERVER\schaaf_ssas"
$ssasPass = "Saas 244050@"
$cred = New-Object PSCredential($ssasUser, (ConvertTo-SecureString $ssasPass -AsPlainText -Force))

$result = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    $output = @()
    
    # Staging connection
    $stgConn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=10")
    $stgConn.Open()
    
    $mapping = @(
        @{ Staging = "dbo.stg_dimArticulo"; SSAS = "dimArticulo" }
        @{ Staging = "dbo.stg_dimProveedor"; SSAS = "dimProveedor" }
        @{ Staging = "dbo.stg_factComprasEnProceso"; SSAS = "factComprasEnProceso" }
        @{ Staging = "dbo.stg_factConsumo"; SSAS = "factConsumoHistoria" }
        @{ Staging = "dbo.stg_factConsumoPlanificado"; SSAS = "factConsumoPlanificado" }
        @{ Staging = "dbo.stg_factDemandaPendiente"; SSAS = "factDemandaPendientePlanificacion" }
        @{ Staging = "dbo.stg_factRecepcionesHistoria"; SSAS = "factRecepcionesHistoria" }
        @{ Staging = "dbo.stg_factStockEPSA"; SSAS = "factStockEPSA" }
    )
    
    foreach ($m in $mapping) {
        $output += "`n=== $($m.SSAS) vs $($m.Staging) ==="
        
        # Get staging columns
        $cmd = $stgConn.CreateCommand()
        $cmd.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='$($m.Staging.Split('.')[1])' ORDER BY ORDINAL_POSITION"
        $reader = $cmd.ExecuteReader()
        $stgCols = @()
        while ($reader.Read()) { $stgCols += $reader[0] }
        $reader.Close()
        
        $output += "  Staging columns ($($stgCols.Count)): $($stgCols -join ', ')"
    }
    
    $stgConn.Close()
    
    # Now get SSAS column names via AMO
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    
    foreach ($m in $mapping) {
        $table = $db.Model.Tables | Where-Object { $_.Name -eq $m.SSAS }
        if ($table) {
            $ssasCols = @()
            foreach ($col in $table.Columns) {
                if ($col.Type -eq "data") { $ssasCols += $col.Name }
            }
            $output += "  SSAS columns ($($ssasCols.Count)): $($ssasCols -join ', ')"
            
            # Get staging columns again for comparison
            $stgConn2 = New-Object System.Data.SqlClient.SqlConnection("Server=localhost,1435;Database=staging_compras;User Id=app_compras;Password=Saas 244050@;Connect Timeout=10")
            $stgConn2.Open()
            $cmd2 = $stgConn2.CreateCommand()
            $cmd2.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='$($m.Staging.Split('.')[1])' ORDER BY ORDINAL_POSITION"
            $reader2 = $cmd2.ExecuteReader()
            $stgCols2 = @()
            while ($reader2.Read()) { $stgCols2 += $reader2[0] }
            $reader2.Close()
            $stgConn2.Close()
            
            # Compare
            $missing = $ssasCols | Where-Object { $_ -notin $stgCols2 }
            $extra = $stgCols2 | Where-Object { $_ -notin $ssasCols }
            
            if ($missing.Count -eq 0 -and $extra.Count -eq 0) {
                $output += "  MATCH: All columns align perfectly!"
            } else {
                if ($missing.Count -gt 0) { $output += "  MISSING from staging: $($missing -join ', ')" }
                if ($extra.Count -gt 0) { $output += "  EXTRA in staging (not in SSAS): $($extra -join ', ')" }
            }
        }
    }
    
    $ssas.Disconnect()
    return $output
}

Write-Host ($result -join "`n") -ForegroundColor White
