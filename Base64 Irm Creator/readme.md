## Base64-irm
![](https://img.shields.io/badge/-PowerShell-blue)

The **Base64-irm** script is a PowerShell function designed to simplify the process of downloading and executing scripts encoded in Base64 from a given URL. It automates the steps of downloading, decoding, and executing the script, making it easier to quickly run scripts without manual intervention.

### Usage

1. Run the script by calling the `Base64-irm` function.
2. You will be prompted to enter a URL. Make sure to use a URL that points to a Base64-encoded PowerShell script, often hosted on platforms like `https://t.ly/`.

### Execution Steps

1. The script will download the Base64-encoded content from the provided URL.
2. The downloaded content will be saved to a file named `e.txt` on your desktop.
3. The `certutil` command is then used to decode the Base64 content from `e.txt` and save it as `d.ps1` on your desktop.
4. Finally, the PowerShell script `d.ps1` is executed.

### Note

- Make sure you understand the source and content of the script you're executing, as this process involves running scripts from external sources, which can be a security risk.
- Use this script responsibly and only on trusted URLs.

**Please exercise caution while using this script and ensure that you are complying with security best practices.**

*Disclaimer: This script was created for educational and illustrative purposes. The author is not responsible for any misuse or damages arising from its use.*
