# Discord Channel + DM Screencapper README
![](https://img.shields.io/badge/-PowerShell-blue)

## Overview

This PowerShell script captures multiple screenshots of Discord channels and direct messages (DMs). It then uploads these screenshots to a specified Discord Webhook. 

## Features

- Opens Discord application
- Navigates through channels and DMs
- Takes screenshots
- Uploads screenshots to a Discord Webhook

## Pre-requisites

- Windows Operating System
- PowerShell
- Discord application installed
- A Discord Webhook URL

## Functionality Breakdown

1. `Upload-Discord` - Function to upload files or text to Discord via a webhook.
2. `screenshot` - Captures screenshots based on given dimensions.
3. `PressKeys, PressKeys2, PressKeys3` - Simulate keypress events to navigate through Discord.
4. `Get-Discord` - Main function to execute the operations in sequence.

## How To Run

Here is an example that demonstrates how to take screenshots of your Discord and upload them using a webhook.

```powershell
Get-Discord -WebhookUrl "YOUR DISCORD WEBHOOK URL"
```
