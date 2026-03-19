# LinkedinStrategy — Architecture

## Self-Contained Design

Everything lives under /Users/axr/Desktop/GTMProjects/.
The only external dependency is Claude Code itself (installed via npm)
and one line in ~/.claude/settings.json for the Claude in Chrome MCP.

## Why --add-dir

Claude Code loads skills from two locations:
1. ./claude/skills/ in the current working directory
2. ~/.claude/skills/ globally

To keep skills self-contained (not in ~/.claude/), each project's launch.sh
passes --add-dir /Users/axr/Desktop/GTMProjects to Claude Code. This tells
Claude Code to also load .claude/skills/ from the GTMProjects root.

Result: skills are shared, data is isolated, nothing goes global.

## Directory Layout

    /Users/axr/Desktop/GTMProjects/          ROOT
    │
    ├── .claude/
    │   ├── skills/                          14 shared skills
    │   │   ├── scan-signals/SKILL.md
    │   │   ├── draft-comment/SKILL.md       ← research + comment drafting
    │   │   ├── engage-signals/SKILL.md      ← LinkedIn posting workflow
    │   │   ├── create-content/SKILL.md      ← research + content generation
    │   │   ├── competitive-scan/SKILL.md
    │   │   ├── battlecard/SKILL.md
    │   │   ├── signal-report/SKILL.md
    │   │   ├── gtm-pipeline/SKILL.md        ← full orchestration
    │   │   ├── init-project/SKILL.md
    │   │   ├── migrate-data/SKILL.md
    │   │   ├── research-topic/SKILL.md      ← web research subagent
    │   │   ├── signal-scanner/SKILL.md      ← browsing subagent
    │   │   ├── content-writer/SKILL.md      ← writing subagent
    │   │   └── competitive-researcher/SKILL.md
    │   └── rules/
    │       └── gtm-global.md               ← always-active rules
    │
    ├── corello-gtm/                         PROJECT A
    │   ├── CLAUDE.md                        ← domain context
    │   ├── PROJECT.json                     ← ICP + competitors + stats
    │   ├── launch.sh                        ← cd here + claude --add-dir ..
    │   └── data/
    │       ├── signals-database.json
    │       ├── content/
    │       │   ├── drafts/                  ← pending approval
    │       │   ├── posts/                   ← published
    │       │   ├── articles/
    │       │   └── sequences/               ← per-signal comment drafts
    │       ├── competitive/
    │       │   ├── profiles/                ← JSON per competitor
    │       │   ├── battlecards/
    │       │   └── reports/
    │       └── reports/
    │
    ├── [project-b]/                         PROJECT B (new-project.sh)
    │   ├── CLAUDE.md
    │   ├── PROJECT.json
    │   ├── launch.sh
    │   └── data/
    │
    ├── install.sh
    ├── new-project.sh
    ├── find-legacy-data.sh
    ├── README.md
    └── ARCHITECTURE.md

## Pipeline Flow

    /gtm-pipeline
        │
        ├─ /scan-signals ──────────────────► data/signals-database.json
        │       │                            (with post URLs, content_potential)
        │
        ├─ /draft-comment all ─────────────► data/content/sequences/
        │       │                            (3 searches per signal,
        │       │                             Tier 1/2 source required,
        │       │                             data anchor embedded in draft)
        │
        ├─ /create-content all ────────────► data/content/drafts/
        │       │                            (5+ searches per pillar,
        │       │                             Research Brief confirmed before writing)
        │
        ├─ /competitive-scan all ──────────► data/competitive/profiles/
        │
        └─ /battlecard all ────────────────► data/competitive/battlecards/

    Then (human-in-the-loop):
        /engage-signals comments ──────────► posts comments to LinkedIn posts
        /engage-signals posts ─────────────► publishes approved LinkedIn posts

## How Skills Stay Project-Isolated

Every skill starts with:
    Read ./PROJECT.json
    If not found → abort

All file I/O is relative to ./  (the current working directory = project folder).
Skills never construct absolute paths. They never reference other project folders.
The --add-dir flag loads the shared skills but does not change the working directory.

## What Is NOT Self-Contained

- Claude Code binary: installed globally via npm
- ~/.claude/settings.json: Claude Code always reads MCP config from here
  (one entry: Claude_in_Chrome MCP server)
