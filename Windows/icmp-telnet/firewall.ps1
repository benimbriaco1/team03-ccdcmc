$ErrorActionPreference = "Stop"
 
$ad = Read-Host "IP of AD/DNS (pitwall)"
 
# Default deny inbound only (outbound is left untouched)
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -DefaultInboundAction Block
 
# Remove rules from previous runs (matched by name)
Remove-NetFirewallRule -DisplayName "CompFW*" -ErrorAction SilentlyContinue
 
$tcp = "53","88","135","389","445","464","636","3268","3269","9389"
$udp = "53","88","123","389","464"
 
# Inbound: ICMP echo request (ping) from anywhere
New-NetFirewallRule -DisplayName "CompFW In ICMPv4" -Direction Inbound -Action Allow -Protocol ICMPv4 -IcmpType 8 | Out-Null
New-NetFirewallRule -DisplayName "CompFW In ICMPv6" -Direction Inbound -Action Allow -Protocol ICMPv6 -IcmpType 128 | Out-Null
 
# Inbound: Telnet from anywhere
New-NetFirewallRule -DisplayName "CompFW In Telnet" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 23 | Out-Null
 
# Inbound: AD ports from the DC only
New-NetFirewallRule -DisplayName "CompFW In AD TCP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $tcp -RemoteAddress $ad | Out-Null
New-NetFirewallRule -DisplayName "CompFW In AD UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $udp -RemoteAddress $ad | Out-Null
 
Write-Host "Success: default deny inbound set; ICMP, Telnet and AD ports ($ad) allowed in." -ForegroundColor Green
 
