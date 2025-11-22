#!/bin/bash

# Script: organize-projects.sh
# Purpose: Safely move project folders to /Volumes/Ai/Projects/
# Author: Claude Code
# Date: 2025-01-20
# Usage: ./organize-projects.sh [--dry-run]

set -e
set -u
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
SOURCE_DIR="/Volumes/Ai"
DEST_DIR="/Volumes/Ai/Projects"
LOG_FILE="/Volumes/Ai/.Master/logs/organize-projects-$(date +%Y%m%d-%H%M%S).log"
DRY_RUN=false

# Check for dry-run flag
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Create log directory
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Print header
print_header() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${CYAN}  Project Folder Organization${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}🔍 DRY RUN MODE - No changes will be made${NC}"
        echo ""
    fi
}

# Project folders to move
declare -a PROJECTS=(
    "arabian-sweets-empire"
    "Entertainment-Hub"
    "Karazah"
    "p-o-h"
    "syrian-memory-game"
    "Tarboush"
    "website"
    "website2.0"
)

# Optional folders (ask user)
declare -a OPTIONAL_FOLDERS=(
    "Events"
    "job-applications"
    "resumes"
)

# Folders to NEVER move
declare -a PROTECTED=(
    ".Master"
    ".claude"
    ".DocumentRevisions-V100"
    ".fseventsd"
    ".Spotlight-V100"
    ".TemporaryItems"
    ".Trashes"
    "Desktop"
    "Projects"
)

# Check if folder is protected
is_protected() {
    local folder="$1"
    for protected in "${PROTECTED[@]}"; do
        if [[ "$folder" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

# Display folders to be moved
show_plan() {
    echo -e "${BLUE}📋 Move Plan${NC}"
    echo ""
    echo -e "${GREEN}✓ Will move these project folders:${NC}"
    for project in "${PROJECTS[@]}"; do
        if [ -d "$SOURCE_DIR/$project" ]; then
            SIZE=$(du -sh "$SOURCE_DIR/$project" 2>/dev/null | cut -f1)
            echo -e "  → ${CYAN}$project${NC} ($SIZE)"
        else
            echo -e "  → ${YELLOW}$project${NC} (not found - will skip)"
        fi
    done

    echo ""
    echo -e "${MAGENTA}? Optional folders (will ask):${NC}"
    for folder in "${OPTIONAL_FOLDERS[@]}"; do
        if [ -d "$SOURCE_DIR/$folder" ]; then
            SIZE=$(du -sh "$SOURCE_DIR/$folder" 2>/dev/null | cut -f1)
            echo -e "  → ${CYAN}$folder${NC} ($SIZE)"
        fi
    done

    echo ""
    echo -e "${RED}🔒 Protected (will NOT move):${NC}"
    for protected in "${PROTECTED[@]}"; do
        if [ -d "$SOURCE_DIR/$protected" ] || [ "$protected" == "Desktop" ]; then
            echo -e "  → ${YELLOW}$protected${NC}"
        fi
    done

    echo ""
}

# Ask about optional folders
ask_optional() {
    echo -e "${BLUE}📦 Optional Folders${NC}"
    echo ""

    for folder in "${OPTIONAL_FOLDERS[@]}"; do
        if [ -d "$SOURCE_DIR/$folder" ]; then
            echo -e "Found: ${CYAN}$folder${NC}"
            echo "  This could be:"
            case $folder in
                "Events")
                    echo "  - A project (move to Projects/)"
                    echo "  - Event files (keep at root)"
                    ;;
                "job-applications"|"resumes")
                    echo "  - Personal documents (move to Documents/)"
                    echo "  - Keep at root"
                    ;;
            esac
            echo ""
            read -p "  Move $folder to Projects/? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                PROJECTS+=("$folder")
                log "INFO: User chose to move $folder"
            else
                log "INFO: User chose to keep $folder at root"
            fi
            echo ""
        fi
    done
}

# Safety checks
safety_checks() {
    echo -e "${BLUE}🔍 Safety Checks${NC}"
    echo ""

    # Check destination exists
    echo -n "Checking destination folder exists... "
    if [ -d "$DEST_DIR" ]; then
        echo -e "${GREEN}✓${NC}"
        log "INFO: Destination folder exists: $DEST_DIR"
    else
        echo -e "${YELLOW}Creating${NC}"
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$DEST_DIR"
        fi
        log "INFO: Created destination folder: $DEST_DIR"
    fi

    # Check disk space
    echo -n "Checking disk space... "
    AVAILABLE=$(df -h /Volumes/Ai | tail -1 | awk '{print $4}')
    echo -e "${GREEN}$AVAILABLE available${NC}"
    log "INFO: Available disk space: $AVAILABLE"

    # Check write permissions
    echo -n "Checking write permissions... "
    if [ -w "$SOURCE_DIR" ] && [ -w "$DEST_DIR" ]; then
        echo -e "${GREEN}✓${NC}"
        log "INFO: Write permissions verified"
    else
        echo -e "${RED}✗${NC}"
        log "ERROR: No write permissions"
        echo ""
        echo -e "${RED}Error: No write permissions!${NC}"
        exit 1
    fi

    # Check for open files (skip in dry-run for speed)
    if [ "$DRY_RUN" = true ]; then
        echo -n "Checking for open files in project folders... "
        echo -e "${YELLOW}[SKIPPED - DRY RUN]${NC}"
        log "INFO: Open files check skipped in dry-run mode"
    else
        echo -n "Checking for open files in project folders... "
        OPEN_FILES=0
        for project in "${PROJECTS[@]}"; do
            if [ -d "$SOURCE_DIR/$project" ]; then
                OPEN=$(lsof +D "$SOURCE_DIR/$project" 2>/dev/null | wc -l)
                OPEN_FILES=$((OPEN_FILES + OPEN))
            fi
        done

        if [ $OPEN_FILES -gt 0 ]; then
            echo -e "${YELLOW}$OPEN_FILES files open${NC}"
            echo ""
            echo -e "${YELLOW}⚠️  Warning: Some files are currently open!${NC}"
            echo "   It's recommended to close all apps before continuing."
            echo ""
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log "INFO: User aborted due to open files"
                exit 0
            fi
            log "WARNING: Proceeding with $OPEN_FILES files open"
        else
            echo -e "${GREEN}✓${NC}"
            log "INFO: No open files detected"
        fi
    fi

    echo ""
}

# Move a single folder
move_folder() {
    local folder_name="$1"
    local source_path="$SOURCE_DIR/$folder_name"
    local dest_path="$DEST_DIR/$folder_name"

    # Check if source exists
    if [ ! -d "$source_path" ]; then
        echo -e "  ${YELLOW}↷ $folder_name${NC} - not found, skipping"
        log "WARNING: Folder not found: $source_path"
        return
    fi

    # Check if destination already exists
    if [ -d "$dest_path" ]; then
        echo -e "  ${YELLOW}↷ $folder_name${NC} - already exists at destination"
        log "WARNING: Folder already exists: $dest_path"
        return
    fi

    # Get folder size
    SIZE=$(du -sh "$source_path" 2>/dev/null | cut -f1)

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${CYAN}→ $folder_name${NC} ($SIZE) [DRY RUN]"
        log "DRY RUN: Would move $source_path → $dest_path"
    else
        echo -ne "  ${CYAN}→ $folder_name${NC} ($SIZE) ... "

        # Move the folder
        if mv "$source_path" "$dest_path" 2>/dev/null; then
            # Create symlink for backwards compatibility
            ln -s "$dest_path" "$source_path" 2>/dev/null || true

            echo -e "${GREEN}✓${NC}"
            log "SUCCESS: Moved $source_path → $dest_path (symlink created)"
        else
            echo -e "${RED}✗${NC}"
            log "ERROR: Failed to move $source_path"
        fi
    fi
}

# Move all folders
move_folders() {
    echo -e "${BLUE}📦 Moving Folders${NC}"
    echo ""

    local count=0
    local total=${#PROJECTS[@]}

    for project in "${PROJECTS[@]}"; do
        count=$((count + 1))
        echo -e "${MAGENTA}[$count/$total]${NC}"
        move_folder "$project"
    done

    echo ""
}

# Verify git repositories still work
verify_git_repos() {
    echo -e "${BLUE}🔍 Verifying Git Repositories${NC}"
    echo ""

    for project in "${PROJECTS[@]}"; do
        local repo_path="$DEST_DIR/$project"

        if [ -d "$repo_path/.git" ]; then
            echo -ne "  Checking ${CYAN}$project${NC}... "

            if [ "$DRY_RUN" = true ]; then
                echo -e "${YELLOW}[SKIP - DRY RUN]${NC}"
            else
                cd "$repo_path"
                if git status >/dev/null 2>&1; then
                    echo -e "${GREEN}✓${NC}"
                    log "INFO: Git repo OK: $project"
                else
                    echo -e "${YELLOW}! (not critical)${NC}"
                    log "WARNING: Git repo may have issues: $project"
                fi
                cd - >/dev/null
            fi
        fi
    done

    echo ""
}

# Create additional folders (Documents, Media)
create_additional_folders() {
    echo -e "${BLUE}📁 Additional Organization${NC}"
    echo ""

    read -p "Create /Volumes/Ai/Documents/ for personal files? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p /Volumes/Ai/Documents
            echo -e "  ${GREEN}✓${NC} Created Documents/"
            log "INFO: Created /Volumes/Ai/Documents/"
        else
            echo -e "  ${CYAN}→${NC} Would create Documents/ [DRY RUN]"
        fi
    fi

    echo ""
    read -p "Create /Volumes/Ai/Media/ for video/audio files? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p /Volumes/Ai/Media
            echo -e "  ${GREEN}✓${NC} Created Media/"
            log "INFO: Created /Volumes/Ai/Media/"

            # Ask about moving the .mov file
            if [ -f "$SOURCE_DIR/من جيل .mov" ]; then
                echo ""
                read -p "Move 'من جيل .mov' (1GB) to Media/? (Y/n): " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                    mv "$SOURCE_DIR/من جيل .mov" /Volumes/Ai/Media/
                    ln -s "/Volumes/Ai/Media/من جيل .mov" "$SOURCE_DIR/من جيل .mov"
                    echo -e "  ${GREEN}✓${NC} Moved video file to Media/"
                    log "INFO: Moved video file to Media/"
                fi
            fi
        else
            echo -e "  ${CYAN}→${NC} Would create Media/ [DRY RUN]"
        fi
    fi

    echo ""
}

# Print summary
print_summary() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${CYAN}  Summary${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}This was a DRY RUN - no changes were made${NC}"
        echo ""
        echo "To actually move folders, run:"
        echo -e "  ${GREEN}./organize-projects.sh${NC}"
    else
        echo -e "${GREEN}✓ Folder organization complete!${NC}"
        echo ""
        echo "What happened:"
        echo "  • Project folders moved to /Volumes/Ai/Projects/"
        echo "  • Symlinks created at old locations (backwards compatibility)"
        echo "  • Git repositories verified"
        echo "  • All operations logged"
        echo ""
        echo "New structure:"
        echo "  /Volumes/Ai/"
        echo "  ├── .Master/          (stayed - critical)"
        echo "  ├── Projects/         (all projects here)"
        echo "  ├── Desktop/          (stayed - workspace)"
        echo "  └── [system folders]  (stayed)"
        echo ""
        echo "Next steps:"
        echo "  1. Verify projects open correctly"
        echo "  2. If all good, remove symlinks:"
        echo "     find /Volumes/Ai -maxdepth 1 -type l -delete"
        echo "  3. Clean up .DS_Store files:"
        echo "     find /Volumes/Ai -name '.DS_Store' -delete"
    fi

    echo ""
    echo "Log file: $LOG_FILE"
    echo ""
}

# Main execution
main() {
    print_header
    log "INFO: Script started (dry-run: $DRY_RUN)"

    show_plan

    if [ "$DRY_RUN" = false ]; then
        echo ""
        read -p "Proceed with moving folders? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "INFO: User cancelled"
            echo "Cancelled."
            exit 0
        fi
        echo ""

        ask_optional
    fi

    safety_checks
    move_folders

    if [ "$DRY_RUN" = false ]; then
        verify_git_repos
        create_additional_folders
    fi

    print_summary

    log "INFO: Script completed successfully"
}

# Run main function
main
