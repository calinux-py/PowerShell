function Get-MicrosoftOSINT {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Domain
    )
    
    if (-not $Domain) {
        $Domain = Read-Host "Enter the domain to investigate"
    }
    
    if ([string]::IsNullOrWhiteSpace($Domain)) {
        Write-Error "Domain cannot be empty"
        return
    }
    
    Write-Host "`n=== Microsoft OSINT for Domain: $Domain ===" -ForegroundColor Cyan
    Write-Host "Checking if domain is hosted on Microsoft..." -ForegroundColor Yellow
    
    $Results = [PSCustomObject]@{
        Domain = $Domain
        IsHostedOnMicrosoft = $false
        TenantExists = $false
        TenantID = $null
        OrganizationName = $null
        NamespaceType = $null
        CloudInstance = $null
        UserState = $null
        FederationBrandName = $null
        Endpoints = @{}
        ErrorMessages = @()
    }
    
    try {
        Write-Host "`n[0] Performing initial domain check..." -ForegroundColor Green
        $userRealmUrl = "https://login.microsoftonline.com/getuserrealm.srf?login=user@$Domain"
        
        try {
            $initialCheck = Invoke-RestMethod -Uri $userRealmUrl -Method GET -ErrorAction Stop
            
            if ($initialCheck.NameSpaceType -eq "Unknown" -or 
                [string]::IsNullOrWhiteSpace($initialCheck.NameSpaceType)) {
                Write-Host "  ✗ Domain is NOT hosted on Microsoft/Office 365" -ForegroundColor Red
                Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
                Write-Host "Domain '$Domain' is not a Microsoft/Office 365 tenant." -ForegroundColor Yellow
                Write-Host "This domain may be hosted elsewhere or does not exist." -ForegroundColor Yellow
                Write-Host "`n=== END REPORT ===" -ForegroundColor Cyan
                return
            }
            
            $Results.IsHostedOnMicrosoft = $true
            Write-Host "  ✓ Domain IS hosted on Microsoft/Office 365" -ForegroundColor Green
            Write-Host "  Proceeding with detailed information gathering..." -ForegroundColor Yellow
            
        }
        catch {
            Write-Host "  ✗ Unable to determine if domain is hosted on Microsoft" -ForegroundColor Red
            Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
            Write-Host "Could not verify if domain '$Domain' is hosted on Microsoft." -ForegroundColor Yellow
            Write-Host "The domain may not exist or the service is unavailable." -ForegroundColor Yellow
            Write-Host "`n=== END REPORT ===" -ForegroundColor Cyan
            return
        }
        
        Write-Host "`n[1] Analyzing user realm details..." -ForegroundColor Green
        
        if ($initialCheck) {
            $Results.TenantExists = $true
            $Results.NamespaceType = $initialCheck.NameSpaceType
            $Results.CloudInstance = $initialCheck.CloudInstanceName
            $Results.UserState = switch ($initialCheck.UserState) {
                1 { "Exists" }
                2 { "Unknown" }
                3 { "Throttled" }
                4 { "Managed" }
                default { $initialCheck.UserState }
            }
            $Results.FederationBrandName = $initialCheck.FederationBrandName
            
            Write-Host "  ✓ Domain Status: Active Microsoft tenant" -ForegroundColor Green
            Write-Host "  ✓ Namespace Type: $($Results.NamespaceType)" -ForegroundColor White
            
            if ($Results.NamespaceType -eq "Federated") {
                Write-Host "  ✓ Federation Status: FEDERATED (uses external identity provider)" -ForegroundColor Yellow
                if ($initialCheck.AuthURL) {
                    Write-Host "  ✓ Federation Auth URL: $($initialCheck.AuthURL)" -ForegroundColor White
                }
            }
            elseif ($Results.NamespaceType -eq "Managed") {
                Write-Host "  ✓ Federation Status: MANAGED (uses Microsoft authentication)" -ForegroundColor Green
            }
            
            Write-Host "  ✓ User State: $($Results.UserState)" -ForegroundColor White
            Write-Host "  ✓ Cloud Instance: $($Results.CloudInstance)" -ForegroundColor White
            
            if ($Results.FederationBrandName) {
                Write-Host "  ✓ Organization Name: $($Results.FederationBrandName)" -ForegroundColor White
                $Results.OrganizationName = $Results.FederationBrandName
            }
        }
        
        Write-Host "`n[2] Checking OpenID configuration..." -ForegroundColor Green
        $openIdUrl = "https://login.microsoftonline.com/$Domain/v2.0/.well-known/openid-configuration"
        
        try {
            $openIdResponse = Invoke-RestMethod -Uri $openIdUrl -Method GET -ErrorAction Stop
            
            if ($openIdResponse) {
                if ($openIdResponse.issuer -match "([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})") {
                    $Results.TenantID = $matches[1]
                    Write-Host "  ✓ Tenant ID: $($Results.TenantID)" -ForegroundColor White
                }
                
                $Results.Endpoints = @{
                    AuthorizationEndpoint = $openIdResponse.authorization_endpoint
                    TokenEndpoint = $openIdResponse.token_endpoint
                    UserInfoEndpoint = $openIdResponse.userinfo_endpoint
                    JWKSUri = $openIdResponse.jwks_uri
                    DeviceAuthEndpoint = $openIdResponse.device_authorization_endpoint
                    LogoutEndpoint = $openIdResponse.end_session_endpoint
                    KerberosEndpoint = $openIdResponse.kerberos_endpoint
                    GraphHost = $openIdResponse.msgraph_host
                    CloudGraphHost = $openIdResponse.cloud_graph_host_name
                    RBACUrl = $openIdResponse.rbac_url
                }
                
                Write-Host "  ✓ OAuth2 endpoints discovered" -ForegroundColor White
                Write-Host "  ✓ Microsoft Graph host: $($openIdResponse.msgraph_host)" -ForegroundColor White
                Write-Host "  ✓ Tenant region scope: $($openIdResponse.tenant_region_scope)" -ForegroundColor White
                
                if ($openIdResponse.token_endpoint_auth_methods_supported) {
                    Write-Host "  ✓ Supported auth methods: $($openIdResponse.token_endpoint_auth_methods_supported -join ', ')" -ForegroundColor White
                }
            }
        }
        catch {
            $Results.ErrorMessages += "OpenID configuration query failed: $($_.Exception.Message)"
            Write-Host "  ✗ Unable to retrieve OpenID configuration" -ForegroundColor Red
        }
        
        Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
        Write-Host "Domain: $Domain" -ForegroundColor White
        Write-Host "Microsoft Hosted: Yes" -ForegroundColor Green
        if ($Results.TenantID) { Write-Host "Tenant ID: $($Results.TenantID)" -ForegroundColor White }
        if ($Results.OrganizationName) { Write-Host "Organization: $($Results.OrganizationName)" -ForegroundColor White }
        Write-Host "Namespace Type: $($Results.NamespaceType)" -ForegroundColor White
        Write-Host "User State: $($Results.UserState)" -ForegroundColor White
        Write-Host "Cloud Instance: $($Results.CloudInstance)" -ForegroundColor White
        
        Write-Host "`nKey Endpoints:" -ForegroundColor Cyan
        if ($Results.Endpoints.AuthorizationEndpoint) {
            Write-Host "  • Authorization: $($Results.Endpoints.AuthorizationEndpoint)" -ForegroundColor Gray
        }
        if ($Results.Endpoints.GraphHost) {
            Write-Host "  • Microsoft Graph: https://$($Results.Endpoints.GraphHost)" -ForegroundColor Gray
        }
        
        if ($Results.ErrorMessages.Count -gt 0) {
            Write-Host "`nErrors encountered:" -ForegroundColor Red
            $Results.ErrorMessages | ForEach-Object { Write-Host "  • $_" -ForegroundColor Red }
        }
        
        Write-Host "`n=== END REPORT ===" -ForegroundColor Cyan
        
        if ($PSBoundParameters.ContainsKey('OutVariable')) {
            return $Results
        }
        else {
            $null = $Results
        }
    }
    catch {
        Write-Error "An unexpected error occurred: $($_.Exception.Message)"
    }
}

# Example usage:
# Get-MicrosoftOSINT -Domain "contoso.com"
# Get-MicrosoftOSINT