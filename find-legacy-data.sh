#!/bin/bash
# ============================================================
# find-legacy-data.sh — LinkedinStrategy
#
# Locates all previous GTM Intelligence / Cowork / signal-detector
# data on this machine so you can migrate it into the new setup.
#
# Usage: bash find-legacy-data.sh
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  LinkedinStrategy — Legacy Data Finder${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

FOUND_ANYTHING=false

# ─── 1. Cowork / Claude Desktop plugin folders ───────────────────────────────
echo -e "${CYAN}[1/6] Checking Cowork and Claude Desktop plugin folders...${NC}"

COWORK_DIRS=(
  "$HOME/Library/Application Support/Claude/cowork"
  "$HOME/Library/Application Support/Claude/plugins"
  "$HOME/.claude/plugins"
  "$HOME/.cowork"
)

for dir in "${COWORK_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo -e "  ${GREEN}FOUND${NC}: $dir"
    ls "$dir" 2>/dev/null | sed 's/^/    /'
    FOUND_ANYTHING=true
  fi
done

COWORK_JSON=$(find "$HOME/Library/Application Support/Claude" -name "*.json" -path "*/cowork/*" 2>/dev/null | head -10)
if [ -n "$COWORK_JSON" ]; then
  echo -e "  ${GREEN}FOUND in Claude app data:${NC}"
  echo "$COWORK_JSON" | sed 's/^/    /'
  FOUND_ANYTHING=true
fi

# ─── 2. signals-database.json ────────────────────────────────────────────────
echo ""
echo -e "${CYAN}[2/6] Searching for signals-database.json...${NC}"

SIGNAL_FILES=$(find ~ -name "signals-database.json" 2>/dev/null \
  | grep -v "node_modules" | grep -v ".Trash" | head -20)

if [ -n "$SIGNAL_FILES" ]; then
  echo -e "  ${GREEN}FOUND:${NC}"
  while IFS= read -r f; do
    SIZE=$(wc -c < "$f" 2>/dev/null | tr -d ' ')
    COUNT=$(python3 -c "
import json, sys
try:
    d = json.load(open('$f'))
    print(len(d.get('signals', d.get('Signals', []))))
except:
    print('?')
" 2>/dev/null)
    echo -e "    ${BOLD}$f${NC}"
    echo -e "      Size: ${SIZE} bytes | Signals: ${COUNT}"
  done <<< "$SIGNAL_FILES"
  FOUND_ANYTHING=true
else
  echo -e "  ${YELLOW}Not found${NC}"
fi

# ─── 3. Competitor profiles ───────────────────────────────────────────────────
echo ""
echo -e "${CYAN}[3/6] Searching for competitor profile directories...${NC}"

COMP_DIRS=$(find ~ -type d -name "competitive" 2>/dev/null \
  | grep -v "node_modules" | grep -v ".Trash" | head -10)

if [ -n "$COMP_DIRS" ]; then
  echo -e "  ${GREEN}FOUND competitive/ directories:${NC}"
  while IFS= read -r d; do
    COUNT=$(find "$d" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "    $d  (${COUNT} JSON files)"
  done <<< "$COMP_DIRS"
  FOUND_ANYTHING=true
else
  echo -e "  ${YELLOW}Not found${NC}"
fi

COMP_FILES=$(find ~ \( -name "maintainx.json" -o -name "tulip.json" -o \
  -name "parsable.json" -o -name "proshop.json" \) 2>/dev/null \
  | grep -v "node_modules" | head -10)
if [ -n "$COMP_FILES" ]; then
  echo -e "  ${GREEN}Individual competitor profiles:${NC}"
  echo "$COMP_FILES" | sed 's/^/    /'
  FOUND_ANYTHING=true
fi

# ─── 4. Generated content ─────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}[4/6] Searching for generated content directories...${NC}"

CONTENT_DIRS=$(find ~ -type d -name "content" -path "*/data/*" 2>/dev/null \
  | grep -v "node_modules" | grep -v ".Trash" | head -10)

if [ -n "$CONTENT_DIRS" ]; then
  echo -e "  ${GREEN}FOUND content/ directories:${NC}"
  while IFS= read -r d; do
    COUNT=$(find "$d" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "    $d  (${COUNT} .md files)"
  done <<< "$CONTENT_DIRS"
  FOUND_ANYTHING=true
else
  echo -e "  ${YELLOW}Not found${NC}"
fi

# ─── 5. Battlecards ───────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}[5/6] Searching for battlecard files...${NC}"

BATTLECARD_FILES=$(find ~ -name "battlecard-*.md" 2>/dev/null \
  | grep -v "node_modules" | grep -v ".Trash" | head -10)

if [ -n "$BATTLECARD_FILES" ]; then
  echo -e "  ${GREEN}FOUND:${NC}"
  echo "$BATTLECARD_FILES" | sed 's/^/    /'
  FOUND_ANYTHING=true
else
  echo -e "  ${YELLOW}Not found${NC}"
fi

# ─── 6. Previous plugin project folders ──────────────────────────────────────
echo ""
echo -e "${CYAN}[6/6] Searching for previous plugin/project folders...${NC}"

OLD_DIRS=$(find ~ \( \
  -name "signal-detector" -o \
  -name "corello-gtm" -o \
  -name "gtm-intelligence" -o \
  -name "corello-gtm-suite" \
  \) -type d 2>/dev/null \
  | grep -v "node_modules" | grep -v ".Trash" | head -10)

if [ -n "$OLD_DIRS" ]; then
  echo -e "  ${GREEN}FOUND:${NC}"
  while IFS= read -r d; do
    echo -e "    ${BOLD}$d${NC}"
    ls "$d" 2>/dev/null | sed 's/^/      /'
  done <<< "$OLD_DIRS"
  FOUND_ANYTHING=true
else
  echo -e "  ${YELLOW}Not found${NC}"
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$FOUND_ANYTHING" = true ]; then
  echo -e "${GREEN}${BOLD}Data found. Migration steps:${NC}"
  echo ""
  echo -e "  1. Note the path(s) listed above"
  echo -e "  2. Open a terminal and run:"
  echo ""
  echo -e "       cd ~/projects/corello-gtm"
  echo -e "       claude"
  echo -e "       /migrate-data [path from above]"
  echo ""
  echo -e "  Example:"
  echo -e "       /migrate-data ~/Downloads/signal-detector/data"
else
  echo -e "${YELLOW}${BOLD}No data found automatically.${NC}"
  echo ""
  echo -e "  Try these manual searches:"
  echo -e "    ls ~/Downloads | grep -i 'signal\\|corello\\|gtm'"
  echo -e "    ls ~/Desktop  | grep -i 'signal\\|corello\\|gtm'"
  echo -e "    find ~ -name '*.json' 2>/dev/null | grep -i signal"
  echo ""
  echo -e "  If you only have the original .zip from this session, unzip it first:"
  echo -e "    unzip ~/Downloads/signal-detector*.zip -d ~/Downloads/signal-extracted"
  echo -e "    Then: /migrate-data ~/Downloads/signal-extracted"
fi

echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
