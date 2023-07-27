Get-Ports PowerShell Function
Description

The Get-Ports function is a PowerShell script that retrieves information about established TCP connections and displays the open ports along with their corresponding remote ports. It is particularly useful for network analysis and troubleshooting.
Prerequisites

Before using the Get-Ports function, ensure that you have the necessary permissions to execute PowerShell scripts on your system. Additionally, the function requires Windows PowerShell and access to the Get-NetTCPConnection cmdlet.
How to Use

    Open PowerShell: Launch PowerShell with administrative privileges if you require elevated access to view all established TCP connections.

    Copy the Get-Ports function: Copy the entire content of the function and paste it into your PowerShell terminal.

    Run the function: After pasting the function, execute it by typing Get-Ports and pressing Enter.

Function Output

The function outputs information about open ports and their corresponding remote ports in a tabulated format. Each entry displays the local port, the remote port it is connected to, and an incrementing number to help identify each connection.