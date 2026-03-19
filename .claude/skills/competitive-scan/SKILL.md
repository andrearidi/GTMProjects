---
name: competitive-scan
description: >
  Scan competitor intelligence for the current project. Reads competitor list from
  PROJECT.json. Writes only to ./data/competitive/. 
  Usage: /competitive-scan [competitor_name|all]
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__find
  - Read
  - Write
context: fork
disable-model-invocation: false
---

# Competitive Scan

## Step 0 — Load Project Context

Read `./PROJECT.json`. If not found: abort.

Extract `config.competitors` — this is the scan target list for this project.
If $ARGUMENTS specifies a competitor, scope scan to that one.
If $ARGUMENTS is empty or "all", scan all competitors in the list.

---

## Phase 1 — Per-Competitor Intelligence

For each target competitor:

**1a — Website:** homepage positioning, pricing page, changelog
**1b — LinkedIn:** `https://linkedin.com/company/[slug]` — posts, job postings, follower count
**1c — G2/Capterra:** recent reviews (last 90 days) — top praised + top complaints
**1d — LinkedIn mentions:** `"[competitor]" [project ICP industry]`
**1e — Funding/News:** recent funding, acquisitions, partnerships

---

## Phase 2 — Update Profile

Read `./data/competitive/profiles/[competitor].json`.
If not found, create from scratch using the standard schema.

Merge findings into `intelligence_log`. Flag `battlecard_relevant: true` where applicable.
Write back to `./data/competitive/profiles/[competitor].json`.

---

## Phase 3 — Detect New Competitors

Search: `[project ICP industry] AI platform 2025 OR 2026 startup`
And: `[core pain from PROJECT.json ICP] software`

For new names (2+ appearances), create stub in `./data/competitive/profiles/emerging/`.

---

## Phase 4 — Summary

Print: project name, competitors scanned, new findings, battlecard-relevant count,
emerging threats. Suggest `/battlecard [name]` if high-value findings exist.
