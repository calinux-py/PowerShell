$pythonPath = Join-Path $env:LOCALAPPDATA "Programs\Python"

if (Test-Path -Path $pythonPath) {
} else {
    
    $installerUrl = "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe"

    $installerPath = Join-Path $env:TEMP "python_installer.exe"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    Start-Process -FilePath $installerPath -Args "/quiet InstallAllUsers=1 PrependPath=1" -Wait

    Remove-Item -Path $installerPath

}

$scriptUrl = "https://raw.githubusercontent.com/calinux-py/Python/main/Overlay-AceVentura/Overlay-Ace.py"

$scriptPath = Join-Path $env:TEMP "Overlay-Ace.py"

Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

try {
    Start-Process -FilePath "pip" -Args "install pyautogui keyboard" -NoNewWindow -Wait
} catch {
    Start-Process -FilePath "pip3" -Args "install pyautogui keyboard" -NoNewWindow -Wait
}

try {
    & python $scriptPath
} catch {
    & python3 $scriptPath
}

