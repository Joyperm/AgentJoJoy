# Decisions Log

This folder records significant decisions made during the project's
lifetime — choices that shape direction, constrain future options,
or reflect non-obvious reasoning that future-me (or a new
collaborator) would want to understand.

## When to record a decision here

Record a decision when it meets one or more of:

- **Direction-shaping** — e.g. "chose React over Vue", "use Postgres
  not MongoDB", "monorepo over polyrepo"
- **Constrains the future** — e.g. "no third-party auth, build our
  own", "no premium dependencies until $X revenue"
- **Non-obvious reasoning** — the *why* behind a choice that would
  otherwise look arbitrary
- **Reversal risk** — decisions that are expensive to undo, where
  having the reasoning preserved helps weigh future "should we
  reverse this?" calls

Do NOT record:

- Trivial implementation choices (variable names, file organization
  inside a module)
- Decisions already documented in the team repo (ADRs, RFCs, design
  docs) — link to them instead
- Daily work updates — those go in
  `AgentJoJoy/agent-records/progress-tracker.md`

## File format

One decision per file. Name with the date and a short kebab-case
slug: `YYYY-MM-DD-<topic>.md` — e.g.
`2026-05-25-react-over-vue.md`.

Suggested template (keep it short):

```markdown
# <Decision title>

**Date:** YYYY-MM-DD
**Status:** active | superseded by [<file>] | reversed

## Context
<What situation prompted this decision? 1-3 sentences.>

## Decision
<What was chosen.>

## Reasoning
<Why this option won over alternatives. List the alternatives
considered and the deciding factors.>

## Consequences
<What this constrains or enables going forward.>
```

## Cross-references

When a decision is logged here during active setup, also note it in
`AgentJoJoy/agent-records/setup-tracker.md` → "Resolved Decisions" with a
link. After setup completes, preserve the setup-side index in
`AgentJoJoy/agent-records/setup-history/`; do not copy it into
`AgentJoJoy/agent-records/progress-tracker.md`.
