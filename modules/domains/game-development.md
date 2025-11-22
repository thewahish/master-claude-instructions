# Game Development Domain Module

## 🎮 Applies To Projects
- **p-o-h**: React-based RPG with complex systems (turn-based combat, dungeon crawler)
- **Halwiyat**: Phaser.js Arabian sweets empire game (business simulation)
- **tarboush**: Syrian character platform game (side-scrolling action)

## 🎯 Domain-Specific Agent Enhancements

### Agent 2: Requirements Detective (Game Enhanced)
- **Player Experience**: Map user stories to gameplay mechanics
- **Game Balance**: Identify progression, difficulty, and reward systems
- **Engagement Metrics**: Define retention, session length, and satisfaction goals
- **Accessibility**: Consider motor, visual, and cognitive accessibility needs

### Agent 4: System Architect (Game Enhanced)
- **Game Loop Architecture**: Update, render, input handling cycles
- **State Management**: Game state, save systems, progression tracking
- **Asset Pipeline**: Loading, caching, and memory management for assets
- **Performance Architecture**: 60fps targets, optimization strategies

### Agent 7: Code Generator (Game Enhanced)
- **Game Patterns**: State machines, object pools, component systems
- **Performance Code**: Efficient collision detection, rendering optimization
- **Save Systems**: Robust serialization, multiple save slots, versioning
- **Input Handling**: Keyboard, mouse, touch, gamepad support

### Agent 8: Test Engineer (Game Enhanced)
- **Balance Testing**: Automated progression and difficulty validation
- **Performance Testing**: Frame rate monitoring, memory leak detection
- **Playtesting**: User experience validation, engagement metrics
- **Save System Testing**: Data integrity, version compatibility

### Agent 11: Performance Optimizer (Game Enhanced)
- **Frame Rate**: Consistent 60fps, avoid frame drops
- **Memory Management**: Efficient asset loading/unloading
- **Battery Optimization**: Mobile power consumption awareness
- **Loading Times**: Asset streaming, progressive loading

## 🎮 Game Architecture Patterns

### Core Game Loop
```javascript
class GameLoop {
    constructor() {
        this.lastTime = 0;
        this.accumulator = 0;
        this.fixedTimeStep = 16.67; // 60fps
    }
    
    update(currentTime) {
        const deltaTime = currentTime - this.lastTime;
        this.lastTime = currentTime;
        this.accumulator += deltaTime;
        
        // Fixed timestep updates for consistent physics
        while (this.accumulator >= this.fixedTimeStep) {
            this.fixedUpdate(this.fixedTimeStep);
            this.accumulator -= this.fixedTimeStep;
        }
        
        // Variable timestep for rendering
        this.render(deltaTime);
        requestAnimationFrame(this.update.bind(this));
    }
}
```

### State Management Pattern
```javascript
class GameState {
    constructor() {
        this.current = {
            scene: 'menu',
            player: null,
            world: null,
            ui: null
        };
        this.subscribers = [];
    }
    
    subscribe(callback) {
        this.subscribers.push(callback);
        return () => {
            this.subscribers = this.subscribers.filter(sub => sub !== callback);
        };
    }
    
    update(newState) {
        this.current = { ...this.current, ...newState };
        this.subscribers.forEach(callback => callback(this.current));
    }
}
```

### Save System Architecture
```javascript
class SaveSystem {
    constructor() {
        this.version = '1.0.0';
        this.maxSlots = 3;
    }
    
    save(characterId, slotNumber, gameData) {
        const saveData = {
            version: this.version,
            timestamp: Date.now(),
            characterId,
            data: this.serialize(gameData)
        };
        
        const key = `game_save_${characterId}_${slotNumber}`;
        localStorage.setItem(key, JSON.stringify(saveData));
    }
    
    load(characterId, slotNumber) {
        const key = `game_save_${characterId}_${slotNumber}`;
        const saveData = localStorage.getItem(key);
        
        if (!saveData) return null;
        
        const parsed = JSON.parse(saveData);
        if (this.isCompatible(parsed.version)) {
            return this.deserialize(parsed.data);
        }
        
        return this.migrate(parsed);
    }
}
```

## ⚖️ Game Balance Framework

### Progression Systems
```javascript
class ProgressionCurve {
    static experienceRequired(level) {
        // Balanced XP curve: prevents rapid early leveling
        return Math.floor(100 + (level * 120));
    }
    
    static statGrowth(level, baseStat, growthRate = 0.1) {
        // Diminishing returns on stat growth
        return Math.floor(baseStat * (1 + (growthRate * Math.log(level + 1))));
    }
    
    static difficultyScaling(floor, baseValue, scalingFactor = 0.15) {
        // Exponential difficulty with manageable curve
        return Math.floor(baseValue * Math.pow(1 + scalingFactor, floor - 1));
    }
}
```

### Balance Testing Automation
```javascript
class BalanceSimulator {
    static runCombatSimulation(player, enemy, iterations = 1000) {
        let playerWins = 0;
        let avgTurns = 0;
        
        for (let i = 0; i < iterations; i++) {
            const result = this.simulateCombat(player, enemy);
            if (result.winner === 'player') playerWins++;
            avgTurns += result.turns;
        }
        
        return {
            playerWinRate: playerWins / iterations,
            averageTurns: avgTurns / iterations,
            balanced: Math.abs(0.6 - (playerWins / iterations)) < 0.1 // Target 60% win rate
        };
    }
}
```

### Resource Economy
```javascript
class EconomyBalance {
    static validateRewardStructure(rewards, costs) {
        const inflationRate = this.calculateInflation(rewards, costs);
        const grindFactor = this.calculateGrindFactor(rewards, costs);
        
        return {
            inflationRate: inflationRate < 0.1, // Less than 10% inflation
            grindFactor: grindFactor > 0.5 && grindFactor < 2.0, // Reasonable grind
            balanced: inflationRate < 0.1 && grindFactor > 0.5 && grindFactor < 2.0
        };
    }
}
```

## 🎨 Asset Management

### Asset Loading Strategy
```javascript
class AssetManager {
    constructor() {
        this.cache = new Map();
        this.loading = new Map();
        this.preloadQueue = [];
    }
    
    async preloadCritical() {
        // Load essential assets first
        const criticalAssets = [
            'ui/interface.png',
            'audio/music_menu.ogg',
            'fonts/main.woff2'
        ];
        
        await Promise.all(criticalAssets.map(asset => this.load(asset)));
    }
    
    async load(path) {
        if (this.cache.has(path)) {
            return this.cache.get(path);
        }
        
        if (this.loading.has(path)) {
            return this.loading.get(path);
        }
        
        const promise = this.loadAsset(path);
        this.loading.set(path, promise);
        
        try {
            const asset = await promise;
            this.cache.set(path, asset);
            this.loading.delete(path);
            return asset;
        } catch (error) {
            this.loading.delete(path);
            throw error;
        }
    }
}
```

### Memory Management
```javascript
class MemoryManager {
    static cleanup() {
        // Remove unused assets from memory
        const currentScene = GameState.current.scene;
        const requiredAssets = this.getRequiredAssets(currentScene);
        
        AssetManager.cache.forEach((asset, path) => {
            if (!requiredAssets.includes(path)) {
                AssetManager.unload(path);
            }
        });
        
        // Force garbage collection in development
        if (process.env.NODE_ENV === 'development') {
            window.gc?.();
        }
    }
}
```

## 🎯 User Experience Patterns

### Input Handling
```javascript
class InputManager {
    constructor() {
        this.bindings = new Map();
        this.state = new Map();
        this.setupEventListeners();
    }
    
    bind(action, keys) {
        if (!Array.isArray(keys)) keys = [keys];
        this.bindings.set(action, keys);
    }
    
    isPressed(action) {
        const keys = this.bindings.get(action) || [];
        return keys.some(key => this.state.get(key));
    }
    
    // Mobile touch support
    setupTouchControls() {
        const touchArea = document.getElementById('touch-controls');
        
        touchArea.addEventListener('touchstart', (e) => {
            e.preventDefault();
            const touch = e.touches[0];
            const action = this.getTouchAction(touch.clientX, touch.clientY);
            if (action) this.triggerAction(action);
        });
    }
}
```

### Accessibility Implementation
```javascript
class AccessibilityManager {
    static setupScreenReaderSupport() {
        // Announce important game events
        const announcer = document.getElementById('sr-announcer');
        
        GameState.subscribe(state => {
            if (state.player?.levelUp) {
                announcer.textContent = `Level up! Now level ${state.player.level}`;
            }
            
            if (state.combat?.victory) {
                announcer.textContent = `Victory! Battle completed.`;
            }
        });
    }
    
    static setupColorBlindSupport() {
        // Provide shape/symbol alternatives to color
        const colorBlindMode = localStorage.getItem('colorBlindMode') === 'true';
        
        if (colorBlindMode) {
            document.body.classList.add('colorblind-friendly');
        }
    }
    
    static setupMotorAccessibility() {
        // Larger touch targets, hold-to-press options
        const touchTargets = document.querySelectorAll('.game-button');
        touchTargets.forEach(button => {
            button.style.minWidth = '44px';
            button.style.minHeight = '44px';
        });
    }
}
```

## 📊 Analytics & Metrics

### Player Engagement Tracking
```javascript
class AnalyticsManager {
    static trackPlayerProgression(event, data) {
        const sessionData = {
            event,
            timestamp: Date.now(),
            sessionId: this.getSessionId(),
            playerLevel: GameState.current.player?.level,
            playTime: this.getSessionPlayTime(),
            ...data
        };
        
        // Store locally for privacy
        this.storeEvent(sessionData);
    }
    
    static generateSessionReport() {
        const events = this.getStoredEvents();
        
        return {
            totalPlayTime: this.calculateTotalPlayTime(events),
            levelsGained: this.calculateProgression(events),
            deathCount: events.filter(e => e.event === 'player_death').length,
            engagementScore: this.calculateEngagement(events)
        };
    }
}
```

### Performance Monitoring
```javascript
class PerformanceMonitor {
    constructor() {
        this.frameCount = 0;
        this.fpsHistory = [];
        this.memoryHistory = [];
    }
    
    update() {
        this.frameCount++;
        
        if (this.frameCount % 60 === 0) { // Every second
            const fps = this.calculateFPS();
            const memory = this.getMemoryUsage();
            
            this.fpsHistory.push(fps);
            this.memoryHistory.push(memory);
            
            // Alert if performance drops
            if (fps < 45) {
                console.warn('Low FPS detected:', fps);
                this.optimizePerformance();
            }
        }
    }
    
    optimizePerformance() {
        // Reduce visual effects
        // Lower particle counts
        // Cleanup unused assets
        MemoryManager.cleanup();
    }
}
```

## 🔧 Development Tools

### Debug Console
```javascript
class DebugConsole {
    static setupHotkeys() {
        document.addEventListener('keydown', (e) => {
            if (process.env.NODE_ENV !== 'development') return;
            
            switch(e.key) {
                case '0': this.toggleGodMode(); break;
                case '1': this.restoreHealth(); break;
                case '2': this.restoreResources(); break;
                case '3': this.addGold(100); break;
                case '4': this.levelUp(); break;
                case '5': this.winBattle(); break;
            }
        });
    }
    
    static createDebugPanel() {
        const panel = document.createElement('div');
        panel.className = 'debug-panel';
        panel.innerHTML = `
            <h3>Debug Tools</h3>
            <div>FPS: <span id="fps-counter">60</span></div>
            <div>Memory: <span id="memory-counter">0MB</span></div>
            <button onclick="DebugConsole.exportSave()">Export Save</button>
            <button onclick="DebugConsole.runBalanceTest()">Test Balance</button>
        `;
        document.body.appendChild(panel);
    }
}
```

## 🧪 Testing Protocols

### Automated Balance Testing
```javascript
describe('Game Balance', () => {
    test('Player progression is balanced', () => {
        const player = new Player(1);
        const enemy = new Enemy(1);
        
        const result = BalanceSimulator.runCombatSimulation(player, enemy);
        
        expect(result.playerWinRate).toBeGreaterThan(0.5);
        expect(result.playerWinRate).toBeLessThan(0.8);
        expect(result.averageTurns).toBeGreaterThan(3);
    });
    
    test('Economy inflation is controlled', () => {
        const rewards = calculateFloorRewards(1, 10);
        const costs = calculateShopPrices(1, 10);
        
        const balance = EconomyBalance.validateRewardStructure(rewards, costs);
        expect(balance.balanced).toBe(true);
    });
});
```

### Performance Testing
```javascript
describe('Performance', () => {
    test('Frame rate maintains 60fps', (done) => {
        const monitor = new PerformanceMonitor();
        
        setTimeout(() => {
            const avgFps = monitor.getAverageFPS();
            expect(avgFps).toBeGreaterThan(55);
            done();
        }, 5000);
    });
    
    test('Memory usage is stable', () => {
        const initialMemory = performance.memory?.usedJSHeapSize || 0;
        
        // Simulate gameplay for 100 frames
        for (let i = 0; i < 100; i++) {
            GameLoop.update();
        }
        
        const finalMemory = performance.memory?.usedJSHeapSize || 0;
        const memoryGrowth = (finalMemory - initialMemory) / initialMemory;
        
        expect(memoryGrowth).toBeLessThan(0.1); // Less than 10% growth
    });
});
```

### Playtesting Protocol
```javascript
class PlaytestManager {
    static async runAutomatedPlaytest() {
        const scenarios = [
            'new_player_tutorial',
            'mid_game_progression',
            'late_game_challenge',
            'save_load_integrity'
        ];
        
        const results = [];
        
        for (const scenario of scenarios) {
            const result = await this.runScenario(scenario);
            results.push(result);
        }
        
        return this.generatePlaytestReport(results);
    }
}
```

## 📋 Quality Checklist

### Pre-Release Checklist
- [ ] Frame rate stable at 60fps on target devices
- [ ] Save/load system tested across multiple scenarios
- [ ] Game balance validated through simulation
- [ ] All input methods (keyboard, mouse, touch) functional
- [ ] Accessibility features implemented and tested
- [ ] Memory usage optimized and stable
- [ ] Audio levels balanced and functional
- [ ] UI responsive across different screen sizes

### Performance Targets
- **Frame Rate**: Consistent 60fps
- **Load Times**: < 3 seconds for scene transitions
- **Memory Usage**: < 100MB for web games
- **Battery Impact**: Minimal for mobile games
- **Save/Load**: < 1 second for save operations

### Player Experience Goals
- **Onboarding**: Tutorial completion rate > 80%
- **Retention**: Day 7 retention > 40%
- **Engagement**: Average session > 10 minutes
- **Satisfaction**: Positive feedback ratio > 70%

---

*This module provides game development best practices optimized for engaging, performant, and accessible gaming experiences across all game projects.*