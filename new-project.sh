#!/bin/bash
# ============================================================
# new-project.sh — LinkedinStrategy
#
# Creates a new GTM project inside /Users/axr/Desktop/GTMProjects/
# with PROJECT.json scaffold, CLAUDE.md template, empty data/,
# and a launch.sh that uses the shared skills.
#
# Usage: bash new-project.sh "Project Name"
# Example: bash new-project.sh "ScaleUp Labs GTM"
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

GTMROOT="/Users/axr/Desktop/GTMProjects"

# ─── Get project name ─────────────────────────────────────────────────────────
if [ -z "$1" ]; then
  echo -e "${RED}Usage: bash new-project.sh \"Project Name\"${NC}"
  echo -e "Example: bash new-project.sh \"ScaleUp Labs GTM\""
  exit 1
fi

PROJECT_NAME="$1"
PROJECT_SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
PROJECT_DIR="$GTMROOT/$PROJECT_SLUG"
PROJECT_ID="proj_$(date +%Y%m%d)_${PROJECT_SLUG}"

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  LinkedinStrategy — New Project${NC}"
echo -e "${BOLD}  Name:   $PROJECT_NAME${NC}"
echo -e "${BOLD}  Folder: $PROJECT_DIR${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ─── Check GTMProjects exists ────────────────────────────────────────────────
if [ ! -d "$GTMROOT" ]; then
  echo -e "${RED}GTMProjects not found at $GTMROOT${NC}"
  echo "Run install.sh first."
  exit 1
fi

if [ ! -d "$GTMROOT/.claude/skills/scan-signals" ]; then
  echo -e "${RED}Skills not found at $GTMROOT/.claude/skills/${NC}"
  echo "Run install.sh first."
  exit 1
fi

# ─── Check project doesn't already exist ─────────────────────────────────────
if [ -d "$PROJECT_DIR" ]; then
  echo -e "${YELLOW}⚠ Folder already exists: $PROJECT_DIR${NC}"
  read -p "  Continue and overwrite scaffold files? (data/ will not be touched) [y/N]: " confirm
  [[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "Aborted." && exit 0
fi

# ─── Create directory structure ───────────────────────────────────────────────
echo -e "${CYAN}Creating directory structure...${NC}"

dirs=(
  "$PROJECT_DIR/data/content/drafts"
  "$PROJECT_DIR/data/content/posts"
  "$PROJECT_DIR/data/content/articles"
  "$PROJECT_DIR/data/content/sequences"
  "$PROJECT_DIR/data/competitive/profiles/emerging"
  "$PROJECT_DIR/data/competitive/battlecards"
  "$PROJECT_DIR/data/competitive/reports"
  "$PROJECT_DIR/data/reports"
)

for dir in "${dirs[@]}"; do
  mkdir -p "$dir"
done
echo -e "  ${GREEN}✓ data/ structure created${NC}"

# ─── Create PROJECT.json ──────────────────────────────────────────────────────
cat > "$PROJECT_DIR/PROJECT.json" << JSONEOF
{
  "project_name": "$PROJECT_NAME",
  "project_id": "$PROJECT_ID",
  "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "last_active": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "config": {
    "icp": {
      "company": "FILL IN — your company name",
      "product": "FILL IN — one-sentence product description",
      "target_titles": [
        "FILL IN — job title 1",
        "FILL IN — job title 2"
      ],
      "target_industries": [
        "FILL IN — industry 1",
        "FILL IN — industry 2"
      ],
      "target_company_size": "FILL IN — e.g. 50-500 employees, USD 10M-200M revenue",
      "core_pains": [
        "FILL IN — pain point 1",
        "FILL IN — pain point 2",
        "FILL IN — pain point 3"
      ],
      "disqualifiers": [
        "FILL IN — who NOT to target"
      ]
    },
    "competitors": [
      "FILL IN — competitor 1",
      "FILL IN — competitor 2"
    ],
    "content_voice": {
      "pillars": [
        "FILL IN — content pillar 1",
        "FILL IN — content pillar 2"
      ],
      "forbidden_words": [
        "leverage", "synergy", "cutting-edge", "revolutionary", "game-changer"
      ],
      "tone": "FILL IN — e.g. practitioner-first, specific beats generic",
      "newsletter_name": "FILL IN — e.g. The Weekly Brief"
    },
    "linkedin_handle": "FILL IN — your LinkedIn profile URL",
    "scan_cadence": "weekly"
  },
  "stats": {
    "total_signals": 0,
    "total_scans": 0,
    "total_engagements": 0,
    "total_content_generated": 0,
    "last_scan": null,
    "last_engagement": null,
    "last_competitive_scan": null
  }
}
JSONEOF
echo -e "  ${GREEN}✓ PROJECT.json created${NC}"

# ─── Create CLAUDE.md ─────────────────────────────────────────────────────────
cat > "$PROJECT_DIR/CLAUDE.md" << MDEOF
# $PROJECT_NAME — GTM Intelligence

## Project Identity
- **Project:** $PROJECT_NAME
- **Product / Company:** FILL IN
- **Positioning:** FILL IN — one sentence: what you do and for whom

---

## ICP (Ideal Customer Profile)

**Target Titles:** FILL IN
**Company Size:** FILL IN
**Industries:** FILL IN

**Core Pains:**
- FILL IN — pain 1
- FILL IN — pain 2
- FILL IN — pain 3

**Disqualifiers (do not engage):**
- FILL IN

---

## Signal Classification
[Uses global defaults from shared plugin. Add project-specific overrides below if needed.]

---

## Competitor Universe
| Competitor | Core Weakness vs Your Product |
|---|---|
| FILL IN | FILL IN |
| FILL IN | FILL IN |

---

## Content Voice

**Tone:** FILL IN
**Pillars:** FILL IN
**Never say:** FILL IN

---

## LinkedIn Scan Targets

**Subreddits:** FILL IN
**Custom search queries:** FILL IN

---

## Safety Rules
- NEVER mention [your product] by name in Touch 1 comments
- ALWAYS confirm "Acting for project: $PROJECT_NAME" before any LinkedIn action
MDEOF
echo -e "  ${GREEN}✓ CLAUDE.md scaffold created${NC}"

# ─── Initialize signals database ─────────────────────────────────────────────
cat > "$PROJECT_DIR/data/signals-database.json" << DBEOF
{
  "project": "$PROJECT_NAME",
  "metadata": {
    "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "last_scan": null,
    "total_signals": 0,
    "total_scans": 0
  },
  "signals": []
}
DBEOF
echo -e "  ${GREEN}✓ signals-database.json initialized${NC}"

# ─── Create launch.sh ─────────────────────────────────────────────────────────
cat > "$PROJECT_DIR/launch.sh" << LAUNCHEOF
#!/bin/bash
# Start Claude Code for: $PROJECT_NAME
# Loads shared skills from GTMProjects/.claude/skills/ via --add-dir
PROJECT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"
GTMROOT="\$(dirname "\$PROJECT_DIR")"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  LinkedinStrategy — $PROJECT_NAME"
echo "  Project: \$PROJECT_DIR"
echo "  Skills:  \$GTMROOT/.claude/skills/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v claude &> /dev/null; then
  echo "ERROR: Claude Code not found. Install: npm install -g @anthropic-ai/claude-code"
  exit 1
fi

cd "\$PROJECT_DIR"
exec claude --add-dir "\$GTMROOT"
LAUNCHEOF
chmod +x "$PROJECT_DIR/launch.sh"
echo -e "  ${GREEN}✓ launch.sh created${NC}"

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}Project created: $PROJECT_NAME${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo ""
echo -e "  1. Fill in your ICP and competitors:"
echo -e "     ${CYAN}open $PROJECT_DIR/CLAUDE.md${NC}"
echo -e "     ${CYAN}open $PROJECT_DIR/PROJECT.json${NC}"
echo ""
echo -e "  2. Launch Claude Code:"
echo -e "     ${CYAN}bash $PROJECT_DIR/launch.sh${NC}"
echo ""
echo -e "  3. Inside Claude Code, start scanning:"
echo -e "     ${CYAN}/gtm-pipeline${NC}"
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
