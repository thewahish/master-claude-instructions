# Cross-Platform Syntax Guide
## macOS Terminal + Windows CMD/PowerShell Commands

---

## 🔧 System Commands

### **Navigation**
```bash
# macOS Terminal
cd /Volumes/Ai/.Master
cd /Volumes/Ai/Projects/project-name
pwd                              # Show current directory
ls -la                          # List files with details
ls -la /Volumes/Ai/Projects     # List all projects
```

```cmd
REM Windows CMD
cd /d "D:\.Master"
cd /d "D:\Projects\project-name"
cd                              REM Show current directory
dir                             REM List files
dir "D:\Projects"               REM List all projects
```

```powershell
# Windows PowerShell
cd "D:\.Master"
cd "D:\Projects\project-name"
pwd                             # Show current directory
ls                              # List files (alias for Get-ChildItem)
ls "D:\Projects"                # List all projects
```

### **Directory Operations**
```bash
# macOS Terminal
mkdir -p "/Volumes/Ai/.Master/new-folder"
cp -r "source-folder" "destination"
mv "old-name" "new-name"
rm -rf "folder-to-delete"
```

```cmd
REM Windows CMD
mkdir "D:\.Master\new-folder"
xcopy "source-folder" "destination" /E /I
move "old-name" "new-name"
rmdir /s /q "folder-to-delete"
```

```powershell
# Windows PowerShell
New-Item -ItemType Directory -Path "D:\.Master\new-folder" -Force
Copy-Item "source-folder" "destination" -Recurse
Move-Item "old-name" "new-name"
Remove-Item "folder-to-delete" -Recurse -Force
```

---

## 🎯 Master System Commands

### **Initialize Master System**
```bash
# macOS Terminal
/Volumes/Ai/.Master/scripts/init-project.sh
/Volumes/Ai/.Master/scripts/setup-existing.sh
/Volumes/Ai/.Master/scripts/sync-all-projects.sh
```

```cmd
REM Windows CMD
"D:\.Master\scripts\windows-sync-all.bat"
"D:\.Master\scripts\create-missing-repos.bat"
node "D:\.Master\global-assets\project-discovery-windows.js" --update-registry
```

```powershell
# Windows PowerShell
& "D:\.Master\scripts\windows-sync-all.bat"
& "D:\.Master\scripts\create-missing-repos.bat"
node "D:\.Master\global-assets\project-discovery-windows.js" --update-registry
```

### **Project Discovery**
```bash
# macOS Terminal
source /Volumes/Ai/.Master/global-assets/project-discovery.sh
list_all_projects
get_project_path "p-o-h"
exec_in_project "p-o-h" npm run build
```

```cmd
REM Windows CMD
node "D:\.Master\global-assets\project-discovery-windows.js" --list
cd /d "D:\Projects\p-o-h" && npm run build
```

```powershell
# Windows PowerShell
node "D:\.Master\global-assets\project-discovery-windows.js" --list
Set-Location "D:\Projects\p-o-h"; npm run build
```

---

## 📋 Git Operations

### **Repository Initialization**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/project-name
git init
git add .
git commit -m "Initial commit 🧮 Generated with Claude Code"
git remote add origin https://github.com/thewahish/repo-name.git
git push -u origin main
```

```cmd
REM Windows CMD
cd /d "D:\Projects\project-name"
git init
git add .
git commit -m "Initial commit 🧮 Generated with Claude Code"
git remote add origin https://github.com/thewahish/repo-name.git
git push -u origin main
```

```powershell
# Windows PowerShell
Set-Location "D:\Projects\project-name"
git init
git add .
git commit -m "Initial commit 🧮 Generated with Claude Code"
git remote add origin https://github.com/thewahish/repo-name.git
git push -u origin main
```

### **Safe Sync with Active Work Sessions**
```bash
# macOS Terminal - SAFE SYNC PROTOCOL
cd /Volumes/Ai/Projects/personal-finance
git status                      # Check for changes
git stash push -m "Work in progress - $(date)"
git pull origin main
git stash pop                   # Restore your changes
```

```cmd
REM Windows CMD - SAFE SYNC PROTOCOL
cd /d "D:\Projects\personal finance"
git status                      REM Check for changes
git stash push -m "Work in progress - %date% %time%"
git pull origin main
git stash pop                   REM Restore your changes
```

```powershell
# Windows PowerShell - SAFE SYNC PROTOCOL
Set-Location "D:\Projects\personal finance"
git status                      # Check for changes
git stash push -m "Work in progress - $(Get-Date)"
git pull origin main
git stash pop                   # Restore your changes
```

### **Bulk Operations on All Projects**
```bash
# macOS Terminal
for dir in /Volumes/Ai/Projects/*/; do
    if [ -d "$dir/.git" ]; then
        echo "Syncing: $(basename "$dir")"
        cd "$dir"
        git fetch origin
        git status --porcelain
    fi
done
```

```cmd
REM Windows CMD
for /d %%i in ("D:\Projects\*") do (
    if exist "%%i\.git" (
        echo Syncing: %%~ni
        cd /d "%%i"
        git fetch origin
        git status --porcelain
    )
)
```

```powershell
# Windows PowerShell
Get-ChildItem "D:\Projects" -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\.git") {
        Write-Host "Syncing: $($_.Name)"
        Set-Location $_.FullName
        git fetch origin
        git status --porcelain
    }
}
```

---

## 🎮 Project-Specific Commands

### **Node.js Projects**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/p-o-h
npm install
npm run dev
npm run build
npm run deploy
```

```cmd
REM Windows CMD
cd /d "D:\Projects\p-o-h"
npm install
npm run dev
npm run build
npm run deploy
```

```powershell
# Windows PowerShell
Set-Location "D:\Projects\p-o-h"
npm install
npm run dev
npm run build
npm run deploy
```

### **Python Projects**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/personal-finance
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

```cmd
REM Windows CMD
cd /d "D:\Projects\personal finance"
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

```powershell
# Windows PowerShell
Set-Location "D:\Projects\personal finance"
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python main.py
```

### **Web Projects (Static)**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/website2.0
python3 -m http.server 8000
# or
live-server --port=3000
```

```cmd
REM Windows CMD
cd /d "D:\Projects\website2.0"
python -m http.server 8000
REM or
live-server --port=3000
```

```powershell
# Windows PowerShell
Set-Location "D:\Projects\website2.0"
python -m http.server 8000
# or
live-server --port=3000
```

---

## 🛡️ Safe Sync Protocols

### **Before Starting Work Session**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/your-project
git fetch origin
git status
# If clean, pull latest
git pull origin main
# If dirty, stash first
git stash push -m "Pre-session backup $(date)"
git pull origin main
```

```cmd
REM Windows CMD
cd /d "D:\Projects\your-project"
git fetch origin
git status
REM If clean, pull latest
git pull origin main
REM If dirty, stash first
git stash push -m "Pre-session backup %date% %time%"
git pull origin main
```

### **During Work Session - Periodic Saves**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/your-project
git add .
git commit -m "Work in progress: [describe changes] 🧮 Generated with Claude Code"
# Optional: push to backup branch
git push origin main
```

```cmd
REM Windows CMD
cd /d "D:\Projects\your-project"
git add .
git commit -m "Work in progress: [describe changes] 🧮 Generated with Claude Code"
REM Optional: push to backup branch
git push origin main
```

### **End of Work Session**
```bash
# macOS Terminal
cd /Volumes/Ai/Projects/your-project
git add .
git commit -m "Session complete: [final changes] 🧮 Generated with Claude Code"
git push origin main
```

```cmd
REM Windows CMD
cd /d "D:\Projects\your-project"
git add .
git commit -m "Session complete: [final changes] 🧮 Generated with Claude Code"
git push origin main
```

---

## 🔍 System Verification Commands

### **Check All Projects Status**
```bash
# macOS Terminal
/Volumes/Ai/.Master/scripts/verify-setup.sh
```

```cmd
REM Windows CMD
node "D:\.Master\global-assets\project-discovery-windows.js" --update-registry
type "D:\.Master\project-registry.json"
```

### **Verify Git Remotes**
```bash
# macOS Terminal
for dir in /Volumes/Ai/Projects/*/; do
    if [ -d "$dir/.git" ]; then
        echo "=== $(basename "$dir") ==="
        cd "$dir"
        git remote -v
    fi
done
```

```cmd
REM Windows CMD
for /d %%i in ("D:\Projects\*") do (
    if exist "%%i\.git" (
        echo === %%~ni ===
        cd /d "%%i"
        git remote -v
    )
)
```

### **Check for Uncommitted Changes**
```bash
# macOS Terminal
for dir in /Volumes/Ai/Projects/*/; do
    if [ -d "$dir/.git" ]; then
        cd "$dir"
        if [[ -n $(git status --porcelain) ]]; then
            echo "CHANGES: $(basename "$dir")"
            git status --short
        fi
    fi
done
```

```cmd
REM Windows CMD
for /d %%i in ("D:\Projects\*") do (
    if exist "%%i\.git" (
        cd /d "%%i"
        git status --porcelain | findstr . && echo CHANGES: %%~ni
    )
)
```

---

## 📱 Mobile/Remote Access Commands

### **Quick Status Check**
```bash
# macOS Terminal (via SSH)
ssh user@mac-machine 'cd /Volumes/Ai && find Projects -name ".git" -type d | wc -l'
```

```cmd
REM Windows CMD (via RDP/PowerShell)
dir "D:\Projects" /AD /B | find /C /V ""
```

### **Remote Project List**
```bash
# macOS Terminal
ssh user@mac-machine 'ls /Volumes/Ai/Projects'
```

```cmd
REM Windows CMD
dir "D:\Projects" /B
```

---

## ⚡ Performance Optimization Commands

### **Cleanup Temporary Files**
```bash
# macOS Terminal
find /Volumes/Ai/Projects -name "node_modules" -type d -exec du -sh {} \;
find /Volumes/Ai/Projects -name ".DS_Store" -delete
```

```cmd
REM Windows CMD
forfiles /p "D:\Projects" /m node_modules /s /c "cmd /c echo @path"
del /s /q /a:h "D:\Projects\Thumbs.db"
```

### **Disk Space Analysis**
```bash
# macOS Terminal
du -sh /Volumes/Ai/Projects/*
df -h /Volumes/Ai
```

```cmd
REM Windows CMD
forfiles /p "D:\Projects" /m *.* /s /c "cmd /c echo @fsize @path"
dir "D:\" /-c
```

---

**📝 Note**: Always use the appropriate syntax for your current platform. The master system auto-detects platform and adjusts paths accordingly, but manual commands need platform-specific syntax.