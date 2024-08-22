function Ask-AI {
    param(
        [string]$arg
    )

    $apiKey = 'YOUR API KEY'
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

function Create-TextBox {
    param([string]$Text)
    $lines = $Text -split "`n"
    $maxLength = ($lines | Measure-Object -Property Length -Maximum).Maximum

    $border = "-" * $maxLength
    "$border`n$Text`n$border"
}

    if ($arg -eq "/s") {
        $showErrorInfo = $true
    } elseif ($arg -eq "/d") {
        $detailed = $true
    } elseif ($arg -eq "/a") {
        $showErrorInfo = $true
        $detailed = $true
    } elseif ($arg -eq "/i") {
        $userInputMode = $true
    } elseif ($arg -eq "/help" -or $arg -eq "/?" -or $arg -eq "-help" -or $arg -eq "help" -or $arg -eq "?") {
        $help
        return
    }

    if ($userInputMode) {
        Write-Host "User Input:" -ForegroundColor Yellow
        $prompt = Read-Host

        $maxTokens = 80
    } else {
        if ($Error.Count -gt 0) {
            $ErrorMessage = $Error[0].Exception.Message
            $LastUserInput = $Error[0].InvocationInfo.Line
    
            if ($showErrorInfo) {
                Write-Host -ForegroundColor Yellow "`nPowerShell Error: $ErrorMessage"
                Write-Host -ForegroundColor Yellow "`nLast user command: $LastUserInput"
            }
        } else {
            $LastUserInput = Read-Host
        }
    
        $prompt = "User tried this command: $($LastUserInput) and got this PowerShell Error: $($ErrorMessage)`nIf the term is not recognized, provide the right command or syntax using less than 10 words. If the error is something else, explain the error in less than 20 words.. Do NOT add additional context."
        $maxTokens = 80
    
        if ($detailed) {
            $prompt = "User tried this command: $($LastUserInput) and got this PowerShell Error: $($ErrorMessage)`nProvide a detailed explanation of the error and a solution with the correct command or syntax, using up to 80 words."
            $maxTokens = 250
        }
    }
    $body = @{
        'model'    = "gpt-3.5-turbo"
        'messages' = @(
            @{
                'role'    = "system"
                'content' = "PowerShell Terminal"
            },
            @{
                'role'    = "user"
                'content' = $prompt
            }
        )
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $apiEndpoint -Method 'POST' -Headers $headers -Body $body

    $formattedResponse = Create-TextBox -Text $response.choices[0].message.content
    Write-Host $formattedResponse -ForegroundColor Green "`n"
}
