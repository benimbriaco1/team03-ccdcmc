#! bin/bash

echo "Running System_Baselines..."

echo "------------------- HOSTNAME, OS, KERNEL -------------------"
hostnamectl

echo "------------------- DISTRO/VERSION -------------------"
cat /etc/os-release

echo "------------------- KERNEL -------------------"
uname -a

echo "------------------- LOAD + UPTIME -------------------"
uptime

echo "------------------- TIME / TIMEZONE -------------------"
date; timedatectl

echo "------------------- INTERFACES + IPS -------------------"
ip a

echo "------------------- ROUTES -------------------"
ip r

echo "------------------- DNS CONFIG -------------------"
cat /etc/resolv.conf

echo "------------------- HIJACKED HOSTNAMES -------------------"
cat /etc/hosts

echo "------------------- DISK USAGE (full = logging stops) -------------------"
df -h

echo "------------------- MEMORY -------------------"
free -h

echo "System_Baselines finished!"
