function Get-Geo {
    $ipInfoApiUrl = "http://ip-api.com/json"
    
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

            Write-Host "IP Address    : $($geoLocation.IP)"
            Write-Host "Country       : $($geoLocation.Country)"
            Write-Host "Region        : $($geoLocation.Region)"
            Write-Host "City          : $($geoLocation.City)"
            Write-Host "Latitude      : $($geoLocation.Latitude)"
            Write-Host "Longitude     : $($geoLocation.Longitude)"
            Write-Host "Time Zone     : $($geoLocation.TimeZone)"
            Write-Host "ISP           : $($geoLocation.ISP)"
        }
        else {
            Write-Error "Failed to retrieve geolocation information."
        }
    }
    catch {
        Write-Error "An error occurred while trying to fetch geolocation data: $_"
    }
}