# Google Drive Pwn

**Disclaimer: This script is provided for educational and informational purposes only. Ensure to comply with all applicable laws and use ethically.**

## Description

`Google Drive Pwn` is a PowerShell script designed to automate specific interactions with Google Drive through a web browser. **It's vital to underline the importance of responsible and ethical use of automation scripts and to ensure you are adhering to Google's use policies and any applicable local, state, and federal laws.**

The script performs the following actions:
1. Opens Google Drive in the default web browser.
2. Simulates keyboard inputs to navigate through Google Drive UI.
3. Optionally grants access to a specified email address.

## Prerequisites

- PowerShell
- Windows OS
- Appropriate privileges to run PowerShell scripts

## Usage

**IMPORTANT: Before running, ensure to replace `"YOUREMAIL@gmail.com"` with the email you want to grant access to.**

```powershell
# Run script
path\to\script\GoogleDrivePwn.ps1
```

### Parameters

- **drive URL**: A URL of the target Google Drive (default and additional URLs can be uncommented/added in the script).
- **$word**: An email address that the script sends keys for to potentially grant access to certain Google Drive functionalities.
