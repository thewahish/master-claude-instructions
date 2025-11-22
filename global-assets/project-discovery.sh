#!/bin/bash

# Project Discovery Helper
# Source this file in any project to discover and call other projects
# Usage: source /Volumes/Ai/.Master/global-assets/project-discovery.sh

MASTER_DIR="/Volumes/Ai/.Master"
PROJECTS_DIR="/Volumes/Ai/Projects"
REGISTRY_FILE="$MASTER_DIR/project-registry.json"

# Function to get project path by name
get_project_path() {
    local project_name="$1"
    if [ -d "$PROJECTS_DIR/$project_name" ]; then
        echo "$PROJECTS_DIR/$project_name"
        return 0
    else
        echo ""
        return 1
    fi
}

# Function to list all projects
list_all_projects() {
    if [ -f "$REGISTRY_FILE" ]; then
        if command -v jq &> /dev/null; then
            jq -r '.projects | keys[]' "$REGISTRY_FILE"
        else
            # Fallback: list directories
            ls -1 "$PROJECTS_DIR"
        fi
    else
        ls -1 "$PROJECTS_DIR"
    fi
}

# Function to get project info
get_project_info() {
    local project_name="$1"
    if [ -f "$REGISTRY_FILE" ] && command -v jq &> /dev/null; then
        jq ".projects[\"$project_name\"]" "$REGISTRY_FILE"
    else
        echo "Registry not available or jq not installed"
        return 1
    fi
}

# Function to execute command in another project
exec_in_project() {
    local project_name="$1"
    shift  # Remove first argument, rest are the command
    local project_path=$(get_project_path "$project_name")

    if [ -n "$project_path" ]; then
        (cd "$project_path" && "$@")
    else
        echo "Error: Project '$project_name' not found"
        return 1
    fi
}

# Function to call npm script in another project
npm_in_project() {
    local project_name="$1"
    local npm_script="$2"
    exec_in_project "$project_name" npm run "$npm_script"
}

# Export functions
export -f get_project_path
export -f list_all_projects
export -f get_project_info
export -f exec_in_project
export -f npm_in_project

# Export variables
export MASTER_DIR
export PROJECTS_DIR
export REGISTRY_FILE

# Print helper on source
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    echo "✓ Project Discovery Helper loaded"
    echo "Available functions:"
    echo "  - get_project_path <name>         # Get path to project"
    echo "  - list_all_projects               # List all projects"
    echo "  - get_project_info <name>         # Get project metadata"
    echo "  - exec_in_project <name> <cmd>    # Execute command in project"
    echo "  - npm_in_project <name> <script>  # Run npm script in project"
    echo ""
    echo "Example: exec_in_project p-o-h npm run dev"
fi
