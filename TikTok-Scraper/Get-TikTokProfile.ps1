function Get-TikTokProfile {
    param([string]$Username)
    
    if (-not $Username) {
        $Username = Read-Host "Enter TikTok username"
    }
    
    $Username = $Username.TrimStart('@')
    
    try {
        Write-Host "`nFetching @$Username..." -ForegroundColor Yellow
        
        $html = (Invoke-WebRequest -Uri "https://www.tiktok.com/@$Username" -Headers @{
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0"
        }).Content
        
        $data = @{
            username = [regex]::Match($html, '"uniqueId":"([^"]+)"').Groups[1].Value
            nickname = [regex]::Match($html, '"nickname":"([^"]*)"').Groups[1].Value
            userId = [regex]::Match($html, '"id":"(\d+)"').Groups[1].Value
            verified = [regex]::Match($html, '"verified":(true|false)').Groups[1].Value
            followers = [regex]::Match($html, '"followerCount":(\d+)').Groups[1].Value
            following = [regex]::Match($html, '"followingCount":(\d+)').Groups[1].Value
            likes = [regex]::Match($html, '"heartCount":(\d+)').Groups[1].Value
            videos = [regex]::Match($html, '"videoCount":(\d+)').Groups[1].Value
            friends = [regex]::Match($html, '"friendCount":(\d+)').Groups[1].Value
            private = [regex]::Match($html, '"privateAccount":(true|false)').Groups[1].Value
            created = [regex]::Match($html, '"createTime":(\d+)').Groups[1].Value
            bio = [regex]::Match($html, '"webapp\.user-detail".*?"signature":"([^"]*)"').Groups[1].Value
        }
        
        if (-not $data.username -or -not $data.followers) {
            throw "Could not extract profile data"
        }
        
        Write-Host ("`n" + "="*50) -ForegroundColor Cyan
        Write-Host "  TIKTOK PROFILE: @$($data.username)" -ForegroundColor Cyan
        Write-Host ("="*50) -ForegroundColor Cyan
        
        Write-Host "`nBASIC INFO:" -ForegroundColor Green
        @(
            @("Username", "@$($data.username)", "Yellow"),
            @("Display Name", $data.nickname, "Yellow"),
            @("User ID", $data.userId, "Yellow"),
            @("Verified", $(if($data.verified -eq "true"){"✓ Yes"}else{"✗ No"}), $(if($data.verified -eq "true"){"Green"}else{"Red"}))
        ) | ForEach-Object {
            Write-Host "  $($_[0]): " -NoNewline -ForegroundColor White
            Write-Host $_[1] -ForegroundColor $_[2]
        }
        
        Write-Host "`nSTATISTICS:" -ForegroundColor Green
        @("Followers", "Following", "Total Likes", "Videos", "Friends") | ForEach-Object {
            $key = $_.ToLower() -replace ' ', '' -replace 'totallikes', 'likes'
            Write-Host "  ${_}: " -NoNewline -ForegroundColor White
            Write-Host $data.$key -ForegroundColor Magenta
        }
        
        Write-Host "`nACCOUNT SETTINGS:" -ForegroundColor Green
        Write-Host "  Private Account: " -NoNewline -ForegroundColor White
        Write-Host $(if($data.private -eq "true"){"Yes"}else{"No (Public)"}) -ForegroundColor $(if($data.private -eq "true"){"Red"}else{"Green"})
        
        if ($data.created) {
            Write-Host "  Account Created: " -NoNewline -ForegroundColor White
            Write-Host ([DateTimeOffset]::FromUnixTimeSeconds([int64]$data.created).ToString('MMMM dd, yyyy')) -ForegroundColor Yellow
        }
        
        Write-Host "`nBIO:" -ForegroundColor Green
        Write-Host "  $(if($data.bio){"$($data.bio)"}else{"(No bio)"})" -ForegroundColor $(if($data.bio){"White"}else{"Gray"})
        
        Write-Host ("`n" + "="*50) -ForegroundColor Cyan
        
    } catch {
        Write-Host "Error: $(if($_.Exception.Response.StatusCode -eq 404){"User '@$Username' not found"}else{$_.Exception.Message})" -ForegroundColor Red
    }
}

# Usage: Get-TikTokProfile "username" or just Get-TikTokProfile if ur lazy