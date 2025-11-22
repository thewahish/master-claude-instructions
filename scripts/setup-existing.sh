#!/bin/bash

# ========================================
# Quick Setup for Existing Projects
# Adds Claude instructions to current folder
# ========================================

MASTER_DIR="/Volumes/Ai/.Master"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}Claude Code Quick Setup${NC}"
echo -e "${YELLOW}Adding Claude instructions to current project${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")

echo -e "${CYAN}Current directory: $CURRENT_DIR${NC}"
echo -e "${CYAN}Project name: $PROJECT_NAME${NC}"
echo ""

# Check if already set up
if [ -f "CLAUDE_INSTRUCTIONS.md" ]; then
    echo -e "${YELLOW}Warning: CLAUDE_INSTRUCTIONS.md already exists!${NC}"
    read -p "Overwrite? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo -e "${RED}Setup cancelled${NC}"
        exit 1
    fi
fi

# Get basic project info
read -p "Project type (e.g., Web App, API, Mobile App): " PROJECT_TYPE
read -p "Technology (e.g., React, Python, Node.js): " TECHNOLOGY
read -p "Brief description: " DESCRIPTION

# Create Claude directories
echo ""
echo -e "${YELLOW}Creating Claude structure...${NC}"
mkdir -p .claude/{logs,versions,backups,assets}
echo -e "${GREEN}✓ Claude directories created${NC}"

# Copy master instructions
if [ -f "$MASTER_DIR/CLAUDE_INSTRUCTIONS.md" ]; then
    cp "$MASTER_DIR/CLAUDE_INSTRUCTIONS.md" CLAUDE_INSTRUCTIONS.md

    # Append project-specific info
    cat >> CLAUDE_INSTRUCTIONS.md <<EOF

# ==========================================
# PROJECT-SPECIFIC CONFIGURATION
# ==========================================

## This Project Details
- **Name**: $PROJECT_NAME
- **Type**: $PROJECT_TYPE
- **Technology**: $TECHNOLOGY
- **Description**: $DESCRIPTION
- **Path**: $CURRENT_DIR
- **Setup Date**: $(date '+%Y-%m-%d %H:%M:%S')

## Quick Notes
- Agents adapted for $PROJECT_TYPE development
- Using $TECHNOLOGY stack
- All 12 agents ready and configured

---
**Ready for Claude Code!**
EOF

    echo -e "${GREEN}✓ CLAUDE_INSTRUCTIONS.md created${NC}"
else
    echo -e "${RED}Error: Master template not found${NC}"
    exit 1
fi

# Create initialization file
cat > .claude-project-init <<EOF
Project: $PROJECT_NAME
Initialized: $(date '+%Y-%m-%d %H:%M:%S')
Type: $PROJECT_TYPE
Technology: $TECHNOLOGY
Description: $DESCRIPTION
Setup: Quick (Existing Project)
EOF

echo -e "${GREEN}✓ Initialization file created${NC}"

# Create session file
echo "Session started: $(date '+%Y-%m-%d %H:%M:%S')" > .claude-last-session
echo "Quick setup completed for existing project" >> .claude-last-session

echo -e "${GREEN}✓ Session tracking initialized${NC}"

# Update .gitignore if exists
if [ -f .gitignore ]; then
    if ! grep -q ".claude/" .gitignore; then
        echo "" >> .gitignore
        echo "# Claude Code System Files" >> .gitignore
        echo ".claude/" >> .gitignore
        echo ".claude-project-init" >> .gitignore
        echo ".claude-last-session" >> .gitignore
        echo "*.claude-backup" >> .gitignore
        echo -e "${GREEN}✓ .gitignore updated${NC}"
    fi
elif [ -d .git ]; then
    cat > .gitignore <<EOF
# Claude Code System Files
.claude/
.claude-project-init
.claude-last-session
*.claude-backup
EOF
    echo -e "${GREEN}✓ .gitignore created${NC}"
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Project: $PROJECT_NAME${NC}"
echo -e "${YELLOW}Type: $PROJECT_TYPE${NC}"
echo -e "${YELLOW}Technology: $TECHNOLOGY${NC}"
echo ""
echo -e "${GREEN}You can now run: ${CYAN}claude${NC}"
echo ""
