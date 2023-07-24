Password Validation PowerShell Script

**Introduction**
```
This PowerShell script, written by CaliNux, is designed to validate a user-entered password against a pre-defined encrypted password. The script prompts the user to enter the password and compares it with the decrypted password stored in a specified file. It allows a maximum number of attempts before displaying an error message and imposing a brief delay.
Prerequisites
```
**Before running the script, ensure the following prerequisites are met:**
```
    Encrypted Password File: The encrypted password file must be created and accessible at the specified location.
```
**Instructions**
```
Follow these steps to use the script:

    Define the Encrypted Password File: Update the $encryptedPasswordFile variable with the path to your encrypted password file.

    Set Maximum Attempts: The $maxAttempts variable determines the maximum number of password entry attempts allowed.

    Customize Prompt Message: Modify the $promptMessage variable to display a customized prompt for password entry.

    Customize Error Message: Adjust the $errorMessage variable to customize the error message displayed after reaching the maximum attempts.

Running the Script

    Open a PowerShell terminal.

    Navigate to the directory containing the script.

    Execute the script by entering .\scriptname.ps1, where scriptname.ps1 is the name of the script file.

    The script will prompt you to enter the password.

    After entering the password, the script will validate it against the decrypted password stored in the encrypted file.

    If the entered password is correct, the script will exit.

    If the entered password is incorrect, the script will provide feedback and allow for additional attempts until the maximum limit is reached.
```
**Important Notes**
```
    Make sure to keep the encrypted password file secure and accessible only to authorized users.

    The script does not permanently lock the user out after reaching the maximum attempts. To reset the attempts, rerun the script.

    Always handle encrypted password files and sensitive data with utmost care and security.```
