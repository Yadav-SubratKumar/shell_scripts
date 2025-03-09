#!/bin/bash

# Use dyanmic paths
backup=$1
dest=$2
# Check if directories exist, create if not
if [ ! -d "$backup" ]; then
    mkdir -p "$backup"
    echo "Created source directory: $backup"
fi

if [ ! -d "$dest" ]; then
    mkdir -p "$dest"
    echo "Created destination directory: $dest"
fi

# Get the current day of the week
day=$(date +%A)

# Use the third argument as the backup name
if [ -z "$3" ]; then
    echo "Please provide a backup name."
    exit 1
fi

backupname=$3

# Create the archive name with the current day
archive="${backupname}-${day}.tgz"

# Create the backup archive
tar czf "$dest/$archive" -C "$backup" .

# Check if the tar command was successful
if [ $? -eq 0 ]; then
    echo "Backup Finished: $dest/$archive"
else
    echo "Backup failed!"
    exit 1
fi
