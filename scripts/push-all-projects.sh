#!/bin/bash

# Push All Projects to GitHub
# Uses registry to push all tracked projects

set -e

PROJECTS_DIR="/Volumes/Ai/Projects"
MASTER_DIR="/Volumes/Ai/.Master"
REGISTRY_FILE="$MASTER_DIR/project-registry.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}   Push All Projects to GitHub${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check if registry exists
if [ ! -f "$REGISTRY_FILE" ]; then
    echo -e "${RED}✗ Registry not found!${NC}"
    echo -e "${YELLOW}Run sync-all-projects.sh first${NC}"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠ jq not installed, using basic parsing${NC}"
    USE_JQ=false
else
    USE_JQ=true
fi

# Push .Master first
echo -e "${BLUE}[0] Pushing .Master to GitHub...${NC}"
cd "$MASTER_DIR"

if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}  ⚠ Uncommitted changes in .Master${NC}"
    read -p "  Commit changes? (y/n): " commit_master
    if [ "$commit_master" = "y" ]; then
        git add .
        git commit -m "Update master system and project registry

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        echo -e "${GREEN}  ✓ Committed${NC}"
    fi
fi

git push origin main
echo -e "${GREEN}✓ .Master pushed${NC}"
echo ""

# Push all projects
count=0
for project_dir in "$PROJECTS_DIR"/*/ ; do
    [ -d "$project_dir" ] || continue

    project_name=$(basename "$project_dir")
    count=$((count + 1))

    echo -e "${BLUE}[$count] Pushing $project_name...${NC}"
    cd "$project_dir"

    # Check if git repo exists
    if [ ! -d ".git" ]; then
        echo -e "${RED}  ✗ Not a git repository, skipping${NC}"
        echo ""
        continue
    fi

    # Get current branch
    branch=$(git branch --show-current)

    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}  ⚠ Uncommitted changes detected${NC}"
        git status --short
        read -p "  Commit all changes? (y/n/skip): " commit_choice

        if [ "$commit_choice" = "y" ]; then
            git add .
            read -p "  Commit message (or press Enter for default): " commit_msg
            if [ -z "$commit_msg" ]; then
                commit_msg="Update project

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
            fi
            git commit -m "$commit_msg"
            echo -e "${GREEN}  ✓ Committed${NC}"
        elif [ "$commit_choice" = "skip" ]; then
            echo -e "${YELLOW}  ⊘ Skipped${NC}"
            echo ""
            continue
        fi
    fi

    # Push to remote
    if git push origin "$branch" 2>&1; then
        echo -e "${GREEN}  ✓ Pushed to GitHub${NC}"
    else
        echo -e "${RED}  ✗ Push failed (repo may not exist on GitHub)${NC}"
        echo -e "${YELLOW}  Create repo at: https://github.com/new${NC}"
    fi

    echo ""
done

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}All projects processed!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "Verify at: ${BLUE}https://github.com/thewahish?tab=repositories${NC}"
echo ""
