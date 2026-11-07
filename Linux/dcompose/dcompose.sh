#!/bin/bash

BACKUP="/root/backup"

mkdir -p "$BACKUP"

# Backup Docker Compose project directories
find / -type f \( -name "docker-compose.yml" -o -name "compose.yaml" -o -name "compose.yml" \) \
    -not -path "/proc/*" \
    -not -path "/sys/*" \
    -not -path "/root/backup/*" \
    2>/dev/null |
while read -r file; do

    dir=$(dirname "$file")
    name=$(echo "$dir" | tr '/' '_')

    echo "Backing up $dir"

    tar -czf "$BACKUP/$name.tar.gz" -C "$dir" .

done

# Backup Docker volume information
docker volume ls > "$BACKUP/volumes.txt"

# Backup running containers
docker ps -a > "$BACKUP/containers.txt"

echo "Docker backup complete: $BACKUP"
