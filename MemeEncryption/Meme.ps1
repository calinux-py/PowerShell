function MemeEncrypt($inputString) {
    $key = "YouHaveBeenDabbedOnGoodSir"

    # Convert the input string and key to byte arrays
    $inputBytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)

    # Initialize an empty byte array for the encrypted result
    $encryptedBytes = New-Object byte[] $inputBytes.Length

    # Perform the encryption
    for ($i = 0; $i -lt $inputBytes.Length; $i++) {
        $encryptedBytes[$i] = $inputBytes[$i] -bxor $keyBytes[$i % $keyBytes.Length] -bxor ($i % 255)
    }

    # Convert the encrypted bytes back to a string and return
    return [Convert]::ToBase64String($encryptedBytes)
}

# Define the decryption algorithm
function CustomDecrypt($encryptedString) {
    $key = "YouHaveBeenDabbedOnGoodSir"

    # Convert the encrypted string and key from Base64 and to byte arrays
    $encryptedBytes = [Convert]::FromBase64String($encryptedString)
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)

    # Initialize an empty byte array for the decrypted result
    $decryptedBytes = New-Object byte[] $encryptedBytes.Length

    # Perform the custom decryption logic
    for ($i = 0; $i -lt $encryptedBytes.Length; $i++) {
        $decryptedBytes[$i] = $encryptedBytes[$i] -bxor $keyBytes[$i % $keyBytes.Length] -bxor ($i % 255)
    }

    # Convert the decrypted bytes back to a string and return
    return [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
}

function EF($FP) {
    $fileContent = Get-Content $FP -Raw

    $encryptedContent = MemeEncrypt $fileContent

    $encryptedFilePath = "$FP.meme"
    [System.IO.File]::WriteAllText($encryptedFilePath, $encryptedContent)
    Write-Host "File encrypted successfully: $encryptedFilePath"
}

function DF($encryptedFilePath) {
    $encryptedContent = Get-Content $encryptedFilePath -Raw

    $decryptedContent = CustomDecrypt $encryptedContent

    $decryptedFilePath = $encryptedFilePath.Replace(".meme", "")
    [System.IO.File]::WriteAllText($decryptedFilePath, $decryptedContent)
}

#$FP = "path\to\your\dank\memes"
#EF $FP
#DF "$FP.meme"
