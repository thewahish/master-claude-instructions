#!/bin/bash

# Audit Projects Against Reference Resources
# Analyzes each user project and suggests applicable resources from:
# - claude-cookbooks
# - claude-quickstarts
# - claude-skills

set -e

PROJECTS_DIR="/Volumes/Ai/Projects"
MASTER_DIR="/Volumes/Ai/.Master"
REGISTRY_FILE="$MASTER_DIR/project-registry.json"
SUGGESTIONS_DIR="$MASTER_DIR/project-suggestions"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}   Project Resource Audit${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Create suggestions directory
mkdir -p "$SUGGESTIONS_DIR"

# User projects (excluding reference projects)
USER_PROJECTS=(
    "ai-courses"
    "arabian-sweets-empire"
    "Entertainment-Hub"
    "job-applications"
    "Karazah"
    "MSU-Oct2025"
    "p-o-h"
    "resumes"
    "syrian-memory-game"
    "Tarboush"
    "website"
    "website2.0"
)

echo -e "${YELLOW}Auditing ${#USER_PROJECTS[@]} user projects...${NC}"
echo ""

for project in "${USER_PROJECTS[@]}"; do
    project_path="$PROJECTS_DIR/$project"

    if [ ! -d "$project_path" ]; then
        echo -e "${YELLOW}⚠ Skipping $project (not found)${NC}"
        continue
    fi

    echo -e "${BLUE}Analyzing: $project${NC}"

    # Detect project type
    has_package_json=false
    has_react=false
    has_next=false
    has_vite=false
    has_python=false
    has_html=false
    is_game=false

    if [ -f "$project_path/package.json" ]; then
        has_package_json=true
        if grep -q "react" "$project_path/package.json" 2>/dev/null; then
            has_react=true
        fi
        if grep -q "next" "$project_path/package.json" 2>/dev/null; then
            has_next=true
        fi
        if grep -q "vite" "$project_path/package.json" 2>/dev/null; then
            has_vite=true
        fi
        if grep -q "phaser" "$project_path/package.json" 2>/dev/null; then
            is_game=true
        fi
    fi

    if [ -f "$project_path/requirements.txt" ]; then
        has_python=true
    fi

    if [ -f "$project_path/index.html" ]; then
        has_html=true
    fi

    # Generate suggestions
    suggestion_file="$SUGGESTIONS_DIR/${project}-suggestions.md"

    cat > "$suggestion_file" << EOF
# Resource Suggestions for $project

**Generated**: $(date)
**Project Type**: $([ "$has_package_json" = true ] && echo "Node.js" || echo "Static")$([ "$has_react" = true ] && echo " + React" || echo "")$([ "$has_python" = true ] && echo " + Python" || echo "")

---

## 📚 Applicable Resources from Reference Projects

EOF

    # Add cookbook suggestions
    cat >> "$suggestion_file" << 'EOF'
### From `claude-cookbooks`

EOF

    if [ "$has_react" = true ] || [ "$has_next" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
#### Tool Use & Integration
- **Location**: `claude-cookbooks/tool_use/`
- **Useful For**: Adding AI-powered features to your app
- **Examples**:
  - `customer_service_agent.ipynb` - Build chatbot interfaces
  - `extracting_structured_json.ipynb` - Parse user input into structured data
  - `vision_with_tools.ipynb` - Process images/screenshots

EOF
    fi

    if [ "$has_package_json" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
#### Multimodal (Vision)
- **Location**: `claude-cookbooks/multimodal/`
- **Useful For**: Adding image processing capabilities
- **Examples**:
  - `getting_started_with_vision.ipynb` - Image analysis
  - `best_practices_for_vision.ipynb` - Optimize vision tasks

EOF
    fi

    # Add quickstarts suggestions
    cat >> "$suggestion_file" << 'EOF'
### From `claude-quickstarts`

EOF

    if [ "$has_react" = true ] || [ "$has_next" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
#### Customer Support Agent
- **Location**: `claude-quickstarts/customer-support-agent/`
- **Tech Stack**: Next.js + TypeScript + Tailwind
- **Useful For**: Adding AI chat support to your application
- **Features**:
  - Complete chat UI with left/right sidebars
  - Knowledge base integration
  - Streaming responses
  - shadcn/ui components

#### Financial Data Analyst
- **Location**: `claude-quickstarts/financial-data-analyst/`
- **Tech Stack**: Next.js + Recharts + Claude API
- **Useful For**: Data visualization and analysis features
- **Features**:
  - Chart rendering (line, bar, pie)
  - File upload and preview
  - Interactive data analysis

EOF
    fi

    # Add skills suggestions
    cat >> "$suggestion_file" << 'EOF'
### From `claude-skills`

#### Document Skills
- **Location**: `claude-skills/document-skills/`
- **Useful For**: Generating reports, exports, documentation
- **Available Formats**:
  - **XLSX** - Excel spreadsheets with formulas
  - **PPTX** - PowerPoint presentations
  - **PDF** - PDF documents and forms
  - **DOCX** - Word documents with formatting

EOF

    if [ "$is_game" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
#### Creative Skills
- **Location**: `claude-skills/algorithmic-art/`
- **Useful For**: Generative art and visual effects
- **Features**: p5.js integration, particle systems, flow fields

EOF
    fi

    if [ "$has_react" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
#### Development Skills
- **Location**: `claude-skills/artifacts-builder/`
- **Useful For**: Building complex React components
- **Tech Stack**: React + Tailwind + shadcn/ui
- **Features**: Component templates, bundling scripts

#### Testing Skills
- **Location**: `claude-skills/webapp-testing/`
- **Useful For**: Automated UI testing
- **Tech Stack**: Playwright
- **Features**: Element discovery, console logging, automation scripts

EOF
    fi

    # Add quick wins section
    cat >> "$suggestion_file" << 'EOF'
---

## 🚀 Quick Wins (Start Here)

### High Impact, Low Effort

EOF

    if [ "$has_react" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
1. **Add Document Export** (30 min)
   - Use `claude-skills/document-skills/xlsx/` or `pdf/`
   - Generate downloadable reports from your data
   - Example: Export game stats, user data, analytics

2. **Implement Chat Support** (2 hours)
   - Copy `claude-quickstarts/customer-support-agent/`
   - Adapt components to your UI
   - Connect to your API/data

3. **Add Data Visualization** (1 hour)
   - Reference `claude-quickstarts/financial-data-analyst/`
   - Use Recharts library
   - Create interactive charts

EOF
    elif [ "$has_html" = true ]; then
        cat >> "$suggestion_file" << 'EOF'
1. **Generate Marketing Assets** (20 min)
   - Use `claude-skills/canvas-design/`
   - Create social media graphics
   - Design promotional materials

2. **Add PDF Export** (30 min)
   - Use `claude-skills/document-skills/pdf/`
   - Generate PDF versions of content
   - Create downloadable resources

EOF
    fi

    # Add integration examples
    cat >> "$suggestion_file" << 'EOF'
---

## 💡 Integration Examples

### Example 1: Add Excel Export

```javascript
// In your project
import { createExcelReport } from '@/lib/claude-skills-xlsx';

function exportToExcel(data) {
  const workbook = createExcelReport({
    title: "Project Report",
    data: data,
    charts: true
  });

  // Download file
  workbook.download('report.xlsx');
}
```

### Example 2: Integrate Chat Support

```javascript
// Copy from claude-quickstarts/customer-support-agent/
import ChatArea from '@/components/ChatArea';
import { streamChatResponse } from '@/lib/claude-api';

export default function SupportPage() {
  return (
    <div className="flex h-screen">
      <ChatArea
        onMessage={streamChatResponse}
        knowledgeBase={yourKnowledgeBase}
      />
    </div>
  );
}
```

---

## 📖 Learning Resources

### Tutorials
- **Claude Cookbooks**: Browse 300+ examples at `/Volumes/Ai/Resources/claude-cookbooks/`
- **Quickstart Apps**: See complete applications at `/Volumes/Ai/Resources/claude-quickstarts/`
- **Skill Templates**: Learn skill patterns at `/Volumes/Ai/Resources/claude-skills/`

### Documentation
- **Integration Guide**: `/Volumes/Ai/.Master/COOKBOOK_INTEGRATION.md`
- **Project Discovery**: `/Volumes/Ai/.Master/global-assets/README.md`

---

**💡 Tip**: Start with one feature, test it, then expand. The reference projects are read-only resources you can copy from.

EOF

    echo -e "${GREEN}  ✓ Generated suggestions: $suggestion_file${NC}"

done

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Audit Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "Suggestions saved to: ${BLUE}$SUGGESTIONS_DIR/${NC}"
echo -e "View any file: ${YELLOW}cat $SUGGESTIONS_DIR/<project>-suggestions.md${NC}"
echo ""
