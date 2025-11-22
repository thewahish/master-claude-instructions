// Windows-adapted project discovery system
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class WindowsProjectDiscovery {
    constructor() {
        this.basePath = 'D:';
        this.projectsPath = 'D:/Projects';
        this.masterPath = 'D:/.Master';
        this.registryPath = path.join(this.masterPath, 'project-registry.json');
    }

    // Get project path (Windows compatible)
    getProjectPath(projectName) {
        const registry = this.loadRegistry();
        const project = registry.projects[projectName];
        return project ? project.path : null;
    }

    // List all projects
    listAllProjects() {
        const registry = this.loadRegistry();
        return Object.keys(registry.projects);
    }

    // Get project by domain
    getProjectsByDomain(domain) {
        const registry = this.loadRegistry();
        return Object.entries(registry.projects)
            .filter(([name, project]) => project.domain === domain)
            .map(([name, project]) => ({ name, ...project }));
    }

    // Execute command in another project (Windows)
    execInProject(projectName, command) {
        const projectPath = this.getProjectPath(projectName);
        if (!projectPath) {
            throw new Error(`Project ${projectName} not found`);
        }

        try {
            const result = execSync(command, { 
                cwd: projectPath, 
                encoding: 'utf8',
                shell: 'cmd.exe'
            });
            return result;
        } catch (error) {
            throw new Error(`Command failed in ${projectName}: ${error.message}`);
        }
    }

    // Run npm script in another project
    runNpmScript(projectName, script) {
        return this.execInProject(projectName, `npm run ${script}`);
    }

    // Get package.json from another project
    getPackageJson(projectName) {
        const projectPath = this.getProjectPath(projectName);
        if (!projectPath) return null;

        const packagePath = path.join(projectPath, 'package.json');
        if (!fs.existsSync(packagePath)) return null;

        try {
            return JSON.parse(fs.readFileSync(packagePath, 'utf8'));
        } catch (error) {
            return null;
        }
    }

    // Require module from another project
    requireFromProject(projectName, modulePath) {
        const projectPath = this.getProjectPath(projectName);
        if (!projectPath) {
            throw new Error(`Project ${projectName} not found`);
        }

        const fullPath = path.join(projectPath, modulePath);
        if (!fs.existsSync(fullPath)) {
            throw new Error(`Module ${modulePath} not found in ${projectName}`);
        }

        return require(fullPath);
    }

    // Load registry
    loadRegistry() {
        if (!fs.existsSync(this.registryPath)) {
            return { projects: {} };
        }

        try {
            return JSON.parse(fs.readFileSync(this.registryPath, 'utf8'));
        } catch (error) {
            console.error('Error loading registry:', error.message);
            return { projects: {} };
        }
    }

    // Update registry
    updateRegistry() {
        console.log('Scanning projects directory...');
        const projects = this.scanProjectsDirectory();
        const registry = {
            projects,
            lastUpdated: new Date().toISOString(),
            totalProjects: Object.keys(projects).length,
            projectsPath: this.projectsPath,
            masterPath: this.masterPath,
            platform: 'windows'
        };

        try {
            fs.writeFileSync(this.registryPath, JSON.stringify(registry, null, 2));
            console.log(`Registry updated with ${Object.keys(projects).length} projects`);
            return registry;
        } catch (error) {
            console.error('Error updating registry:', error.message);
            throw error;
        }
    }

    // Scan projects directory
    scanProjectsDirectory() {
        const projects = {};
        
        if (!fs.existsSync(this.projectsPath)) {
            console.warn('Projects directory not found:', this.projectsPath);
            return projects;
        }

        const entries = fs.readdirSync(this.projectsPath, { withFileTypes: true });
        
        for (const entry of entries) {
            if (entry.isDirectory() && !entry.name.startsWith('.')) {
                const projectPath = path.join(this.projectsPath, entry.name);
                const projectInfo = this.analyzeProject(projectPath, entry.name);
                
                if (projectInfo) {
                    projects[entry.name] = projectInfo;
                }
            }
        }

        return projects;
    }

    // Analyze individual project
    analyzeProject(projectPath, projectName) {
        const info = {
            path: projectPath.replace(/\\/g, '/'), // Normalize path separators
            type: 'other',
            domain: 'unknown',
            branch: null,
            hasUncommittedChanges: false,
            remote: null
        };

        // Check for package.json (Node.js project)
        if (fs.existsSync(path.join(projectPath, 'package.json'))) {
            info.type = 'node';
        }

        // Check for Python files
        const pyFiles = this.findFiles(projectPath, '.py');
        if (pyFiles.length > 0) {
            info.type = 'python';
        }

        // Check for web files
        const htmlFiles = this.findFiles(projectPath, '.html');
        if (htmlFiles.length > 0 && info.type === 'other') {
            info.type = 'web';
        }

        // Determine domain from project analysis
        info.domain = this.determineDomain(projectPath, projectName);

        // Check git status if .git exists
        if (fs.existsSync(path.join(projectPath, '.git'))) {
            try {
                // Get current branch
                const branch = execSync('git rev-parse --abbrev-ref HEAD', { 
                    cwd: projectPath, 
                    encoding: 'utf8' 
                }).trim();
                info.branch = branch;

                // Get remote URL
                try {
                    const remote = execSync('git remote get-url origin', { 
                        cwd: projectPath, 
                        encoding: 'utf8' 
                    }).trim();
                    info.remote = remote;
                } catch (e) {
                    // No remote configured
                }

                // Check for uncommitted changes
                const status = execSync('git status --porcelain', { 
                    cwd: projectPath, 
                    encoding: 'utf8' 
                });
                info.hasUncommittedChanges = status.trim().length > 0;

            } catch (error) {
                // Git command failed, but .git exists
                console.warn(`Git analysis failed for ${projectName}:`, error.message);
            }
        }

        return info;
    }

    // Determine project domain
    determineDomain(projectPath, projectName) {
        const name = projectName.toLowerCase();
        
        // Game development indicators
        if (name.includes('game') || name.includes('p-o-h') || name.includes('tarboush') || name.includes('halwiyat')) {
            return 'game-development';
        }

        // Application systems indicators
        if (name.includes('application') || name.includes('finance') || name.includes('ai-course')) {
            return 'application-systems';
        }

        // Content creation indicators  
        if (name.includes('resume') || name.includes('kinda') || name.includes('msu') || name.includes('invoice')) {
            return 'content-creation';
        }

        // Web development (default for web projects)
        if (fs.existsSync(path.join(projectPath, 'index.html')) || 
            fs.existsSync(path.join(projectPath, 'package.json'))) {
            return 'web-development';
        }

        return 'unknown';
    }

    // Find files with specific extension
    findFiles(dir, extension, found = []) {
        try {
            const entries = fs.readdirSync(dir, { withFileTypes: true });
            
            for (const entry of entries) {
                const fullPath = path.join(dir, entry.name);
                
                if (entry.isDirectory() && !entry.name.startsWith('.') && entry.name !== 'node_modules') {
                    this.findFiles(fullPath, extension, found);
                } else if (entry.isFile() && entry.name.endsWith(extension)) {
                    found.push(fullPath);
                }
            }
        } catch (error) {
            // Directory not accessible
        }

        return found;
    }
}

// CLI usage
if (require.main === module) {
    const discovery = new WindowsProjectDiscovery();
    
    const args = process.argv.slice(2);
    
    if (args.includes('--update-registry')) {
        discovery.updateRegistry();
    } else if (args.includes('--list')) {
        console.log('All projects:', discovery.listAllProjects());
    } else {
        console.log('Windows Project Discovery System');
        console.log('Usage: node project-discovery-windows.js [--update-registry] [--list]');
    }
}

module.exports = WindowsProjectDiscovery;