# Retrieve official Datadog IP ranges
$ddUrl = "https://ip-ranges.us5.datadoghq.com/"
$dd = Invoke-RestMethod -Uri $ddUrl

# Collect all IPv4 and IPv6 prefixes across Datadog services
$ddRanges = @(
    $dd.PSObject.Properties |
    Where-Object { $_.Name -match '^prefixes_ipv[46]$' } |
    ForEach-Object { $_.Value }
) | Sort-Object -Unique

if (-not $ddRanges) {
    throw "Failed to retrieve Datadog IP ranges. Aborting."
}

# Explicitly allow traffic to and from Datadog
New-NetFirewallRule `
    -DisplayName "CompFW Datadog Inbound" `
    -Direction Inbound `
    -Action Allow `
    -Protocol Any `
    -RemoteAddress $ddRanges | Out-Null

New-NetFirewallRule `
    -DisplayName "CompFW Datadog Outbound" `
    -Direction Outbound `
    -Action Allow `
    -Protocol Any `
    -RemoteAddress $ddRanges | Out-Null
