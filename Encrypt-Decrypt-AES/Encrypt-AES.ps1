function Encrypt-AES {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$plainTextFile
    )

    if (-not (Test-Path $plainTextFile)) {
        Write-Error "File not found: $plainTextFile"
        return
    }

    $encryptedFile = "$plainTextFile.aes"

    $key = New-Object Byte[] 32
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)

    $aes = New-Object Security.Cryptography.AesCryptoServiceProvider
    $aes.Key = $key

    $plainTextBytes = Get-Content $plainTextFile -Encoding Byte
    $encryptedBytes = $aes.CreateEncryptor().TransformFinalBlock($plainTextBytes, 0, $plainTextBytes.Length)

    $encryptedBytes | Set-Content $encryptedFile -Encoding Byte

    $keyPath = Join-Path (Split-Path $plainTextFile -Parent) "key.txt"
    $ivPath = Join-Path (Split-Path $plainTextFile -Parent) "iv.txt"

    $key | Set-Content $keyPath -Encoding Byte
    $aes.IV | Set-Content $ivPath -Encoding Byte

    Remove-Item -Path $plainTextFile -Force
    Clear-RecycleBin -Confirm:$false
}

# Encrypt-AES "path/to/the/file"
