$securePassword = Read-Host -Prompt "Enter your password" -AsSecureString
$securePassword | ConvertFrom-SecureString | Set-Content C:\Users\$env:USERNAME\Documents\WindowsPowerShell\yeet.txt
