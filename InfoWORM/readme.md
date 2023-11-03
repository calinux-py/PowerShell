# InfoWORM 🪱

Welcome to the repository of InfoWORM, a potent PowerShell worm crafted for educational purposes only. The code herein represents a dangerous and rapidly spreading piece of malware that can infect virtually any system and replicate itself with alarming speed.

:warning: **DISCLAIMER**: The author of InfoWORM is not responsible for any misuse of this code. This repository and its contents are intended strictly for educational and ethical training purposes. By using InfoWORM, you agree to use it in a manner consistent with the laws and regulations of your jurisdiction. Misuse of this information can result in criminal charges brought against the persons in question. The author will not be held liable for any damages or legal implications arising from misuse of this code.

## Description :page_with_curl:

InfoWORM is a PowerShell script that uses advanced tactics to ensure execution, persistence, and propagation. Here's how it instills fear in the heart of digital security:

- **Stealthy Execution**: Utilizes hidden PowerShell windows to run unseen in the background.
- **Startup Persistence**: Ensures it is executed on every system start by setting a registry key in Windows.
- **System Information Harvesting**: Gathers system information, such as public IP addresses, hostname, and network details, sending them to a remote Discord webhook.
- **Self-Replication**: Able to replicate itself onto any removable drives that are connected to the system, waiting to infect the next host.
- **Remote Monitoring**: Sends real-time alerts and status updates to a Discord channel using webhooks.

## How It Works :gear:

1. **Initialization**: Upon execution, InfoWORM sends an initial alert with the system's details to the configured Discord channel.
2. **Replication**: It copies itself into a common directory and sets a registry key to gain persistence, ensuring it starts with Windows every time.
3. **Propagation**: InfoWORM constantly monitors for new drives and replicates itself onto any that are added, such as USB flash drives.
4. **Stealth Mode**: It operates covertly, minimizing its visibility to evade detection by users and some antivirus software.
5. **Remote Notifications**: Every significant action taken by the worm is reported back to the attacker via Discord webhook messages.

## Setup :wrench:

To set up InfoWORM for educational demonstration:

1. Clone this repository or copy the script into a `.ps1` file.
2. Set up a Discord server and create a webhook for receiving notifications.
3. Replace the `$webhookUrl` variable with your Discord webhook URL.
4. Execute the script in a controlled, isolated environment to study its behavior.

## Usage :computer:

```powershell
# Run the script (ensure you have the necessary permissions and execution policy set):
powershell.exe -ExecutionPolicy Bypass -File .\InfoWORM.ps1
```

## Safety Precautions :shield:

- Never run InfoWORM on a device or network without explicit permission and proper authorization.
- Always operate within a controlled, isolated environment (like a virtual machine) without any network connections to other live systems.
- Understand and comply with your local laws to avoid legal repercussions.

## Educational Objectives :mortar_board:

InfoWORM can be used in a cybersecurity lab setting to:

- Understand the mechanics of self-replicating malware.
- Develop skills to detect and analyze malware behavior.
- Improve defensive strategies against malware spread and data exfiltration.

## License :scroll:

This project is licensed under the MIT License - see the LICENSE file for details.

---

Remember, with great power comes great responsibility. Use InfoWORM wisely and ethically.
```
