Get-Geo PowerShell Script
Description

This PowerShell script, created by CaliNux, allows you to retrieve geolocation information based on the public IP address of the machine running the script. It uses the "ip-api.com" API to fetch the geolocation data, providing details such as IP address, country, region, city, latitude, longitude, timezone, and ISP.
Prerequisites

    PowerShell 5.1 or later.

How to Use

    Download or clone this repository to your local machine.

    Open a PowerShell terminal.

    Navigate to the directory where you saved the script.

    Run the script by executing the following command:
.\Get-Geo.ps1

    The script will contact the "ip-api.com" API to fetch geolocation data based on your public IP address.

    The geolocation information will be displayed on the console, showing details such as IP address, country, region, city, latitude, longitude, timezone, and ISP.

Error Handling

If an error occurs while trying to fetch geolocation data, the script will display an appropriate error message.
Note

    The accuracy of the geolocation information may vary based on the accuracy of the public IP address mapping to a specific physical location.