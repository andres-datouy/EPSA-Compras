# Send-TeamsAlert.ps1
# Usage: powershell -ExecutionPolicy Bypass -File C:\Scripts\Send-TeamsAlert.ps1 -Title "Alert Title" -Message "Details here"
# Called by SQL Agent Jobs on failure via CmdExec step

param(
    [string]$Title = "Staging Alert",
    [string]$Message = "Check stg_refresh_log for details",
    [string]$Color = "FF0000"  # Red for failure
)

$uri = "https://defaultf747ef8e41e2435eafd74ee0a24b76.93.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/905b3b1065e940cc85ac9e97c23c1abc/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Ngh-y6cQI834jiDbLnD0wb8qD2jXafOa6vnyzDQggfo"

# Adaptive Card format (required by Power Automate "Post to channel" template)
$body = @{
    type = "AdaptiveCard"
    "`$schema" = "http://adaptivecards.io/schemas/adaptive-card.json"
    version = "1.4"
    body = @(
        @{
            type = "TextBlock"
            text = $Title
            weight = "bolder"
            size = "medium"
            color = if ($Color -eq "FF0000") { "attention" } else { "good" }
        },
        @{
            type = "TextBlock"
            text = $Message
            wrap = $true
        },
        @{
            type = "FactSet"
            facts = @(
                @{
                    title = "Server"
                    value = $env:COMPUTERNAME
                },
                @{
                    title = "Time"
                    value = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $body
    Write-Output "Alert sent successfully"
}
catch {
    Write-Error "Failed to send alert: $_"
    exit 1
}
