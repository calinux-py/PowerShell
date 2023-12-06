Sleep 10

do {
    # Execute the Get-ChildItem command to find and start wallpaper64.exe
    Get-ChildItem -Recurse -Path C:\ -Filter "wallpaper64.exe" | Select-Object -First 1 | ForEach-Object { Start-Process $_.FullName }

    # Wait for 5 seconds
    Start-Sleep -Seconds 5

    # Check if wallpaper64.exe is running
    $process = Get-Process wallpaper64 -ErrorAction SilentlyContinue

    # If the process is found, exit the script
    if ($process) {
        exit
    }

    # If the process is not found, the loop will continue and rerun the Get-ChildItem command
} while ($true)
