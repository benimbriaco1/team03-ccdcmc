#!/bin/bash
set -euo pipefail

DD_URL="https://ip-ranges.us5.datadoghq.com/"

# Download Datadog IP ranges
DD_JSON=$(curl -fsSL "$DD_URL")

# Extract all IPv4 and IPv6 prefixes
DD_RANGES=$(echo "$DD_JSON" | jq -r '
    .prefixes_ipv4[], .prefixes_ipv6[]
' | sort -u)

if [[ -z "$DD_RANGES" ]]; then
    echo "ERROR: Failed to retrieve Datadog IP ranges."
    exit 1
fi

# Configure UFW defaults
ufw --force enable
ufw default deny incoming
ufw default allow outgoing

# Allow traffic to and from Datadog
while IFS= read -r IP; do
    [[ -z "$IP" ]] && continue

    ufw allow in from "$IP" comment 'Datadog official IP ranges'
    ufw allow out to "$IP" comment 'Datadog official IP ranges'

done <<< "$DD_RANGES"

echo "Datadog IP ranges allowed."
ufw status verbose
