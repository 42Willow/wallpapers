#!/bin/sh

# Usage: batch_unspace.sh <folder_path>

if [ -z "$1" ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

# Set the provided path as the folder path
folder_path="$1"

# Change to the specified folder
cd "$folder_path" || exit

# Loop through each file in the folder and rename it
for file in *; do
    # Check if the current file is not the script itself
    if [ -f "$file" ]; then
        echo "Processing file: $file"
        mv "$file" "$(echo "$file" | tr '[:blank:]' '_')"
    fi
done

echo "Batch unspace processing complete."