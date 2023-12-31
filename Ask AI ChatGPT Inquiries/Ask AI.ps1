function Ask-AI {
    $apiKey = 'YOUR OPEN AI API'
    $apiEndpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions'

    $headers = @{
        'Authorization' = "Bearer $apiKey"
        'Content-Type'  = 'application/json'
    }

    Write-Host -ForegroundColor Yellow "`nUser Input:"
    $Input = Read-Host

    $body = @{
        'prompt'              = "Respond to this using less than 50 words: "+$Input
        'temperature'         = 1
        'max_tokens'          = 80
        'top_p'               = 1
        'frequency_penalty'   = 0
        'presence_penalty'    = 0
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $apiEndpoint -Method 'POST' -Headers $headers -Body $body

    Write-Host $response.choices[0].text -ForegroundColor Green "`n"
}
