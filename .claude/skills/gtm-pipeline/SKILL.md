---
name: gtm-pipeline
description: >
  Run the full GTM pipeline for the current project: scan signals, generate content,
  scan competitors, generate battlecards, produce unified report.
  Use for weekly GTM runs: /gtm-pipeline
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__find
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__computer
  - Read
  - Write
  - Task
disable-model-invocation: false
---

# GTM Pipeline — Full Orchestration

## Step 0 — Load & Confirm Project

Read `./PROJECT.json`. If not found: "No project. Run /init-project first." Abort.

Print: "Running full GTM pipeline for: **[project_name]**"
Show: last_scan date, last_engagement, total_signals so far.
Ask: "Proceed?" — wait for confirmation.

---

## Pipeline Execution

```
Step 1: /scan-signals         (LinkedIn feed + search)
Step 2: /draft-comment all    (generate comment drafts for CRITICAL/HIGH signals)
Step 3: /create-content all   (research-first: deep web search per signal → Research Brief → post)
Step 4: /competitive-scan all (parallel with step 3 if possible)
Step 5: /battlecard all       (if competitive-scan found new findings)
Step 6: Unified pipeline report

Then separately (human-in-the-loop):
Step 7: /engage-signals comments  (review drafts + post comments)
Step 8: /engage-signals posts     (publish approved LinkedIn posts)
```

All steps read/write to `./data/` of the current project only.

---

## Step 5 — Unified Pipeline Report

Save to `./data/reports/pipeline-[YYYYMMDD].md`

Content:
1. **Project:** [name], run timestamp, duration
2. **Signal Intelligence:** totals by class, top signal, competitor mentions
3. **Content Generated:** posts/articles/newsletters/sequences drafted
4. **Competitive Intelligence:** profiles updated, new findings, emerging threats
5. **Recommended Actions:** 🔴 Today / 🟡 This Week / 🟢 This Month
6. **Content Queue:** table of drafts to approve and their recommended post days

Update `./PROJECT.json` stats after report generation.

Print report. Ask: "Review drafts or go to /engage-signals?"
