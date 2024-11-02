import os
flavors = ["latte", "frappe", "macchiato", "mocha"]

def lutgen(directory):
    for category in os.listdir(directory):
        category_path = os.path.join(directory, category)
        for item in os.listdir(category_path):
            item_path = os.path.join(category_path, item)
            if os.path.isdir(item_path):
                print("++++++++++++="+item)
                for image in os.listdir(item_path):
                    print("++++++++++-----"+image)
                    for flavor in flavors:
                        output_path = os.path.join("dist", flavor, os.path.basename(directory), category, item, image)
                        os.system(f"lutgen apply -p catppuccin-{flavor} {item_path}/{image} -o {output_path}")


if __name__ == "__main__":
    directory_path = input("Enter the directory path (parent of wallpapers/): ")
    if not os.path.exists(os.path.join(directory_path, "wallpapers", "images")):
        print("Invalid directory path")
        exit(1)
    # Remove dist/ directory
    print("Removing dist/ directory...")
    os.system(f"rm -r {os.path.join(directory_path, 'dist')}")
    # theme images/ with lutgen
    print("Applying LUTs to images...")
    lutgen(os.path.join(directory_path, "wallpapers", "images"))
    # theme vector/ with faerber
    # theme pixel/ with pixeldetector and then faerber