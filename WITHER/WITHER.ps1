Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Set-MpPreference -DisableRealtimeMonitoring $true

Set-MpPreference -MAPSReporting 0


Set-MpPreference -SubmitSamplesConsent 0
