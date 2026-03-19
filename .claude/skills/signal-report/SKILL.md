---
name: signal-report
description: >
  Generate a signal report for the current project.
  Usage: /signal-report [today|week|month]
allowed-tools:
  - Read
  - Write
disable-model-invocation: true
---

# Signal Report

Read `./PROJECT.json` — confirm project name.
Period: $ARGUMENTS (default: week)

Read `./data/signals-database.json`. Filter by `project: [project_name]` AND period.

Report sections:
1. Header: project name, period, run timestamp
2. Executive Summary (totals by class, type, source)
3. CRITICAL Signals (full detail)
4. HIGH Signals (grouped by type)
5. Engagement Activity (touches taken in period)
6. Content Generated (signals that spawned content)
7. Competitive Mentions (competitor names in signals)
8. Recommended Actions (top 5 prioritized)

Save to `./data/reports/signal-report-[YYYYMMDD]-[period].md`
Print to terminal.
