# init-project.ps1 - DEBUGGED AND FIXED VERSION
# Save this as D:\.Master\init-project.ps1

```powershell
# ========================================
# Claude Code Intelligent Project Initializer - FIXED VERSION
# ========================================

param(
    [string]$ProjectsRoot = "D:\Projects"
)

# Fancy banner
function Show-Banner {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   Claude Code Intelligent Project Setup   " -ForegroundColor Yellow
    Write-Host "       Multi-Agent System Initializer      " -ForegroundColor Yellow
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
}

# Get project information
function Get-ProjectInfo {
    $projectInfo = @{}
    
    # Get project name
    Write-Host "PROJECT SETUP" -ForegroundColor Green
    Write-Host ""
    
    do {
        $projectInfo.Name = Read-Host "Enter project name (e.g., my-awesome-app)"
    } while ([string]::IsNullOrWhiteSpace($projectInfo.Name))
    
    # Get project category
    Write-Host ""
    Write-Host "PROJECT CATEGORY" -ForegroundColor Green
    Write-Host "1. Software Development"
    Write-Host "2. Business/Administrative"
    Write-Host "3. Research/Analysis"
    Write-Host "4. Content/Documentation"
    Write-Host "5. Personal/Organization"
    Write-Host "6. Data Science/ML"
    Write-Host "7. Creative/Design"
    Write-Host "8. Other/Custom"
    Write-Host ""
    
    do {
        $category = Read-Host "Select project category (1-8)"
    } while ($category -notmatch '^[1-8]$')
    
    $projectInfo.Category = @{
        "1" = "Software Development"
        "2" = "Business/Administrative"
        "3" = "Research/Analysis"
        "4" = "Content/Documentation"
        "5" = "Personal/Organization"
        "6" = "Data Science/ML"
        "7" = "Creative/Design"
        "8" = "Other/Custom"
    }[$category]
    
    # Get specific project type based on category
    Write-Host ""
    Write-Host "PROJECT TYPE" -ForegroundColor Green
    
    $typeOptions = @{}
    
    switch ($category) {
        "1" { # Software Development
            Write-Host "1. Web Application"
            Write-Host "2. API/Backend"
            Write-Host "3. Mobile App"
            Write-Host "4. Desktop Application"
            Write-Host "5. Script/Automation"
            Write-Host "6. Library/Package"
            Write-Host "7. Full-Stack Application"
            Write-Host "8. Other"
            
            $typeOptions = @{
                "1" = "Web Application"
                "2" = "API/Backend"
                "3" = "Mobile App"
                "4" = "Desktop Application"
                "5" = "Script/Automation"
                "6" = "Library/Package"
                "7" = "Full-Stack Application"
                "8" = "Other Development"
            }
        }
        "2" { # Business/Administrative
            Write-Host "1. Resume/CV Tracking"
            Write-Host "2. Financial Management"
            Write-Host "3. Project Management"
            Write-Host "4. HR/Recruitment"
            Write-Host "5. Customer Management (CRM)"
            Write-Host "6. Inventory/Supply Chain"
            Write-Host "7. Business Analysis"
            Write-Host "8. Other Business"
            
            $typeOptions = @{
                "1" = "Resume/CV Tracking"
                "2" = "Financial Management"
                "3" = "Project Management"
                "4" = "HR/Recruitment"
                "5" = "Customer Management"
                "6" = "Inventory Management"
                "7" = "Business Analysis"
                "8" = "Other Business"
            }
        }
        "3" { # Research/Analysis
            Write-Host "1. Market Research"
            Write-Host "2. Academic Research"
            Write-Host "3. Data Analysis"
            Write-Host "4. Competitive Analysis"
            Write-Host "5. Literature Review"
            Write-Host "6. Scientific Research"
            Write-Host "7. Survey Analysis"
            Write-Host "8. Other Research"
            
            $typeOptions = @{
                "1" = "Market Research"
                "2" = "Academic Research"
                "3" = "Data Analysis"
                "4" = "Competitive Analysis"
                "5" = "Literature Review"
                "6" = "Scientific Research"
                "7" = "Survey Analysis"
                "8" = "Other Research"
            }
        }
        "4" { # Content/Documentation
            Write-Host "1. Technical Documentation"
            Write-Host "2. Blog/Articles"
            Write-Host "3. Book/eBook"
            Write-Host "4. Course Material"
            Write-Host "5. Marketing Content"
            Write-Host "6. User Guides"
            Write-Host "7. API Documentation"
            Write-Host "8. Other Content"
            
            $typeOptions = @{
                "1" = "Technical Documentation"
                "2" = "Blog/Articles"
                "3" = "Book/eBook"
                "4" = "Course Material"
                "5" = "Marketing Content"
                "6" = "User Guides"
                "7" = "API Documentation"
                "8" = "Other Content"
            }
        }
        "5" { # Personal/Organization
            Write-Host "1. Personal Finance"
            Write-Host "2. Task Management"
            Write-Host "3. Learning/Study"
            Write-Host "4. Health/Fitness"
            Write-Host "5. Travel Planning"
            Write-Host "6. Event Organization"
            Write-Host "7. Personal Database"
            Write-Host "8. Other Personal"
            
            $typeOptions = @{
                "1" = "Personal Finance"
                "2" = "Task Management"
                "3" = "Learning/Study"
                "4" = "Health/Fitness"
                "5" = "Travel Planning"
                "6" = "Event Organization"
                "7" = "Personal Database"
                "8" = "Other Personal"
            }
        }
        "6" { # Data Science/ML
            Write-Host "1. Machine Learning Model"
            Write-Host "2. Data Pipeline"
            Write-Host "3. Data Visualization"
            Write-Host "4. Statistical Analysis"
            Write-Host "5. NLP Project"
            Write-Host "6. Computer Vision"
            Write-Host "7. Predictive Analytics"
            Write-Host "8. Other Data Science"
            
            $typeOptions = @{
                "1" = "Machine Learning Model"
                "2" = "Data Pipeline"
                "3" = "Data Visualization"
                "4" = "Statistical Analysis"
                "5" = "NLP Project"
                "6" = "Computer Vision"
                "7" = "Predictive Analytics"
                "8" = "Other Data Science"
            }
        }
        "7" { # Creative/Design
            Write-Host "1. UI/UX Design"
            Write-Host "2. Graphic Design"
            Write-Host "3. Video/Animation"
            Write-Host "4. Game Development"
            Write-Host "5. Music/Audio"
            Write-Host "6. 3D Modeling"
            Write-Host "7. Photography"
            Write-Host "8. Other Creative"
            
            $typeOptions = @{
                "1" = "UI/UX Design"
                "2" = "Graphic Design"
                "3" = "Video/Animation"
                "4" = "Game Development"
                "5" = "Music/Audio"
                "6" = "3D Modeling"
                "7" = "Photography"
                "8" = "Other Creative"
            }
        }
        default { # Other/Custom
            Write-Host "Please describe your project type:"
            $projectInfo.ProjectType = Read-Host "Project type"
        }
    }
    
    if ($typeOptions.Count -gt 0) {
        Write-Host ""
        do {
            $typeChoice = Read-Host "Select project type (1-8)"
        } while ($typeChoice -notmatch '^[1-8]$')
        
        $projectInfo.ProjectType = $typeOptions[$typeChoice]
    }
    
    # Get setup type
    Write-Host ""
    Write-Host "SETUP TYPE" -ForegroundColor Green
    Write-Host "1. Create new empty project"
    Write-Host "2. Clone from GitHub"
    Write-Host "3. Use existing local folder"
    Write-Host ""
    
    do {
        $choice = Read-Host "Select option (1-3)"
    } while ($choice -notmatch '^[1-3]$')
    
    $projectInfo.SetupType = $choice
    
    # Get GitHub URL if cloning
    if ($choice -eq "2") {
        Write-Host ""
        Write-Host "GITHUB SETUP" -ForegroundColor Green
        $projectInfo.GitUrl = Read-Host "Enter GitHub URL (or press Enter to skip)"
    }
    # Get existing folder path if using local
    elseif ($choice -eq "3") {
        Write-Host ""
        Write-Host "EXISTING FOLDER" -ForegroundColor Green
        do {
            $projectInfo.ExistingPath = Read-Host "Enter full path to existing folder"
        } while (!(Test-Path $projectInfo.ExistingPath))
    }
    
    # Get project description
    Write-Host ""
    Write-Host "PROJECT DETAILS" -ForegroundColor Green
    $projectInfo.Description = Read-Host "Brief project description (optional)"
    
    # Get technology if relevant for development projects
    if ($category -eq "1" -or $category -eq "6") {
        Write-Host ""
        Write-Host "TECHNOLOGY/LANGUAGE" -ForegroundColor Green
        Write-Host "1. JavaScript/Node.js"
        Write-Host "2. Python"
        Write-Host "3. React"
        Write-Host "4. Next.js"
        Write-Host "5. Vue.js"
        Write-Host "6. .NET/C#"
        Write-Host "7. Java"
        Write-Host "8. PHP"
        Write-Host "9. Go"
        Write-Host "10. Other/None"
        Write-Host ""
        
        $tech = Read-Host "Select technology (1-10, or Enter to skip)"
        
        if ($tech -match '^([1-9]|10)$') {
            $projectInfo.Technology = @{
                "1" = "JavaScript/Node.js"
                "2" = "Python"
                "3" = "React"
                "4" = "Next.js"
                "5" = "Vue.js"
                "6" = ".NET/C#"
                "7" = "Java"
                "8" = "PHP"
                "9" = "Go"
                "10" = "Other"
            }[$tech]
        } else {
            $projectInfo.Technology = "Not Specified"
        }
    } else {
        $projectInfo.Technology = "Not Applicable"
    }
    
    return $projectInfo
}

# Initialize project
function Initialize-Project {
    param($ProjectInfo, $ProjectsRoot)
    
    Write-Host ""
    Write-Host "INITIALIZING PROJECT..." -ForegroundColor Cyan
    
    # Determine project path
    if ($ProjectInfo.SetupType -eq "3" -and $ProjectInfo.ExistingPath) {
        $projectPath = $ProjectInfo.ExistingPath
    } else {
        $projectPath = Join-Path $ProjectsRoot $ProjectInfo.Name
    }
    
    # Create project directory if needed
    if ($ProjectInfo.SetupType -eq "1") {
        if (Test-Path $projectPath) {
            Write-Host "Warning: Project folder already exists!" -ForegroundColor Yellow
            $overwrite = Read-Host "Overwrite? (y/n)"
            if ($overwrite -ne 'y') {
                Write-Host "Setup cancelled" -ForegroundColor Red
                return $null
            }
        }
        New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
        Write-Host "Created project folder: $projectPath" -ForegroundColor Green
    }
    
    # Clone from GitHub if specified
    if ($ProjectInfo.SetupType -eq "2" -and $ProjectInfo.GitUrl) {
        Write-Host "Cloning from GitHub..." -ForegroundColor Yellow
        
        if (Test-Path $projectPath) {
            Remove-Item $projectPath -Recurse -Force
        }
        
        try {
            git clone $ProjectInfo.GitUrl $projectPath 2>&1 | Out-Null
            Write-Host "Repository cloned successfully" -ForegroundColor Green
        } catch {
            Write-Host "Failed to clone repository" -ForegroundColor Red
            Write-Host "Creating empty project instead..." -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
        }
    }
    
    # Navigate to project directory
    Set-Location $projectPath
    Write-Host "Working in: $projectPath" -ForegroundColor Cyan
    
    # Create Claude directories
    Write-Host "Creating Claude structure..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path ".claude\logs" -Force | Out-Null
    New-Item -ItemType Directory -Path ".claude\versions" -Force | Out-Null
    New-Item -ItemType Directory -Path ".claude\backups" -Force | Out-Null
    New-Item -ItemType Directory -Path ".claude\assets" -Force | Out-Null
    Write-Host "Claude directories created" -ForegroundColor Green
    
    # Create project initialization file
    $initTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $githubUrl = if ($ProjectInfo.GitUrl) { $ProjectInfo.GitUrl } else { "None" }
    
    $initContent = @"
Project: $($ProjectInfo.Name)
Initialized: $initTime
Category: $($ProjectInfo.Category)
Type: $($ProjectInfo.ProjectType)
Description: $($ProjectInfo.Description)
Technology: $($ProjectInfo.Technology)
GitHub: $githubUrl
Setup Type: $(@{1="New"; 2="Cloned"; 3="Existing"}[$ProjectInfo.SetupType])
"@
    
    $initContent | Out-File ".claude-project-init" -Encoding UTF8
    Write-Host "Project initialization recorded" -ForegroundColor Green
    
    # Create customized Claude instructions
    Write-Host "Creating customized Claude instructions..." -ForegroundColor Yellow
    
    # Copy master template if it exists
    if (Test-Path "D:\.Master\CLAUDE_INSTRUCTIONS.md") {
        Copy-Item "D:\.Master\CLAUDE_INSTRUCTIONS.md" -Destination "CLAUDE_INSTRUCTIONS.md" -Force
        
        # Append project-specific configuration
        $projectSpecific = @"

# ==========================================
# PROJECT-SPECIFIC CONFIGURATION
# ==========================================

## This Project Details
- **Name**: $($ProjectInfo.Name)
- **Category**: $($ProjectInfo.Category)
- **Type**: $($ProjectInfo.ProjectType)
- **Description**: $($ProjectInfo.Description)
- **Technology**: $($ProjectInfo.Technology)
- **Path**: $projectPath

## How Agents Apply to This $($ProjectInfo.ProjectType) Project

"@

        # Add category-specific agent descriptions
        $agentDesc = Get-CategoryAgentDescriptions -Category $ProjectInfo.Category -ProjectType $ProjectInfo.ProjectType
        $projectSpecific += $agentDesc
        
        Add-Content -Path "CLAUDE_INSTRUCTIONS.md" -Value $projectSpecific -Encoding UTF8
    } else {
        # Create from scratch if no master template
        $instructions = Create-CompleteInstructions -ProjectInfo $ProjectInfo -ProjectPath $projectPath
        $instructions | Out-File "CLAUDE_INSTRUCTIONS.md" -Encoding UTF8
    }
    
    Write-Host "Claude instructions customized for $($ProjectInfo.ProjectType)" -ForegroundColor Green
    
    # Create project summary
    $summaryContent = @"
# $($ProjectInfo.Name)

## Project Overview
- **Category**: $($ProjectInfo.Category)
- **Type**: $($ProjectInfo.ProjectType)
- **Description**: $($ProjectInfo.Description)
- **Technology**: $($ProjectInfo.Technology)
- **Initialized**: $initTime
- **GitHub**: $githubUrl

## Claude Multi-Agent System
This project is configured with Claude's 12-agent system, specifically adapted for $($ProjectInfo.ProjectType).

## Quick Start
Run: claude

Claude will automatically read CLAUDE_INSTRUCTIONS.md and understand:
- This is a $($ProjectInfo.ProjectType) project
- The 12 agents are configured for $($ProjectInfo.Category) tasks
- All specific requirements and guidelines
"@
    
    $summaryContent | Out-File "PROJECT_SUMMARY.md" -Encoding UTF8
    Write-Host "Project summary created" -ForegroundColor Green
    
    # Add to .gitignore if git repo
    if (Test-Path ".git") {
        Write-Host "Updating .gitignore..." -ForegroundColor Yellow
        $gitignoreContent = @"

# Claude Code System Files
.claude/
.claude-project-init
.claude-last-session
*.claude-backup
"@
        Add-Content -Path ".gitignore" -Value $gitignoreContent -Encoding UTF8
        Write-Host ".gitignore updated" -ForegroundColor Green
    }
    
    return @{
        Path = $projectPath
        Info = $ProjectInfo
    }
}

# Get category-specific agent descriptions
function Get-CategoryAgentDescriptions {
    param($Category, $ProjectType)
    
    $desc = "For this $ProjectType project in the $Category category:`n`n"
    
    if ($Category -eq "Business/Administrative") {
        $desc += @"
- **Agent 0**: Understands business requirements and compliance needs
- **Agent 1**: Analyzes existing systems and documents
- **Agent 2**: Extracts business rules and workflows
- **Agent 3**: Identifies risks and compliance issues
- **Agent 4**: Designs data structures and systems
- **Agent 5**: Establishes business patterns
- **Agent 6**: Breaks down into tasks
- **Agent 7**: Creates automation and templates
- **Agent 8**: Validates business logic
- **Agent 9**: Reviews for best practices
- **Agent 10**: Optimizes processes
- **Agent 11**: Improves efficiency
- **Agent 12**: Creates documentation
"@
    }
    elseif ($Category -eq "Research/Analysis") {
        $desc += @"
- **Agent 0**: Defines research questions
- **Agent 1**: Reviews existing research
- **Agent 2**: Identifies data requirements
- **Agent 3**: Assesses methodology risks
- **Agent 4**: Designs research framework
- **Agent 5**: Identifies patterns
- **Agent 6**: Plans research phases
- **Agent 7**: Creates analysis code
- **Agent 8**: Validates findings
- **Agent 9**: Reviews methodology
- **Agent 10**: Refines analysis
- **Agent 11**: Optimizes processing
- **Agent 12**: Writes papers
"@
    }
    elseif ($Category -eq "Personal/Organization") {
        $desc += @"
- **Agent 0**: Understands personal goals
- **Agent 1**: Reviews existing systems
- **Agent 2**: Identifies needs
- **Agent 3**: Assesses sustainability
- **Agent 4**: Designs organization system
- **Agent 5**: Creates templates
- **Agent 6**: Plans implementation
- **Agent 7**: Builds tracking systems
- **Agent 8**: Tests feasibility
- **Agent 9**: Reviews practicality
- **Agent 10**: Simplifies systems
- **Agent 11**: Optimizes workflow
- **Agent 12**: Creates guides
"@
    }
    else {
        $desc += @"
- **Agent 0**: Understands requirements
- **Agent 1**: Analyzes existing code
- **Agent 2**: Extracts specifications
- **Agent 3**: Identifies risks
- **Agent 4**: Designs architecture
- **Agent 5**: Selects patterns
- **Agent 6**: Plans tasks
- **Agent 7**: Generates code
- **Agent 8**: Tests thoroughly
- **Agent 9**: Reviews quality
- **Agent 10**: Refactors code
- **Agent 11**: Optimizes performance
- **Agent 12**: Documents everything
"@
    }
    
    return $desc
}

# Create complete instructions from scratch
function Create-CompleteInstructions {
    param($ProjectInfo, $ProjectPath)
    
    $githubUrl = if ($ProjectInfo.GitUrl) { $ProjectInfo.GitUrl } else { "Not connected" }
    
    $instructions = @"
# CLAUDE_INSTRUCTIONS.md

## ATTENTION CLAUDE: MANDATORY EXECUTION

**YOU MUST FOLLOW THESE INSTRUCTIONS FOR EVERY INTERACTION IN THIS PROJECT**

## PROJECT CONTEXT
- **Project**: $($ProjectInfo.Name)
- **Category**: $($ProjectInfo.Category)
- **Type**: $($ProjectInfo.ProjectType)
- **Description**: $($ProjectInfo.Description)
- **Technology**: $($ProjectInfo.Technology)
- **GitHub**: $githubUrl
- **Path**: $ProjectPath

## YOUR 12 SPECIALIZED AGENTS

You have 12 agents adapted for this $($ProjectInfo.ProjectType) project.

$(Get-CategoryAgentDescriptions -Category $ProjectInfo.Category -ProjectType $ProjectInfo.ProjectType)

## WORKFLOW
1. Always start by reading this file
2. Use appropriate agents for the task
3. Log all actions to .claude/logs/
4. Create backups before changes
5. Save reusable code to .claude/assets/

## READY TO START
I am configured as your Intelligent Master Orchestrator for this $($ProjectInfo.ProjectType) project.
What would you like to work on?
"@
    
    return $instructions
}

# Launch Claude Code with context
function Start-ClaudeWithContext {
    param($Project)
    
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "        PROJECT READY FOR CLAUDE CODE       " -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Project: $($Project.Info.Name)" -ForegroundColor Yellow
    Write-Host "Location: $($Project.Path)" -ForegroundColor Yellow
    Write-Host "Category: $($Project.Info.Category)" -ForegroundColor Yellow
    Write-Host "Type: $($Project.Info.ProjectType)" -ForegroundColor Yellow
    Write-Host "Technology: $($Project.Info.Technology)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Claude has been configured with:" -ForegroundColor Cyan
    Write-Host "  - 12 agents adapted for $($Project.Info.ProjectType)"
    Write-Host "  - Specific guidelines for $($Project.Info.Category)"
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Green
    Write-Host "  1. Start Claude Code now"
    Write-Host "  2. Open project folder"
    Write-Host "  3. View instructions"
    Write-Host "  4. Exit"
    Write-Host ""
    
    do {
        $choice = Read-Host "Select option (1-4)"
        
        switch ($choice) {
            "1" {
                Write-Host ""
                Write-Host "Launching Claude Code..." -ForegroundColor Green
                
                $initialPrompt = "I'm working on $($Project.Info.Name), a $($Project.Info.ProjectType) project. "
                if ($Project.Info.Description) {
                    $initialPrompt += "Description: $($Project.Info.Description). "
                }
                $initialPrompt += "Please read CLAUDE_INSTRUCTIONS.md and confirm you understand your role."
                
                & claude $initialPrompt
                break
            }
            "2" {
                Write-Host "Opening project folder..." -ForegroundColor Green
                explorer.exe $Project.Path
            }
            "3" {
                Write-Host "Showing instructions..." -ForegroundColor Green
                if (Test-Path "CLAUDE_INSTRUCTIONS.md") {
                    Get-Content "CLAUDE_INSTRUCTIONS.md" | Select-Object -First 30
                    Write-Host "... (truncated) ..." -ForegroundColor Gray
                }
                Read-Host "Press Enter to continue"
            }
            "4" {
                Write-Host "Setup complete!" -ForegroundColor Green
                break
            }
        }
    } while ($choice -ne "1" -and $choice -ne "4")
}

# Main execution
Show-Banner

# Check prerequisites
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Warning: Git not installed. Clone features won't work." -ForegroundColor Yellow
}

# Ensure projects root exists
if (!(Test-Path $ProjectsRoot)) {
    New-Item -ItemType Directory -Path $ProjectsRoot -Force | Out-Null
    Write-Host "Created projects directory: $ProjectsRoot" -ForegroundColor Green
}

# Get project information
$projectInfo = Get-ProjectInfo

# Initialize project
$project = Initialize-Project -ProjectInfo $projectInfo -ProjectsRoot $ProjectsRoot

if ($project) {
    Start-ClaudeWithContext -Project $project
} else {
    Write-Host "Project initialization failed" -ForegroundColor Red
}

