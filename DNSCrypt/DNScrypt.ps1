# Check if script is being run as an administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script needs to be run as an administrator. Please restart the script with administrative privileges." -ForegroundColor Red
    Read-Host "Press any key to exit..."
    exit
}

# Check if dnscrypt-proxy.exe is running
$process = Get-Process -Name "dnscrypt-proxy" -ErrorAction SilentlyContinue

if (-not $process) {
    # If dnscrypt-proxy.exe is not running, follow these instructions:

    # Change directory
    Set-Location "C:\dnscrypt-proxy-win64-2.1.5\win64"

    # Start dnscrypt-proxy service
    .\dnscrypt-proxy -service start

    # Change DNS IP address to 127.0.0.1 and port to 53
    $interface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ServerAddresses "127.0.0.1"

} else {
    # If dnscrypt-proxy.exe is already running, follow these instructions:

    # Change directory
    Set-Location "C:\dnscrypt-proxy-win64-2.1.5\win64"

    # Stop dnscrypt-proxy service
    .\dnscrypt-proxy -service stop

    # Change DNS and IP address back to auto
    $interface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ResetServerAddresses
}
