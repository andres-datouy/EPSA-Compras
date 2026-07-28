$sqlPass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" | Where-Object { $_ -match "^SQL_PASSWORD=" } | ForEach-Object { ($_ -split "=", 2)[1] }
# Phase 5 Deploy: factVencimientos table + expiry measures
# Step 1: Deploy SQL to staging (create table + SP + initial load)
# Step 2: Add table + relationship to SSAS model via TMSL
# Step 3: Process the new table

$pass = Get-Content "d:\Andres\Dev\EPSA-Compras\.env.local" -ErrorAction SilentlyContinue | Where-Object { $_ -match "SSAS_PASS" } | ForEach-Object { ($_ -split "=", 2)[1] }
if (-not $pass) { throw "SSAS_PASSWORD no encontrado en .env.local" }
$cred = New-Object PSCredential("EXLER-SERVER\schaaf_ssas", (ConvertTo-SecureString $pass -AsPlainText -Force))

# === STEP 1: Deploy SQL to staging database ===
Write-Host "=== Step 1: Deploy SQL to staging database ===" -ForegroundColor Cyan

$sqlResult = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    param($sqlScript)
    $output = @()
    
    # Write SQL to temp file
    $tempFile = "C:\temp\deploy_factVencimientos.sql"
    if (-not (Test-Path "C:\temp")) { New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null }
    Set-Content -Path $tempFile -Value $sqlScript -Encoding UTF8
    
    # Execute with sqlcmd
    $result = & "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE" -S "localhost,1435" -U "sa" -P "$using:sqlPass" -d "staging_compras" -i $tempFile 2>&1
    $output += $result
    
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    return $output
} -ArgumentList (Get-Content "d:\Andres\Dev\EPSA-Compras\scripts\sql\ssas_staging\12_factVencimientos.sql" -Raw -Encoding UTF8)

Write-Host ($sqlResult -join "`n") -ForegroundColor White

# === STEP 2: Add table + relationship to SSAS model ===
Write-Host "`n=== Step 2: Add factVencimientos to SSAS model ===" -ForegroundColor Cyan

$tmslResult = Invoke-Command -ComputerName 192.168.2.47 -Credential $cred -Authentication Negotiate -ScriptBlock {
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\170\DTS\Binn\Microsoft.AnalysisServices.Tabular.dll"
    $output = @()

    $ssas = New-Object Microsoft.AnalysisServices.Tabular.Server
    $ssas.Connect("Data Source=localhost:2383")
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }

    # Check if table already exists
    $existing = $db.Model.Tables["factVencimientos"]
    if ($existing) {
        $output += "Table factVencimientos already exists. Removing old version..."
        $db.Model.Tables.Remove($existing)
    }

    # TMSL to create the table
    $tmsl = @"
{
  "createOrReplace": {
    "object": {
      "database": "Compras_EPSA",
      "table": "factVencimientos"
    },
    "table": {
      "name": "factVencimientos",
      "columns": [
        { "name": "Vencimiento Articulo Codigo", "dataType": "string", "sourceColumn": "cod_articulo", "summarizeBy": "none" },
        { "name": "Vencimiento Nro Lote", "dataType": "string", "sourceColumn": "nro_lote", "summarizeBy": "none" },
        { "name": "Vencimiento Cantidad", "dataType": "double", "sourceColumn": "cantidad", "formatString": "#,0", "summarizeBy": "sum" },
        { "name": "Vencimiento Fecha", "dataType": "dateTime", "sourceColumn": "fec_venc", "formatString": "dd/MM/yyyy", "summarizeBy": "none" }
      ],
      "partitions": [
        {
          "name": "factVencimientos-Partition",
          "mode": "import",
          "source": {
            "type": "query",
            "query": "SELECT [cod_articulo], [nro_lote], [cantidad], [fec_venc] FROM [dbo].[stg_factVencimientos]",
            "dataSource": "staging_compras"
          }
        }
      ],
      "measures": [
        {
          "name": "Stock Por Vencer 30d",
          "expression": "VAR FechaHoy = TODAY()\nVAR FechaLimite = FechaHoy + 30\nRETURN\nCALCULATE(\n    SUM(factVencimientos[Vencimiento Cantidad]),\n    factVencimientos[Vencimiento Fecha] >= FechaHoy,\n    factVencimientos[Vencimiento Fecha] <= FechaLimite\n)",
          "formatString": "#,0"
        },
        {
          "name": "Stock Por Vencer 90d",
          "expression": "VAR FechaHoy = TODAY()\nVAR FechaLimite = FechaHoy + 90\nRETURN\nCALCULATE(\n    SUM(factVencimientos[Vencimiento Cantidad]),\n    factVencimientos[Vencimiento Fecha] >= FechaHoy,\n    factVencimientos[Vencimiento Fecha] <= FechaLimite\n)",
          "formatString": "#,0"
        },
        {
          "name": "Stock Vencido",
          "expression": "CALCULATE(\n    SUM(factVencimientos[Vencimiento Cantidad]),\n    factVencimientos[Vencimiento Fecha] < TODAY()\n)",
          "formatString": "#,0"
        },
        {
          "name": "Stock Vencido USD",
          "expression": "SUMX(\n    FILTER(\n        factVencimientos,\n        factVencimientos[Vencimiento Fecha] < TODAY()\n    ),\n    factVencimientos[Vencimiento Cantidad] * [Costo Unitario Promedio USD]\n)",
          "formatString": "$#,0.00"
        },
        {
          "name": "% Stock Por Vencer",
          "expression": "VAR StockPorVencer = [Stock Por Vencer 30d]\nVAR StockTotal = SUMX(ALL(factVencimientos), factVencimientos[Vencimiento Cantidad])\nRETURN\nDIVIDE(StockPorVencer, StockTotal, 0)",
          "formatString": "0.00%"
        }
      ]
    }
  }
}
"@

    try {
        $r = $ssas.Execute($tmsl)
        if ($r -and $r.ContainsErrors) {
            foreach ($m in $r.Messages) {
                $output += "TMSL ERROR: $($m.Text)"
            }
        } else {
            $output += "Table created successfully"
        }
    } catch {
        $output += "EXCEPTION: $_"
    }

    # Create relationship: factVencimientos -> dimArticulo
    $output += "Creating relationship factVencimientos -> dimArticulo..."
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    
    $factTbl = $db.Model.Tables["factVencimientos"]
    $dimTbl = $db.Model.Tables["dimArticulo"]
    
    # Check if relationship already exists
    $existingRel = $db.Model.Relationships | Where-Object { $_.FromTable -eq $factTbl -and $_.FromColumn.Name -eq "Vencimiento Articulo Codigo" }
    if ($existingRel) {
        $output += "Relationship already exists, skipping"
    } else {
        $rel = New-Object Microsoft.AnalysisServices.Tabular.SingleColumnRelationship
        $rel.FromColumn = $factTbl.Columns["Vencimiento Articulo Codigo"]
        $rel.ToColumn = $dimTbl.Columns["Artículo Código"]
        $rel.FromCardinality = [Microsoft.AnalysisServices.Tabular.RelationshipEndCardinality]::Many
        $rel.ToCardinality = [Microsoft.AnalysisServices.Tabular.RelationshipEndCardinality]::One
        $rel.IsActive = $true
        $db.Model.Relationships.Add($rel)
        $output += "Relationship created"
    }

    # Process the new table
    $output += "Processing factVencimientos table..."
    try {
        $refreshTmsl = @"
{
  "refresh": {
    "type": "automatic",
    "objects": [
      {
        "database": "Compras_EPSA",
        "table": "factVencimientos"
      }
    ]
  }
}
"@
        $r2 = $ssas.Execute($refreshTmsl)
        if ($r2 -and $r2.ContainsErrors) {
            foreach ($m in $r2.Messages) {
                $output += "REFRESH ERROR: $($m.Text)"
            }
        } else {
            $output += "Table processed successfully"
        }
    } catch {
        $output += "REFRESH EXCEPTION: $_"
    }

    # Verify
    $ssas.Refresh()
    $db = $ssas.Databases | Where-Object { $_.Name -eq "Compras_EPSA" }
    $tbl = $db.Model.Tables["factVencimientos"]
    if ($tbl) {
        $output += "Verification: Table exists with $($tbl.Measures.Count) measures, $($tbl.Columns.Count) columns"
        foreach ($m in $tbl.Measures) {
            $output += "  Measure: $($m.Name)"
        }
    }
    $output += "Total relationships in model: $($db.Model.Relationships.Count)"

    $ssas.Disconnect()
    return $output
}

Write-Host ($tmslResult -join "`n") -ForegroundColor White
