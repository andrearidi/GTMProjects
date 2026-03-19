---
name: create-content
description: >
  Generate GTM content from detected signals. Before writing any post,
  performs deep web research on the topic to ground content in current data,
  real examples, and verified statistics. Reads project voice from PROJECT.json
  and CLAUDE.md. Writes only to ./data/content/.
  Usage: /create-content [post|article|newsletter|all]
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__find
  - Read
  - Write
  - WebFetch
disable-model-invocation: false
---

# Create Content

Research first. Write second. Every piece of content must be grounded in
current data, real examples, and specific facts — not generic observations.

---

## Step 0 — Load Project Context

Read `./PROJECT.json`. Abort if not found.
Read `./CLAUDE.md` for ICP, positioning, voice, forbidden words.
Read `./data/signals-database.json` — select signals where
`content_potential: high` or `medium`, sorted by signal_class DESC.

Target from $ARGUMENTS: `post` | `article` | `newsletter` | `all`
Default if empty: `post`

Show the user the selected signals and confirm before proceeding.

---

## Step 1 — Topic Extraction

For each selected signal, extract the **core topic** to research.

Map signal_type → research angle:

| signal_type         | Research Angle                                                      |
|---------------------|---------------------------------------------------------------------|
| pain                | How widespread is this pain? Industry data, failure rates, costs    |
| retirement          | Stats on workforce aging in manufacturing, knowledge transfer costs |
| data-frustration    | ERP failure rates, paper-based process costs, digitization stats    |
| erp-failure         | ERP implementation failure rates, SMB-specific data                 |
| question            | What are the actual leading approaches? Recent case studies         |
| skepticism          | AI adoption data in manufacturing, ROI evidence, failure patterns   |
| competitor          | Recent coverage of that competitor, known limitations, G2 data      |
| hiring              | What this role signals about the company's direction                |
| funding             | Sector funding trends, what this company is likely building toward  |

Also pull the `content_pillar` tag from the signal — it sets the research frame:
- `tribal-knowledge` → research workforce aging + knowledge loss costs
- `paper-intelligence` → research paper-based process inefficiency data
- `hmlv-complexity` → research job shop / custom manufacturing challenges
- `ai-skepticism` → research AI adoption barriers + evidence of what works
- `operator-empowerment` → research skills gap + automation anxiety in mfg

---

## Step 2 — Deep Research Phase

**Run all searches before writing a single word of content.**

For each topic, execute a structured search sequence. Each sequence is
3–5 searches minimum, using progressively specific queries.

---

### Research Sequence by Pillar

#### Pillar: tribal-knowledge

Search 1 (scale of the problem):
  Query: `manufacturing workforce retirement crisis statistics 2024 2025`
  Goal: find current % of manufacturing workforce near retirement, timeframes

Search 2 (cost data):
  Query: `cost of losing experienced manufacturing worker knowledge transfer`
  Goal: find dollar estimates for knowledge loss, onboarding cost per worker

Search 3 (industry reports):
  Query: `manufacturing skills gap report 2025 Deloitte OR NAM OR McKinsey`
  Goal: credible industry source with specific numbers

Search 4 (real examples):
  Query: `job shop manufacturer "tribal knowledge" problem case study OR story`
  Goal: find a real company story or operator quote

Search 5 (current angle):
  Query: `manufacturing knowledge management AI 2025 results OR ROI`
  Goal: find any current evidence of what's working

---

#### Pillar: paper-intelligence

Search 1 (scale):
  Query: `manufacturing companies still using paper processes percentage 2024`
  Goal: % of manufacturers still paper-based or partially paper-based

Search 2 (cost):
  Query: `paper based manufacturing process cost inefficiency study`
  Goal: cost per error, time spent on manual data entry, error rates

Search 3 (traveler-specific):
  Query: `paper traveler manufacturing job shop problems digitization`
  Goal: specific pain with paper travelers in job shop context

Search 4 (industry data):
  Query: `manufacturing digitization ROI SMB small medium manufacturer data`
  Goal: ROI numbers from digitization in SMB manufacturing context

Search 5 (current news):
  Query: `manufacturing digital transformation 2025 barriers challenges`
  Goal: current framing of why digitization is still hard

---

#### Pillar: hmlv-complexity

Search 1:
  Query: `high mix low volume manufacturing challenges data 2024 2025`

Search 2:
  Query: `job shop custom manufacturing profitability costing accuracy problem`

Search 3:
  Query: `HMLV manufacturer ERP failure or poor fit statistics`

Search 4:
  Query: `custom manufacturing quote accuracy job costing error rate`

Search 5:
  Query: `job shop manufacturing AI tools results case study`

---

#### Pillar: ai-skepticism

Search 1:
  Query: `AI manufacturing adoption barriers concerns 2024 2025`

Search 2:
  Query: `AI hallucination manufacturing industrial risk examples`

Search 3:
  Query: `manufacturing AI ROI evidence results small medium manufacturer`

Search 4:
  Query: `industrial AI vs general AI difference manufacturing context`

Search 5:
  Query: `AI manufacturing skepticism survey data operator trust`

---

#### Pillar: operator-empowerment

Search 1:
  Query: `manufacturing skills gap 2025 statistics unfilled positions`

Search 2:
  Query: `manufacturing worker automation fear survey data`

Search 3:
  Query: `AI augmentation manufacturing worker productivity evidence`

Search 4:
  Query: `new manufacturing worker onboarding time cost industry data`

Search 5:
  Query: `manufacturing operator AI tools adoption success story`

---

### Fetching Sources

For each search, fetch the top 2–3 most credible results:
- Prioritize: NAM, Deloitte, McKinsey, MIT, industry associations,
  peer-reviewed studies, government data (BLS, Census Bureau)
- Accept: major trade publications (Manufacturing Engineering, Industry Week,
  Modern Machine Shop, Quality Magazine)
- Deprioritize: vendor blogs, PR articles, SEO content farms

For each fetched page, extract:
- The specific statistic or finding (with year)
- The source name and URL
- Any direct quote from a practitioner or operator

---

### Research Brief

After all searches, compile a Research Brief before writing:

```
RESEARCH BRIEF — [topic] — [date]
════════════════════════════════════════════

SIGNAL CONTEXT
  Person: [name], [title] @ [company]
  Post:   "[excerpt]"
  Pillar: [pillar]

KEY STATISTICS FOUND
  • [Stat 1] — Source: [name], [year], [url]
  • [Stat 2] — Source: [name], [year], [url]
  • [Stat 3] — Source: [name], [year], [url]

REAL EXAMPLES FOUND
  • [Company/case] — [what happened] — Source: [url]
  • [Quote from practitioner if found] — Source: [url]

CURRENT FRAMING (what's being discussed right now)
  [1–2 sentences on the current conversation around this topic]

GAPS / ANGLES NOT COVERED (content opportunity)
  [What's missing from current coverage that we can add]

CHOSEN POST ANGLE
  [One sentence: the specific insight we'll lead with, grounded in the research]
════════════════════════════════════════════
```

Show the Research Brief to the user before writing.
Ask: "Proceed with this angle? Or adjust?"
Wait for confirmation.

---

## Step 3 — Write the Post

Only write after the Research Brief is confirmed.

Apply the post format that best fits the research findings:

**Format 1 — The Statistic Reframe**
Use when: strong numerical finding that challenges a common assumption.
```
[Surprising stat from research] — [Source, Year]

Most people in [industry] assume [common belief].

The data says something different:
[2–3 specific findings from research, each on its own line]

What's actually driving this:
[Your interpretation — specific, not generic]

[Question that invites the audience's experience]
```

**Format 2 — The Story + Data Combo**
Use when: a real example found in research that illustrates a broader pattern.
```
[Company/situation from research — anonymize if needed]:
[What happened — specific details]

This isn't unusual. [Stat from research] of [ICP segment] face this.

The underlying pattern:
[2–3 bullets from research findings]

The manufacturers getting past it tend to [specific behavior from research].

[Question]
```

**Format 3 — The Counterintuitive Finding**
Use when: research reveals something that contradicts conventional wisdom.
```
The common advice on [topic]: [what everyone says]

What the data actually shows: [finding from research — cite source]

Why the gap exists:
[Explanation grounded in research]

[Implication for the ICP]

[Question]
```

**Format 4 — The Current Problem Brief**
Use when: research reveals the topic is more urgent or widespread than people realize.
```
[Specific number] [ICP companies] are dealing with [problem] right now.
(Source: [credible source, year])

The breakdown:
→ [Finding 1 from research]
→ [Finding 2 from research]
→ [Finding 3 from research]

What makes it hard to solve isn't [obvious reason].
It's [less obvious root cause from research].

[Question]
```

---

### Post Writing Rules

- Every factual claim must come from the Research Brief — no invented stats
- Cite sources inline when using statistics: "(Source: NAM, 2024)"
  or work the attribution into the sentence naturally
- Length: 150–300 words
- No hashtags in body — max 3 at the end, chosen from research keywords
- No forbidden words from PROJECT.json
- No product name in organic posts
- End with a specific, open question tied to the research finding
- Use plain language — no jargon unless the ICP uses it themselves

---

### Post Front Matter

Save to `./data/content/drafts/post-[YYYYMMDD]-NNN.md`:

```yaml
---
project: [project_name]
type: linkedin-post
signal_id: [source signal ID]
content_pillar: [pillar]
format: [1–4]
status: draft
created: [timestamp]
research_sources:
  - url: [source 1 url]
    name: [source name]
    stat: [key stat used]
  - url: [source 2 url]
    name: [source name]
    stat: [key stat used]
---
```

Then the full post text.

---

## Step 4 — Article and Newsletter (if $ARGUMENTS includes these)

Run the same research sequence first.
For articles, run 8–10 searches (deeper) before writing.
For newsletters, research each section topic separately.

Articles and newsletters follow the same research → brief → confirm → write flow.
Save to `./data/content/articles/`.

---

## Step 5 — Final Output

List all generated files with a summary table:

```
CONTENT GENERATED — [project_name]
────────────────────────────────────────────────────────
File                          Type    Signal   Format  Sources
post-20260319-001.md          post    sig_042  F2      3 sources
post-20260319-002.md          post    sig_038  F1      4 sources
article-20260319.md           article sig_042  —       7 sources
────────────────────────────────────────────────────────
All drafts in: ./data/content/drafts/
Review, set status: approved, then run /engage-signals posts to publish.
```

Mark `content_generated: true` on source signals in signals-database.json.
Update `./PROJECT.json` stats: `total_content_generated`.
