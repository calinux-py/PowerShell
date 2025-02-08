# Obfuscate PowerShell Script

## Description
`Obfuscate` is a PowerShell script that obfuscates a given PowerShell script file by renaming functions and variables, removing comments and unnecessary whitespace, and optionally inserting junk code. It also provides deeper levels of obfuscation, including numeric obfuscation, compression, and encryption.

## Features
- **Basic Obfuscation**: Removes comments, renames functions and variables, and strips unnecessary whitespace.
- **Junk Code Insertion**: Inserts random functions and variables to make analysis more difficult.
- **Deep Numeric Obfuscation**: Converts numeric literals into complex arithmetic expressions.
- **Advanced Mode**: Compresses the obfuscated code and wraps it in a self-extracting loader.
- **SuperAdvanced Mode**: Compresses and encrypts the obfuscated script, requiring a password to execute.

## Usage
```powershell
Obfuscate -FilePath <path to script> [options]
```

### Parameters
- `-FilePath <string>`: Path to the PowerShell script to obfuscate.
- `-Advanced`: Enables compression and a self-extracting loader.
- `-Junk`: Inserts junk functions and variables.
- `-Deep`: Applies deep numeric obfuscation.
- `-SuperAdvanced`: Compresses and encrypts the obfuscated script.
- `-Help, -h, --help`: Displays help information.

### Examples
```powershell
# Basic obfuscation
Obfuscate -FilePath "C:\path\to\script.ps1"

# Obfuscation with junk code and deep numeric obfuscation
Obfuscate -FilePath "C:\path\to\script.ps1" -Advanced -Junk -Deep

# SuperAdvanced obfuscation (compression + encryption)
Obfuscate -FilePath "C:\path\to\script.ps1" -Advanced -SuperAdvanced -Junk -Deep
```

## Output
The obfuscated script is saved in the same directory as the original file, with a suffix indicating the obfuscation mode used:
- `-Obfuscated.ps1`: Basic obfuscation.
- `-AdvancedObfuscated.ps1`: Advanced obfuscation.
- `-SuperAdvancedObfuscated.ps1`: SuperAdvanced obfuscation (compressed and encrypted).

## Notes
- In `SuperAdvanced` mode, the script will prompt for an encryption password.
- Encrypted scripts will require the correct password to execute.