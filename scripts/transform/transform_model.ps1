# =====================================================
# Transform Model: Rewrite Data Sources to staging_compras
# Reads: model/database.json
# Writes: model/database_staging.json (ready for deployment)
# =====================================================

param(
    [string]$InputFile = "$PSScriptRoot\..\model\database.json",
    [string]$OutputFile = "$PSScriptRoot\..\model\database_staging.json",
    [string]$StagingServer = "192.168.2.47,1435",
    [string]$StagingDatabase = "staging_compras"
)

$ErrorActionPreference = "Stop"

Write-Host "Reading model from: $InputFile" -ForegroundColor Yellow
$json = Get-Content $InputFile -Raw -Encoding UTF8 | ConvertFrom-Json

$server = $StagingServer
$db = $StagingDatabase
Write-Host "Target: $server / $db" -ForegroundColor Green

# --- New M partition expressions ---
$newPartitions = @{}

$newPartitions["dimArticulo"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_dimArticulo"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Articulo Codigo", "Artículo Código"},
        {"Articulo Nombre", "Artículo Nombre"},
        {"Articulo Catalogo", "Artículo Catalogo"},
        {"Tipo Articulo Codigo", "Tipo Artículo Código"},
        {"Tipo Articulo Nombre", "Tipo de Artículo Nombre"},
        {"Marca Codigo", "Marca Código"},
        {"Marca Descripcion", "Marca Descripción"},
        {"Clase Codigo", "Clase Código"},
        {"Familia Codigo", "Familia Código"},
        {"Subfamilia Codigo", "Subfamilia Código"},
        {"Grupo Contable de Venta Codigo", "Grupo Contable de Venta Código"},
        {"Articulo Stock Minimo", "Artículo Stock Mínimo"},
        {"Lote Minimo Compra", "Lote Mínimo Compra"},
        {"Proveedor Articulo", "Proveedor Articulo"}
    })
in
    #"Renamed"
"@

$newPartitions["dimProveedor"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_dimProveedor"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Proveedor Direccion", "Proveedor Dirección"},
        {"Proveedor Telefono", "Proveedor Teléfono"},
        {"Pais Codigo", "País Código"},
        {"Pais Nombre", "País Nombre"}
    })
in
    #"Renamed"
"@

$newPartitions["factStockEPSA"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factStockEPSA"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Stock Articulo Codigo", "Stock Artículo Código"}
    })
in
    #"Renamed"
"@

$newPartitions["factConsumoHistoria"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factConsumoHistoria"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Consumo Articulo Codigo", "Consumo Artículo Código"},
        {"Consumo N Documento", "Consumo Nº Documento"}
    })
in
    #"Renamed"
"@

$newPartitions["factConsumoPlanificado"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factConsumoPlanificado"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Consumo Planificado Articulo", "Consumo Planificado Artículo"},
        {"Consumo Planificado N Paso Orden", "Consumo Planificado Nº Paso Orden"}
    })
in
    #"Renamed"
"@

$newPartitions["factRecepcionesHistoria"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factRecepcionesHistoria"]}[Data],
    #"Extracted Date" = Table.TransformColumns(t,{
        {"RecepcionFecha", DateTime.Date, type date},
        {"OC Fecha", DateTime.Date, type date},
        {"Compra Fecha", DateTime.Date, type date}
    })
in
    #"Extracted Date"
"@

$newPartitions["factComprasEnProceso"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factComprasEnProceso"]}[Data]
in
    t
"@

$newPartitions["factDemandaPendientePlanificacion"] = @"
let
    Source = Sql.Database("$server", "$db"),
    t = Source{[Schema="dbo",Item="stg_factDemandaPendiente"]}[Data],
    #"Renamed" = Table.RenameColumns(t,{
        {"Demanda Pendiente Componente Codigo", "Demanda Pendiente Componente Código"},
        {"Tipo Ficha", "Demanda Pendiente Componente Tipo Ficha"},
        {"Articulo Pedido x Cliente", "Demanda Pendiente Articulo Pedido x Cliente"}
    })
in
    #"Renamed"
"@

# --- Remove unwanted tables ---
$tablesToRemove = @("00_Run_Staging", "DateAutoTemplate")
$originalCount = $json.model.tables.Count
$json.model.tables = @($json.model.tables | Where-Object { $tablesToRemove -notcontains $_.name })
$tablesRemoved = $originalCount - $json.model.tables.Count
Write-Host "Removed $tablesRemoved tables: $($tablesToRemove -join ', ')" -ForegroundColor Green

# --- Modify partition expressions ---
$tablesModified = 0
foreach ($table in $json.model.tables) {
    if ($newPartitions.ContainsKey($table.name)) {
        if ($table.partitions -and $table.partitions.Count -gt 0) {
            $table.partitions[0].source.expression = $newPartitions[$table.name]
            $table.partitions[0].source.PSObject.Properties.Remove('format')
            $tablesModified++
            Write-Host "  Modified: $($table.name)" -ForegroundColor Cyan
        }
    }
}
Write-Host "Modified $tablesModified partition expressions" -ForegroundColor Green

# --- Replace Calendario with CALENDARAUTO(6) ---
$calendarioTable = $json.model.tables | Where-Object { $_.name -eq "Calendario" }
if ($calendarioTable) {
    $calendarioTable.partitions = @(
        [PSCustomObject]@{
            "name" = "Calendario"
            "source" = [PSCustomObject]@{
                "type" = "calculated"
                "expression" = "CALENDARAUTO(6)"
            }
        }
    )
    
    # Keep only essential columns + add calculated ones
    $calendarioTable.columns = @(
        [PSCustomObject]@{
            "name" = "Fecha"
            "dataType" = "dateTime"
            "isKey" = $true
            "sourceColumn" = "[Date]"
            "formatString" = "Short Date"
            "summarizeBy" = "none"
            "lineageTag" = "cal-fecha"
        }
        [PSCustomObject]@{
            "name" = "Año"
            "dataType" = "int64"
            "type" = "calculated"
            "expression" = "YEAR(Calendario[Fecha])"
            "summarizeBy" = "none"
            "lineageTag" = "cal-ano"
        }
        [PSCustomObject]@{
            "name" = "Mes Número"
            "dataType" = "int64"
            "isHidden" = $true
            "type" = "calculated"
            "expression" = "MONTH(Calendario[Fecha])"
            "summarizeBy" = "none"
            "lineageTag" = "cal-mesnum"
        }
        [PSCustomObject]@{
            "name" = "Mes"
            "dataType" = "string"
            "type" = "calculated"
            "expression" = "FORMAT(Calendario[Fecha], ""MMMM"")"
            "sortByColumn" = "Mes Número"
            "summarizeBy" = "none"
            "lineageTag" = "cal-mes"
        }
        [PSCustomObject]@{
            "name" = "Año Mes"
            "dataType" = "string"
            "type" = "calculated"
            "expression" = "FORMAT(Calendario[Fecha], ""YYYY-MM"")"
            "summarizeBy" = "none"
            "lineageTag" = "cal-anomes"
        }
        [PSCustomObject]@{
            "name" = "Año Mes Número"
            "dataType" = "int64"
            "isHidden" = $true
            "type" = "calculated"
            "expression" = "YEAR(Calendario[Fecha]) * 100 + MONTH(Calendario[Fecha])"
            "summarizeBy" = "none"
            "lineageTag" = "cal-anomesnum"
        }
        [PSCustomObject]@{
            "name" = "Trimestre"
            "dataType" = "string"
            "type" = "calculated"
            "expression" = """Q"" & FORMAT(Calendario[Fecha], ""Q"")"
            "summarizeBy" = "none"
            "lineageTag" = "cal-trim"
        }
        [PSCustomObject]@{
            "name" = "Año Fiscal"
            "dataType" = "string"
            "type" = "calculated"
            "expression" = "VAR m = MONTH(Calendario[Fecha]) RETURN IF(m >= 7, ""FY "" & YEAR(Calendario[Fecha]) & ""-"" & (YEAR(Calendario[Fecha])+1), ""FY "" & (YEAR(Calendario[Fecha])-1) & ""-"" & YEAR(Calendario[Fecha]))"
            "summarizeBy" = "none"
            "lineageTag" = "cal-anofiscal"
        }
        [PSCustomObject]@{
            "name" = "Año Fiscal Número"
            "dataType" = "int64"
            "isHidden" = $true
            "type" = "calculated"
            "expression" = "IF(MONTH(Calendario[Fecha]) >= 7, YEAR(Calendario[Fecha]), YEAR(Calendario[Fecha]) - 1)"
            "summarizeBy" = "none"
            "lineageTag" = "cal-anofiscalnum"
        }
        [PSCustomObject]@{
            "name" = "Fiscal Month"
            "dataType" = "string"
            "type" = "calculated"
            "expression" = "VAR m = MONTH(Calendario[Fecha]) RETURN IF(m >= 7, FORMAT(DATE(2000,m,1),""MMMM""), FORMAT(DATE(2000,m,1),""MMMM""))"
            "summarizeBy" = "none"
            "lineageTag" = "cal-fiscalmonth"
        }
    )
    
    Write-Host "  Replaced Calendario with CALENDARAUTO(6) + calculated columns" -ForegroundColor Cyan
}

# --- Remove RecepcionArticuloTipo column from factRecepcionesHistoria (not in staging) ---
$recepcionesTable = $json.model.tables | Where-Object { $_.name -eq "factRecepcionesHistoria" }
if ($recepcionesTable) {
    $recepcionesTable.columns = @($recepcionesTable.columns | Where-Object { $_.name -ne "RecepcionArticuloTipo" })
    Write-Host "  Removed RecepcionArticuloTipo column from factRecepcionesHistoria" -ForegroundColor Yellow
}

# --- Rename database ---
$json.name = "Compras_EPSA"

# --- Remove timestamps that would conflict on deploy ---
$json.PSObject.Properties.Remove('createdTimestamp')
$json.PSObject.Properties.Remove('lastUpdate')
$json.PSObject.Properties.Remove('lastSchemaUpdate')
$json.PSObject.Properties.Remove('lastProcessed')

# --- Write output ---
Write-Host "Writing transformed model to: $OutputFile" -ForegroundColor Yellow
$json | ConvertTo-Json -Depth 100 | Out-File -FilePath $OutputFile -Encoding UTF8 -NoNewline:$false

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TRANSFORMATION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tables: $($json.model.tables.Count) (removed: $tablesRemoved)"
Write-Host "Partitions rewritten: $tablesModified"
Write-Host "Calendario: CALENDARAUTO(6) + 10 calculated columns"
Write-Host "Removed: RecepcionArticuloTipo (not in staging)"
Write-Host "Output: $OutputFile"
Write-Host ""
Write-Host "Next: Deploy database_staging.json to SSAS" -ForegroundColor Yellow
