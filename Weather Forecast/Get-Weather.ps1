function Get-Weather {
    $url = "https://wttr.in/"
    $units = "?u" # ?M or ?m for metric options - RUX
    $location = "Sunnyvale CA" # Replace "Your_Location" with your desired location

    $wttrUrl = "$url/$location?units"
    $weatherForecast = Invoke-RestMethod -Uri $wttrUrl

    Write-Host $weatherForecast
}