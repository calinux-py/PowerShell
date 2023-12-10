# MemeEncryption README.md

## Introduction
This PowerShell script provides a unique way to encrypt and decrypt files using a custom algorithm. 
The goal was to test if custom encryption was more effective in avoiding AV detection.

## Features
- **Custom Encryption Algorithm**: Uses a combination of XOR operations and a fixed key for encryption.
- **Base64 Encoding**: Encrypted data is encoded in Base64, making it suitable for storage or transmission in text form.
- **Encrypt and Decrypt Files**: Functions to encrypt and decrypt files, with the encrypted file having a `.meme` extension.
- **PowerShell Based**: Easy to run and integrate into existing PowerShell workflows.

## Functions
1. **MemeEncrypt($inputString)**: Encrypts a given string using the custom algorithm.
2. **CustomDecrypt($encryptedString)**: Decrypts a string encrypted by the MemeEncrypt function.
3. **EF($FP)**: Encrypts the content of a file at the given file path.
4. **DF($encryptedFilePath)**: Decrypts a file encrypted by the EF function.

## How to Use
1. **Encrypt a File**: Call the `EF` function with the file path as an argument.
   ```powershell
   $FP = "path_to_your_file"
   EF $FP
   ```
   This will create an encrypted file with the `.meme` extension.

2. **Decrypt a File**: Call the `DF` function with the path to the encrypted `.meme` file.
   ```powershell
   DF "path_to_your_file.meme"
   ```
   This will restore the file to its original form.

## Requirements
- PowerShell 5.0 or higher.

## Security Note
While MemeEncryption adds a fun twist to file encryption, it's important to note that the fixed key `"YouHaveBeenDabbedOnGoodSir"` is hardcoded into the script. For serious security applications, consider using a more robust encryption method or modifying the script to use a dynamic key.
