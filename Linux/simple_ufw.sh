#! /bin/bash

echo "simple_ufw.sh is running..."

echo "ufw install:"
apt install ufw

echo "blocking incoming traffic"
ufw default deny incoming

echo "allowing outgoing traffic"
ufw default allow outgoing

echo "allowing ssh"
ufw allow ssh

echo "open to http & https"
ufw allow http
ufw allow https

echo "enabling logging & setting it to medium"
ufw logging on
ufw logging medium

echo "enabling ufw and verifying status"
ufw enable
ufw status verbose

echo "simple_ufw.sh complete!"