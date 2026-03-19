# LinkedinStrategy — Global Rules

These rules apply across ALL projects using this shared plugin.

## Project Isolation (CRITICAL)

- Every skill MUST read ./PROJECT.json before doing any file I/O
- All reads/writes MUST be scoped to ./data/ of the current working directory
- Never read or write to another project's data/ folder
- Always confirm project name before posting or publishing
- Before any LinkedIn action, print: "Acting for project: [project_name]"

## Engagement Rules

- Never post without explicit user approval
- Never enter credentials — ask user to handle login
- Never engage same person twice in 24 hours
- Max 3 touches per signal per month
- Touch 2: min 2–3 days after Touch 1
- Touch 3: min 5–7 days after Touch 1
- Best LinkedIn posting times (ET): Tue/Wed/Thu 8–10 AM, Tue/Wed 12–1 PM

## Content Rules

- Never name the product in Touch 1 engagement comments
- No hashtags in post body — max 3 at end
- Posts: 150–300 words. Articles: 800–1200 words. DMs: max 120 words
- Always end LinkedIn posts with an open question

## Data Integrity

- Always read before writing — merge, never overwrite
- Mark content_generated: true after /create-content runs on a signal
- Archive published posts from drafts/ to posts/
- Never delete records — use status fields to retire them
- Update PROJECT.json stats after every skill run

## Multi-Project Safety

- If PROJECT.json is missing, STOP and tell user to run /init-project
- Never assume ICP or competitors — always read from PROJECT.json
- Content voice and forbidden words are project-specific — read from CLAUDE.md
