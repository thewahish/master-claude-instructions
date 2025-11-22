#!/bin/bash

# Auto-Detect New Folders in /Volumes/Ai
# Automatically detects and categorizes new folders added to the Ai directory
# Run this as part of your master sync routine

set -e

AI_DIR="/Volumes/Ai"
PROJECTS_DIR="/Volumes/Ai/Projects"
MASTER_DIR="/Volumes/Ai/.Master"
REGISTRY_FILE="$MASTER_DIR/project-registry.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}   Auto-Detect New Folders${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Known folders to skip
SKIP_FOLDERS=(
    ".Master"
    "Projects"
    "Resources"
    "Documents"
    "Desktop"
    ".Trash"
    ".DS_Store"
)

# Check if folder should be skipped
should_skip() {
    local folder="$1"
    for skip in "${SKIP_FOLDERS[@]}"; do
        if [ "$folder" = "$skip" ]; then
            return 0
        fi
    done
    return 1
}

# Detect if folder is an Anthropic reference repository
is_anthropic_reference() {
    local folder_name="$1"
    local folder_path="$2"

    # Check for common Anthropic indicators
    if [[ "$folder_name" == *"claude"* ]] || [[ "$folder_name" == *"anthropic"* ]]; then
        # Check for LICENSE file
        if [ -f "$folder_path/LICENSE" ]; then
            if grep -qi "anthropic" "$folder_path/LICENSE" 2>/dev/null; then
                return 0
            fi
        fi

        # Check for README mentioning Anthropic
        if [ -f "$folder_path/README.md" ]; then
            if grep -qi "anthropic\|claude" "$folder_path/README.md" 2>/dev/null; then
                return 0
            fi
        fi
    fi

    return 1
}

# Get category for folder
categorize_folder() {
    local folder_name="$1"
    local folder_path="$2"

    if is_anthropic_reference "$folder_name" "$folder_path"; then
        echo "reference"
    else
        echo "user"
    fi
}

# Scan for new folders in /Volumes/Ai
new_folders_found=0

echo -e "${YELLOW}Scanning $AI_DIR for new folders...${NC}"
echo ""

for item in "$AI_DIR"/*; do
    # Skip if not a directory
    [ -d "$item" ] || continue

    folder_name=$(basename "$item")

    # Skip known folders
    if should_skip "$folder_name"; then
        continue
    fi

    # Check if already in Projects or Resources
    if [ -d "$PROJECTS_DIR/$folder_name" ] || [ -d "/Volumes/Ai/Resources/$folder_name" ]; then
        continue
    fi

    # Found a new folder!
    new_folders_found=$((new_folders_found + 1))

    echo -e "${CYAN}Found new folder: $folder_name${NC}"

    # Categorize
    category=$(categorize_folder "$folder_name" "$item")

    echo -e "  Location: $item"
    echo -e "  Category: ${YELLOW}$category${NC}"

    # Ask what to do
    echo ""
    echo -e "${YELLOW}What should I do with this folder?${NC}"
    echo "  1) Move to Projects/ (recommended)"
    echo "  2) Skip (leave where it is)"
    echo "  3) Delete"

    read -p "Choose (1/2/3): " choice

    case $choice in
        1)
            echo -e "${GREEN}Moving to Projects/${NC}"
            mv "$item" "$PROJECTS_DIR/"

            # Initialize git if not already a repo
            if [ ! -d "$PROJECTS_DIR/$folder_name/.git" ]; then
                echo -e "${YELLOW}Initialize git repository?${NC}"
                read -p "Enter GitHub URL (or press Enter to skip): " github_url

                if [ -n "$github_url" ]; then
                    cd "$PROJECTS_DIR/$folder_name"
                    git init
                    git remote add origin "$github_url"
                    git add .
                    git commit -m "Initial commit of $folder_name"
                    echo -e "${GREEN}✓ Git initialized${NC}"
                fi
            fi

            echo -e "${GREEN}✓ Moved to Projects/${NC}"
            ;;
        2)
            echo -e "${YELLOW}⊘ Skipped${NC}"
            ;;
        3)
            echo -e "${RED}Deleting ${folder_name}...${NC}"
            rm -rf "$item"
            echo -e "${RED}✓ Deleted${NC}"
            ;;
        *)
            echo -e "${YELLOW}Invalid choice, skipping${NC}"
            ;;
    esac

    echo ""
done

if [ $new_folders_found -eq 0 ]; then
    echo -e "${GREEN}No new folders found${NC}"
else
    echo -e "${GREEN}Processed $new_folders_found new folder(s)${NC}"
    echo ""
    echo -e "${YELLOW}Don't forget to update the registry:${NC}"
    echo -e "$MASTER_DIR/scripts/sync-all-projects.sh"
fi

echo ""
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Auto-Detection Complete${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
