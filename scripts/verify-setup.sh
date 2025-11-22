#!/bin/bash

# ========================================
# Verify Claude Master System Setup
# Checks that everything is configured correctly
# ========================================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

PASS="${GREEN}✓${NC}"
FAIL="${RED}✗${NC}"
WARN="${YELLOW}⚠${NC}"

echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}Claude Master System - Verification${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Track results
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNED=0

# Function to check and report
check() {
    local description="$1"
    local command="$2"
    local required="$3"  # "required" or "optional"

    if eval "$command" >/dev/null 2>&1; then
        echo -e "$PASS $description"
        ((CHECKS_PASSED++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "$FAIL $description"
            ((CHECKS_FAILED++))
            return 1
        else
            echo -e "$WARN $description (optional)"
            ((CHECKS_WARNED++))
            return 2
        fi
    fi
}

# Master Directory Checks
echo -e "${CYAN}Master Directory:${NC}"
check "Master directory exists" "test -d /Volumes/Ai/.Master" "required"
check "Scripts directory exists" "test -d /Volumes/Ai/.Master/scripts" "required"
check "Global assets directory exists" "test -d /Volumes/Ai/.Master/global-assets" "optional"
check "Templates directory exists" "test -d /Volumes/Ai/.Master/templates" "optional"
echo ""

# Core Files
echo -e "${CYAN}Core Files:${NC}"
check "Master instructions template" "test -f /Volumes/Ai/.Master/CLAUDE_INSTRUCTIONS.md" "required"
check "README documentation" "test -f /Volumes/Ai/.Master/README.md" "required"
check "Quick start guide" "test -f /Volumes/Ai/.Master/QUICK_START.md" "required"
check "Master summary" "test -f /Volumes/Ai/.Master/MASTER_PROMPT_SUMMARY.md" "required"
echo ""

# Scripts
echo -e "${CYAN}Scripts:${NC}"
check "init-project.sh exists" "test -f /Volumes/Ai/.Master/scripts/init-project.sh" "required"
check "init-project.sh is executable" "test -x /Volumes/Ai/.Master/scripts/init-project.sh" "required"
check "setup-existing.sh exists" "test -f /Volumes/Ai/.Master/scripts/setup-existing.sh" "required"
check "setup-existing.sh is executable" "test -x /Volumes/Ai/.Master/scripts/setup-existing.sh" "required"
check "install-aliases.sh exists" "test -f /Volumes/Ai/.Master/scripts/install-aliases.sh" "optional"
check "install-aliases.sh is executable" "test -x /Volumes/Ai/.Master/scripts/install-aliases.sh" "optional"
echo ""

# Projects Directory
echo -e "${CYAN}Projects Directory:${NC}"
check "Projects directory exists" "test -d /Volumes/Ai/Projects" "optional"
if [ -d /Volumes/Ai/Projects ]; then
    PROJECT_COUNT=$(find /Volumes/Ai/Projects -maxdepth 1 -type d | wc -l | tr -d ' ')
    ((PROJECT_COUNT--))  # Subtract 1 for the Projects dir itself
    echo -e "  ${CYAN}→${NC} Found $PROJECT_COUNT project(s)"
fi
echo ""

# System Prerequisites
echo -e "${CYAN}System Prerequisites:${NC}"
check "Git installed" "command -v git" "optional"
check "Claude CLI available" "command -v claude" "optional"
echo ""

# Shell Configuration
echo -e "${CYAN}Shell Configuration:${NC}"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
    echo -e "  ${CYAN}→${NC} Detected: Zsh"
elif [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    else
        SHELL_RC="$HOME/.bashrc"
    fi
    echo -e "  ${CYAN}→${NC} Detected: Bash"
fi

if [ -n "$SHELL_RC" ]; then
    echo -e "  ${CYAN}→${NC} Config file: $SHELL_RC"

    if grep -q "# Claude Master System" "$SHELL_RC" 2>/dev/null; then
        echo -e "  $PASS Aliases installed"
        ((CHECKS_PASSED++))
    else
        echo -e "  $WARN Aliases not installed (optional)"
        echo -e "      ${YELLOW}Run:${NC} /Volumes/Ai/.Master/scripts/install-aliases.sh"
        ((CHECKS_WARNED++))
    fi
fi
echo ""

# File Permissions
echo -e "${CYAN}File Permissions:${NC}"
MASTER_OWNER=$(stat -f "%Su" /Volumes/Ai/.Master 2>/dev/null)
if [ -n "$MASTER_OWNER" ]; then
    echo -e "  ${CYAN}→${NC} Master directory owner: $MASTER_OWNER"
    if [ "$MASTER_OWNER" = "$(whoami)" ]; then
        echo -e "  $PASS You own the master directory"
        ((CHECKS_PASSED++))
    else
        echo -e "  $WARN Master directory owned by different user"
        ((CHECKS_WARNED++))
    fi
fi
echo ""

# Summary
echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}Verification Summary${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "  ${GREEN}Passed:${NC}  $CHECKS_PASSED"
echo -e "  ${RED}Failed:${NC}  $CHECKS_FAILED"
echo -e "  ${YELLOW}Warnings:${NC} $CHECKS_WARNED"
echo ""

# Overall result
if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ System is properly configured!${NC}"
    echo ""

    if [ $CHECKS_WARNED -gt 0 ]; then
        echo -e "${YELLOW}Optional improvements available:${NC}"

        if ! command -v git >/dev/null 2>&1; then
            echo -e "  • Install Git for cloning repositories"
        fi

        if ! command -v claude >/dev/null 2>&1; then
            echo -e "  • Install Claude CLI for interaction"
        fi

        if ! grep -q "# Claude Master System" "$SHELL_RC" 2>/dev/null; then
            echo -e "  • Run install-aliases.sh for convenient shortcuts"
        fi

        echo ""
    fi

    echo -e "${GREEN}Ready to use!${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. Create a new project:  ${YELLOW}/Volumes/Ai/.Master/scripts/init-project.sh${NC}"
    echo -e "  2. Setup existing project: ${YELLOW}cd /path/to/project && /Volumes/Ai/.Master/scripts/setup-existing.sh${NC}"
    echo -e "  3. Install aliases (optional): ${YELLOW}/Volumes/Ai/.Master/scripts/install-aliases.sh${NC}"
    echo ""

else
    echo -e "${RED}✗ Setup incomplete - $CHECKS_FAILED required check(s) failed${NC}"
    echo ""
    echo -e "${YELLOW}Please fix the issues above and run this script again.${NC}"
    echo ""
    exit 1
fi
