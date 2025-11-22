#!/bin/bash

# ========================================
# Install Claude Master System Aliases
# Adds convenient shortcuts to your shell
# ========================================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}Claude Master System - Alias Installer${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Detect shell
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
    SHELL_NAME="Zsh"
elif [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    else
        SHELL_RC="$HOME/.bashrc"
    fi
    SHELL_NAME="Bash"
else
    echo -e "${RED}Could not detect shell. Please add aliases manually.${NC}"
    exit 1
fi

echo -e "${CYAN}Detected shell: ${YELLOW}$SHELL_NAME${NC}"
echo -e "${CYAN}Config file: ${YELLOW}$SHELL_RC${NC}"
echo ""

# Check if aliases already exist
if grep -q "# Claude Master System" "$SHELL_RC" 2>/dev/null; then
    echo -e "${YELLOW}Aliases already installed!${NC}"
    echo ""
    read -p "Reinstall/Update? (y/n): " reinstall
    if [ "$reinstall" != "y" ]; then
        echo -e "${GREEN}No changes made.${NC}"
        exit 0
    fi

    # Remove old aliases
    echo -e "${YELLOW}Removing old aliases...${NC}"
    sed -i.bak '/# Claude Master System/,/# End Claude aliases/d' "$SHELL_RC"
fi

# Add aliases
echo -e "${GREEN}Adding aliases to $SHELL_RC...${NC}"

cat >> "$SHELL_RC" <<'EOF'

# Claude Master System
# Convenient shortcuts for Claude multi-agent development system
alias init-project='/Volumes/Ai/.Master/scripts/init-project.sh'
alias setup-claude='/Volumes/Ai/.Master/scripts/setup-existing.sh'
alias claude-master='cd /Volumes/Ai/.Master && claude'
alias projects='cd /Volumes/Ai/Projects'

# Project navigation helpers
alias list-projects='ls -la /Volumes/Ai/Projects'
alias claude-logs='cat .claude/logs/current.log'
alias claude-session='cat .claude-last-session'

# End Claude aliases
EOF

echo -e "${GREEN}✓ Aliases added successfully!${NC}"
echo ""

# Ask to reload
echo -e "${YELLOW}Aliases added. You need to reload your shell.${NC}"
echo ""
echo "Option 1: Run this command now:"
echo -e "  ${CYAN}source $SHELL_RC${NC}"
echo ""
echo "Option 2: Close and reopen your terminal"
echo ""

read -p "Reload shell config now? (y/n): " reload_now

if [ "$reload_now" = "y" ]; then
    # Source the file
    source "$SHELL_RC"
    echo ""
    echo -e "${GREEN}✓ Shell reloaded!${NC}"
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Available commands:${NC}"
echo ""
echo -e "  ${CYAN}init-project${NC}       - Create a new project"
echo -e "  ${CYAN}setup-claude${NC}       - Add Claude to existing project"
echo -e "  ${CYAN}claude-master${NC}      - Go to master directory"
echo -e "  ${CYAN}projects${NC}           - Go to projects directory"
echo -e "  ${CYAN}list-projects${NC}      - List all projects"
echo -e "  ${CYAN}claude-logs${NC}        - View current session logs"
echo -e "  ${CYAN}claude-session${NC}     - View last session info"
echo ""
echo -e "${GREEN}Try it now: ${CYAN}init-project${NC}"
echo ""
