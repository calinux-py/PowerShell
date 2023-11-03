# InfoWORM: PowerShell Worm 🪱

## Disclaimer

The `InfoWORM` PowerShell script is intended for educational and **ethical testing purposes only**. The author is not responsible for any misuse or damage that may occur from using this script. It is imperative that you only run this script in controlled environments where you have explicit permission to do so. Misuse of this script could lead to legal repercussions.

## Overview

`InfoWORM` is a PowerShell script designed to demonstrate the behavior of a worm on Windows systems. It uses various techniques to collect system information and replicate itself to other drives.

### Features

- Collects system information including IP addresses, system time, and hostname.
- Replicates itself to storage drives, including USBs.
- Injects itself into the Windows startup registry.
- Uses a Discord webhook to send information to a specified channel.

## Usage

To use the script, follow these steps:

1. **Clone the repository**  
   Clone this repository to your local machine or download the `InfoWORM.ps1` file directly.

2. **Setting Up Discord Webhook**  
   Set up a Discord webhook URL by editing the `$webhookUrl` variable at the top of the script with your own webhook URL.

3. **Run the Script**  
   Execute the script in a PowerShell environment with appropriate permissions.

```powershell
./InfoWORM.ps1
```

4. **Monitoring**  
   Monitor the output in your Discord server to observe the behavior of the worm.

## Functionality

Here is a brief overview of the key functions in the script:

- `Send-ToDiscord`: Sends a message to the Discord server using the provided webhook URL.
- `Copy-FileToUSB`: Attempts to copy the script to a newly detected USB drive.
- `Check-ForNewDrive`: Monitors for new drives and initiates the copy process if a new drive is detected.

---
