@echo off
setlocal enabledelayedexpansion

echo ================================
echo     NEW PROJECT CREATOR
echo ================================
echo.

REM Get project name
set /p PROJECT_NAME="Enter project name: "
if "!PROJECT_NAME!"=="" (
    echo Error: Project name cannot be empty
    pause
    exit /b 1
)

REM Get GitHub repository URL
set /p GITHUB_URL="Enter GitHub repository URL (or press Enter to create later): "

REM Get project category
echo.
echo Available categories:
echo 1. web-development
echo 2. game-development  
echo 3. application-systems
echo 4. content-creation
echo 5. Create new category
echo.
set /p CATEGORY_CHOICE="Select category (1-5): "

REM Map category choice
if "!CATEGORY_CHOICE!"=="1" set CATEGORY=web-development
if "!CATEGORY_CHOICE!"=="2" set CATEGORY=game-development
if "!CATEGORY_CHOICE!"=="3" set CATEGORY=application-systems
if "!CATEGORY_CHOICE!"=="4" set CATEGORY=content-creation
if "!CATEGORY_CHOICE!"=="5" (
    set /p CATEGORY="Enter new category name: "
    echo Creating new category: !CATEGORY!
)

REM Get project type
echo.
echo Project type:
echo 1. Node.js (React, Vue, etc.)
echo 2. Python 
echo 3. Static HTML/CSS/JS
echo 4. Other
echo.
set /p TYPE_CHOICE="Select project type (1-4): "

if "!TYPE_CHOICE!"=="1" set PROJECT_TYPE=node
if "!TYPE_CHOICE!"=="2" set PROJECT_TYPE=python
if "!TYPE_CHOICE!"=="3" set PROJECT_TYPE=web
if "!TYPE_CHOICE!"=="4" set PROJECT_TYPE=other

echo.
echo ================================
echo Creating project: !PROJECT_NAME!
echo Category: !CATEGORY!
echo Type: !PROJECT_TYPE!
echo GitHub: !GITHUB_URL!
echo ================================
echo.

REM Create project directory
set PROJECT_PATH=D:\Projects\!PROJECT_NAME!
mkdir "!PROJECT_PATH!" 2>nul

if not exist "!PROJECT_PATH!" (
    echo Error: Could not create project directory
    pause
    exit /b 1
)

cd /d "!PROJECT_PATH!"

REM Initialize git
git init
echo # !PROJECT_NAME! > README.md

REM Create project-specific files based on type
if "!PROJECT_TYPE!"=="node" (
    echo Creating Node.js project structure...
    echo { > package.json
    echo   "name": "!PROJECT_NAME!", >> package.json
    echo   "version": "1.0.0", >> package.json
    echo   "description": "", >> package.json
    echo   "main": "index.js", >> package.json
    echo   "scripts": { >> package.json
    echo     "start": "node index.js", >> package.json
    echo     "dev": "nodemon index.js", >> package.json
    echo     "test": "jest" >> package.json
    echo   }, >> package.json
    echo   "keywords": [], >> package.json
    echo   "author": "", >> package.json
    echo   "license": "MIT" >> package.json
    echo } >> package.json
    
    mkdir src 2>nul
    echo console.log('Hello from !PROJECT_NAME!'); > src/index.js
)

if "!PROJECT_TYPE!"=="python" (
    echo Creating Python project structure...
    echo # !PROJECT_NAME! > main.py
    echo print('Hello from !PROJECT_NAME!') >> main.py
    echo # Project dependencies > requirements.txt
    mkdir src 2>nul
    echo __version__ = '1.0.0' > src/__init__.py
)

if "!PROJECT_TYPE!"=="web" (
    echo Creating web project structure...
    echo ^<!DOCTYPE html^> > index.html
    echo ^<html lang="en"^> >> index.html
    echo ^<head^> >> index.html
    echo     ^<meta charset="UTF-8"^> >> index.html
    echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> index.html
    echo     ^<title^>!PROJECT_NAME!^</title^> >> index.html
    echo     ^<link rel="stylesheet" href="style.css"^> >> index.html
    echo ^</head^> >> index.html
    echo ^<body^> >> index.html
    echo     ^<h1^>Welcome to !PROJECT_NAME!^</h1^> >> index.html
    echo     ^<script src="script.js"^>^</script^> >> index.html
    echo ^</body^> >> index.html
    echo ^</html^> >> index.html
    
    echo /* !PROJECT_NAME! Styles */ > style.css
    echo body { font-family: Arial, sans-serif; margin: 0; padding: 20px; } >> style.css
    
    echo // !PROJECT_NAME! JavaScript > script.js
    echo console.log('!PROJECT_NAME! loaded'); >> script.js
)

REM Call Node.js script to create CLAUDE.md and update registry
node "D:\.Master\scripts\setup-new-project.js" "!PROJECT_NAME!" "!CATEGORY!" "!PROJECT_TYPE!" "!GITHUB_URL!"

REM Initial git commit
git add .
git commit -m "Initial commit - !PROJECT_NAME! project setup 🧮 Generated with Claude Code"

REM Setup remote if GitHub URL provided
if not "!GITHUB_URL!"=="" (
    echo Setting up GitHub remote...
    git remote add origin !GITHUB_URL!
    echo.
    echo To push to GitHub, run:
    echo git push -u origin main
    echo.
    echo Make sure the repository exists on GitHub first!
)

echo.
echo ================================
echo ✅ PROJECT CREATED SUCCESSFULLY!
echo ================================
echo.
echo Project location: !PROJECT_PATH!
echo.
echo Next steps:
echo 1. cd "!PROJECT_PATH!"
echo 2. claude ^(to start working with AI assistance^)
if not "!GITHUB_URL!"=="" (
    echo 3. git push -u origin main ^(to upload to GitHub^)
)
echo.

pause