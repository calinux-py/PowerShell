Get-ChildItem -Recurse -Path C:\ -Filter "wallpaper64.exe" | Select-Object -First 1 | ForEach-Object { Start-Process $_.FullName }
