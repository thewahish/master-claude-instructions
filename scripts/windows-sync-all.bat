@echo off
REM Windows version of sync-all-projects script

echo Syncing all projects in D:\Projects...

set PROJECTS_DIR=D:\Projects
set MASTER_DIR=D:\.Master

echo.
echo =================================================
echo  Windows Master AI System - Project Sync
echo =================================================
echo.

REM Update project registry
echo [1/4] Updating project registry...
node "%MASTER_DIR%\global-assets\project-discovery.js" --update-registry

REM Check git status for all projects
echo [2/4] Checking git status...
for /d %%i in ("%PROJECTS_DIR%\*") do (
    if exist "%%i\.git" (
        echo Checking: %%~ni
        cd /d "%%i"
        git status --porcelain > nul
        if errorlevel 1 (
            echo   - Has changes
        ) else (
            echo   - Clean
        )
    )
)

REM Pull latest changes
echo [3/4] Pulling latest changes...
for /d %%i in ("%PROJECTS_DIR%\*") do (
    if exist "%%i\.git" (
        echo Pulling: %%~ni
        cd /d "%%i"
        git pull origin main 2>nul || git pull origin master 2>nul
    )
)

REM Update CLAUDE.md files with inheritance
echo [4/4] Updating CLAUDE.md files...
for /d %%i in ("%PROJECTS_DIR%\*") do (
    if not exist "%%i\CLAUDE.md" (
        echo Creating CLAUDE.md for: %%~ni
        copy "%MASTER_DIR%\modules\templates\project-claude-template.md" "%%i\CLAUDE.md"
    )
)

echo.
echo ============================================
echo  Sync completed successfully!
echo ============================================
echo.

cd /d "%MASTER_DIR%"