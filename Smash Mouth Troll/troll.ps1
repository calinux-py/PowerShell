function T {
    Add-Type -AssemblyName System.Windows.Forms

    $lyrics = @(
		"Somebody once told me the world is gonna roll me"
		"I ain't the sharpest tool in the shed"
		"She was looking kind of dumb with her finger and her thumb"
		"In the shape of an 'L' on her forehead"
        "Well, the years start coming and they don't stop coming",
        "and they don't stop coming"
    )

    foreach ($line in $lyrics) {
        if ($line -eq "and they don't stop coming") {
            while ($true) {
                [System.Windows.Forms.MessageBox]::Show($line, "meme", [System.Windows.Forms.MessageBoxButtons]::OK)
            }
        }
        else {
            [System.Windows.Forms.MessageBox]::Show($line, "meme", [System.Windows.Forms.MessageBoxButtons]::OK)
        }
    }
}
