# DNSCrypt PowerShell Script

This PowerShell script is designed to help you manage the [DNSCrypt](https://dnscrypt.info/) service on your Windows system. DNSCrypt is a tool that encrypts your DNS traffic to enhance privacy and security.

## Prerequisites

Before using this script, please make sure you have the following:

- [DNSCrypt Proxy](https://github.com/DNSCrypt/dnscrypt-proxy) installed on your system.
- Administrator privileges to run this script.

## Usage

1. **Replace the Path:** Before running the script, ensure that you replace the path to the `dnscrypt-proxy-win64-2.1.5\win64` directory with the correct path to your DNSCrypt Proxy installation.

```powershell
# Change directory
Set-Location "C:\dnscrypt-proxy-win64-2.1.5\win64"
```

2. **Run as Administrator:** Right-click the script and select "Run as administrator" to ensure it has the necessary permissions.

3. **Execute the Script:** Run the script, and it will check if the DNSCrypt Proxy is running. Depending on the status, it will either start or stop the service and configure DNS settings accordingly.

**Note:** If you are using a different version of DNSCrypt Proxy, make sure to adjust the path accordingly.

## Important

This script requires administrative privileges to execute successfully. If you encounter any issues, ensure that you are running it as an administrator.
