#!/usr/bin/env bash
set -euo pipefail

[ "$EUID" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
command -v jq   >/dev/null || { echo "Missing jq:   sudo apt install jq";   exit 1; }
command -v curl >/dev/null || { echo "Missing curl: sudo apt install curl"; exit 1; }

# Datadog US5 site; change the URL if you're on another site
URL="https://ip-ranges.us5.datadoghq.com/"

# Collect every IPv4/IPv6 prefix from every section, deduplicated
mapfile -t RANGES < <(curl -fsS "$URL" | jq -r '[.[] | objects | (.prefixes_ipv4[]?, .prefixes_ipv6[]?)] | unique | .[]')
[ "${#RANGES[@]}" -gt 0 ] || { echo "Failed to retrieve Datadog IP ranges. Aborting."; exit 1; }

# Skip IPv6 entries if ufw has IPv6 turned off (ufw errors on them otherwise)
if grep -qi '^IPV6=yes' /etc/default/ufw; then SKIP_V6=0; else SKIP_V6=1; fi

# Trusted internal hosts: inbound
for src in 172.16.1.0/24 10.3.1.99; do
    ufw allow in from "$src" comment 'CompFW Trusted Internal'
done

# Datadog: inbound and outbound
for r in "${RANGES[@]}"; do
    if [[ "$r" == *:* && "$SKIP_V6" -eq 1 ]]; then continue; fi
    ufw allow in  from "$r" comment 'CompFW Datadog'
    ufw allow out to   "$r" comment 'CompFW Datadog'
done

ufw reload
echo "Done. Datadog ranges processed: ${#RANGES[@]} (IPv6 skipped: $SKIP_V6)"
