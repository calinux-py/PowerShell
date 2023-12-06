# PowerShell script to find a file and add its path to the registry for auto-run at boot

# Define the file to search for
$fileName = "wallpaper_AUTO-cali.ps1"

# Search for the file in the specified directory
$file = Get-ChildItem -Path C:\ -Recurse -Filter $fileName -ErrorAction SilentlyContinue | Select-Object -First 1

# Check if the file was found
if ($file -ne $null) {
    # Extract the full path of the file
    $filePath = $file.FullName

    # Define the registry path where the string value will be added
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

    # Define the name of the new registry entry
    $regName = "Wallpaper Engine"

    # Add the file path to the registry
    Set-ItemProperty -Path $regPath -Name $regName -Value $filePath

    Write-Host "Registry entry added for auto-run at boot: $filePath"
    Read-Host -Prompt "Press Enter to continue"

} else {
    Write-Host "File not found: $fileName"
    Read-Host -Prompt "Press Enter to continue"
}
