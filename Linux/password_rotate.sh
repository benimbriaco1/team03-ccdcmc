#!/bin/bash
# Usage:
#   ./password-reset.sh -Users alice,bob    change passwords for only these users (any UID, including root)
 
if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi
 
if [ "$1" != "-Users" ] || [ -z "$2" ]; then
    echo "Usage: $0 -Users a,b"
    exit 1
fi
 
read -s -p "New password: " PASS1; echo
read -s -p "Confirm password: " PASS2; echo
if [ "$PASS1" != "$PASS2" ]; then
    echo "Passwords do not match"
    exit 1
fi
 
IFS=',' read -ra NAMES <<< "$2"
for name in "${NAMES[@]}"; do
    if echo "$name:$PASS1" | chpasswd; then
        echo "[+] $name"
    else
        echo "[!] $name"
    fi
done
 
echo "Done."
 
