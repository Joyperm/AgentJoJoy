# Multi-Agent Coexistence Snippet

This file is the canonical snippet that Path 2 intake offers to merge
into the target repo's `CLAUDE.md` / `AGENTS.md` so multi-agent
coexistence rules (branch reservations, code change tags, commit
attribution) are visible to agents working in that repo without
needing the AgentJoJoy wrapper above it.

---

## How to use

1. During Path 2 intake, the AI proposes adding this snippet to the
   target repo's rule files.
2. AI asks the owner which agents will work on this repo (Claude
   Code, Codex, Cursor, Antigravity, others) - multi-select.
3. Based on selection, AI picks the target rule files:
   - Claude Code -> target repo `CLAUDE.md`
   - Codex, Aider, generic agents -> target repo `AGENTS.md`
   - Cursor -> both `CLAUDE.md` and `AGENTS.md` if both exist (Cursor
     surfaces vary; see `AgentJoJoy/template-lab/validation/cursor-walkup-live.md`)
4. AI inserts the snippet body between the marker comments below. If
   the markers already exist, the AI replaces the section between
   them - never duplicates.
5. The agent list inside the snippet body reflects what the owner
   chose. Re-running the step replaces the section, so the agent
   stack can change later.

---

## Marker format

```
<!-- AGENTJOJOY:MULTI-AGENT BEGIN -->
... snippet body ...
<!-- AGENTJOJOY:MULTI-AGENT END -->
```

Both markers must be on their own line. The intake step uses these
markers to locate and replace the existing block idempotently.

---

## Snippet body (template - fill `{AGENTS}` per repo)

```markdown
<!-- AGENTJOJOY:MULTI-AGENT BEGIN -->

## Multi-Agent Coexistence

This repo is worked on by these AI agents: {AGENTS}.

### Branch naming

Follow this repo's existing branch convention. In addition:

- `cursor/...` is reserved for Cursor background agents (auto-created
  by Cursor's agent surface). Do not create one manually even if it
  fits the project's pattern.
- Do not manually create branches under another agent's reserved
  prefix unless explicitly asked.

### Code change tags

When making a meaningful code addition or behavioral change, add a
concise marker near the logical block:

```
// CLAUDE: <short reason>     // TypeScript / JavaScript / Java
# CLAUDE: <short reason>      # Python / Ruby / shell
```

Other agents use their own name: `// CODEX:`, `// CURSOR:`, etc.

- One marker per function, class, or decision block - not per line.
- Skip markers for trivial formatting, renames, or mechanical edits.
- Preserve existing markers when editing nearby code.
- If a different agent materially changes a marked block, update the
  marker so ownership is clear.

### Commit attribution

Append a co-author trailer to every commit so authorship is durable:

```
Co-Authored-By: <Agent Name> [Model] <noreply@<vendor>.com>
```

Examples:

- `Co-Authored-By: Claude [Opus 4.7] <noreply@anthropic.com>`
- `Co-Authored-By: Codex [GPT-5] <noreply@openai.com>`

`[Model]` must reflect the exact model running. If unsure, ask the
owner before committing.

<!-- AGENTJOJOY:MULTI-AGENT END -->
```

---

## Idempotent overwrite logic (for the AI executing the step)

When merging the snippet into a target file:

1. Check whether the file contains `<!-- AGENTJOJOY:MULTI-AGENT BEGIN -->`
   and `<!-- AGENTJOJOY:MULTI-AGENT END -->` on their own lines.
2. If both exist, replace everything between them (markers inclusive)
   with the new snippet body. Do not touch any other content.
3. If only one marker exists or markers are malformed, ask the owner
   to resolve before writing - do not guess.
4. If neither marker exists, append the snippet body at the end of
   the file with a blank line separator.

This makes re-running the step safe: the owner can change which
agents work on the repo and re-run intake without duplicating or
corrupting unrelated content.

---

## What this snippet does NOT carry

The following are workflow-level rules that stay in AgentJoJoy and do
not travel into target repos:

- SPEC-1 through SPEC-9 (permission gates, strategic-choice rules,
  doc hygiene). These are how AgentJoJoy works in any workspace, not how the
  team works.
- Resume Check protocol (T0-T3 classification). Same reason.
- Session handoff file path under `AgentJoJoy/session-handoff.md`.
  Target repos do not host AgentJoJoy state.
- Sync-recommendation table (rebase vs merge rule of thumb). This
  belongs to AgentJoJoy's intake guidance, not the target team's rulebook.

If the owner explicitly wants more of AgentJoJoy's content inside the
target repo, that is a separate decision and is not covered by this
snippet.
