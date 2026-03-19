---
name: init-project
description: >
  Initialize a new GTM Intelligence project in the current directory.
  Creates PROJECT.json, CLAUDE.md scaffold, and empty data directories.
  Use when starting a new project: /init-project "Project Name"
  Example: /init-project "ScaleUp Labs GTM"
allowed-tools:
  - Read
  - Write
  - Bash
disable-model-invocation: true
---

# Init Project

Bootstrap a new GTM Intelligence project in the current working directory.

Project name: **$ARGUMENTS**

---

## Step 1 — Check for Existing Project

Read `./PROJECT.json` if it exists.
If found: warn "A project already exists here: [name]. Abort or overwrite?"
Wait for user confirmation before proceeding.

---

## Step 2 — Create PROJECT.json

```json
{
  "project_name": "$ARGUMENTS",
  "project_id": "proj_[YYYYMMDD]_[slug]",
  "created": "[ISO-8601]",
  "last_active": "[ISO-8601]",
  "config": {
    "icp": {
      "company": "",
      "product": "",
      "target_titles": [],
      "target_industries": [],
      "target_company_size": "",
      "core_pains": [],
      "disqualifiers": []
    },
    "competitors": [],
    "content_voice": {
      "pillars": [],
      "forbidden_words": [],
      "tone": ""
    },
    "linkedin_handle": "",
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
```

---

## Step 3 — Create Data Directory Structure

```
./data/
├── signals-database.json        ← empty, initialized
├── content/
│   ├── drafts/
│   ├── posts/
│   ├── articles/
│   └── sequences/
├── competitive/
│   ├── profiles/
│   │   └── emerging/
│   ├── battlecards/
│   └── reports/
└── reports/
```

Initialize `./data/signals-database.json`:
```json
{
  "project": "$ARGUMENTS",
  "metadata": {
    "created": "[ISO-8601]",
    "last_scan": null,
    "total_signals": 0,
    "total_scans": 0
  },
  "signals": []
}
```

---

## Step 4 — Create CLAUDE.md Scaffold

Create `./CLAUDE.md` with this template, pre-filled where possible:

```markdown
# [Project Name] — GTM Intelligence

## Project Identity
- **Project:** $ARGUMENTS
- **Product/Company:** [FILL IN]
- **Positioning:** [FILL IN — one sentence]

## ICP (Ideal Customer Profile)
- **Titles:** [FILL IN]
- **Company Size:** [FILL IN]
- **Industries:** [FILL IN]
- **Core Pains:** [FILL IN]
- **Disqualifiers:** [FILL IN]

## Signal Classification Matrix
[Uses global defaults from the shared plugin. Override here if needed.]

## Competitor Universe
[List competitors here — /competitive-scan will populate profiles]

## Content Voice
- **Tone:** [FILL IN]
- **Content Pillars:** [FILL IN]
- **Never say:** [FILL IN]

## Data Location
All data for this project lives in: ./data/
- Launch with: bash launch.sh (loads shared skills via --add-dir)
```

---

## Step 5 — Summary

```
PROJECT INITIALIZED: $ARGUMENTS
──────────────────────────────────────
Created:
  ✅ PROJECT.json
  ✅ CLAUDE.md (scaffold — fill in your ICP and competitors)
  ✅ data/ directory structure
  ✅ data/signals-database.json (empty)

Next steps:
  1. Edit CLAUDE.md — fill in ICP, competitors, content voice
  2. Edit PROJECT.json config section with your specifics
  3. Run: bash launch.sh  to start Claude Code for this project
  4. Or run /migrate-data [path] to import existing data
```
