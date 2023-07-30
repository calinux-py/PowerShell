Description
The CaliLoot PowerShell script is designed to copy specific folders from the user's computer to a designated folder on Dropbox using the Dropbox API. This script requires a Dropbox access token to function correctly. It is intended for users who want to back up certain folders, such as 'MyDocuments' and 'MyPictures', to their Dropbox account.

Prerequisites
Before running the script, ensure you have the following:

PowerShell installed on your system.
A valid Dropbox account.
A Dropbox access token generated from the Dropbox App Console. Replace "YOUR DROPBOX TOKEN HERE" in the script with your actual access token.
Usage
Open the PowerShell console or PowerShell ISE (Integrated Scripting Environment).

Copy and paste the script into the console.

Replace "YOUR DROPBOX TOKEN HERE" with your actual Dropbox access token.

Run the script, and it will perform the following tasks:

Create a folder named "CaliLoot" in your Dropbox account.
Copy the contents of "MyDocuments" and "MyPictures" folders to a temporary folder on your system (CaliLoot).
Upload the copied files from the temporary folder to the corresponding locations in the "CaliLoot" folder on Dropbox.
Please note that the script will automatically rename files with conflicting names in the Dropbox folder to prevent overwriting.