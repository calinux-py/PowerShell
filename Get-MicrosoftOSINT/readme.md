# Get-MicrosoftOSINT

**Author:** calinux  

A PowerShell function for quickly gathering **OSINT** on Microsoft/Office 365 domains.  
It checks whether a domain is hosted on Microsoft, retrieves tenant details, and enumerates related endpoints.

---

## Features
- Detects if a domain is hosted on Microsoft/Office 365.
- Retrieves:
  - Tenant ID
  - Organization name
  - Namespace type (Managed/Federated)
  - Cloud instance & user state
  - Key OAuth2 & Microsoft Graph endpoints
- Displays federation authentication details if applicable.

---

## Requirements
- PowerShell 5.1+ or PowerShell Core  
- Internet access (queries Microsoft's login endpoints)

---

## Usage
```powershell
# Import the script
. .\Get-MicrosoftOSINT.ps1

# Run interactively (prompt for domain)
Get-MicrosoftOSINT

# Specify a domain directly
Get-MicrosoftOSINT -Domain "contoso.com"

# Capture output in a variable for further use
$results = Get-MicrosoftOSINT -Domain "contoso.com" -OutVariable results
````

---

## Example Output

```
=== Microsoft OSINT for Domain: contoso.com ===
✓ Domain IS hosted on Microsoft/Office 365
✓ Namespace Type: Managed
✓ Tenant ID: 12345678-90ab-cdef-1234-567890abcdef
✓ Microsoft Graph host: graph.microsoft.com
...
=== END REPORT ===
```