function Ask-AI {
    param(
        [string]$arg
    )

    $apiKey = 'YOUR OPENAI API'
    $apiEndpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions'

    $headers = @{
        'Authorization' = "Bearer $apiKey"
        'Content-Type'  = 'application/json'
    }

    # Initialize variables
    $ErrorMessage = $null
    $LastUserInput = $null
    $showErrorInfo = $false
    $detailed = $false
    $userInputMode = $false
    $help = @"

`nAsk-AI is a PowerShell function crafted to simplify troubleshooting within PowerShell.
Just type Ask-AI following a PowerShell error to troubleshoot, rectify syntax issues, or locate the right command.
`n
Options:
  /?: Display this help message.
  /s: Display full message sent to OpenAI's API.
  /d: Request detailed assistance.
  /a: Display full message & request detailed assistance.
  /i: Send a custom message to OpenAI's API.
`n
Example:
  > Ask-AI
  > Ask-AI /?
  > Ask-AI /s
  > Ask-AI /d
  > Ask-AI /a
  > Ask-AI /i
`n
"@

    # Custom logic to process options
    if ($arg -eq "/s") {
        $showErrorInfo = $true
    } elseif ($arg -eq "/d") {
        $detailed = $true
    } elseif ($arg -eq "/a") {
        $showErrorInfo = $true
        $detailed = $true
    } elseif ($arg -eq "/i") {
        $userInputMode = $true
    } elseif ($arg -eq "/help" -or $arg -eq "/?" -or $arg -eq "?") {
        $help
        return
    }

    # Handle user input mode
    if ($userInputMode) {
        Write-Host "User Input:" -ForegroundColor Yellow
        $prompt = Read-Host

        $maxTokens = 80
    } else {
        # Check for the most recent error message
        if ($Error.Count -gt 0) {
            $ErrorMessage = $Error[0].Exception.ToString()
            $LastUserInput = $Error[0].InvocationInfo.Line

            if ($showErrorInfo) {
                Write-Host -ForegroundColor Yellow "`nError message: $ErrorMessage"
                Write-Host -ForegroundColor Yellow "Last command: $LastUserInput"
            }
        } else {
            $LastUserInput = Read-Host
        }

        $prompt = "Windows PowerShell error: $($ErrorMessage)`n`nLast Command: $($LastUserInput)`n`nProvide the correct command or syntax using less than 10 words."
        $maxTokens = 80

        if ($detailed) {
            $prompt = "Windows PowerShell error: $($ErrorMessage)`n`nLast Command: $($LastUserInput)`n`nPlease provide a detailed explanation of the error and a solution with the correct command or syntax, using up to 80 words."
            $maxTokens = 250
        }
    }

    $body = @{
        'prompt'              = $prompt
        'temperature'         = 1
        'max_tokens'          = $maxTokens
        'top_p'               = 1
        'frequency_penalty'   = 0
        'presence_penalty'    = 0
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $apiEndpoint -Method 'POST' -Headers $headers -Body $body

    Write-Host $response.choices[0].text -ForegroundColor Green "`n"
}

# Example of how to call the function
# Ask-AI /s
# Ask-AI /d
# Ask-AI /a
# Ask-AI /i
# Ask-AI /?
