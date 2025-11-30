# Claude Code Instructions for /Volumes/Ai Drive

## Core Rules (ALWAYS FOLLOW)

### 1. Chat Transcript Generation (CORE MEMORY - ALWAYS DO THIS)
**MANDATORY:** At the end of EVERY Claude Code session, generate a timestamped chat log transcript.

- **Location:** `/Volumes/Ai/chat-transcripts/`
- **Naming:** `YYYY-MM-DD_HH-MM_topic-description.txt` (include time for multiple sessions per day)
- **Example:** `2025-11-30_10-30_syria-pa-system-github-sync.txt`

**Required Content:**
```
============================================================
CLAUDE CODE SESSION LOG
============================================================
Date: [Full date]
Time: [HH:MM AM/PM]
Duration: [Approximate session length]
Project(s): [Project path(s)]
============================================================

SESSION SUMMARY
---------------
[2-3 sentence overview]

ACCOMPLISHMENTS
---------------
1. [Task completed with details]
2. [Another task]
...

TECHNICAL DETAILS
-----------------
Git commits:
  [hash] - [message]

Files created/modified:
  [path] - [what changed]

Commands run:
  [significant commands]

USER REQUESTS ADDRESSED
-----------------------
1. "[Quote user request]" - [How it was addressed]

PROJECT STATUS
--------------
[Current state, progress %, what's next]

NEXT STEPS
----------
1. [Pending task]
2. [Follow-up needed]

IMPORTANT NOTES
---------------
[Any critical info for future sessions]

============================================================
END OF SESSION LOG
============================================================
```

**When to Generate:**
- At the END of every session (no exceptions)
- Before context runs out
- When switching to a different major task
- When user says "done", "that's all", "thanks", etc.

**Why:** This is CORE MEMORY for continuity. Allows review of all work done, maintains history, enables picking up exactly where left off, and provides accountability for all changes made.

---

### 2. Project Structure Awareness

**Remember this structure:**

```
/Volumes/Ai/
├── .Master/              # Master scripts and templates
│   ├── scripts/          # Automation scripts
│   └── templates/        # Project templates
├── Projects/             # All active projects (23 repos)
│   ├── adhd-quest-coach/ # ADHD Quest Coach app
│   ├── ai-courses/       # AI learning materials
│   ├── AutoAgent/        # Multi-agent system
│   ├── Karazah/          # Syrian cuisine platform
│   ├── mawlid-songs/     # Mawlid songs project
│   ├── p-o-h/            # Pillars of Health
│   ├── ... (16 more)
│   └── website2.0/       # Personal website v2
├── Documentation/        # Central docs
├── chat-transcripts/     # Session transcripts (NEW)
└── *.md files           # Various docs at root
```

**Key Points:**
- All projects have GitHub remotes under `github.com/thewahish/`
- Use `./sync-github.sh` in any project to sync
- Most projects are on `main` branch

---

### 3. Knowledgebase & Documentation

**Always check these locations:**
- `/Volumes/Ai/Documentation/` - Central documentation
- `/Volumes/Ai/ALL-PROJECTS-OVERVIEW.md` - Project summaries
- `/Volumes/Ai/COMPLETE-MERGED-QUEST-LIST.md` - Quest Coach quests
- `/Volumes/Ai/.Master/` - Master scripts and templates
- Individual project READMEs

**When starting a session:**
1. Understand which project(s) are involved
2. Check for existing documentation
3. Reference previous chat transcripts if available

---

### 4. Multi-Agent/Project Architecture

**AutoAgent Structure:**
- Multi-agent system for automated tasks
- Located in `/Volumes/Ai/Projects/AutoAgent/`
- Uses specialized agents for different tasks

**Quest Coach Structure:**
- Browser-based ADHD task management
- Located in `/Volumes/Ai/Projects/adhd-quest-coach/`
- Quest definitions in `all-projects-quests.js`
- Syncs to GitHub via API

---

### 5. Instruction Documentation (IMPORTANT)

**ALWAYS create dual-format instructions:**

When creating any instruction documentation (setup guides, how-tos, tutorials):

1. **Create both formats:**
   - Markdown (.md) for GitHub/developers
   - HTML (.html) for nice formatted viewing

2. **Store in Instructions folder:**
   - Location: `/Volumes/Ai/Instructions/`
   - Subfolder: `YYYY-MM-DD_topic-name/`
   - Example: `/Volumes/Ai/Instructions/2025-11-17_supabase-cloud-sync/`

3. **Naming convention:**
   - `README.md` - Main markdown version
   - `index.html` - Formatted HTML version with CSS styling
   - `assets/` - Any images or resources

4. **HTML should include:**
   - Responsive CSS styling
   - Syntax highlighting for code blocks
   - Table of contents for long docs
   - Print-friendly layout

**Why:** Provides professional, accessible documentation that works for all audiences and can be viewed without markdown rendering.

---

### 6. Quest-Project Sync System (IMPORTANT)

**ALWAYS check and update project quest statuses:**

Each project should have a `quest-status.json` file tracking:
```json
{
  "projectName": "...",
  "status": "active|completed|paused",
  "priority": "urgent|high|medium|low",
  "progressPercent": 0-100,
  "currentFocus": "What you're working on",
  "completedTasks": [],
  "upcomingTasks": [],
  "blockers": [],
  "notes": ""
}
```

**Key Files:**
- `/Volumes/Ai/.Master/scripts/quest-project-sync.sh` - Syncs all project statuses
- `/Volumes/Ai/.Master/all-project-statuses.json` - Master status file
- `/Volumes/Ai/.Master/templates/quest-status-template.json` - Template for new projects
- Each project: `quest-status.json` in root

**When to update:**
1. After completing tasks in a project
2. When project priority changes
3. When blockers are identified
4. At end of session working on a project

**Sync Command:**
```bash
/Volumes/Ai/.Master/scripts/quest-project-sync.sh
```

This keeps Quest Coach app synchronized with actual project progress across all 23 repos.

---

### 7. Progress Dashboard & Tracking System (CRITICAL)

**ALWAYS maintain and update the visual progress dashboard:**

Every project's progress must be visible through an interactive HTML dashboard that auto-updates and can be launched anytime.

**Dashboard Location:**
- `/Volumes/Ai/.Master/dashboard/index.html` - Main progress dashboard
- `/Volumes/Ai/.Master/dashboard/assets/` - Styles and resources

**Auto-Update System:**
- `/Volumes/Ai/.Master/scripts/update-dashboard.sh` - Syncs quest-status.json files to dashboard
- Runs automatically when opening the system
- Can be called manually anytime: `/Volumes/Ai/.Master/scripts/update-dashboard.sh`

**Dashboard Features:**
1. **Real-time Project Status**: Shows all projects with current status, priority, and progress %
2. **Visual Progress Bars**: Color-coded by priority (Urgent=red, High=orange, Medium=blue, Low=gray)
3. **Current Focus**: What each project is actively working on
4. **Task Lists**: Completed tasks, upcoming tasks, and blockers
5. **Quick Actions**: Links to project folders, GitHub repos, and sync commands
6. **Self-Contained**: Standalone HTML file, works offline, no dependencies
7. **Auto-Refresh**: Updates every time dashboard script runs

**When to Update Dashboard:**
1. **ALWAYS** at the start of every session (automatic)
2. After completing tasks in any project
3. When project status/priority changes
4. Before viewing progress (`open /Volumes/Ai/.Master/dashboard/index.html`)
5. At end of session (automatic)

**Launch Dashboard:**
```bash
# Update and open dashboard
/Volumes/Ai/.Master/scripts/update-dashboard.sh && open /Volumes/Ai/.Master/dashboard/index.html
```

**Auto-Launch on System Start:**
The dashboard automatically updates and can optionally open when:
- Opening terminal in `/Volumes/Ai/`
- Running any master script
- User requests: "show progress" or "show dashboard"

**Dashboard Data Flow:**
```
Each Project's quest-status.json
           ↓
update-dashboard.sh (aggregates)
           ↓
.Master/all-project-statuses.json
           ↓
dashboard/index.html (renders)
           ↓
Visual GUI in browser
```

**User Commands for Progress:**
- "show progress" → Update and open dashboard
- "update dashboard" → Refresh dashboard data
- "project status" → Show current project statuses in terminal

**Why:** Provides instant visual feedback on all projects, ensures nothing is forgotten, and gives comprehensive overview of entire /Volumes/Ai ecosystem at a glance.

---

## Session Best Practices

### At Session Start:
1. **UPDATE AND VIEW DASHBOARD** (`/Volumes/Ai/.Master/scripts/update-dashboard.sh`)
2. Identify which project(s) are relevant
3. Check for recent changes: `git status` in project
4. Review existing documentation and chat transcripts
5. Understand current context from dashboard

### During Session:
1. Use TodoWrite to track tasks
2. Log comprehensive console output for debugging
3. Commit frequently with descriptive messages
4. Update project quest-status.json when progress is made
5. Sync to GitHub after significant changes

### At Session End:
1. **UPDATE PROJECT quest-status.json** files for all modified projects
2. **UPDATE DASHBOARD** (`/Volumes/Ai/.Master/scripts/update-dashboard.sh`)
3. **GENERATE CHAT TRANSCRIPT** (see Rule #1)
4. **RUN QUEST SYNC** if project statuses changed
5. Commit all changes in all modified projects
6. Sync all modified projects to GitHub
7. Note any pending tasks for next session

---

## GitHub Sync Commands

**Quick sync for any project:**
```bash
cd /Volumes/Ai/Projects/<project-name>
./sync-github.sh
```

**Manual sync:**
```bash
git add -A
git commit -m "Description of changes"
git pull --rebase origin main
git push origin main
```

**Bulk sync all projects:**
```bash
for dir in /Volumes/Ai/Projects/*/; do
    if [ -d "$dir/.git" ]; then
        echo "Syncing $(basename $dir)..."
        cd "$dir" && git pull --rebase origin main && git push origin main
        cd -
    fi
done
```

---

## Important Files Reference

| File | Purpose |
|------|---------|
| `/Volumes/Ai/CLAUDE.md` | This file - Claude Code instructions |
| `/Volumes/Ai/.Master/dashboard/index.html` | **Visual progress dashboard (main GUI)** |
| `/Volumes/Ai/.Master/scripts/update-dashboard.sh` | **Update dashboard from all quest-status.json** |
| `/Volumes/Ai/.Master/all-project-statuses.json` | Master aggregated status file |
| `/Volumes/Ai/chat-transcripts/*.txt` | Session transcripts |
| `/Volumes/Ai/ALL-PROJECTS-OVERVIEW.md` | Project summaries |
| `/Volumes/Ai/.Master/scripts/` | Automation scripts |
| `/Volumes/Ai/Projects/*/quest-status.json` | Individual project status tracking |
| `/Volumes/Ai/Projects/*/package.json` | Project dependencies |
| `/Volumes/Ai/Projects/*/.git/` | Git repositories |

---

## User Preferences

- **Console logging:** Comprehensive logging for debugging
- **Priority system:** Urgent > High > Medium > Low
- **Emoji usage:** Only when user requests
- **Notifications:** Clear, concise alerts
- **GitHub:** Keep all projects synced both ways
- **Documentation:** Generate transcripts, not unnecessary README files

---

*Last updated: 2025-11-30*
