Add-Type -AssemblyName System.Windows.Forms

$response = [System.Windows.Forms.MessageBox]::Show("Go to 7DtD door you want to unlock and go to the 'Enter Code' screen and click OK.", "Unlock Door", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)

if ($response -eq [System.Windows.Forms.DialogResult]::OK) {
    [System.Windows.Forms.MessageBox]::Show("Hold CTRL for 3 seconds to stop.", "Instruction", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)
    Start-Sleep -Seconds 5
} else {
    exit
}

Add-Type -AssemblyName PresentationCore

$lines = Get-Content "C:\Programming\#PythonScripts\Malware\Windows\WiFi Password Bruteforce\pass.txt"

function Send-Keystroke {
    param (
        [string]$Keys
    )
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait($Keys)
}

function Mouse-ClickCenter {
    Add-Type -AssemblyName System.Windows.Forms
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(($screenWidth/2), ($screenHeight/2))

    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseActions {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, uint dwExtraInfo);

    public static void MouseClick() {
        mouse_event(0x0002, 0, 0, 0, 0); // Mouse down
        mouse_event(0x0004, 0, 0, 0, 0); // Mouse up
    }
}
"@ -Language CSharp

    [MouseActions]::MouseClick()
}

function Check-CtrlPressed {
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LeftCtrl) -or 
        [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightCtrl)) {
        exit
    }
}

foreach ($line in $lines) {
    Check-CtrlPressed

    Send-Keystroke $line
    Send-Keystroke "{ENTER}"
    
    Check-CtrlPressed

    $randomDelay = Get-Random -Minimum 0.2 -Maximum 2
    Start-Sleep -Seconds $randomDelay

    for ($i = 0; $i -lt $randomDelay; $i++) {
        Check-CtrlPressed
        Start-Sleep -Seconds 0.5
    }

    Mouse-ClickCenter
    Start-Sleep 1
}
