cls
[Console]::CursorVisible = $false

$width = [Console]::WindowWidth
$height = [Console]::WindowHeight
$text = "C a l i N u X"

$drops = 0..($width - 1) | ForEach-Object { Get-Random -Minimum 0 -Maximum $height }
cls

while ($true) {
    if ([Console]::KeyAvailable) {
        [Console]::ReadKey($true) | Out-Null
        cls
        break
    }
    
    for ($i = 0; $i -lt $width; $i++) {
        $char = [char](Get-Random -Minimum 33 -Maximum 126)
        [Console]::SetCursorPosition($i, $drops[$i])
        Write-Host $char -ForegroundColor Green -NoNewline
        
        $drops[$i]++
        if ($drops[$i] -ge $height) {
            $drops[$i] = 0
        }
    }
    
    $centerX = [Math]::Floor(($width - $text.Length) / 2)
    $centerY = [Math]::Floor($height / 2)
    [Console]::SetCursorPosition($centerX, $centerY)
    Write-Host $text -ForegroundColor Red -NoNewline
    
    Start-Sleep -Milliseconds 80
}