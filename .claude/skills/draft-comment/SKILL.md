---
name: draft-comment
description: >
  Draft LinkedIn comments for detected signals. Runs targeted web research
  on each signal topic before writing — comments are grounded in data and
  authoritative sources, not opinion. Saves drafts to ./data/content/sequences/.
  Usage: /draft-comment [signal_id|all]
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__find
  - WebFetch
  - Read
  - Write
disable-model-invocation: false
---

# Draft Comment

Research first. Comment second.

Every comment must contain at least one of:
- A specific statistic from a credible source
- A real-world example or pattern observed across multiple companies
- A named framework or methodology with known provenance
- A direct reference to how practitioners in the field actually handle this

Generic opinions ("this is a real challenge", "many companies struggle with this")
are NOT acceptable as the core of a comment. They can appear as connective tissue
only — the anchor must always be a verifiable claim.

---

## Step 0 — Load Project Context

Read `./PROJECT.json` — ICP, content voice, forbidden words.
Read `./CLAUDE.md` — positioning, tone, domain expertise.

Target from $ARGUMENTS: specific signal ID, or all CRITICAL/HIGH signals where
`engagement.status` is `new` or touch timing has elapsed.

Show the queue to user before proceeding:

```
COMMENT QUEUE — [project_name]
────────────────────────────────────────────────────────
[1] sig_001 · CRITICAL · pain
    Person: John Smith, Plant Manager @ Acme Manufacturing
    Post:   "We're drowning in paper travelers and nobody can
             find job history when something goes wrong..."
    Touch:  1 of 3

[2] sig_002 · HIGH · retirement
    Person: Maria Gonzalez, VP Operations @ TechFab Inc.
    Post:   "30-year machinist retiring next month. We have
             no idea how to capture what he knows..."
    Touch:  1 of 3
────────────────────────────────────────────────────────
Research and draft comments for all [N]? [y/n/select]
```

---

## Step 1 — Research Phase (run before drafting any comment)

For each signal, run a focused search to find the single strongest
data point or authoritative reference relevant to the post's topic.

The goal is not comprehensive research — it's finding one sharp, credible
anchor that makes the comment authoritative rather than opinionated.

### Search Strategy by Signal Type

**Type: pain / data-frustration / erp-failure**

Search 1 — quantify the problem:
  `[specific pain from post] manufacturing statistics OR data OR study`
  Example: `"paper traveler" manufacturing error rate OR cost data`
  Goal: find a number that validates the person's pain with external evidence

Search 2 — find a named pattern or root cause:
  `[pain topic] manufacturing root cause OR "common pattern" OR industry`
  Goal: a named concept, framework, or observed pattern with a source

Search 3 — find what works:
  `[pain topic] manufacturing solution approach results OR case study`
  Goal: evidence of what practitioners who solved this actually did

---

**Type: retirement / tribal-knowledge**

Search 1 — workforce data:
  `manufacturing workforce retirement statistics [current year] OR [last year]`
  Goal: % near retirement, timeline, scale of the problem

Search 2 — cost of loss:
  `cost manufacturing knowledge loss retiring worker study OR data`
  Goal: dollar figure or time estimate for knowledge reconstruction

Search 3 — what works:
  `manufacturing knowledge capture methods results OR evidence`
  Goal: what approaches have documented success

---

**Type: question** (asking for tool/approach recommendations)

Search 1 — map the landscape honestly:
  `[tool/approach they asked about] manufacturing results OR ROI OR limitations`
  Goal: what the evidence says, not vendor claims

Search 2 — find the nuance:
  `[topic] manufacturing "depends on" OR "works best when" OR "fails when"`
  Goal: the context-dependent insight that makes the answer non-generic

Search 3 — find a comparison or framework:
  `[topic] manufacturing comparison OR framework OR "how to choose"`
  Goal: a structured way to think about the decision

---

**Type: skepticism** (AI doubts)

Search 1 — validate the concern:
  `AI manufacturing failure OR risk OR "hallucination" industrial data`
  Goal: real documented cases of AI failures in industrial settings

Search 2 — find what actually works:
  `AI manufacturing ROI evidence OR results "small manufacturer" OR "job shop"`
  Goal: specific evidence from comparable companies

Search 3 — find the distinguishing factor:
  `manufacturing AI success factors OR "what makes AI work" industrial`
  Goal: the specific condition that separates working from failing implementations

---

**Type: competitor**

Search 1 — find documented limitations:
  `"[competitor name]" limitations OR problems OR "not designed for" manufacturing`
  Goal: credible third-party evidence of the competitor's gaps (G2, forums, case studies)

Search 2 — find the category distinction:
  `"[competitor name]" vs alternatives manufacturing category OR positioning`
  Goal: how analysts or practitioners distinguish this tool from others

---

**Type: hiring**

Search 1 — find what this role typically signals:
  `"[job title]" manufacturing "first priorities" OR "challenges" OR "what to expect"`
  Goal: what practitioners say about the reality of this role in manufacturing

Search 2 — find relevant context:
  `"[job title]" manufacturing company size challenges data OR survey`
  Goal: data on what this role faces at the company's scale

---

### Source Quality Rules

Accept as authoritative anchors:
- Government data: BLS, Census Bureau, NIST, DoD, DoE
- Major consultancies: Deloitte, McKinsey, BCG, Accenture (manufacturing practice)
- Industry bodies: NAM, SME, AME, APICS, ASQ, AAIM
- Trade publications: Industry Week, Modern Machine Shop, Manufacturing Engineering,
  The Fabricator, Quality Magazine, Production Machining
- Academic: MIT, Purdue, Georgia Tech manufacturing research
- Review platforms: G2, Gartner Peer Insights (for competitor signals)

Accept with caution (note the source explicitly):
- Vendor research reports — use only if methodology is transparent
- Forum posts (LinkedIn) — use only as "practitioners report..." not as data

Reject:
- Anonymous statistics without a traceable original source
- Data older than 4 years (unless foundational/landmark)
- SEO articles that cite other SEO articles

---

### Research Summary Per Signal

After searching, compile a 4-line research summary before drafting:

```
RESEARCH SUMMARY — sig_001
  Best anchor: "74% of manufacturers cite knowledge loss from retiring workers
                as a top operational risk" — Deloitte Manufacturing Study, 2024
  Source URL:  https://...
  Credibility: Tier 1
  How to use:  Lead with the stat to validate their pain, then pivot to the
               specific question about their situation
```

If no credible anchor is found after 3 searches:
- Fall back to a named framework or observed pattern ("In job shops with
  mixed-age workforces, the pattern is usually...")
- Flag the comment as "framework-based, no external data" in the draft file
- Do NOT invent statistics

---

## Step 2 — Draft the Comment

Write each comment using the research summary as its backbone.

### Comment Architecture

Every strong comment follows this structure:
```
[Data anchor or authoritative reference]  ←  the credible hook
[Specific insight that extends it]        ←  your added interpretation
[Open question tied to their situation]   ←  invite dialogue
```

The data anchor appears early — ideally in the first sentence or two.
It does not need to be a formal citation ("according to...") —
it can be woven in naturally:

Good: "74% of manufacturers flag this as their top operational risk — and
the ones who've solved it tend to approach it differently than you'd expect.
Are you capturing the judgment calls, or mostly the documented procedures?"

Bad: "This is a really common challenge that many manufacturers face.
Have you thought about a different approach?"

---

### Touch 1 Comment — Data-Anchored Templates by Signal Type

**Type: pain**
```
[Stat that validates their pain — source woven in naturally]
[The specific insight about WHY it's hard to solve — not the obvious reason]
[Question that surfaces their specific context]
```
Max 280 characters. End with the question.

---

**Type: retirement / tribal-knowledge**
```
[Workforce data point — scale or cost of the problem]
[The distinction between what gets documented vs what doesn't]
[Question about what they're actually trying to preserve]
```

---

**Type: question**
```
[Honest framing: "Depends on [the key variable]"]
[What the evidence says about when each approach works]
[Question that clarifies which situation they're in]
```
Don't give a single answer. Give a conditional one backed by evidence.

---

**Type: data-frustration / erp-failure**
```
[Data point on how common/costly this specific failure mode is]
[The root cause that the data points to — specific, not generic]
[Question about whether that root cause applies to their situation]
```

---

**Type: skepticism**
```
[Acknowledge the concern is legitimate — with evidence]
[The specific condition that determines whether the concern applies]
[Question about their specific use case / risk threshold]
```

---

**Type: competitor** (they're complaining about a tool)
```
[What the data/reviews say about that tool's documented limitations]
[The structural reason — why the tool is built that way, not just "it sucks"]
[Question about what they were actually trying to accomplish]
```
Never name the competing product as inferior unprompted.
Use the data — let the evidence speak.

---

### Touch 2 and Touch 3

**Touch 2:** If they replied to Touch 1, reference their reply specifically.
Add a second data point or a more specific example.
Still ends with a question or a resource offer.

**Touch 3 (DM):** Can be longer (up to 120 words).
Open with a reference to the full exchange.
Offer one concrete, useful resource or observation.
Corello mention is allowed only if genuinely relevant — not as a pitch.

---

## Step 3 — Apply Hard Constraints

Before finalizing each draft:

- [ ] Touch 1: 280 characters or fewer
- [ ] Contains at least one data point, named example, or authoritative reference
- [ ] No forbidden words from PROJECT.json
- [ ] No product name (Touch 1 and Touch 2)
- [ ] No hashtags in comment body
- [ ] Ends with a specific question (Touch 1)
- [ ] Tone matches project voice from CLAUDE.md
- [ ] Does not repeat phrasing from any previous touch on this signal
- [ ] Source credibility is Tier 1 or Tier 2 (or flagged if Tier 3)

---

## Step 4 — Save Draft

Create or update `./data/content/sequences/seq-[signal_id].md`:

```markdown
---
project: [project_name]
signal_id: [id]
person: [name] @ [company]
post_url: [url]
signal_type: [type]
status: draft
generated: [timestamp]
---

## Research Summary
- Anchor: "[stat or reference used]"
- Source: [name], [year], [url]
- Credibility: Tier [1/2/3]
- Fallback used: yes/no (if no credible data found)

## Touch 1 — Comment (Day 0)
Status: draft
Platform: LinkedIn comment on post
Char count: [N]/280
Post URL: [url]
Data anchor: "[the specific stat/reference embedded]"

[COMMENT TEXT]

---

## Touch 2 — [type] (Day 2–3)
Status: pending
[...]

## Touch 3 — DM (Day 6–8)
Status: pending
[...]
```

---

## Step 5 — Summary

```
DRAFTS READY — [project_name]
────────────────────────────────────────────────────────
[N] comments drafted — all grounded in external data

  sig_001 · John Smith  · Touch 1 · 247 chars
            Anchor: Deloitte 2024 (Tier 1) ✓

  sig_002 · Maria Gonzalez · Touch 1 · 198 chars
            Anchor: NAM Workforce Report 2025 (Tier 1) ✓

  sig_003 · David Lee   · Touch 2 · connection note
            Anchor: framework-based (no Tier 1/2 data found) ⚠

Drafts saved to: ./data/content/sequences/
Run /engage-signals to review and post.
```

Flag any comment where no credible external anchor was found —
the user should review those manually before posting.
