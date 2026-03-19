# LinkedinStrategy — GTMProjects
### Self-Contained Installation at /Users/axr/Desktop/GTMProjects/

A Claude Code plugin suite for LinkedIn GTM intelligence:
detect buying signals → draft data-grounded comments → post to LinkedIn
→ generate content → track competitors → produce battlecards.

Everything lives under this one directory.

---

## How It Works

```
/Users/axr/Desktop/GTMProjects/
├── .claude/
│   ├── skills/          ← shared plugin (14 skills)
│   └── rules/           ← global engagement rules
│
├── corello-gtm/         ← Project A (Corello)
│   ├── CLAUDE.md        ← domain context (ICP, voice, competitors)
│   ├── PROJECT.json     ← config + stats
│   ├── launch.sh        ← start Claude Code for this project
│   └── data/            ← ALL data for this project
│
├── scaleup-labs/        ← Project B (created with new-project.sh)
│   └── ...
│
├── install.sh           ← one-time setup
├── new-project.sh       ← add a new project
└── find-legacy-data.sh  ← find data from previous plugin versions
```

Skills are shared across all projects. Data is isolated per project.
Nothing is installed globally (except the Claude in Chrome MCP entry in
~/.claude/settings.json, which Claude Code always reads from there).

---

## Launch

    bash /Users/axr/Desktop/GTMProjects/corello-gtm/launch.sh

Or from terminal:

    cd /Users/axr/Desktop/GTMProjects/corello-gtm
    claude --add-dir /Users/axr/Desktop/GTMProjects

---

## Commands (inside Claude Code)

| Command | Description |
|---|---|
| /gtm-pipeline | Full weekly run — all stages in sequence |
| /scan-signals | LinkedIn + Reddit signal scan |
| /draft-comment [id/all] | Research + draft grounded comments for signals |
| /engage-signals [comments/posts/dms] | Post comments to LinkedIn (core action) |
| /create-content [post/article/newsletter/all] | Research + generate content |
| /competitive-scan [name/all] | Scan competitor intelligence |
| /battlecard [name/all] | Generate sales battlecards |
| /signal-report [today/week/month] | Signal summary |
| /migrate-data [path] | Import data from previous plugin version |

---

## Core Loop

    /scan-signals          detect relevant posts, capture exact URLs
    /draft-comment all     research topic → draft data-grounded comments
    /engage-signals        review drafts + post comments to LinkedIn

---

## Add a New Project

    bash /Users/axr/Desktop/GTMProjects/new-project.sh "ScaleUp Labs GTM"
    bash /Users/axr/Desktop/GTMProjects/scaleup-labs-gtm/launch.sh

---

## Run Two Projects in Parallel

    Terminal 1: bash /Users/axr/Desktop/GTMProjects/corello-gtm/launch.sh
    Terminal 2: bash /Users/axr/Desktop/GTMProjects/scaleup-labs-gtm/launch.sh

Each session is fully isolated. Same skills, different data.

---

## Migrate Existing Data

    bash /Users/axr/Desktop/GTMProjects/find-legacy-data.sh
    # then inside Claude Code:
    /migrate-data [path found above]
