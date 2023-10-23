# Google Drive Pwn

This script provides an automated way to grant access to a specified Google Drive account using PowerShell. The script simulates keyboard and mouse actions to provide access to the mentioned email.

## Prerequisites
- Windows OS with PowerShell.
- `System.Windows.Forms` assembly should be available (usually comes with the .NET Framework).

## Usage

1. Copy the function `Access-Drive` into your PowerShell session or script file.
2. Use the function by passing the email address you want to grant access to:

```powershell
Access-Drive -em "your_email@example.com"
```

## Functionality

- The function opens the Google Drive web page in the default browser.
- It then navigates through the process of granting access to the specified email address.
- At the end of the function, all browser windows with "Google Drive" in the title are forcibly closed.

## Customization

The script currently targets the primary Google Drive account (`https://drive.google.com/drive/u/0/my-drive`). If you wish to access other drive URLs, you can uncomment the respective lines in the script.

## Limitations & Warnings

1. Ensure you're logged into the correct Google account in the default browser before running the script.
2. This method relies on simulated keystrokes. It might fail if the structure of the Google Drive webpage changes or if there are unexpected delays in loading.
3. Be cautious when using scripts that automate browser activity, especially on important accounts. It's a good idea to test on non-critical accounts first.
