# Convert-Base64 PowerShell Script

## Overview
This PowerShell script provides a function `Convert-Base64` that takes a file path as input and performs either Base64 encoding or decoding on its content. If the file is already in Base64 format, it decodes it; otherwise, it encodes the file content to Base64 format.

## Features
- Automatically detect whether a file is Base64 encoded
- Encode to Base64 if the file is not already Base64 encoded
- Decode from Base64 if the file is Base64 encoded

## Prerequisites
- PowerShell 5.1 or higher

## Usage

1. Open PowerShell terminal.
2. Navigate to the directory where the script is saved or import it.
3. Run the function `Convert-Base64`.

```powershell
PS C:\> .\path-to-script.ps1
PS C:\> Convert-Base64
```

4. You'll be prompted to enter the file path:

```powershell
Enter the path of the file you want to convert: C:\path\to\your\file.txt
```

The script will automatically determine if the file is Base64 encoded and will encode or decode accordingly.

## Error Handling
- If the file does not exist, the script will output `"File does not exist. Exiting..."` and terminate.

## License
This project is open-source and available under the MIT License. Feel free to use, modify, and distribute.

For any issues or suggestions, please open an issue on GitHub.
