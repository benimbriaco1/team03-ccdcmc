#Requires -RunAsAdministrator

# Retrieve official Datadog IP ranges (US5 site; change URL if you're on another site)
$ddUrl = "https://ip-ranges.us5.datadoghq.com/"
$dd = Invoke-RestMethod -Uri $ddUrl

# Collect all IPv4 and IPv6 prefixes across every Datadog section
$ddRanges = foreach ($section in $dd.PSObject.Properties) {
    if ($section.Value -and $section.Value.PSObject.Properties.Name -contains 'prefixes_ipv4') {
        $section.Value.prefixes_ipv4
        $section.Value.prefixes_ipv6
    }
}
$ddRanges = @($ddRanges | Where-Object { $_ } | Sort-Object -Unique)

if (-not $ddRanges) {
    throw "Failed to retrieve Datadog IP ranges. Aborting."
}

# Remove old copies so re-runs don't create duplicates
foreach ($name in "CompFW Datadog Inbound", "CompFW Datadog Outbound", "CompFW Trusted Internal Inbound") {
    Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue | Remove-NetFirewallRule
}

# Datadog: inbound
New-NetFirewallRule `
    -DisplayName "CompFW Datadog Inbound" `
    -Direction Inbound `
    -Action Allow `
    -Protocol Any `
    -RemoteAddress $ddRanges | Out-Null

# Datadog: outbound
New-NetFirewallRule `
    -DisplayName "CompFW Datadog Outbound" `
    -Direction Outbound `
    -Action Allow `
    -Protocol Any `
    -RemoteAddress $ddRanges | Out-Null

# Trusted internal hosts: inbound
New-NetFirewallRule `
    -DisplayName "CompFW Trusted Internal Inbound" `
    -Direction Inbound `
    -Action Allow `
    -Protocol Any `
    -RemoteAddress @("172.16.1.0/24", "10.3.1.99/32") | Out-Null

Write-Host "Done. Datadog ranges added: $($ddRanges.Count)"
