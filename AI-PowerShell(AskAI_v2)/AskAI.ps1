function Ask-AI {
    param(
        [string]$arg
    )

    $apiKey = 'YOUR OPENAI API HERE'
    $apiEndpoint = 'https://api.openai.com/v1/chat/completions'


    $headers = @{
        'Authorization' = "Bearer $apiKey"
        'Content-Type'  = 'application/json'
    }

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

    if ($arg -eq "/s") {
        $showErrorInfo = $true
    } elseif ($arg -eq "/d") {
        $detailed = $true
    } elseif ($arg -eq "/a") {
        $showErrorInfo = $true
        $detailed = $true
    } elseif ($arg -eq "/i") {
        $userInputMode = $true
    } elseif ($arg -eq "/help" -or $arg -eq "/?" -or $arg -eq "?" -or $arg -eq "help" -or $arg -eq "h" -or $arg -eq "/h") {
        $help
        return
    }


    if ($userInputMode) {
        Write-Host "User Input:" -ForegroundColor Yellow
        $prompt = Read-Host

        $maxTokens = 80
    } else {
        if ($Error.Count -gt 0) {
            if ($Error.Count -gt 0 -and $Error[0] -ne $null) {
                $ErrorMessage = $Error[0].ToString()
            } else {
                $ErrorMessage = "No recent errors detected."
            }

            $LastUserInput = $Error[0].InvocationInfo.Line

            if ($showErrorInfo) {
                Write-Host -ForegroundColor Yellow "`nError message: $ErrorMessage`n"
                Write-Host -ForegroundColor Cyan "Last command: $LastUserInput`n"
            }
        } else {
            $LastUserInput = Read-Host
        }

        $prompt = "Windows PowerShell error: $($ErrorMessage)`n`nLast Command: $($LastUserInput)`n`nProvide the correct command or syntax using less than 10 words. Do NOT use codeblocks. System: Windows OS"
        $maxTokens = 80

        if ($detailed) {
            $prompt = "Windows PowerShell error: $($ErrorMessage)`n`nLast Command: $($LastUserInput)`n`nPlease provide a detailed explanation of the error and a solution with the correct command or syntax, using up to 80 words. Do NOT use codeblocks. System: Windows OS"
            $maxTokens = 250
        }
    }

    $body = @{
        'model'               = 'gpt-3.5-turbo-0125'
        'messages'            = @(
                                @{
                                    'role'    = 'user'
                                    'content' = $prompt
                                }
                                )
        'temperature'         = 1
        'max_tokens'          = $maxTokens
        'top_p'               = 1
        'frequency_penalty'   = 0
        'presence_penalty'    = 0
    } | ConvertTo-Json


    $response = Invoke-RestMethod -Uri $apiEndpoint -Method 'POST' -Headers $headers -Body $body

    if ($response -ne $null -and $response.choices -ne $null) {
        Write-Host $response.choices[0].message.content -ForegroundColor Green "`n"
    } else {
        Write-Host "`nNo response from API." -ForegroundColor Red
    }


}

# Example of how to call the function
# Ask-AI /s
# Ask-AI /d
# Ask-AI /a
# Ask-AI /i
# Ask-AI /?
