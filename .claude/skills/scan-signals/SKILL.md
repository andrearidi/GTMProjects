---
name: scan-signals
description: >
  Scan LinkedIn for GTM buying signals. Reads ICP and competitors from
  PROJECT.json. Writes only to ./data/. First step in the GTM pipeline.
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__find
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__computer
  - Read
  - Write
context: fork
disable-model-invocation: false
---

# Scan Signals

## Step 0 — Load Project Context

Read `./PROJECT.json`. If not found: "No project found. Run /init-project first." Abort.

Extract from PROJECT.json:
- `project_name` — label for this scan session
- `config.icp.target_titles` — relevance filter
- `config.icp.target_industries` — relevance filter
- `config.icp.core_pains` — build pain-based search queries
- `config.competitors` — build competitor-based queries

Read `./CLAUDE.md` for extended ICP and voice context.
Read `./data/signals-database.json` (for deduplication).

---

## Phase 1 — LinkedIn Feed

Navigate to `https://linkedin.com/feed`. Scroll 3–4 times.
Filter: prioritize posts from `config.icp.target_titles` and `target_industries`.

---

## Phase 2 — LinkedIn Search

Build queries dynamically from PROJECT.json config:

**Pain-Based** (one query per `core_pain`):
- `"[core_pain]" [primary industry] frustrated OR struggling`

**Role-Based** (one query per `target_title`):
- `"[target_title]" "new role" OR "first 90 days"`

**Competitor-Based** (one query per competitor in `config.competitors`):
- `"[competitor]" alternative OR switching OR problem`

Search at: `https://www.linkedin.com/search/results/content/?keywords=QUERY&sortBy=date`

---

## Phase 3 — Store in ./data/

Write to `./data/signals-database.json`. Every record includes:
```json
{
  "project": "[project_name from PROJECT.json]",
  "content_potential": "high|medium|low",
  "content_pillar": "[pillar]"
}
```

Check for duplicates (same person.name + content.url = skip).
Update `./PROJECT.json` stats after writing.

---

## Phase 5 — Summary

Print: project name, scan totals by class, content potential count,
any competitor names seen, next step suggestions.

---

## Signal Schema Addition

When storing signals, include these fields required by engage-signals:

  "content": {
    "summary": "",
    "url": "",           ← REQUIRED: exact LinkedIn post URL for navigation
    "full_text": "",
    "post_text_excerpt": ""  ← first 200 chars of post text, for display in queue
  }

Always capture the direct post URL (linkedin.com/posts/...) not the feed URL.
Without the exact post URL, engage-signals cannot navigate to the post to comment.
