---
name: battlecard
description: >
  Generate sales battlecards for the current project. Reads from ./data/competitive/profiles/.
  Usage: /battlecard [competitor_name|all]
allowed-tools:
  - Read
  - Write
disable-model-invocation: false
---

# Battlecard

## Step 0 — Load Project Context

Read `./PROJECT.json` — extract `project_name`, `config.icp`, `config.competitors`.
Read `./CLAUDE.md` — positioning and differentiation language.

Target: `$ARGUMENTS` competitor, or all if empty/all.

---

## Module A — Per-Competitor Battlecard

Read `./data/competitive/profiles/[competitor].json`.

Generate battlecard using the project's positioning (from CLAUDE.md) vs the competitor.
Adapt win themes to this project's ICP — titles, pains, company size.

Save to `./data/competitive/battlecards/battlecard-[competitor]-v[N].md`

Front matter:
```yaml
---
project: [project_name]
competitor: [name]
last_updated: [date]
version: N
based_on_profile: [profile last_updated date]
---
```

Sections: One-Line Differentiation, When You'll See Them, Their Pitch,
Our Response table, Where We Win, Where They Win (honest), Landmines to Plant,
Proof Points, Red Flags.

---

## Module B — Full Positioning Report (when $ARGUMENTS = all)

Read all profiles in `./data/competitive/profiles/`.
Generate: market map, head-to-head matrix, primary threats, emerging threats,
strategic recommendations, content/GTM implications.

Save to `./data/competitive/reports/positioning-report-[YYYYMMDD].md`

---

## Summary

List files generated. Note if any profiles are stubs needing a `/competitive-scan` first.
