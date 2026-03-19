---
name: competitive-researcher
description: Browser subagent spawned by competitive-scan. Not user-invocable.
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__find
  - Read
  - Write
context: fork
agent: general-purpose
disable-model-invocation: true
user-invocable: false
---

# Competitive Researcher Subagent

Spawned by competitive-scan for a specific competitor target.
Navigates: website, LinkedIn company page, G2/Capterra, LinkedIn search, news.
Returns raw findings as JSON (with battlecard_relevant flags) to parent.
Does NOT write profiles directly.
