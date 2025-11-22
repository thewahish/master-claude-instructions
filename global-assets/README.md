# Global Assets - Project Discovery System

This directory contains shared utilities that all projects can use to discover and interact with each other.

## 🎯 Purpose

The Project Discovery System allows any project in `/Volumes/Ai/Projects/` to:
- Find other projects automatically
- Execute commands in other projects
- Share code and resources
- Maintain independence while being interconnected

---

## 📁 Available Tools

### 1. `project-discovery.sh` (Bash)

Shell script for Bash-based automation and scripts.

**Source in your script:**
```bash
source /Volumes/Ai/.Master/global-assets/project-discovery.sh
```

**Available Functions:**

```bash
# Get path to a project
path=$(get_project_path "p-o-h")
echo $path  # /Volumes/Ai/Projects/p-o-h

# List all projects
list_all_projects

# Get project metadata (requires jq)
get_project_info "website"

# Execute command in another project
exec_in_project "p-o-h" ls -la

# Run npm script in another project
npm_in_project "p-o-h" "dev"
```

**Example Usage:**

```bash
#!/bin/bash
source /Volumes/Ai/.Master/global-assets/project-discovery.sh

# Build all projects
for project in $(list_all_projects); do
    echo "Building $project..."
    exec_in_project "$project" npm run build
done
```

---

### 2. `project-discovery.js` (Node.js)

JavaScript module for Node.js projects.

**Require in your code:**
```javascript
const projects = require('/Volumes/Ai/.Master/global-assets/project-discovery.js');
```

**Available Methods:**

```javascript
// Get project path
const path = projects.getProjectPath('p-o-h');
// Returns: '/Volumes/Ai/Projects/p-o-h'

// List all projects
const allProjects = projects.listAllProjects();
// Returns: ['ai-courses', 'p-o-h', 'website', ...]

// Get project info
const info = projects.getProjectInfo('website');
// Returns: { path: '...', remote: '...', type: 'html', ... }

// Execute command in another project
const output = projects.execInProject('p-o-h', 'ls -la');

// Run npm script
projects.runNpmScript('p-o-h', 'build');

// Get package.json from another project
const pkg = projects.getPackageJson('p-o-h');
console.log(pkg.version);

// Require module from another project
const util = projects.requireFromProject('p-o-h', 'src/utils/helper.js');
```

**Example Usage:**

```javascript
const projects = require('/Volumes/Ai/.Master/global-assets/project-discovery.js');

// Build all Node.js projects
const allProjects = projects.listAllProjects();

allProjects.forEach(projectName => {
    const pkg = projects.getPackageJson(projectName);

    if (pkg && pkg.scripts && pkg.scripts.build) {
        console.log(`Building ${projectName}...`);
        try {
            projects.runNpmScript(projectName, 'build');
            console.log(`✓ ${projectName} built successfully`);
        } catch (error) {
            console.error(`✗ ${projectName} build failed`);
        }
    }
});
```

---

## 🗂️ Project Registry

The system maintains a central registry at `/Volumes/Ai/.Master/project-registry.json`

**Registry Structure:**
```json
{
  "projects": {
    "p-o-h": {
      "path": "/Volumes/Ai/Projects/p-o-h",
      "remote": "https://github.com/thewahish/p-o-h.git",
      "type": "node",
      "branch": "main",
      "hasUncommittedChanges": false
    },
    "website": {
      "path": "/Volumes/Ai/Projects/website",
      "remote": "https://github.com/thewahish/website.git",
      "type": "html",
      "branch": "main",
      "hasUncommittedChanges": false
    }
  },
  "lastUpdated": "2025-01-20T20:30:00Z",
  "totalProjects": 12,
  "projectsPath": "/Volumes/Ai/Projects",
  "masterPath": "/Volumes/Ai/.Master"
}
```

**Update Registry:**
```bash
/Volumes/Ai/.Master/scripts/sync-all-projects.sh
```

---

## 🔄 Project Types

The system auto-detects project types based on files present:

| Type | Detection |
|------|-----------|
| `node` | Has `package.json` |
| `python` | Has `requirements.txt` |
| `ruby` | Has `Gemfile` |
| `java` | Has `pom.xml` |
| `go` | Has `go.mod` |
| `rust` | Has `Cargo.toml` |
| `html` | Has `index.html` |
| `other` | None of the above |

---

## 💡 Use Cases

### Cross-Project Building

Build multiple related projects in sequence:

```bash
# Build shared library first, then dependent projects
npm_in_project "shared-lib" "build"
npm_in_project "web-app" "build"
npm_in_project "admin-panel" "build"
```

### Shared Utilities

Import utilities from another project:

```javascript
// In project A, use code from project B
const helpers = projects.requireFromProject('shared-utils', 'src/helpers.js');
helpers.formatDate(new Date());
```

### Automated Testing

Test all projects:

```bash
for project in $(list_all_projects); do
    echo "Testing $project..."
    exec_in_project "$project" npm test
done
```

### Deployment Coordination

Deploy multiple projects together:

```bash
projects=("backend-api" "frontend-app" "admin-dashboard")

for proj in "${projects[@]}"; do
    npm_in_project "$proj" "build"
    exec_in_project "$proj" git push heroku main
done
```

---

## 🛠️ Management Scripts

### Scan & Update Registry

```bash
/Volumes/Ai/.Master/scripts/sync-all-projects.sh
```
- Scans all folders in `Projects/`
- Detects git repositories
- Asks for GitHub URLs if missing
- Updates registry with current state

### Push All Projects

```bash
/Volumes/Ai/.Master/scripts/push-all-projects.sh
```
- Commits uncommitted changes (with confirmation)
- Pushes all projects to GitHub
- Uses registry for tracking

---

## ✨ Benefits

1. **Interconnected**: Projects can call each other easily
2. **Self-Sufficient**: Each project remains independent
3. **Auto-Discovery**: No manual configuration needed
4. **Type-Safe**: Knows what type each project is
5. **Version Controlled**: Registry tracks all projects
6. **Cross-Platform**: Works on Mac and Termux (with path adjustment)

---

## 🔧 Advanced Examples

### Monorepo-style Workflow

```javascript
// scripts/build-all.js
const projects = require('/Volumes/Ai/.Master/global-assets/project-discovery.js');

const buildOrder = ['shared-lib', 'api', 'web-app'];

buildOrder.forEach(name => {
    console.log(`Building ${name}...`);
    projects.runNpmScript(name, 'build');
});
```

### Cross-Project Testing

```bash
#!/bin/bash
source /Volumes/Ai/.Master/global-assets/project-discovery.sh

# Test API first
npm_in_project "backend-api" "test"

# Then test frontend with API running
(
    npm_in_project "backend-api" "start" &
    API_PID=$!
    sleep 5
    npm_in_project "frontend-app" "test:e2e"
    kill $API_PID
)
```

---

## 📝 Notes

- Registry is automatically created on first run
- Projects without git will be prompted for setup
- Safe to run scripts multiple times
- Registry updates don't require manual editing
- Works with any folder structure in `Projects/`

---

**Happy Coding! 🚀**
