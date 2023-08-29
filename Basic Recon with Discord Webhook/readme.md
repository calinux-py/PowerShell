# PowerShell Recon Script
![](https://img.shields.io/badge/-PowerShell-blue)

This PowerShell script, `Get-Recon`, is designed to gather various system information and geolocation data. It compiles this information into a file and optionally uploads it to a Discord webhook. The script performs the following tasks:

1. Fetch Geolocation Information:
   - Uses the ip-api.com JSON API to retrieve geolocation data based on the public IP address of the system.
   - Saves the geolocation data, including IP, country, region, city, latitude, longitude, timezone, and ISP, to a temporary file.

2. Gather Network Configuration:
   - Retrieves the private IP address, subnet, default gateway, and DNS server(s) from the system's network configuration (WMI).

3. List Users on the System:
   - Retrieves the names of all user accounts on the system using WMI (Win32_UserAccount) and saves them to the file.

4. Check Firewall Status:
   - Determines the status of the firewall (enabled/disabled) and saves the status to the file.

5. Retrieve Antivirus Information:
   - Queries antivirus product information from the "root/SecurityCenter2" namespace using CIM (Common Information Model).
   - Saves the antivirus display name and product state to the file.

6. List Wifi SSIDs and Passwords:
   - Retrieves a list of Wi-Fi profiles stored on the system using the `Get-Networks` function and saves SSID-password pairs to the file.

7. Get Computer Information:
   - Uses the `Get-ComputerInfo` cmdlet to fetch general system information and appends it to the file.

8. Get Proccess Information:
   - Uses the `Get-Process` cmdlet to fetch current proccesses and amends it to the file.

## Prerequisites
- PowerShell version 5.1 or later.

## How to Use

1. Copy and paste the script into a PowerShell console, editor, or script file.
2. Optional: If you want to upload the generated file to a Discord webhook, uncomment the last two lines and replace `'WEBHOOK GOES HERE'` with your Discord webhook URL.
3. Save the script and run it.

The script will create a file named `CaliLoot.txt` in the user's temporary folder (usually `%TEMP%`) and populate it with the collected information. If a Discord webhook URL is provided, the file will be uploaded to the specified channel.

Please note that some information may not be available depending on system configurations, permissions, or the presence of antivirus software.

Remember to exercise caution when using and sharing this script, as it may disclose sensitive information. Always ensure that you have the right to access and use the information retrieved by the script.

**Note:** This script was created for educational and informational purposes. The usage and distribution of this script may be subject to certain legal restrictions depending on your jurisdiction. Use it responsibly and only on systems you have explicit permission to access.

If you encounter any issues or have questions, feel free to open an issue or reach out via the contact information provided in my GitHub profile. Happy reconning!
