#!/bin/bash

# Auto-Detect and Sync All Projects Script
# Scans Projects/ folder, ensures git setup, maintains master registry

set -e  # Exit on error

PROJECTS_DIR="/Volumes/Ai/Projects"
MASTER_DIR="/Volumes/Ai/.Master"
REGISTRY_FILE="$MASTER_DIR/project-registry.json"
GITHUB_USER="thewahish"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}   Auto-Detect & Sync Projects${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Create registry file if it doesn't exist
if [ ! -f "$REGISTRY_FILE" ]; then
    echo '{
  "projects": {},
  "lastUpdated": "",
  "totalProjects": 0
}' > "$REGISTRY_FILE"
    echo -e "${GREEN}✓ Created project registry${NC}"
fi

# Function to get project metadata
get_project_type() {
    local project_path="$1"

    if [ -f "$project_path/package.json" ]; then
        echo "node"
    elif [ -f "$project_path/requirements.txt" ]; then
        echo "python"
    elif [ -f "$project_path/Gemfile" ]; then
        echo "ruby"
    elif [ -f "$project_path/pom.xml" ]; then
        echo "java"
    elif [ -f "$project_path/go.mod" ]; then
        echo "go"
    elif [ -f "$project_path/Cargo.toml" ]; then
        echo "rust"
    elif [ -f "$project_path/index.html" ]; then
        echo "html"
    else
        echo "other"
    fi
}

# Initialize registry array
declare -A projects_registry

# Scan Projects directory
echo -e "${YELLOW}Scanning $PROJECTS_DIR...${NC}"
echo ""

project_count=0

for project_dir in "$PROJECTS_DIR"/*/ ; do
    # Skip if not a directory
    [ -d "$project_dir" ] || continue

    project_name=$(basename "$project_dir")
    project_count=$((project_count + 1))

    echo -e "${BLUE}[$project_count] $project_name${NC}"

    cd "$project_dir"

    # Check if git is initialized
    if [ ! -d ".git" ]; then
        echo -e "${RED}  ✗ No git repository found${NC}"
        echo -e "${YELLOW}  ? Initialize git for $project_name?${NC}"
        read -p "    GitHub repo name (or 'skip'): " repo_name

        if [ "$repo_name" != "skip" ] && [ -n "$repo_name" ]; then
            git init
            git remote add origin "https://github.com/$GITHUB_USER/$repo_name.git"
            echo -e "${GREEN}  ✓ Git initialized with remote${NC}"
        else
            echo -e "${YELLOW}  ⊘ Skipped${NC}"
            continue
        fi
    else
        echo -e "${GREEN}  ✓ Git repository exists${NC}"
    fi

    # Get remote URL
    remote_url=$(git remote get-url origin 2>/dev/null || echo "none")

    if [ "$remote_url" = "none" ]; then
        echo -e "${YELLOW}  ? No remote configured${NC}"
        read -p "    GitHub repo name: " repo_name
        if [ -n "$repo_name" ]; then
            git remote add origin "https://github.com/$GITHUB_USER/$repo_name.git"
            remote_url="https://github.com/$GITHUB_USER/$repo_name.git"
            echo -e "${GREEN}  ✓ Remote added${NC}"
        fi
    else
        echo -e "${GREEN}  ✓ Remote: $remote_url${NC}"
    fi

    # Get project type
    project_type=$(get_project_type "$project_dir")
    echo -e "  📦 Type: $project_type"

    # Get git branch
    branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo -e "  🌿 Branch: $branch"

    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}  ⚠ Uncommitted changes detected${NC}"
        uncommitted="true"
    else
        echo -e "${GREEN}  ✓ Working tree clean${NC}"
        uncommitted="false"
    fi

    # Store in registry
    projects_registry["$project_name"]="$remote_url|$project_type|$branch|$uncommitted"

    echo ""
done

# Update registry JSON file
echo -e "${BLUE}Updating project registry...${NC}"

# Build JSON
json_projects="{"
first=true

for project in "${!projects_registry[@]}"; do
    IFS='|' read -r remote type branch uncommitted <<< "${projects_registry[$project]}"

    if [ "$first" = true ]; then
        first=false
    else
        json_projects+=","
    fi

    json_projects+="
    \"$project\": {
      \"path\": \"/Volumes/Ai/Projects/$project\",
      \"remote\": \"$remote\",
      \"type\": \"$type\",
      \"branch\": \"$branch\",
      \"hasUncommittedChanges\": $uncommitted
    }"
done

json_projects+="
  }"

# Create complete JSON
cat > "$REGISTRY_FILE" << EOF
{
  "projects": $json_projects,
  "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "totalProjects": $project_count,
  "projectsPath": "/Volumes/Ai/Projects",
  "masterPath": "/Volumes/Ai/.Master"
}
EOF

echo -e "${GREEN}✓ Registry updated: $REGISTRY_FILE${NC}"
echo ""

# Summary
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Summary:${NC}"
echo -e "${BLUE}================================${NC}"
echo -e "Total projects detected: ${GREEN}$project_count${NC}"
echo -e "Registry file: ${GREEN}$REGISTRY_FILE${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review registry: cat $REGISTRY_FILE | jq"
echo "2. Commit any changes to projects"
echo "3. Push all to GitHub: $MASTER_DIR/scripts/push-all-projects.sh"
echo ""
