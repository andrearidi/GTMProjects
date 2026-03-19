---
name: migrate-data
description: >
  Migrate data from a previous plugin version (Cowork, old signal-detector,
  or any legacy format) into the current project's data/ directory.
  Handles schema conversion, deduplication, and validation.
  Usage: /migrate-data [source_path]
  Example: /migrate-data ~/Downloads/signal-detector/data/
  Or: /migrate-data (interactive — will help locate the source)
allowed-tools:
  - Read
  - Write
  - Bash
disable-model-invocation: false
---

# Migrate Data

Import existing GTM intelligence data into the current project.

Source path: **$ARGUMENTS** (if empty → run interactive discovery)

---

## Step 0 — Verify Current Project

Read `./PROJECT.json`. If not found:
"No project initialized here. Run /init-project first."
Abort.

Read `./data/signals-database.json` — note current signal count.

---

## Step 1 — Locate Source Data

### If $ARGUMENTS is provided:
Try to read the directory at `$ARGUMENTS`.
Expected files: `signals-database.json`, and optionally `competitive/profiles/`, `content/`.

### If $ARGUMENTS is empty (interactive mode):
Run these bash commands to find candidate data locations:

```bash
# Search for signals-database.json on the machine
find ~ -name "signals-database.json" 2>/dev/null | head -20

# Search for old plugin data folders
find ~ -name "signal-detector" -type d 2>/dev/null | head -10
find /Users/axr/Desktop -name "*.json" -path "*/data/*" 2>/dev/null | head -10

# Search in common locations
ls ~/Downloads/ 2>/dev/null | grep -i "signal\|corello\|gtm\|linkedin"
ls ~/Documents/ 2>/dev/null | grep -i "signal\|corello\|gtm\|linkedin"
ls /Users/axr/Desktop/ 2>/dev/null | grep -i "signal\|corello\|gtm\|linkedin"
ls ~/Desktop/ 2>/dev/null | grep -i "signal\|corello\|gtm"
```

Show results to user. Ask: "Which path contains the data to migrate?"
Wait for user to confirm the path before proceeding.

---

## Step 2 — Detect Source Format

Read the source `signals-database.json`. Detect the schema version:

### Format A — Old Cowork/Plugin format (no `content_potential` or `content_pillar`):
```json
{ "signals": [{ "id": "...", "signal_class": "...", ... }] }
```

### Format B — signal-detector v1 (has basic engagement but no content fields):
```json
{ "metadata": {...}, "signals": [...] }
```

### Format C — corello-gtm-suite (current format — has `content_potential`, `content_pillar`):
Already compatible. Just merge.

### Format D — Unknown / flat CSV or unstructured:
Parse best-effort, map fields manually, flag unmapped records.

Report detected format to user. Show first 2 signal records for visual confirmation.

---

## Step 3 — Schema Migration

For each signal in the source, apply this transformation:

**Fields to carry over as-is:**
`id`, `timestamp`, `source`, `signal_class`, `signal_type`,
`person`, `content`, `notes`

**Fields to add if missing (with defaults):**
```json
{
  "scan_session": "[infer from timestamp if possible, else 'migrated']",
  "content_potential": "[infer: CRITICAL/HIGH → high, MEDIUM → medium, LOW → low]",
  "content_pillar": "[infer from signal_type — see mapping below]",
  "content_generated": false,
  "migrated_from": "[source path]",
  "migrated_at": "[ISO-8601]"
}
```

**Signal type → content pillar mapping:**
```
retirement         → tribal-knowledge
data-frustration   → paper-intelligence
erp-failure        → paper-intelligence
pain               → hmlv-complexity
question           → hmlv-complexity
skepticism         → ai-skepticism
competitor         → hmlv-complexity
hiring             → tribal-knowledge
funding            → hmlv-complexity
conversation       → operator-empowerment
event              → operator-empowerment
```

**Engagement field migration:**
If old format uses `"status": "touch-1"` → convert to:
```json
{
  "status": "touched",
  "touch_number": 1,
  "actions_taken": [{ "touch": 1, "type": "unknown", "timestamp": "[infer]", "text": "[legacy]" }]
}
```

---

## Step 4 — Deduplication

Before merging, check for duplicates between source signals and existing
signals in `./data/signals-database.json`.

Duplicate = same `person.name` + same `content.url` OR same `id`.

For each duplicate: show to user and ask: keep source, keep target, or merge.
Default: keep the record with more complete engagement history.

---

## Step 5 — Migrate Competitor Profiles

Check for `competitive/profiles/` in the source directory.

For each `.json` profile found:
1. Check if `./data/competitive/profiles/[slug].json` exists
2. If exists: merge `intelligence_log` arrays (deduplicate by date+finding)
3. If new: copy directly
4. Report: "Merged N profiles, added N new profiles"

---

## Step 6 — Migrate Content

Check for `content/` directory in source.

For published posts (`content/posts/`): copy to `./data/content/posts/`
For drafts (`content/drafts/`): copy to `./data/content/drafts/` — set status to `migrated-draft`
For articles: copy to `./data/content/articles/`
For sequences: copy to `./data/content/sequences/`

---

## Step 7 — Write & Validate

Write merged `signals-database.json` to `./data/signals-database.json`.
Update `PROJECT.json` stats:
```json
{
  "stats": {
    "total_signals": [new count],
    "last_scan": "[most recent scan_session from migrated data]"
  }
}
```

---

## Step 8 — Migration Report

```
MIGRATION COMPLETE
──────────────────────────────────────────────
Source:            [path]
Source format:     [A/B/C/D]

Signals migrated:      N
  Carried over:        N
  Schema upgraded:     N
  Duplicates skipped:  N
  Conflicts resolved:  N

Competitor profiles:   N merged, N new
Content files:         N posts, N articles, N sequences, N drafts

Current project total: N signals

Issues flagged:
  [any records that couldn't be automatically converted]

Next steps:
  → /signal-report week  to review migrated signals
  → /scan-signals        to add new signals on top of migrated data
  → /competitive-scan    to refresh competitor profiles
```
