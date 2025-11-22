/**
 * Project Discovery Helper for Node.js
 *
 * Use this in any Node.js project to discover and interact with other projects
 *
 * Usage:
 *   const projects = require('/Volumes/Ai/.Master/global-assets/project-discovery.js');
 *
 *   // Get project path
 *   const path = projects.getProjectPath('p-o-h');
 *
 *   // List all projects
 *   const allProjects = projects.listAllProjects();
 *
 *   // Get project info
 *   const info = projects.getProjectInfo('website');
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const MASTER_DIR = '/Volumes/Ai/.Master';
const PROJECTS_DIR = '/Volumes/Ai/Projects';
const REGISTRY_FILE = path.join(MASTER_DIR, 'project-registry.json');

/**
 * Load the project registry
 */
function loadRegistry() {
    try {
        if (fs.existsSync(REGISTRY_FILE)) {
            const data = fs.readFileSync(REGISTRY_FILE, 'utf8');
            return JSON.parse(data);
        }
    } catch (error) {
        console.warn('Warning: Could not load project registry:', error.message);
    }
    return { projects: {}, totalProjects: 0 };
}

/**
 * Get the path to a project by name
 * @param {string} projectName - The name of the project
 * @returns {string|null} - The absolute path to the project, or null if not found
 */
function getProjectPath(projectName) {
    const projectPath = path.join(PROJECTS_DIR, projectName);
    return fs.existsSync(projectPath) ? projectPath : null;
}

/**
 * List all available projects
 * @returns {string[]} - Array of project names
 */
function listAllProjects() {
    const registry = loadRegistry();
    if (Object.keys(registry.projects).length > 0) {
        return Object.keys(registry.projects);
    }
    // Fallback: scan directory
    try {
        return fs.readdirSync(PROJECTS_DIR).filter(name => {
            return fs.statSync(path.join(PROJECTS_DIR, name)).isDirectory();
        });
    } catch (error) {
        console.error('Error listing projects:', error.message);
        return [];
    }
}

/**
 * Get detailed information about a project
 * @param {string} projectName - The name of the project
 * @returns {object|null} - Project metadata or null if not found
 */
function getProjectInfo(projectName) {
    const registry = loadRegistry();
    return registry.projects[projectName] || null;
}

/**
 * Execute a command in another project's directory
 * @param {string} projectName - The name of the project
 * @param {string} command - The command to execute
 * @returns {Buffer} - Command output
 */
function execInProject(projectName, command) {
    const projectPath = getProjectPath(projectName);
    if (!projectPath) {
        throw new Error(`Project '${projectName}' not found`);
    }
    return execSync(command, { cwd: projectPath });
}

/**
 * Run an npm script in another project
 * @param {string} projectName - The name of the project
 * @param {string} scriptName - The npm script to run
 * @returns {Buffer} - Command output
 */
function runNpmScript(projectName, scriptName) {
    return execInProject(projectName, `npm run ${scriptName}`);
}

/**
 * Get package.json from another project
 * @param {string} projectName - The name of the project
 * @returns {object|null} - Parsed package.json or null
 */
function getPackageJson(projectName) {
    const projectPath = getProjectPath(projectName);
    if (!projectPath) return null;

    const packagePath = path.join(projectPath, 'package.json');
    if (!fs.existsSync(packagePath)) return null;

    try {
        const data = fs.readFileSync(packagePath, 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error(`Error reading package.json for ${projectName}:`, error.message);
        return null;
    }
}

/**
 * Require a module from another project
 * @param {string} projectName - The name of the project
 * @param {string} modulePath - The relative path to the module
 * @returns {any} - The required module
 */
function requireFromProject(projectName, modulePath) {
    const projectPath = getProjectPath(projectName);
    if (!projectPath) {
        throw new Error(`Project '${projectName}' not found`);
    }
    const fullPath = path.join(projectPath, modulePath);
    return require(fullPath);
}

// Export all functions
module.exports = {
    MASTER_DIR,
    PROJECTS_DIR,
    REGISTRY_FILE,
    loadRegistry,
    getProjectPath,
    listAllProjects,
    getProjectInfo,
    execInProject,
    runNpmScript,
    getPackageJson,
    requireFromProject
};
