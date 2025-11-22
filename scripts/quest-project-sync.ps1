# Quest Coach - Master Project Sync Script (Windows PowerShell Version)
# Scans all projects for quest-status.json files and syncs with Quest Coach

Write-Host "Quest Coach - Project Status Sync" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""

$PROJECTS_DIR = "D:\Projects"
$OUTPUT_FILE = "D:\.Master\all-project-statuses.json"
$FOUND_COUNT = 0
$TOTAL_PROJECTS = 0

# Initialize master status object
$MASTER_STATUS = @{
    "lastUpdated" = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    "totalProjects" = 0
    "projectsWithStatus" = 0
    "projects" = @()
}

Write-Host "Scanning projects directory: $PROJECTS_DIR" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $PROJECTS_DIR)) {
    Write-Host "Projects directory not found: $PROJECTS_DIR" -ForegroundColor Red
    exit 1
}

# Get all project directories
$projectDirs = Get-ChildItem -Path $PROJECTS_DIR -Directory

foreach ($project in $projectDirs) {
    $TOTAL_PROJECTS++
    $projectName = $project.Name
    $questStatusPath = Join-Path $project.FullName "quest-status.json"
    
    if (Test-Path $questStatusPath) {
        $FOUND_COUNT++
        Write-Host "Found: $projectName - quest-status.json" -ForegroundColor Green
        
        try {
            # Read and parse the JSON
            $questData = Get-Content $questStatusPath -Raw | ConvertFrom-Json
            
            # Add to master status
            $MASTER_STATUS.projects += $questData
            
            # Show key info
            $status = $questData.status
            $priority = $questData.priority
            $progress = $questData.progressPercent
            Write-Host "    Status: $status | Priority: $priority | Progress: $progress%" -ForegroundColor Gray
        }
        catch {
            Write-Host "    Error reading JSON: $_" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Missing: $projectName - No quest-status.json" -ForegroundColor Gray
    }
}

# Update master status counts
$MASTER_STATUS.totalProjects = $TOTAL_PROJECTS
$MASTER_STATUS.projectsWithStatus = $FOUND_COUNT

# Write master status file
try {
    $MASTER_STATUS | ConvertTo-Json -Depth 10 | Set-Content $OUTPUT_FILE -Encoding UTF8
    Write-Host ""
    Write-Host "Master status file created: $OUTPUT_FILE" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "Error writing master status file: $_" -ForegroundColor Red
}

# Summary
Write-Host ""
Write-Host "Status Summary:" -ForegroundColor Blue
Write-Host "   Total projects: $TOTAL_PROJECTS" -ForegroundColor White
Write-Host "   Projects with quest-status: $FOUND_COUNT" -ForegroundColor White
Write-Host "   Projects without quest-status: $($TOTAL_PROJECTS - $FOUND_COUNT)" -ForegroundColor White

if ($FOUND_COUNT -gt 0) {
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Open Quest Coach app and refresh" -ForegroundColor White
    Write-Host "   2. Check $OUTPUT_FILE for complete status" -ForegroundColor White
    Write-Host "   3. Add quest-status.json to projects without it" -ForegroundColor White
}

Write-Host ""
Write-Host "Quest sync completed!" -ForegroundColor Green