# Add issues to GitHub Project V2
# Cuenta: acunarro-epsa
# Ejecutar cuando el rate limit de GraphQL se haya reseteado

# Token should be set via environment variable or passed as parameter
$token = $env:GH_PAT_EPSA
if (-not $token) {
    Write-Host "Error: Set GH_PAT_EPSA environment variable with your GitHub PAT" -ForegroundColor Red
    exit 1
}
$owner = "acunarro-epsa"
$repo = "EPSA-Compras"
$projectNumber = 2

$issues = @(8,9,10,11,12,13,14,15,16,17,18,19,20,21)

$env:GH_TOKEN = $token

# Obtener project ID
$projectQuery = '{"query": "query { user(login: \"' + $owner + '\") { projectV2(number: ' + $projectNumber + ') { id } } }"}'
$projectJson = ($projectQuery | gh api graphql --input -) | ConvertFrom-Json

if ($projectJson.errors) {
    Write-Host "Error obteniendo proyecto: $($projectJson.errors.message)" -ForegroundColor Red
    Write-Host "Espera a que se resetee el rate limit de GraphQL (~1 hora)" -ForegroundColor Yellow
    exit 1
}

$projectId = $projectJson.data.user.projectV2.id
Write-Host "Project ID: $projectId" -ForegroundColor Green

foreach ($issueNumber in $issues) {
    # Obtener issue ID
    $issueQuery = '{"query": "query { repository(owner: \"' + $owner + '\", name: \"' + $repo + '\") { issue(number: ' + $issueNumber + ') { id title } } }"}'
    $issueJson = ($issueQuery | gh api graphql --input -) | ConvertFrom-Json
    
    if ($issueJson.errors) {
        Write-Host "Error obteniendo issue #$issueNumber`: $($issueJson.errors.message)" -ForegroundColor Red
        continue
    }
    
    $issueId = $issueJson.data.repository.issue.id
    $issueTitle = $issueJson.data.repository.issue.title
    Write-Host "Issue #$issueNumber`: $issueTitle"
    
    # Agregar al proyecto
    $addMutation = '{"query": "mutation { addProjectV2ItemById(input: { projectId: \"' + $projectId + '\", contentId: \"' + $issueId + '\" }) { item { id } } }"}'
    $addJson = ($addMutation | gh api graphql --input -) | ConvertFrom-Json
    
    if ($addJson.errors) {
        Write-Host "Error agregando issue #$issueNumber`: $($addJson.errors.message)" -ForegroundColor Red
    } else {
        Write-Host "Agregado issue #$issueNumber al proyecto!" -ForegroundColor Green
    }
    
    Start-Sleep -Seconds 3
}

Write-Host "Listo!" -ForegroundColor Cyan
