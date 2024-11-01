#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

# Set the provided path as the folder path
folder_path="$1"

# Set the path for the new folder
new_folders=("Latte" "Frappe" "Macchiato" "Mocha" "OLED")

# Prompt for the hald value
read -p "Enter the hald value (between 2 and 16): " hald_value
if [[ ! "$hald_value" =~ ^[2-9]$|^1[0-6]$ ]]; then
    echo "Error: Invalid hald value. Please enter a value between 2 and 16."
    exit 1
fi

# Change to the specified folder
cd "$folder_path" || exit

# Create the new folders with the name of the folder we're converting
for new_folder in "${new_folders[@]}"; do
    mkdir "$new_folder"
done

# Get the script filename
script_file="$(basename "$0")"

# Loop through each file in the folder and run catppuccinifier
for file in *; do
    # Check if the current file is not the script itself
    if [ "$file" != "$script_file" ] && [ -f "$file" ]; then
        echo "Processing file: $file"
        catppuccinifier --image "$file" --hald "$hald_value"
    fi
done

echo "Batch catppuccinifier processing complete."

# read -r -p "Would you like to sort the files into the new folders? [y/N] " response
# if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
#     echo "Sorting files into new folders..."
# else
#     echo "Files not sorted into new folders."
#     exit 1
# fi

for file in *; do
    # if file is directory, skip
    if [ -d "$file" ]; then
        continue
    fi
    
    echo "Processing file: $file"

    base_filename=$(echo "$file" | sed -E 's/^(latte|frappe|macchiato|mocha|oled)-hald[0-9]+-//; s/\.png$//')

    if [[ "$file" == *"latte"* ]]; then
        new_folder="Latte"
    elif [[ "$file" == *"frappe"* ]]; then
        new_folder="Frappe"
    elif [[ "$file" == *"macchiato"* ]]; then
        new_folder="Macchiato"
    elif [[ "$file" == *"mocha"* ]]; then
        new_folder="Mocha"
    elif [[ "$file" == *"oled"* ]]; then
        new_folder="OLED"
    else
        echo "File not moved: $file"
        continue
    fi

    if [ ! -d "$new_folder" ]; then
        echo "Folder does not exist: $new_folder"
        continue
    else
        mv "$file" "$new_folder/$base_filename"
        echo "File moved to: $new_folder/$base_filename"
    fi
done


# move the new folders to the parent directory
current_dir="$(basename "$PWD")"
for new_folder in "${new_folders[@]}"; do
    mv "$new_folder" "../$current_dir-$new_folder"
done