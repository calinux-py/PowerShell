# Get-PKey PowerShell Script

This PowerShell script retrieves the product key from the local machine and sends it to a specified Discord webhook.

## Functions

### 1. Send-DiscordWebhookMessage
Sends a message to a specified Discord webhook.

#### Parameters:
- `$WebhookUrl`: The URL of the Discord webhook you want to send a message to.
- `$Message`: The message you want to send to the Discord webhook.

### 2. Get-PKey
Retrieves the product key from the local machine and sends it to the specified Discord webhook.

#### Parameters:
- `$wb`: The URL of the Discord webhook you want to send the product key to. This is a mandatory parameter.

## Usage

```powershell
Get-PKey -wb 'YOUR_DISCORD_WEBHOOK_URL_HERE'
```

Replace `'YOUR_DISCORD_WEBHOOK_URL_HERE'` with your actual Discord webhook URL.
