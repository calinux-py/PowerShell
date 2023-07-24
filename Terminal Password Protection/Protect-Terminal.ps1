# Define the path to the encrypted password file
$userName = $env:USERNAME
$encryptedPasswordFile = "C:\Users\$userName\Documents\WindowsPowerShell\yeet.txt"

# Define the number of maximum attempts
$maxAttempts = 3

# Define the prompt message
$promptMessage = ">/" 

# Define the error message
$errorMessage = "Incorrect password. Please wait 10 seconds..."

# Counter for tracking attempts
$attempts = 0

# Function to validate the password
function Validate-Password {
    param (
        [string]$password
    )
    if ($password -eq $decryptedPassword) {
        return $true
    }
    else {
        return $false
    }
}

# Retrieve and decrypt the password from the encrypted file
$encryptedPassword = Get-Content $encryptedPasswordFile
$securePassword = ConvertTo-SecureString $encryptedPassword
$decryptedPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Loop until correct password is entered or maximum attempts are reached
while ($true) {
    $password = Read-Host -Prompt $promptMessage -AsSecureString
    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
 
    if (Validate-Password $password) {
        break
    }
    else {
        $attempts++
        if ($attempts -ge $maxAttempts) {
            Write-Host $errorMessage -ForegroundColor Red
            Start-Sleep -Seconds 10
        }
        else {
            Write-Host "Incorrect password. Please try again." -ForegroundColor Yellow
        }
    }
}