function Get-Ports {
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }
    $openPorts = $connections | Select-Object -ExpandProperty LocalPort | Sort-Object -Unique
    $currentNumber = $openPorts.Count
    Write-Host "`nOPEN PORTS: $currentNumber"-ForegroundColor Cyan
    
    $portCount = 1
    foreach ($port in $openPorts) {
        $remotePorts = ($connections | Where-Object { $_.LocalPort -eq $port }).RemotePort | Select-Object -Unique
        foreach ($remotePort in $remotePorts) {
            Write-Host "`n$portCount. [Local Port]: $port <--> [Remote Port]: $remotePort"-ForegroundColor Red
            $portCount++
write-host("")
        }
    }
}