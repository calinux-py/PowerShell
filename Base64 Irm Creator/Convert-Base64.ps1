function Convert-Base64 {
    [CmdletBinding()]
    Param()

    $filePath = Read-Host "Enter the path of the file you want to convert"
    
    $filePath = $filePath.Trim('"')

    if (-Not (Test-Path $filePath)) {
        Write-Host "File does not exist. Exiting..."
        return
    }

    $fileContent = Get-Content -Path $filePath -Raw
    
    try {
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContent))
        $isBase64 = $true
    } catch {
        $isBase64 = $false
    }

    if ($isBase64) {
        $decodedContent = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContent))
        Set-Content -Path $filePath -Value $decodedContent
        Write-Host "File was Base64. Decoded and saved."
    } else {
        $encodedContent = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($fileContent))
        Set-Content -Path $filePath -Value $encodedContent
        Write-Host "File was not Base64. Encoded and saved."
    }
}
