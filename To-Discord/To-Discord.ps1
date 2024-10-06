# Send the output of Powershell commands directly to a webhook. Example: ipconfig | To-Discord

function To-Discord {
    param (
        [string]$webhookUrl = 'YOUR WEBHOOK HERE'
    )
    
    $output = $input | Out-String
    $content = '```' + $output.Substring(0, [math]::Min($output.Length, 1994)) + '```'
    
    if (-not [string]::IsNullOrEmpty($content.Trim())) {
        irm $webhookUrl -Method Post -ContentType 'application/json' -Body (@{content=$content} | ConvertTo-Json)
    } else {
        Write-Host "Output is empty or not valid for sending."
    }
}
