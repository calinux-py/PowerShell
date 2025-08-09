# TikTok Scraper

A simple PowerShell script to fetch and display TikTok profile information directly from the command line.

## What it does

- Grabs profile data for any public TikTok user
- Shows follower count, likes, videos, and other stats
- Displays account info like verification status and creation date
- Works without any API keys or authentication

## Usage

```powershell

# Load the function

. .\\Get-TikTokProfile.ps1

# Fetch a profile

Get-TikTokProfile "username"

# Or just run it and enter username when prompted

Get-TikTokProfile

```

## Example output

```

==================================================

TIKTOK PROFILE: @someuser

==================================================



BASIC INFO:

Username: @someuser

Display Name: Some User

User ID: 123456789

Verified: ✗ No

STATISTICS:

Followers: 15420

Following: 234

Total Likes: 89653

Videos: 127

Friends: 45

ACCOUNT SETTINGS:

Private Account: No (Public)

Account Created: March 15, 2021



BIO:

Just here for the memes 🎭

==================================================

```

## Requirements

- PowerShell 5.1 or later

## Author

calinux

## Note

This scrapes public profile data only. Private accounts will show limited info.


