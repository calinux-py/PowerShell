# Subnet-Grab PowerShell Script

![Subnet-Grab](https://img.shields.io/badge/Subnet--Grab-PowerShell-blue)

## Description

Subnet-Grab is a PowerShell script designed to automate the process of grabbing subnet devices using a Python script. The PowerShell script ensures that Python and the required packages are installed, downloads the Python script, and executes it. The grabbed data is then sent to a specified Discord webhook.

## Prerequisites

Before running the Subnet-Grab script, ensure you have the following prerequisites installed:

- [Python 3.9.7](https://www.python.org/downloads/release/python-397/)
- [pip](https://pip.pypa.io/en/stable/installing/)
- PowerShell

## Usage

1. Clone this repository or download the `Subnet-Grab.ps1` script.

2. Open a PowerShell terminal.

3. Navigate to the directory containing the `Subnet-Grab.ps1` script.

4. Run the PowerShell script using the following command:

   ```powershell
   Subnet-Grab -discordWebhook "YOUR_DISCORD_WEBHOOK_URL"
   ```

   Replace `YOUR_DISCORD_WEBHOOK_URL` with the actual webhook URL to which the subnet device data will be sent.

## Script Details

The PowerShell script performs the following steps:

1. Checks if Python is installed. If not, it automatically installs Python version 3.9.7.

2. Checks if pip is installed. If not, it installs pip.

3. Installs the required Python packages `scapy` and `netifaces` using pip.

4. Downloads the Python script `SubnetGrab.py` from the GitHub repository and modifies it to include the provided Discord webhook URL.

5. Executes the Python script, which scans the local network for devices in the same subnet and sends the gathered data to the specified Discord webhook.

## Acknowledgments

The Python script used in this project was originally developed by [calinux-py](https://github.com/calinux-py). The PowerShell script automating its setup and execution was created by [YourGitHubUsername](https://github.com/YourGitHubUsername).
