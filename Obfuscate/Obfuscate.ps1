function Obfuscate {
    [CmdletBinding()]
    param (
        [Alias("h", "--help", "--h")]
        [switch]$help,
        [string]$FilePath,
        [switch]$Advanced,    # compress & wrap in a loader
        [switch]$Junk,        # insert junk functions and variables
        [switch]$Deep,        # deep numeric obfuscation
        [switch]$SuperAdvanced  # compress, then encrypt the obfuscated code
    )

    if ($help) {
        $helpText = @'
Obfuscate Script Help:

Description:
    This script obfuscates a PowerShell script file by removing comments and extraneous whitespace,
    renaming functions and variables, optionally inserting junk code, and performing deep numeric obfuscation.
    Additionally, it supports advanced modes that compress the obfuscated code and even encrypt it
    (in SuperAdvanced mode) with a user-provided password.

Usage:
    Obfuscate -FilePath <path to file> [options]

Parameters:
    -FilePath <string>
        The full path to the PowerShell script file you want to obfuscate.
        If not provided, the script will prompt you to enter the file path.

    -Advanced [switch]
        Enables advanced obfuscation features, including compressing the obfuscated code and wrapping it
        in a loader that decompresses and executes the code.

    -Junk [switch]
        Inserts junk functions and variables into the obfuscated code to further confuse analysis.

    -Deep [switch]
        Applies deep numeric obfuscation by replacing numeric literals with arithmetic expressions.

    -SuperAdvanced [switch]
        Combines compression with encryption.
        In this mode, the obfuscated code is compressed and then encrypted.
        You will be prompted to enter and confirm an encryption password.
        A loader is generated that will prompt for the password at runtime to decrypt and execute the script.

    -Help, -h, --help, --h [switch]
        Displays this help message and exits without performing any obfuscation.

Examples:
    # Basic obfuscation:
    Obfuscate -FilePath "C:\path\to\script.ps1"

    # Advanced obfuscation with junk code and deep numeric obfuscation:
    Obfuscate -FilePath "C:\path\to\script.ps1" -Advanced -Junk -Deep

    # SuperAdvanced obfuscation (compression + encryption):
    Obfuscate -FilePath "C:\path\to\script.ps1" -Advanced -SuperAdvanced -Junk -Deep

Notes:
    The obfuscated script is saved to the same directory as the original file,
    with a suffix indicating the mode used (e.g., -Obfuscated, -AdvancedObfuscated, or -SuperAdvancedObfuscated).
'@
        Write-Host $helpText
        return
    }

    try {
        if (-not $FilePath) {
            $FilePath = Read-Host "Enter the path to the file to Obfuscate"
        }
        if (-not (Test-Path $FilePath)) {
            Write-Host "File not found: $FilePath"
            return
        }

        $scriptContent = Get-Content -Path $FilePath -Raw

        $scriptContent = $scriptContent -replace '(?m)^\s*#.*$', ''
        $scriptContent = $scriptContent -replace '(?m)^\s*$\r?\n', ''

        $aliases = @{
            'Write-Host'            = 'echo'
            'Get-Content'           = 'gc'
            'Select-Object'         = 'select'
            'Invoke-RestMethod'     = 'irm'
            'Get-Location'          = 'gl'
            'Get-Date'              = 'date'
            'Get-Service'           = 'gsv'
            'Get-NetIPConfiguration' = 'gip'
            'Where-Object'          = '?'
            'New-Item'              = 'ni'
            'Remove-Item'           = 'ri'
            'Move-Item'             = 'mv'
            'Set-ItemProperty'      = 'sp'
            'Set-Content'           = 'sc'
            'Start-Process'         = 'saps'
            'Copy-Item'             = 'cp'
            'Get-PSDrive'           = 'gdr'
            'Compare-Object'        = 'diff'
            'ForEach-Object'        = '%'
            'Get-WmiObject'         = 'gwmi'
            'Select-String'         = 'sls'
            'Get-ChildItem'         = 'gci'
            'Sort-Object'           = 'sort'
            'Get-CimInstance'       = 'gcim'
            'Get-Process'           = 'ps'
            'Clear-Content'         = 'clc'
        }
        foreach ($key in $aliases.Keys) {
            $pattern = "\b" + [regex]::Escape($key) + "\b"
            $scriptContent = [regex]::Replace($scriptContent, $pattern, $aliases[$key], 'IgnoreCase')
        }

        function Get-RandomName {
            param (
                [int]$length,
                [bool]$forVariable = $false
            )
            $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
            $random = [System.Random]::new()
            $name = ''
            for ($i = 0; $i -lt $length; $i++) {
                $name += $chars[$random.Next(0, $chars.Length)]
            }
            if ($forVariable) {
                return '$' + $name
            } else {
                return $name
            }
        }

        $variablePattern = '\$[a-zA-Z_][a-zA-Z0-9_]*'
        $functionPattern = 'function\s+[\w-]+'
        $variables = [regex]::Matches($scriptContent, $variablePattern) | 
                     Select-Object -ExpandProperty Value -Unique |
                     Where-Object { $_ -notin @('$_', '$null', '$env', '$Env', '$ENV', '$true', '$True', '$false', '$False', '$args') }
        $functions = [regex]::Matches($scriptContent, $functionPattern) |
                     ForEach-Object { $_.Value.Trim() } | 
                     Select-Object -Unique

        $mapping = @{ }

        foreach ($item in ($variables + $functions)) {
            if ($item -notmatch '^\$Path') {
                if ($item -like 'function*') {
                    $randLength = Get-Random -Minimum 15 -Maximum 26
                    $randomName = Get-RandomName -length $randLength -forVariable:$false
                } else {
                    $randLength = Get-Random -Minimum 10 -Maximum 16
                    $randomName = Get-RandomName -length $randLength -forVariable:$true
                }
                while ($mapping.Values -contains $randomName) {
                    if ($item -like 'function*') {
                        $randLength = Get-Random -Minimum 15 -Maximum 26
                        $randomName = Get-RandomName -length $randLength -forVariable:$false
                    } else {
                        $randLength = Get-Random -Minimum 10 -Maximum 16
                        $randomName = Get-RandomName -length $randLength -forVariable:$true
                    }
                }
                $mapping[$item] = $randomName
            }
        }

        foreach ($item in $mapping.Keys) {
            if ($item -like 'function*') {
                $funcName = $item -replace 'function\s+', ''
                $randomFuncName = $mapping[$item]
                $scriptContent = $scriptContent -replace [regex]::Escape($item), "function $randomFuncName"
                $scriptContent = $scriptContent -replace "\b$funcName\b", $randomFuncName
            } else {
                $variableName = $item.TrimStart('$')
                $randomVariableName = $mapping[$item].TrimStart('$')
                $scriptContent = $scriptContent -replace [regex]::Escape($item), $mapping[$item]
                if ($variableName -notin @('Body','ContentType','Uri','Method','Force')) {
                    $scriptContent = $scriptContent -replace "(?<!\w)-$variableName\b", "-$randomVariableName"
                }
            }
        }

        $scriptContent = [regex]::Replace($scriptContent, '"((?:\\.|[^"\\])*)"', {
            param($match)
            $strContent = $match.Groups[1].Value
            if ($strContent.Length -gt 0) {
                $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($strContent))
                return '[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("' + $base64 + '"))'
            } else {
                return '""'
            }
        })

        if ($Junk) {
            $junkFunctions = @()
            for ($i = 0; $i -lt 5; $i++) {
                $junkName = Get-RandomName -length (Get-Random -Minimum 5 -Maximum 10) -forVariable:$false
                $junkFunctions += "function $junkName { param(`$junk) return `$junk; }"
            }
            $junkVariables = @()
            for ($i = 0; $i -lt 3; $i++) {
                $junkVar = Get-RandomName -length (Get-Random -Minimum 8 -Maximum 12) -forVariable:$true
                $junkVariables += "$junkVar = $(Get-Random -Minimum 1000 -Maximum 9999)"
            }
            $junkBlock = ($junkFunctions + $junkVariables) -join "`n"
            $scriptContent = $junkBlock + "`n" + $scriptContent
        }

        $scriptContent = $scriptContent -replace "[ \t]{2,}", " "

        if ($Deep) {
            $scriptContent = [regex]::Replace($scriptContent, '(?<![\w\.])(\d+)(?![\w\.])', {
                param($match)
                $num = [int]$match.Groups[1].Value
                if ($num -le 1) { 
                    return $num.ToString() 
                }
                $r = Get-Random -Minimum 1 -Maximum $num
                $a = $r
                $b = $num - $r
                return "($a+($b))"
            })
        }

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        $fileExtension = [System.IO.Path]::GetExtension($FilePath)

        if ($SuperAdvanced) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($scriptContent)
            $ms = [System.IO.MemoryStream]::new()
            $gzip = [System.IO.Compression.GzipStream]::new($ms, [System.IO.Compression.CompressionMode]::Compress)
            $gzip.Write($bytes, 0, $bytes.Length)
            $gzip.Close()
            $compressedBytes = $ms.ToArray()

            $passwordSecure = Read-Host "Enter encryption password for SuperAdvanced obfuscation" -AsSecureString
            $confirmSecure = Read-Host "Confirm encryption password" -AsSecureString

            $bstrPass = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecure)
            $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstrPass)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrPass)

            $bstrConfirm = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmSecure)
            $confirm = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstrConfirm)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrConfirm)

            if ($password -ne $confirm) {
                Write-Error "Encryption password and confirmation do not match."
                return
            }

            $sha256 = [System.Security.Cryptography.SHA256]::Create()
            $key = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($password))

            $iv = New-Object byte[] 16
            [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($iv)

            $aes = [System.Security.Cryptography.Aes]::Create()
            $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
            $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
            $aes.Key = $key
            $aes.IV = $iv

            $encryptor = $aes.CreateEncryptor()
            $msEnc = New-Object System.IO.MemoryStream
            $csEnc = New-Object System.Security.Cryptography.CryptoStream($msEnc, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
            $csEnc.Write($compressedBytes, 0, $compressedBytes.Length)
            $csEnc.Close()
            $encryptedBytes = $msEnc.ToArray()

            $finalBytes = $iv + $encryptedBytes
            $base64Encrypted = [System.Convert]::ToBase64String($finalBytes)

            $loader = @"
`$encryptedData = "$base64Encrypted"
`$passwordSecure = Read-Host "Enter pwd" -AsSecureString
`$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(`$passwordSecure)
`$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(`$BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR(`$BSTR)
`$sha256 = [System.Security.Cryptography.SHA256]::Create()
`$key = `$sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes(`$password))
`$data = [System.Convert]::FromBase64String(`$encryptedData)
`$iv = `$data[0..15]
`$ciphertext = `$data[16..(`$data.Length - 1)]
`$aes = [System.Security.Cryptography.Aes]::Create()
`$aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
`$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
`$aes.Key = `$key
`$aes.IV = `$iv
`$decryptor = `$aes.CreateDecryptor()
`$ms = New-Object System.IO.MemoryStream
`$cs = New-Object System.Security.Cryptography.CryptoStream(`$ms, `$decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
`$cs.Write(`$ciphertext, 0, `$ciphertext.Length)
`$cs.Close()
`$decryptedBytes = `$ms.ToArray()
`$ms2 = New-Object System.IO.MemoryStream(, `$decryptedBytes)
`$gzip = New-Object System.IO.Compression.GzipStream(`$ms2, [System.IO.Compression.CompressionMode]::Decompress)
`$sr = New-Object System.IO.StreamReader(`$gzip, [System.Text.Encoding]::UTF8)
`$script = `$sr.ReadToEnd()
iex `$script
exit
"@
            $modifiedScriptPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($FilePath), "$fileName-SuperAdvancedObfuscated$fileExtension")
            $loader | Set-Content -Path $modifiedScriptPath -Encoding UTF8
            Write-Host "SuperAdvanced obfuscated and encrypted script saved to: $modifiedScriptPath"

        } elseif ($Advanced) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($scriptContent)
            $ms = [System.IO.MemoryStream]::new()
            $gzip = [System.IO.Compression.GzipStream]::new($ms, [System.IO.Compression.CompressionMode]::Compress)
            $gzip.Write($bytes, 0, $bytes.Length)
            $gzip.Close()
            $compressedBytes = $ms.ToArray()
            $base64Compressed = [System.Convert]::ToBase64String($compressedBytes)

            $loader = @"
`$e = "$base64Compressed"
`$b = [System.Convert]::FromBase64String(`$e)
`$ms = [System.IO.MemoryStream]::new()
`$ms.Write(`$b, 0, `$b.Length)
`$ms.Position = 0
`$gzip = [System.IO.Compression.GzipStream]::new(`$ms, [System.IO.Compression.CompressionMode]::Decompress)
`$sr = [System.IO.StreamReader]::new(`$gzip, [System.Text.Encoding]::UTF8)
`$s = `$sr.ReadToEnd()
iex `$s
exit
"@
            $modifiedScriptPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($FilePath), "$fileName-AdvancedObfuscated$fileExtension")
            $loader | Set-Content -Path $modifiedScriptPath -Encoding UTF8
            Write-Host "Advanced obfuscated script saved to: $modifiedScriptPath"
        }
        else {
            $modifiedScriptPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($FilePath), "$fileName-Obfuscated$fileExtension")
            $scriptContent | Set-Content -Path $modifiedScriptPath -Encoding UTF8
            Write-Host "Obfuscated script saved to: $modifiedScriptPath"
        }
    }
    catch {
        Write-Error "An error occurred during obfuscation: $_"
    }
}

# Example usage:
# To just obfuscate:
# Obfuscate -FilePath "C:\Programming\#Powershell\! Obfuscator\test.ps1"

# To obfuscate with compression and junk code:
# Obfuscate -FilePath "C:\Programming\#Powershell\! Obfuscator\test.ps1" -Advanced -Junk -Deep

# To use the new SuperAdvanced mode (compression + encryption):
# Obfuscate -FilePath "C:\Programming\#Powershell\! Obfuscator\test.ps1" -Advanced -SuperAdvanced -Junk -Deep
