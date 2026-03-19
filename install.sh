#!/bin/bash
# ============================================================
# install.sh — LinkedinStrategy
#
# Installs the full GTM Intelligence suite into:
#   /Users/axr/Desktop/GTMProjects/
#
# Self-contained: skills, projects, and data all live under
# that one directory. Nothing is installed globally except
# the Claude in Chrome MCP entry in ~/.claude/settings.json
# (required by Claude Code — cannot be stored locally).
#
# Usage: bash install.sh
# Run from the root of the unzipped LinkedinStrategy package.
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="/Users/axr/Desktop/GTMProjects"

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  LinkedinStrategy — Self-Contained Installer${NC}"
echo -e "${BOLD}  Target: $TARGET${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ─── Step 1: Prerequisites ────────────────────────────────────────────────────
echo -e "${CYAN}[1/5] Checking prerequisites...${NC}"

if ! command -v claude &> /dev/null; then
  echo -e "  ${RED}✗ Claude Code not found.${NC}"
  echo -e "    Install: npm install -g @anthropic-ai/claude-code"
  exit 1
fi
echo -e "  ${GREEN}✓ Claude Code: $(claude --version 2>/dev/null | head -1)${NC}"

if ! command -v node &> /dev/null; then
  echo -e "  ${YELLOW}⚠ Node.js not found — needed for Claude in Chrome MCP${NC}"
else
  echo -e "  ${GREEN}✓ Node.js: $(node --version)${NC}"
fi

# ─── Step 2: Create GTMProjects directory structure ───────────────────────────
echo ""
echo -e "${CYAN}[2/5] Creating $TARGET ...${NC}"

# Create all required directories
dirs=(
  "$TARGET/.claude/skills"
  "$TARGET/.claude/rules"
  "$TARGET/corello-gtm/data/content/drafts"
  "$TARGET/corello-gtm/data/content/posts"
  "$TARGET/corello-gtm/data/content/articles"
  "$TARGET/corello-gtm/data/content/sequences"
  "$TARGET/corello-gtm/data/competitive/profiles/emerging"
  "$TARGET/corello-gtm/data/competitive/battlecards"
  "$TARGET/corello-gtm/data/competitive/reports"
  "$TARGET/corello-gtm/data/reports"
)

for dir in "${dirs[@]}"; do
  if mkdir -p "$dir" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $dir"
  else
    echo -e "  ${RED}✗ Could not create${NC}: $dir"
    echo -e "    Check that /Users/axr/Desktop exists and is writable."
    exit 1
  fi
done

# ─── Step 3: Install shared skills ────────────────────────────────────────────
echo ""
echo -e "${CYAN}[3/5] Installing shared skills to $TARGET/.claude/skills/ ...${NC}"

SKILLS=(
  "scan-signals"
  "draft-comment"
  "engage-signals"
  "create-content"
  "competitive-scan"
  "battlecard"
  "signal-report"
  "gtm-pipeline"
  "init-project"
  "migrate-data"
  "signal-scanner"
  "content-writer"
  "competitive-researcher"
  "research-topic"
)

SKILLS_SRC="$SCRIPT_DIR/plugin/.claude/skills"

for skill in "${SKILLS[@]}"; do
  SRC="$SKILLS_SRC/$skill"
  DST="$TARGET/.claude/skills/$skill"
  if [ ! -d "$SRC" ]; then
    echo -e "  ${RED}✗ Missing source${NC}: $skill — skipping"
    continue
  fi
  mkdir -p "$DST"
  if [ -f "$DST/SKILL.md" ]; then
    echo -e "  ${YELLOW}↺ Updating${NC}: $skill"
  else
    echo -e "  ${GREEN}✓ Installing${NC}: $skill"
  fi
  cp "$SRC/SKILL.md" "$DST/SKILL.md"
done

# Install global rules
cp "$SCRIPT_DIR/plugin/.claude/rules/gtm-global.md" \
   "$TARGET/.claude/rules/gtm-global.md" 2>/dev/null \
  && echo -e "  ${GREEN}✓ Rules: gtm-global.md${NC}"

# ─── Step 4: Set up Corello project ──────────────────────────────────────────
echo ""
echo -e "${CYAN}[4/5] Setting up Corello GTM project ...${NC}"

CORELLO_SRC="$SCRIPT_DIR/projects/corello-gtm"
CORELLO_DST="$TARGET/corello-gtm"

# Copy project files (never overwrite existing data/)
for file in PROJECT.json CLAUDE.md; do
  if [ -f "$CORELLO_SRC/$file" ]; then
    if [ -f "$CORELLO_DST/$file" ]; then
      echo -e "  ${YELLOW}↺ Updating${NC}: corello-gtm/$file"
    else
      echo -e "  ${GREEN}✓ Installing${NC}: corello-gtm/$file"
    fi
    cp "$CORELLO_SRC/$file" "$CORELLO_DST/$file"
  fi
done

# Initialize signals database only if it doesn't already exist
if [ ! -f "$CORELLO_DST/data/signals-database.json" ]; then
  cat > "$CORELLO_DST/data/signals-database.json" << 'JSON'
{
  "project": "Corello GTM",
  "metadata": {
    "created": "",
    "last_scan": null,
    "total_signals": 0,
    "total_scans": 0
  },
  "signals": []
}
JSON
  echo -e "  ${GREEN}✓ Initialized${NC}: corello-gtm/data/signals-database.json"
else
  echo -e "  ${YELLOW}⏭ Kept existing${NC}: corello-gtm/data/signals-database.json"
fi

# Install launch script
cat > "$CORELLO_DST/launch.sh" << 'LAUNCH'
#!/bin/bash
# Start Claude Code for Corello GTM project
# Loads shared skills from GTMProjects/.claude/skills/ via --add-dir
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
GTMROOT="$(dirname "$PROJECT_DIR")"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  LinkedinStrategy — Corello GTM"
echo "  Project: $PROJECT_DIR"
echo "  Skills:  $GTMROOT/.claude/skills/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v claude &> /dev/null; then
  echo "ERROR: Claude Code not found. Install: npm install -g @anthropic-ai/claude-code"
  exit 1
fi

cd "$PROJECT_DIR"
exec claude --add-dir "$GTMROOT"
LAUNCH
chmod +x "$CORELLO_DST/launch.sh"
echo -e "  ${GREEN}✓ Installed${NC}: corello-gtm/launch.sh"

# Install helper scripts at GTMProjects root
for script in find-legacy-data.sh new-project.sh; do
  if [ -f "$SCRIPT_DIR/$script" ]; then
    cp "$SCRIPT_DIR/$script" "$TARGET/$script"
    chmod +x "$TARGET/$script"
    echo -e "  ${GREEN}✓ Installed${NC}: $script"
  fi
done

# Copy docs
for doc in README.md ARCHITECTURE.md; do
  [ -f "$SCRIPT_DIR/$doc" ] && cp "$SCRIPT_DIR/$doc" "$TARGET/$doc"
done
echo -e "  ${GREEN}✓ Documentation installed${NC}"

# ─── Step 5: MCP configuration ───────────────────────────────────────────────
echo ""
echo -e "${CYAN}[5/5] Configuring Claude in Chrome MCP ...${NC}"
echo -e "  ${YELLOW}Note: MCP config is the only setting stored outside GTMProjects.${NC}"
echo -e "  ${YELLOW}Claude Code always reads it from ~/.claude/settings.json${NC}"

SETTINGS="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"

if [ -f "$SETTINGS" ]; then
  if grep -q "Claude_in_Chrome\|claude-in-chrome" "$SETTINGS" 2>/dev/null; then
    echo -e "  ${GREEN}✓ Claude in Chrome MCP already configured${NC}"
  else
    echo -e "  ${YELLOW}⚠ Adding Claude in Chrome to existing ~/.claude/settings.json${NC}"
    echo -e "  Please add this manually to the mcpServers block:"
    echo ""
    echo -e '    "Claude_in_Chrome": {'
    echo -e '      "command": "npx",'
    echo -e '      "args": ["-y", "@anthropic-ai/claude-in-chrome-mcp@latest"]'
    echo -e '    }'
  fi
else
  cat > "$SETTINGS" << 'JSON'
{
  "mcpServers": {
    "Claude_in_Chrome": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/claude-in-chrome-mcp@latest"]
    }
  }
}
JSON
  echo -e "  ${GREEN}✓ Created ~/.claude/settings.json with Claude in Chrome MCP${NC}"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}Installation complete.${NC}"
echo ""
echo -e "  Everything is installed under:"
echo -e "  ${BOLD}$TARGET/${NC}"
echo ""
echo -e "${BOLD}To launch Corello GTM:${NC}"
echo ""
echo -e "  ${CYAN}bash $TARGET/corello-gtm/launch.sh${NC}"
echo ""
echo -e "  Or from terminal:"
echo -e "  ${CYAN}cd $TARGET/corello-gtm && claude --add-dir $TARGET${NC}"
echo ""
echo -e "${BOLD}To migrate your existing data:${NC}"
echo ""
echo -e "  ${CYAN}bash $TARGET/find-legacy-data.sh${NC}"
echo -e "  Then inside the Claude session:"
echo -e "  ${CYAN}/migrate-data [path found above]${NC}"
echo ""
echo -e "${BOLD}To add a new project:${NC}"
echo ""
echo -e "  ${CYAN}bash $TARGET/new-project.sh \"My Project Name\"${NC}"
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
