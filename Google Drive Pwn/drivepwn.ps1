function Access-Drive {
    param(
        [Parameter(Mandatory=$true)]
        [string]$em
    )

    # drive url target
    Start-Process "https://drive.google.com/drive/u/0/my-drive"
    
    # If you wish to add other drive URLs, you can uncomment and use the below lines:
    # Start-Process "https://drive.google.com/drive/u/1/my-drive"
    # Start-Process "https://drive.google.com/drive/u/2/my-drive"
    # Start-Process "https://drive.google.com/drive/u/3/my-drive"

    Start-Sleep -Seconds 3

    Add-Type -AssemblyName System.Windows.Forms

    [System.Windows.Forms.SendKeys]::SendWait("^(a)")
    Start-Sleep -Milliseconds 400

    [System.Windows.Forms.SendKeys]::SendWait(".")
    Start-Sleep -Seconds 1.5

    # Enter email you want to grant access for
    $word = $em
    foreach ($letter in $word.ToCharArray()) {
        [System.Windows.Forms.SendKeys]::SendWait($letter)
        Start-Sleep -Milliseconds 3
    }

    Start-Sleep -Milliseconds 400

    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    Start-Sleep -Milliseconds 400

    for ($i=0; $i -lt 6; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Milliseconds 30  
    }

    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    Start-Sleep -Seconds 3

    Get-Process | Where-Object { $_.MainWindowTitle -match "Google Drive" } | Stop-Process -Force
}

# To use the function (pass email you want to grant access):
# Access-Drive -em "your_email@example.com"
