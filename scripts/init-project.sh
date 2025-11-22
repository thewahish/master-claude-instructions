#!/bin/bash

# ========================================
# Claude Code Intelligent Project Initializer
# For macOS - Version 2.0
# ========================================

PROJECTS_ROOT="/Volumes/Ai/Projects"
MASTER_DIR="/Volumes/Ai/.Master"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fancy banner
show_banner() {
    clear
    echo -e "${CYAN}============================================${NC}"
    echo -e "${YELLOW}   Claude Code Intelligent Project Setup${NC}"
    echo -e "${YELLOW}       Multi-Agent System Initializer${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
}

# Get project information
get_project_info() {
    echo -e "${GREEN}PROJECT SETUP${NC}"
    echo ""

    # Get project name
    while [ -z "$PROJECT_NAME" ]; do
        read -p "Enter project name (e.g., my-awesome-app): " PROJECT_NAME
    done

    # Get project category
    echo ""
    echo -e "${GREEN}PROJECT CATEGORY${NC}"
    echo "1. Software Development"
    echo "2. Business/Administrative"
    echo "3. Research/Analysis"
    echo "4. Content/Documentation"
    echo "5. Personal/Organization"
    echo "6. Data Science/ML"
    echo "7. Creative/Design"
    echo "8. Other/Custom"
    echo ""

    while true; do
        read -p "Select project category (1-8): " category_choice
        case $category_choice in
            1) CATEGORY="Software Development"; break;;
            2) CATEGORY="Business/Administrative"; break;;
            3) CATEGORY="Research/Analysis"; break;;
            4) CATEGORY="Content/Documentation"; break;;
            5) CATEGORY="Personal/Organization"; break;;
            6) CATEGORY="Data Science/ML"; break;;
            7) CATEGORY="Creative/Design"; break;;
            8) CATEGORY="Other/Custom"; break;;
            *) echo "Invalid choice. Please select 1-8.";;
        esac
    done

    # Get specific project type based on category
    echo ""
    echo -e "${GREEN}PROJECT TYPE${NC}"

    case $category_choice in
        1) # Software Development
            echo "1. Web Application"
            echo "2. API/Backend"
            echo "3. Mobile App"
            echo "4. Desktop Application"
            echo "5. Script/Automation"
            echo "6. Library/Package"
            echo "7. Full-Stack Application"
            echo "8. Other"
            echo ""
            read -p "Select project type (1-8): " type_choice
            case $type_choice in
                1) PROJECT_TYPE="Web Application";;
                2) PROJECT_TYPE="API/Backend";;
                3) PROJECT_TYPE="Mobile App";;
                4) PROJECT_TYPE="Desktop Application";;
                5) PROJECT_TYPE="Script/Automation";;
                6) PROJECT_TYPE="Library/Package";;
                7) PROJECT_TYPE="Full-Stack Application";;
                *) PROJECT_TYPE="Other Development";;
            esac
            ;;
        2) # Business/Administrative
            echo "1. Resume/CV Tracking"
            echo "2. Financial Management"
            echo "3. Project Management"
            echo "4. HR/Recruitment"
            echo "5. Customer Management (CRM)"
            echo "6. Inventory/Supply Chain"
            echo "7. Business Analysis"
            echo "8. Other Business"
            echo ""
            read -p "Select project type (1-8): " type_choice
            case $type_choice in
                1) PROJECT_TYPE="Resume/CV Tracking";;
                2) PROJECT_TYPE="Financial Management";;
                3) PROJECT_TYPE="Project Management";;
                4) PROJECT_TYPE="HR/Recruitment";;
                5) PROJECT_TYPE="Customer Management";;
                6) PROJECT_TYPE="Inventory Management";;
                7) PROJECT_TYPE="Business Analysis";;
                *) PROJECT_TYPE="Other Business";;
            esac
            ;;
        *) # Default for other categories
            read -p "Enter project type: " PROJECT_TYPE
            ;;
    esac

    # Get setup type
    echo ""
    echo -e "${GREEN}SETUP TYPE${NC}"
    echo "1. Create new empty project"
    echo "2. Clone from GitHub"
    echo "3. Use existing local folder"
    echo ""

    while true; do
        read -p "Select option (1-3): " setup_choice
        case $setup_choice in
            1|2|3) SETUP_TYPE=$setup_choice; break;;
            *) echo "Invalid choice. Please select 1-3.";;
        esac
    done

    # Get GitHub URL if cloning
    if [ "$SETUP_TYPE" = "2" ]; then
        echo ""
        echo -e "${GREEN}GITHUB SETUP${NC}"
        read -p "Enter GitHub URL: " GIT_URL
    fi

    # Get existing folder path if using local
    if [ "$SETUP_TYPE" = "3" ]; then
        echo ""
        echo -e "${GREEN}EXISTING FOLDER${NC}"
        while true; do
            read -p "Enter full path to existing folder: " EXISTING_PATH
            if [ -d "$EXISTING_PATH" ]; then
                break
            else
                echo -e "${RED}Folder does not exist. Please try again.${NC}"
            fi
        done
    fi

    # Get project description
    echo ""
    echo -e "${GREEN}PROJECT DETAILS${NC}"
    read -p "Brief project description (optional): " DESCRIPTION

    # Get technology if relevant
    if [ "$category_choice" = "1" ] || [ "$category_choice" = "6" ]; then
        echo ""
        echo -e "${GREEN}TECHNOLOGY/LANGUAGE${NC}"
        echo "1. JavaScript/Node.js"
        echo "2. Python"
        echo "3. React"
        echo "4. Next.js"
        echo "5. Vue.js"
        echo "6. Swift/iOS"
        echo "7. Kotlin/Android"
        echo "8. Go"
        echo "9. Rust"
        echo "10. Other/None"
        echo ""

        read -p "Select technology (1-10, or Enter to skip): " tech_choice
        case $tech_choice in
            1) TECHNOLOGY="JavaScript/Node.js";;
            2) TECHNOLOGY="Python";;
            3) TECHNOLOGY="React";;
            4) TECHNOLOGY="Next.js";;
            5) TECHNOLOGY="Vue.js";;
            6) TECHNOLOGY="Swift/iOS";;
            7) TECHNOLOGY="Kotlin/Android";;
            8) TECHNOLOGY="Go";;
            9) TECHNOLOGY="Rust";;
            *) TECHNOLOGY="Not Specified";;
        esac
    else
        TECHNOLOGY="Not Applicable"
    fi
}

# Initialize project
initialize_project() {
    echo ""
    echo -e "${CYAN}INITIALIZING PROJECT...${NC}"

    # Determine project path
    if [ "$SETUP_TYPE" = "3" ] && [ -n "$EXISTING_PATH" ]; then
        PROJECT_PATH="$EXISTING_PATH"
    else
        PROJECT_PATH="$PROJECTS_ROOT/$PROJECT_NAME"
    fi

    # Create project directory if needed
    if [ "$SETUP_TYPE" = "1" ]; then
        if [ -d "$PROJECT_PATH" ]; then
            echo -e "${YELLOW}Warning: Project folder already exists!${NC}"
            read -p "Overwrite? (y/n): " overwrite
            if [ "$overwrite" != "y" ]; then
                echo -e "${RED}Setup cancelled${NC}"
                exit 1
            fi
        fi
        mkdir -p "$PROJECT_PATH"
        echo -e "${GREEN}Created project folder: $PROJECT_PATH${NC}"
    fi

    # Clone from GitHub if specified
    if [ "$SETUP_TYPE" = "2" ] && [ -n "$GIT_URL" ]; then
        echo -e "${YELLOW}Cloning from GitHub...${NC}"

        if [ -d "$PROJECT_PATH" ]; then
            rm -rf "$PROJECT_PATH"
        fi

        if git clone "$GIT_URL" "$PROJECT_PATH" 2>/dev/null; then
            echo -e "${GREEN}Repository cloned successfully${NC}"
        else
            echo -e "${RED}Failed to clone repository${NC}"
            echo -e "${YELLOW}Creating empty project instead...${NC}"
            mkdir -p "$PROJECT_PATH"
        fi
    fi

    # Navigate to project directory
    cd "$PROJECT_PATH" || exit 1
    echo -e "${CYAN}Working in: $PROJECT_PATH${NC}"

    # Create Claude directories
    echo -e "${YELLOW}Creating Claude structure...${NC}"
    mkdir -p .claude/{logs,versions,backups,assets}
    echo -e "${GREEN}Claude directories created${NC}"

    # Create project initialization file
    INIT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    GIT_URL_DISPLAY="${GIT_URL:-None}"

    cat > .claude-project-init <<EOF
Project: $PROJECT_NAME
Initialized: $INIT_TIME
Category: $CATEGORY
Type: $PROJECT_TYPE
Description: $DESCRIPTION
Technology: $TECHNOLOGY
GitHub: $GIT_URL_DISPLAY
Setup Type: $SETUP_TYPE
EOF

    echo -e "${GREEN}Project initialization recorded${NC}"

    # Copy and customize Claude instructions
    echo -e "${YELLOW}Creating customized Claude instructions...${NC}"

    if [ -f "$MASTER_DIR/CLAUDE_INSTRUCTIONS.md" ]; then
        cp "$MASTER_DIR/CLAUDE_INSTRUCTIONS.md" CLAUDE_INSTRUCTIONS.md

        # Append project-specific configuration
        cat >> CLAUDE_INSTRUCTIONS.md <<EOF

# ==========================================
# PROJECT-SPECIFIC CONFIGURATION
# ==========================================

## This Project Details
- **Name**: $PROJECT_NAME
- **Category**: $CATEGORY
- **Type**: $PROJECT_TYPE
- **Description**: $DESCRIPTION
- **Technology**: $TECHNOLOGY
- **Path**: $PROJECT_PATH

## Agent Adaptation for This $PROJECT_TYPE Project

For this $PROJECT_TYPE project in the $CATEGORY category:

- **Agent 0**: Understands $PROJECT_TYPE requirements
- **Agent 1**: Analyzes existing $PROJECT_TYPE codebase
- **Agent 2**: Extracts $PROJECT_TYPE specifications
- **Agent 3**: Identifies $PROJECT_TYPE risks
- **Agent 4**: Designs $PROJECT_TYPE architecture
- **Agent 5**: Selects patterns for $PROJECT_TYPE
- **Agent 6**: Plans $PROJECT_TYPE tasks
- **Agent 7**: Generates $PROJECT_TYPE code
- **Agent 8**: Tests $PROJECT_TYPE thoroughly
- **Agent 9**: Reviews $PROJECT_TYPE quality
- **Agent 10**: Refactors $PROJECT_TYPE code
- **Agent 11**: Optimizes $PROJECT_TYPE performance
- **Agent 12**: Documents $PROJECT_TYPE features

## Technology Stack
- Primary: $TECHNOLOGY
- Additional tools and frameworks will be documented as discovered

## Project Standards
- Code style: [To be established]
- Testing approach: [To be defined]
- Documentation format: [To be determined]

---

**Project initialized on $INIT_TIME**
**Ready for Claude Code interaction**
EOF

        echo -e "${GREEN}Claude instructions customized for $PROJECT_TYPE${NC}"
    else
        echo -e "${RED}Warning: Master template not found at $MASTER_DIR/CLAUDE_INSTRUCTIONS.md${NC}"
        echo -e "${YELLOW}Creating basic instructions...${NC}"

        cat > CLAUDE_INSTRUCTIONS.md <<EOF
# CLAUDE_INSTRUCTIONS.md

## PROJECT: $PROJECT_NAME

### Details
- **Category**: $CATEGORY
- **Type**: $PROJECT_TYPE
- **Description**: $DESCRIPTION
- **Technology**: $TECHNOLOGY
- **Initialized**: $INIT_TIME

### Instructions
This project uses the Claude Multi-Agent System.
Please read the full instructions from the master template.
EOF
    fi

    # Create project summary
    cat > PROJECT_SUMMARY.md <<EOF
# $PROJECT_NAME

## Project Overview
- **Category**: $CATEGORY
- **Type**: $PROJECT_TYPE
- **Description**: $DESCRIPTION
- **Technology**: $TECHNOLOGY
- **Initialized**: $INIT_TIME
- **GitHub**: $GIT_URL_DISPLAY

## Claude Multi-Agent System
This project is configured with Claude's 12-agent system, specifically adapted for $PROJECT_TYPE.

## Quick Start
Run: \`claude\`

Claude will automatically read CLAUDE_INSTRUCTIONS.md and understand:
- This is a $PROJECT_TYPE project
- The 12 agents are configured for $CATEGORY tasks
- All specific requirements and guidelines

## Project Structure
\`\`\`
.claude/
  ├── logs/       # Session and action logs
  ├── versions/   # Version snapshots
  ├── backups/    # Pre-change backups
  └── assets/     # Reusable components
\`\`\`

## Session Management
- Initial setup: $INIT_TIME
- Last session: Check .claude-last-session
- Logs: .claude/logs/

---
Generated by Claude Code Project Initializer
EOF

    echo -e "${GREEN}Project summary created${NC}"

    # Add to .gitignore if git repo
    if [ -d .git ]; then
        echo -e "${YELLOW}Updating .gitignore...${NC}"

        if [ ! -f .gitignore ]; then
            touch .gitignore
        fi

        # Check if Claude entries already exist
        if ! grep -q ".claude/" .gitignore; then
            cat >> .gitignore <<EOF

# Claude Code System Files
.claude/
.claude-project-init
.claude-last-session
*.claude-backup
EOF
            echo -e "${GREEN}.gitignore updated${NC}"
        else
            echo -e "${YELLOW}.gitignore already contains Claude entries${NC}"
        fi
    fi

    # Create initial session file
    echo "Session started: $(date '+%Y-%m-%d %H:%M:%S')" > .claude-last-session
    echo "Project initialized" >> .claude-last-session
}

# Show completion and next steps
show_completion() {
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${GREEN}        PROJECT READY FOR CLAUDE CODE${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
    echo -e "${YELLOW}Project: $PROJECT_NAME${NC}"
    echo -e "${YELLOW}Location: $PROJECT_PATH${NC}"
    echo -e "${YELLOW}Category: $CATEGORY${NC}"
    echo -e "${YELLOW}Type: $PROJECT_TYPE${NC}"
    echo -e "${YELLOW}Technology: $TECHNOLOGY${NC}"
    echo ""
    echo -e "${CYAN}Claude has been configured with:${NC}"
    echo "  - 12 agents adapted for $PROJECT_TYPE"
    echo "  - Specific guidelines for $CATEGORY"
    echo "  - Automatic logging and version control"
    echo ""
    echo -e "${GREEN}Next Steps:${NC}"
    echo "  1. cd $PROJECT_PATH"
    echo "  2. claude"
    echo ""
    echo -e "${CYAN}Or run:${NC} ${YELLOW}cd $PROJECT_PATH && claude${NC}"
    echo ""
}

# Main execution
show_banner

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Warning: Git not installed. Clone features won't work.${NC}"
    echo ""
fi

# Ensure master directory exists
if [ ! -d "$MASTER_DIR" ]; then
    echo -e "${RED}Error: Master directory not found at $MASTER_DIR${NC}"
    echo "Please ensure the master setup is complete."
    exit 1
fi

# Ensure projects root exists
if [ ! -d "$PROJECTS_ROOT" ]; then
    mkdir -p "$PROJECTS_ROOT"
    echo -e "${GREEN}Created projects directory: $PROJECTS_ROOT${NC}"
    echo ""
fi

# Get project information
get_project_info

# Initialize project
initialize_project

# Show completion
show_completion
