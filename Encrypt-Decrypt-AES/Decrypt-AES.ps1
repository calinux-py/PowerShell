function Decrypt-AES {
    param (
        [Parameter(Mandatory=$true)]
        [string]$encryptedFilePath
    )

    if (-not (Test-Path $encryptedFilePath)) {
        Write-Error "The specified file path does not exist: $encryptedFilePath"
        return
    }

    $dir = [System.IO.Path]::GetDirectoryName($encryptedFilePath)
    $keyFile = [System.IO.Path]::Combine($dir, "key.txt")
    $ivFile = [System.IO.Path]::Combine($dir, "iv.txt")

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($encryptedFilePath)
    $decryptedFile = [System.IO.Path]::Combine($dir, $baseName)

    if (-not (Test-Path $keyFile) -or -not (Test-Path $ivFile)) {
        Write-Error "Either the key file or the IV file is missing."
        return
    }

    $key = Get-Content $keyFile -Encoding Byte
    $iv = Get-Content $ivFile -Encoding Byte

    $aes = New-Object Security.Cryptography.AesCryptoServiceProvider
    $aes.Key, $aes.IV = $key, $iv

    $encryptedBytes = Get-Content $encryptedFilePath -Encoding Byte
    $decryptedBytes = $aes.CreateDecryptor().TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length)
    $decryptedBytes | Set-Content $decryptedFile -Encoding Byte

    Remove-Item $keyFile -Force
    Remove-Item $ivFile -Force
    Remove-Item $encryptedFilePath -Force
    Clear-RecycleBin -Confirm:$false
}

# Decrypt-AES "path/to/file"