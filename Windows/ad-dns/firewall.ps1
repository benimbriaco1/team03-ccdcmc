$ErrorActionPreference = "Stop"

# Default deny inbound only (outbound is left untouched)
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -DefaultInboundAction Block

# Remove rules from previous runs (matched by name)
Remove-NetFirewallRule -DisplayName "CompFW*" -ErrorAction SilentlyContinue

# Allow in: DNS + AD ports
New-NetFirewallRule -DisplayName "CompFW In AD-DNS TCP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 53,88,135,389,445,464,636,3268,3269 | Out-Null
New-NetFirewallRule -DisplayName "CompFW In AD-DNS UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 53,88,123,389,464 | Out-Null

New-NetFirewallRule -DisplayName "Allow Inbound from Trusted Hosts" `
  -Direction Inbound -Action Allow -Protocol Any `
  -RemoteAddress 172.16.1.0/24,10.3.1.99/32 `
  -Profile Any -Enabled True

Write-Host "Success: default deny inbound set; AD and DNS ports allowed in." -ForegroundColor Green
