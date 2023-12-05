# PowerShell Script to Disable UAC

# Ensure the script is run with Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as an Administrator!"
    break
}
# Set the path to the registry key
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
# Disable UAC by setting EnableLUA to 0
Set-ItemProperty -Path $registryPath -Name "EnableLUA" -Value 0