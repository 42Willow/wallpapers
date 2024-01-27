# This is a merge of https://github.com/DragonDev07/Wallpapers/blob/main/markdown.py and https://github.com/42Willow/dotfiles/blob/45ef591a5cb06454f04b82e17be613e186533edf/hypr/wallpapers/populate.py
# These are based off https://github.com/flick0/kabegami/blob/master/populate.py

import os

# Begin README.md
pre = f"""
<!-- HEADERS -->
<p align="center">
  <img width="25%" src="https://github.com/42Willow/dotfiles/blob/main/assets/42willow.gif?raw=true" />
</p>
<p align="center">
  <b> ~ Willow's wallpaper dump ~ </b>
</p>

All wallpapers here are suitable for a 4K monitor :)

Inspired by [flick0](https://github.com/flick0/kabegami)

-----------------
"""

# End README.md
post = """
-----------------

## Sources

- [Flick0](https://github.com/flick0/kabegami)
- [DragonDev07 (for more script features)](https://github.com/DragonDev07/Wallpapers/blob/main/markdown.py)
- [Biohazardia](https://www.deviantart.com/biohazardia/gallery)
- [Imgur Pixel Art Dump](https://imgur.com/gallery/SELjK)
"""

def image_embed(title,folder,img):
    return f"""<img src="./{folder}/{img}" title="{title}"><br>\n"""

def has_image_files(directory):
    for _, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.webp', '.webm')):
                return True
    return False

def create_readme(directory):
    readme_content = pre

    # Get top-level directories
    top_level_dirs = [d for d in os.listdir(directory) if os.path.isdir(os.path.join(directory, d))]

    for top_level_dir in top_level_dirs:
        top_level_path = os.path.join(directory, top_level_dir)
        print(f"======{top_level_path}======")

        # Ignore hidden directories and directories without image files
        if top_level_dir.startswith('.') or not has_image_files(top_level_path):
            continue
        
        # Add heading for top-level directories
        readme_content += f"## {top_level_dir}\n\n"

        # Check if top-level directory has subdirectories
        has_subdirectories = any(os.path.isdir(os.path.join(top_level_path, d)) for d in os.listdir(top_level_path))

        # If top-level directory doesn't have subdirectories, add dropdown
        if not has_subdirectories:
            readme_content += f"<details><summary>{top_level_dir}</summary>\n\n"

        # Walk through the directory structure
        for root, dirs, files in os.walk(top_level_path):
            relative_path = os.path.relpath(root, directory)
            print(f"+++ {relative_path} +++")

            # Ignore hidden directories
            dirs[:] = [d for d in dirs if not d.startswith('.')]

            # If we are in a subdirectory, add it as a dropdown
            if relative_path != top_level_dir:
                readme_content += f"<details><summary>{os.path.basename(relative_path)}</summary>\n\n"

            for file in files:
                file_path = os.path.relpath(os.path.join(root, file))
                file_name, _ = os.path.splitext(file)
                print(file_name)

                # Extract tags from filename and enclose them in inline code blocks
                tags = [f"`{tag.strip('`')}`" for tag in file_name.split("-")] if "-" in file_name else [f"`{file_name.strip('`')}`"]

                # Add tags above image
                readme_content += f"**Tags:** {' '.join(tags)}\n\n"
                readme_content += f"<img src='{file_path}' title='{file_name}'>\n\n"
                

            # Close the details tag if we are in a subdirectory
            if relative_path != top_level_dir:
                readme_content += "</details>\n\n"

        # Close the top-level directory dropdown
        readme_content += f"</details>\n\n"

    with open("README.md", "w") as readme_file:
        readme_file.write(readme_content + post)

if __name__ == "__main__":
    directory_path = input("Enter the directory path: ")
    create_readme(directory_path)
    print("README.md created successfully.")
