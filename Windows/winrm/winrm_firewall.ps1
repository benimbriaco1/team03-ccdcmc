$ErrorActionPreference = "Stop"
 
$ad = Read-Host "IP of AD/DNS (pitwall):"
 
# Default deny inbound only (outbound is left untouched)
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -DefaultInboundAction Block
 
# Remove rules from previous runs (matched by name)
Remove-NetFirewallRule -DisplayName "CompFW*" -ErrorAction SilentlyContinue
 
$tcp = "53","88","135","389","445","464","636","3268","3269","9389"
$udp = "53","88","123","389","464"
 
# Inbound: WinRM (HTTP/HTTPS) from anywhere
New-NetFirewallRule -DisplayName "CompFW In WinRM" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985,5986 | Out-Null
 
# Inbound: AD ports from the DC only
New-NetFirewallRule -DisplayName "CompFW In AD TCP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $tcp -RemoteAddress $ad | Out-Null
New-NetFirewallRule -DisplayName "CompFW In AD UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $udp -RemoteAddress $ad | Out-Null

New-NetFirewallRule -DisplayName "Allow Inbound from Trusted Hosts" `
  -Direction Inbound -Action Allow -Protocol Any `
  -RemoteAddress 172.16.1.0/24,10.3.1.99/32 `
  -Profile Any -Enabled True
 
Write-Host "Success: default deny inbound set; WinRM and AD ports ($ad) allowed in." -ForegroundColor Green
 
