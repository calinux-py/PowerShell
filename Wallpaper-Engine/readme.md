# Wallpaper-Engine PowerShell Script README

## Introduction
`Wallpaper-Engine` is a PowerShell script designed to automate the process of launching your Steam Wallpaper Engine application without the need to start the Steam app. This script helps in setting up your wallpaper, preventing it from being just a black screen.

## Installation
To use this script, you can add it to your startup folder, the registry, or simply keep it on your desktop. Running the script is as simple as selecting the `.ps1` file.

## Usage
Once installed, the script will search for the `wallpaper64.exe` file in your system and launch it, thereby starting your Wallpaper Engine. This eliminates the need to manually start the Wallpaper Engine through Steam.

### Script Details
Here is the core command of the script:
```powershell
Get-ChildItem -Recurse -Path C:\ -Filter "wallpaper64.exe" | Select-Object -First 1 | ForEach-Object { Start-Process $_.FullName }
```
This command performs the following actions:
1. Searches (`Get-ChildItem`) recursively (`-Recurse`) in your C: drive for the file named `wallpaper64.exe`.
2. Selects the first instance (`Select-Object -First 1`) of the file found.
3. Starts the Wallpaper Engine (`Start-Process $_.FullName`).

## Requirements
- PowerShell
- Steam Wallpaper Engine installed on your system

## Note
Ensure that your system's security settings allow the execution of PowerShell scripts or dont. who cares it'll stil work.
