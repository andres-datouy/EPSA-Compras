# create_ssas_staging_issues.ps1
# Creates GitHub issues for the SSAS Staging Data Migration tasks
# Run when GitHub API rate limit resets

param(
    [string]$Owner = "epsa-acunarro",
    [string]$Repo = "EPSA-Compras",
    [string]$Label = "ssas-staging"
)

# Load credentials from .env.local
$envFile = Join-Path $PSScriptRoot "..\.env.local"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^([A-Z_]+)=(.+)$') {
            [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2], "Process")
        }
    }
}

$pat = $env:GITHUB_PAT
if (-not $pat) {
    Write-Host "ERROR: GITHUB_PAT not set. Set it in .env.local or environment." -ForegroundColor Red
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $pat"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$baseUrl = "https://api.github.com/repos/$Owner/$Repo"

# Step 1: Create label
Write-Host "Creating label '$Label'..." -ForegroundColor Cyan
$labelBody = @{
    name = $Label
    color = "0e8a16"
    description = "SSAS staging database setup - data migration from Power BI to server-side staging"
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/labels" -Method Post -Headers $headers -Body $labelBody -ContentType "application/json"
    Write-Host "  Label created." -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "  Label already exists." -ForegroundColor Yellow
    } else {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 2: Define issues
$issues = @(
    @{
        title = "SSAS Staging #1: Linked Server Setup (BI_SOURCE)"
        body = @"
## Task
Create linked server `BI_SOURCE` on 192.168.2.47\SSAS (port 1435) pointing to 192.168.2.7

## Script
`scripts/sql/ssas_staging/01_linked_server.sql`

## Actions
- [ ] Run script on server via SSMS
- [ ] Validate: `SELECT TOP 1 * FROM [BI_SOURCE].[EPSA_BI].[dbo].[vw_Compras_DimArticuloEPSA]`
- [ ] Confirm RPC enabled for remote SP execution

## Dependencies
None - this is the blocker for all other tasks.
"@
    },
    @{
        title = "SSAS Staging #2: Create staging_compras Database"
        body = @"
## Task
Create `staging_compras` database on 192.168.2.47\SSAS (port 1435)

## Script
`scripts/sql/ssas_staging/02_create_database.sql`

## Actions
- [ ] Run script on server
- [ ] Verify recovery model = SIMPLE
- [ ] Verify stg_refresh_log table created

## Dependencies
- Task #1 (Linked Server) NOT required for this step
"@
    },
    @{
        title = "SSAS Staging #3: Migrate dimArticulo (Full Replace)"
        body = @"
## Task
Create staging table + refresh SP for dimArticulo. Source: `EPSA_BI.dbo.vw_Compras_DimArticuloEPSA`

## Script
`scripts/sql/ssas_staging/03_dimArticulo.sql`

## Refresh Strategy
- Type: FULL REPLACE (truncate + load)
- Schedule: Daily 6:00 AM

## Validation
- [ ] Row count matches source
- [ ] All 22 columns present
"@
    },
    @{
        title = "SSAS Staging #4: Migrate dimProveedor (Full Replace)"
        body = @"
## Task
Create staging table + refresh SP for dimProveedor. Source: Nodum multi-table join

## Script
`scripts/sql/ssas_staging/04_dimProveedor.sql`

## Refresh Strategy
- Type: FULL REPLACE (truncate + load)
- Schedule: Daily 6:00 AM

## Validation
- [ ] Row count matches Power BI model
- [ ] Country names populated correctly
"@
    },
    @{
        title = "SSAS Staging #5: Migrate factStockEPSA (Volatile, Full Replace)"
        body = @"
## Task
Create staging table + refresh SP for current stock levels. Source: `EPSA_BI.dbo.vw_ComprasBI_factStockEPSA`

## Script
`scripts/sql/ssas_staging/05_factStockEPSA.sql`

## Refresh Strategy
- Type: FULL REPLACE (truncate + load) - data is volatile
- Schedule: Every 4 hours

## Validation
- [ ] Stock quantities match ERP
- [ ] Fecha_Corte is current
"@
    },
    @{
        title = "SSAS Staging #6: Migrate factConsumoHistoria (Incremental Append)"
        body = @"
## Task
Create staging table + incremental refresh SP for consumption history. Source: Nodum `cpf_stockaux`

## Script
`scripts/sql/ssas_staging/06_factConsumoHistoria.sql`

## Refresh Strategy
- Type: INCREMENTAL APPEND (only new rows since last load)
- Schedule: Daily 7:00 AM
- History grows over time (5+ years)

## Validation
- [ ] Initial load has ~5 years of data
- [ ] Second run appends 0 rows (no new data)
- [ ] Date range covers 2020-02-01 to today
"@
    },
    @{
        title = "SSAS Staging #7: Migrate factRecepcionesHistoria (Incremental Append)"
        body = @"
## Task
Create staging table + incremental refresh SP for receipt history. Source: `EPSA_BI.dbo.vw_ComprasBI_HistoriaRecepciones`

## Script
`scripts/sql/ssas_staging/07_factRecepcionesHistoria.sql`

## Refresh Strategy
- Type: INCREMENTAL APPEND
- Schedule: Daily 7:00 AM

## Validation
- [ ] Receipt dates match source
- [ ] Lead time calculations present
"@
    },
    @{
        title = "SSAS Staging #8: Migrate factConsumoPlanificado (Volatile, Full Replace)"
        body = @"
## Task
Create staging table + refresh SP for planned consumption. Source: `EPSA_BI.dbo.vw_ComprasBI_factConsumoPlanificadoEPSA`

## Script
`scripts/sql/ssas_staging/08_factConsumoPlanificado.sql`

## Refresh Strategy
- Type: FULL REPLACE (volatile)
- Schedule: Daily 6:00 AM

## Validation
- [ ] Row count matches source view
"@
    },
    @{
        title = "SSAS Staging #9: Migrate factComprasEnProceso (Volatile, Full Replace)"
        body = @"
## Task
Create staging table + refresh SP for active purchases. Source: Nodum 3-way UNION query

## Script
`scripts/sql/ssas_staging/09_factComprasEnProceso.sql`

## Refresh Strategy
- Type: FULL REPLACE (volatile)
- Schedule: Every 4 hours

## Validation
- [ ] 3 types present: Solicitud, Orden de Compra, Carpeta Import
- [ ] Row counts by type match source
"@
    },
    @{
        title = "SSAS Staging #10: Migrate factDemandaPendiente (BOM Explosion)"
        body = @"
## Task
Create staging table + refresh SP for pending demand (BOM decomposition). Executes remote SP then pulls results.

## Script
`scripts/sql/ssas_staging/10_factDemandaPendiente.sql`

## Refresh Strategy
- Type: FULL REPLACE (execute remote SP + pull)
- Schedule: Daily 8:00 AM (after other refreshes)

## Validation
- [ ] BOM levels present (0, 1, 2, 3...)
- [ ] Row count matches remote staging table
- [ ] TrazaComposicion paths are correct
"@
    },
    @{
        title = "SSAS Staging #11: SQL Agent Jobs (Scheduled Refresh)"
        body = @"
## Task
Create 4 SQL Agent jobs with staggered schedules for automated refresh

## Script
`scripts/sql/ssas_staging/11_sql_agent_jobs.sql`

## Jobs
| Job | Schedule |
|-----|----------|
| Dimensions + Volatile | Daily 6:00 AM |
| History (Incremental) | Daily 7:00 AM |
| BOM Explosion | Daily 8:00 AM |
| Volatile Refresh | Every 4h (10-22) |

## Validation
- [ ] All 4 jobs visible in SSMS > SQL Agent > Jobs
- [ ] Manual execution of each job succeeds
- [ ] stg_refresh_log shows SUCCESS entries
"@
    },
    @{
        title = "SSAS Staging #12: Update SSAS Model Partitions"
        body = @"
## Task
Update the SSAS Tabular model to read from local staging tables instead of remote 192.168.2.7

## Changes
- Data source: `localhost` / `192.168.2.47,1435`
- Database: `staging_compras`
- Partitions: `SELECT * FROM stg_xxx`

## Approach
Deploy via TMDL/PBIP deployment script (PowerShell + AMO)

## Dependencies
- All staging tables (Tasks 3-10) must have data
- SQL Agent jobs (Task 11) must be operational

## Validation
- [ ] SSAS model processes successfully
- [ ] DAX measures return correct values
- [ ] Power BI Desktop Live Connection works
"@
    }
)

# Step 3: Create issues
Write-Host "`nCreating issues..." -ForegroundColor Cyan
$issueNumbers = @()

foreach ($issue in $issues) {
    $body = @{
        title = $issue.title
        body = $issue.body
        labels = @($Label)
    } | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/issues" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "  Created #$($response.number): $($issue.title)" -ForegroundColor Green
        $issueNumbers += $response.number
        Start-Sleep -Seconds 1  # Rate limit courtesy
    } catch {
        Write-Host "  ERROR creating '$($issue.title)': $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response.StatusCode.value__ -eq 403) {
            Write-Host "  Rate limit hit. Stopping." -ForegroundColor Yellow
            break
        }
    }
}

Write-Host "`nCreated $($issueNumbers.Count) issues: $($issueNumbers -join ', ')" -ForegroundColor Cyan
