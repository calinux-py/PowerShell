function Check-Pass {
    $password = Read-Host "`nEnter the password to check its security status at haveibeenpwned.com" -AsSecureString
    $passwordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

    $sha1Password = [System.Security.Cryptography.SHA1]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($passwordPlainText))
    $sha1Hash = [System.BitConverter]::ToString($sha1Password).Replace("-", "").ToLower()
    $hashPrefix = $sha1Hash.Substring(0, 5)
    $hashSuffix = $sha1Hash.Substring(5)

    $response = Invoke-WebRequest -Uri "https://api.pwnedpasswords.com/range/$hashPrefix" -UseBasicParsing -Headers @{"Add-Padding"="true"}
    $hashes = $response.Content -split "`r`n"

    $found = $false
    foreach ($hash in $hashes) {
        $hashParts = $hash -split ":"
        if ($hashParts[0].Equals($hashSuffix, [System.StringComparison]::OrdinalIgnoreCase)) {
            $found = $true
            $count = [int]$hashParts[1]
            Write-Host "`nThe password has been pwned $count times.`n" -ForegroundColor Red
            break
        }
    }

    if (-not $found) {
        Write-Host "`nThe password has not been pwned. You're good to go!`n" -ForegroundColor Green
    }
}
