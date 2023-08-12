# Check-Pass PowerShell Script

The `Check-Pass` PowerShell script is a simple tool that allows you to check the security status of a password using the haveibeenpwned.com API. It calculates the SHA-1 hash of the provided password and then queries the haveibeenpwned API to determine if the password has been previously exposed in data breaches.

## Features

- Checks the security status of a password by querying haveibeenpwned.com's API.
- Provides information on whether the password has been previously exposed in data breaches.
- Offers a quick way to assess the security of a password before using it.

## Prerequisites

- PowerShell 3.0 or higher.
- Internet connectivity to access the haveibeenpwned.com API.

## How to Use

1. Download or copy the `Check-Pass.ps1` script into your desired directory.

2. Open a PowerShell console.

3. Navigate to the directory where the script is located using the `cd` command.

4. Run the script using the following command:
   
   ```powershell
   .\Check-Pass.ps1
   ```

5. You will be prompted to enter the password you want to check. The password will be masked for security.

6. The script will query the haveibeenpwned.com API and provide feedback on whether the password has been compromised. If the password has been exposed in data breaches, it will display the number of times it has been "pwned." If the password is secure, it will display a confirmation message.
