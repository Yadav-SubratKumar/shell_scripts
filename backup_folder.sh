#!/bin/bash

source=$1

# Check if the source directory exists
if [ ! -d "$source" ]; then
    echo "No such directory: $source"
    exit 1
fi

# Create the backup directory if it doesn't exist
if [ ! -d "backup" ]; then
    mkdir "backup"
fi

# Create the archive name with the current day
day=$(date "+%Y-%m-%d")
archive="backup/backup-${day}"

# Create the backup directory if it doesn't exist
if [ ! -d "$archive" ]; then
    mkdir "$archive"
fi

# Create the backup archive
for i in $(find "$source" -maxdepth 1 -type f ); do
    gzip -k "$i" || { echo "Failed to gzip $i"; exit 1; }
    mv "$i.gz" "$archive" || { echo "Failed to move $i.gz to $archive"; exit 1; }
done

# If we reach this point, the backup was successful
echo "Backup Finished: $archive"

# Function to clean up old backup folders, keeping only the latest 3
cleanup_backups() {
    # Check if backup directory is not empty
    if [ "$(ls -A backup)" ]; then
        # Keep only the latest 3 backup folders
        backups_to_keep=$(ls -d -1 backup/* | sort -r | head -n 3)

        # Remove all other backup folders
        for dir in $(ls -d backup/*); do
            if ! echo "$backups_to_keep" | grep -q "$dir"; then
                rm -rf "$dir"
            fi
        done
    else
        echo "Backup directory is empty. Nothing to clean up."
    fi
}

# Call the cleanup function
cleanup_backups
