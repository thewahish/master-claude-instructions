@echo off
REM Create missing GitHub repositories for local projects

echo Creating missing GitHub repositories...

set PROJECTS_DIR=D:\Projects

echo.
echo =============================================
echo  Creating Missing GitHub Repositories
echo =============================================
echo.

REM Projects that need repositories created
set MISSING_REPOS=invoices Kinda leen

echo The following projects need GitHub repositories:
echo - invoices (Invoice generation system)
echo - Kinda (Political campaign materials)  
echo - leen (Bilingual artist portfolio)
echo.

echo To create these repositories:
echo 1. Go to https://github.com/new
echo 2. Create repository with exact name (case-sensitive)
echo 3. Run the setup commands below
echo.

echo === SETUP COMMANDS ===
echo.

echo For invoices:
echo cd /d "%PROJECTS_DIR%\invoices"
echo git init
echo git add .
echo git commit -m "Initial commit - Invoice generation system"
echo git remote add origin https://github.com/thewahish/invoices.git
echo git push -u origin main
echo.

echo For Kinda:
echo cd /d "%PROJECTS_DIR%\Kinda"
echo git init
echo git add .
echo git commit -m "Initial commit - Political campaign materials"
echo git remote add origin https://github.com/thewahish/Kinda.git
echo git push -u origin main
echo.

echo For leen:
echo cd /d "%PROJECTS_DIR%\leen"
echo git init
echo git add .
echo git commit -m "Initial commit - Bilingual artist portfolio"
echo git remote add origin https://github.com/thewahish/leen.git
echo git push -u origin main
echo.

echo =============================================
echo  Repository creation guide complete
echo =============================================