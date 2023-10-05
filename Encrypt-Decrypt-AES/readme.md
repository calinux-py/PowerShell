```markdown
# PowerShell AES Encryption and Decryption

This set of PowerShell scripts allows you to easily encrypt and decrypt files using the AES (Advanced Encryption Standard) algorithm. You can use these scripts to secure sensitive data by encrypting it and later decrypting it when needed.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Encrypt-AES](#encrypt-aes)
  - [Decrypt-AES](#decrypt-aes)
- [Example](#example)
- [License](#license)

## Prerequisites

Before using these scripts, make sure you have PowerShell installed on your system.

## Usage

### Encrypt-AES

This script is used to encrypt a file using AES encryption and save the encrypted content to a new file with a ".aes" extension.

#### Parameters

- `plainTextFile` (mandatory): The path to the file you want to encrypt.

#### Example

```powershell
Encrypt-AES "path/to/the/file"
```

### Decrypt-AES

This script is used to decrypt a previously encrypted file and recover the original content.

#### Parameters

- `encryptedFilePath` (mandatory): The path to the encrypted file you want to decrypt.

#### Example

```powershell
Decrypt-AES "path/to/encrypted/file.aes"
```

## Example

Here's a simple example of how to use these scripts to encrypt and then decrypt a file:

1. Encrypt a file:

   ```powershell
   Encrypt-AES "path/to/the/file"
   ```

   This will create an encrypted file with a ".aes" extension.

2. Decrypt the encrypted file:

   ```powershell
   Decrypt-AES "path/to/encrypted/file.aes"
   ```

   This will decrypt the file and recover the original content.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

You can include this `readme.md` file in your project to provide clear instructions on how to use your PowerShell scripts for AES encryption and decryption.
