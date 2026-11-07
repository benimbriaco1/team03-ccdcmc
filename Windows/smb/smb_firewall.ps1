$ErrorActionPreference = "Stop"

# allow ad to communicate w/host 
$ad  = Read-Host "IP of AD/DNS (pitwall):"
# allow us to RDP in from LAN 
$rdp = Read-Host "Network allowed to RDP in (e.g. 10.x.1.0/24 or 10.x.1.1)"
 
# Default deny inbound on all profiles
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -DefaultInboundAction Block 
 
# Remove rules from previous runs (matched by name)
Remove-NetFirewallRule -DisplayName "CompFW*" -ErrorAction SilentlyContinue

# ad ports to allow communication
$tcp = "53","88","135","389","445","464","636","3268","3269","9389"
$udp = "53","88","123","389","464"
 
# Inbound: SMB from anywhere - needed for scoring
New-NetFirewallRule -DisplayName "CompFW In SMB" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 445 | Out-Null
 
# Inbound: RDP from our LAN 
New-NetFirewallRule -DisplayName "CompFW In RDP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -RemoteAddress $rdp | Out-Null
 
# Inbound: AD ports from the DC only
New-NetFirewallRule -DisplayName "CompFW In AD TCP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $tcp -RemoteAddress $ad | Out-Null
New-NetFirewallRule -DisplayName "CompFW In AD UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $udp -RemoteAddress $ad | Out-Null
 

