---
name: signal-scanner
description: Browsing subagent spawned by scan-signals. Not user-invocable.
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__find
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__computer
  - Read
  - Write
context: fork
agent: general-purpose
disable-model-invocation: true
user-invocable: false
---

# Signal Scanner Subagent

Browsing subagent for LinkedIn signal detection.
Spawned by scan-signals with target URLs and ICP context from PROJECT.json.

Classify each post against the signal matrix. Tag with content_potential and
content_pillar. Return JSON array of candidates to parent — do not write to database.
