---
name: engage-signals
description: >
  Post LinkedIn comments on detected signal posts. This is the core action skill
  of LinkedinStrategy. Navigates to each LinkedIn post, writes the approved comment,
  posts it, captures the comment URL, and updates the signal record.
  Also handles owned content publishing (Mode B) and DMs (Mode C).
  ALWAYS requires explicit user confirmation before any post or send action.
  Usage: /engage-signals [comments|posts|dms|all]
allowed-tools:
  - mcp__Claude_in_Chrome__navigate
  - mcp__Claude_in_Chrome__read_page
  - mcp__Claude_in_Chrome__find
  - mcp__Claude_in_Chrome__form_input
  - mcp__Claude_in_Chrome__get_page_text
  - mcp__Claude_in_Chrome__computer
  - Read
  - Write
disable-model-invocation: true
---

# Engage Signals

## Step 0 — Load and Confirm Project

Read ./PROJECT.json. If not found: abort with "Run /init-project first."

Print: "LinkedinStrategy — engaging for project: [project_name]"

Mode from $ARGUMENTS: comments | posts | dms | all (default: comments)

---

## MODE A — Post LinkedIn Comments (PRIMARY WORKFLOW)

The core job: navigate to relevant LinkedIn posts and leave high-quality,
context-aware comments that open conversations with potential buyers.

### A1 — Build the Comment Queue

Read ./data/signals-database.json.
Load pre-drafted comments from ./data/content/sequences/ where available.

Include signals where:
- signal_class is CRITICAL or HIGH
- engagement.status is "new" OR touch timing has elapsed:
  - Touch 2 ready: 2+ days since touch 1 timestamp
  - Touch 3 ready: 5+ days since touch 1 timestamp
- engagement.touch_number is 0, 1, or 2

If no sequence file exists for a signal, call /draft-comment [signal_id]
inline to generate the comment before proceeding.

Show the full queue to the user — include person, post excerpt, comment draft,
and character count. Ask: "Post all N comments? Or enter numbers to select:"

Wait for user response before proceeding.

---

### A2 — Per-Signal Posting Loop

For each approved signal, execute this exact sequence:

#### A2.1 — Navigate to the Post

Navigate to [content.url from signal record].
Wait for full page load. Take a screenshot.

Verify the page shows a post by [person.name].
If wrong page, error, or login wall: report to user and skip this signal.

#### A2.2 — Show Post + Comment for Confirmation

Read the actual post text from the page.

Display:
- Author name, title, company
- First 200 chars of actual post text
- The comment draft with character count
- The data anchor used (stat + source) — from the sequence file
- A ⚠ warning if the anchor is framework-based with no external source

Ask: "Post this comment? [yes / edit / skip]"

If the draft has a ⚠ anchor, add an extra prompt:
"Note: this comment has no verified external data anchor.
 Edit the comment or post anyway? [edit / post anyway / skip]"

- "edit" → let user retype the comment
- "skip" → mark signal as skipped, move to next
- "yes" → proceed to A2.3

#### A2.3 — Find the Comment Box

Scroll to the comments section.

Try these in order:
1. Find element: "Add a comment…" placeholder
2. Click the "Comment" button below post reactions, then find the input
3. Find element: text input below the reactions bar

If comment box not found after 2 attempts:
Mark signal as manual-required. Report to user. Move to next signal.

#### A2.4 — Type the Comment

1. Click the comment input to focus it
2. Type the approved comment text
3. Wait 500ms
4. Screenshot showing the typed text in the input box

#### A2.5 — Final Confirmation

Display the full comment text in the response.
Then use the AskUserQuestion tool to show a popup confirmation dialog:
  Question: "Post this comment on [person.name]'s post?"
  Options: ["Post", "Cancel"]

If user selects "Post" → proceed to A2.6.
If user selects "Cancel" → cancel and move to next signal.

#### A2.6 — Post

Click the "Post" button in the comment composer.
Wait 2 seconds. Take a confirmation screenshot.

#### A2.7 — Capture Comment URL

After posting, find the new comment in the comments section.
Click the three-dot menu on the comment.
Copy link to comment if available. Otherwise use the post URL as fallback.

#### A2.8 — Update Records

Write to ./data/signals-database.json:

  engagement.status: "touched"
  engagement.touch_number: N
  actions_taken: append {
    touch: N,
    type: "comment",
    timestamp: ISO-8601,
    text: exact text posted,
    post_url: post URL,
    comment_url: comment URL or post URL,
    char_count: N
  }
  next_step: "Touch N+1 — [follow-up / DM]"
  next_step_date: ISO-8601 (2 days later for T2, 5 days for T3)

Update ./data/content/sequences/seq-[signal_id].md — mark touch as "posted".
Update ./PROJECT.json stats: total_engagements, last_engagement.

Append to ./data/reports/engagement-log.md:

  [timestamp] Touch N on [signal_id]
  Person: [name] @ [company]
  Post URL: [url]
  Comment URL: [url]
  Comment: "[text]"
  Next: [next_step] by [next_step_date]

---

### A3 — Session Cleanup & Summary

After all signals processed:

#### A3.1 — Delete Screenshots

Delete all screenshot files generated during this engagement session
(e.g., sig*-comment-typed.png, sig*-posted.png). These are temporary
artifacts used for user confirmation and should not persist after the session.

#### A3.2 — Print Summary

  COMMENT SESSION COMPLETE — [project_name]
  Posted:  N comments
  Skipped: N
  Errors:  N

  Posted:
    [person] @ [company] — Touch N → [comment_url]
    ...

  Upcoming touches (next 7 days):
    [date] · [person] — Touch N
    ...

---

## MODE B — Prepare LinkedIn Posts for Manual Publishing

Posts are published manually by the user, not automated through the browser.
This mode prepares posts for easy copy-paste publishing.

Scan ./data/content/drafts/ for files with status: approved AND project: [project_name].

For each approved post:
1. Show the full post text formatted and ready to copy
2. Display word count, character count, and hashtags
3. Show the research sources used (for user's reference)
4. Ask: "Mark as ready-to-publish? [yes / edit / skip]"
5. If yes: update file status to "ready-to-publish" and add ready_at timestamp
6. Remind user: "Copy the text above and paste into LinkedIn. After publishing,
   run /post-published [filename] [url] to update records."

Do NOT navigate to LinkedIn or attempt to post automatically.
Do NOT use the browser to type or submit posts.

After the user publishes manually and provides the URL:
- Move file to ./data/content/posts/ with published_url and published_at
- Update PROJECT.json stats

---

## MODE C — Send Direct Messages (Touch 3)

For signals where touch_number is 2 and timing elapsed (5+ days):

1. Load DM text from ./data/content/sequences/seq-[signal_id].md (Touch 3 section)
2. If missing, call /draft-comment [signal_id] to generate it
3. Show DM to user for approval
4. Navigate to [person.profile_url]
5. Click "Message"
6. Type approved DM text
7. Screenshot before sending
8. Use AskUserQuestion tool with popup: "Send this DM to [person.name]?" Options: ["Send", "Cancel"]
9. If "Send" → Click Send. If "Cancel" → skip.
10. Update signal record — if this was Touch 3, set status: fully-engaged

---

## Safety Rules

- Never post without explicit user approval via AskUserQuestion popup
- Never post for a different project than confirmed in Step 0
- Never post the same comment twice on the same signal
- Skip any signal with signal_type: competitor — flag as intelligence-only
- Never name the product in Touch 1 or Touch 2
- If LinkedIn shows a CAPTCHA or login wall: stop immediately, report to user
- Maximum 10 comments per session (LinkedIn rate limiting)
- If LinkedIn shows "posting too fast" warning: stop, tell user to wait 30 min
