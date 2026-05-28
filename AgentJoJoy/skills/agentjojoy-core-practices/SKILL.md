---
name: agentjojoy-core-practices
description: Portable personal core practices for debugging, review, post-mortems, and stakeholder communication. Use when the user reports a bug/error/failure/flaky behavior, asks to review/audit/sanity-check an existing plan/PR/diff/design/proposal, asks for an RCA/post-mortem after a validated fix, or asks to rewrite technical work for management, PMs, Slack, email, standup, or meeting talking points. For open-ended brainstorming or unresolved plans, prefer grill-me. Inspired by thananon/9arm-skills; this file is an original local routing layer, not a vendored copy.
---

# AgentJoJoy Core Practices

Portable entry point for work patterns that should follow the user
across Codex, Claude Code, Cursor, and future agents.

## Provenance

This skill is inspired by the public `thananon/9arm-skills` repository:

- Source: https://github.com/thananon/9arm-skills
- Upstream skills observed: `debug-mantra`, `scrutinize`,
  `post-mortem`, `management-talk`
- This file is an original adaptation/routing layer for AgentJoJoy.
  Do not assume upstream content is vendored in this repo unless a
  separate licensed copy or submodule is present.

If a local full copy is installed, prefer reading it for exact upstream
wording and examples:

- Codex: `%USERPROFILE%\.codex\skills\<skill-name>\SKILL.md`
- Claude Code: `%USERPROFILE%\.claude\skills\<skill-name>\SKILL.md`
- Workspace mirror, if added later:
  `AgentJoJoy/vendor/9arm-skills/skills/...`

## Routing

Use the smallest matching routine.

On the first response of a session, name the active routine so the
owner can verify the routing ("Applying Debug Routine",
"Applying Scrutinize Routine", etc).

If the prompt is ambiguous between an existing-artifact routine
(Debug / Scrutinize / Post-Mortem / Management-Talk) and an
open-ended interview (`grill-me`), ask one short clarifying question
before committing to a routine. Do not pick silently.

### Debug Routine

Use when something is broken, failing, throwing, flaky, or unexpected.

1. Reproduce first. Capture exact steps, input, environment, and a
   fast pass/fail signal. Prefer writing a reproducing automated unit or
   integration test first as the pass/fail signal (TDD Red Phase) where applicable.
   If there is no repro, stop and ask for artifacts or access.
2. Trace the fail path before proposing a fix. Prefer debugger or
   direct execution trace; otherwise trace source paths and list every
   config, input, feature flag, timing, or environment knob that could
   change the result.
3. Falsify the leading hypothesis. Name what would disprove it, then
   run the disproof before committing to the explanation.
4. Keep a short experiment ledger. For every run, record what changed,
   what happened, and what it ruled in or out.

Do not propose or implement a fix before the repro and fail path are
credible.

### Scrutinize Routine

Use when reviewing an existing plan, PR, diff, design, architecture
choice, or proposed change. If the owner wants an interview to shape an
unsettled idea before there is an artifact to review, prefer
`grill-me`.

1. State the intended goal in one sentence. If the intent is unclear,
   stop and ask.
2. Ask whether a simpler, smaller, or already-existing approach would
   solve the same problem with less risk.
3. Trace the real path end to end, not only the edited lines:
   entry point, call sites, branches, state changes, side effects, and
   return/error behavior.
4. Verify every claim against the traced path. Look for edge cases,
   silent contract changes, partial failures, concurrency, empty data,
   large data, and missing tests.
5. Report findings by severity with evidence and a concrete suggested
   change. If nothing is found, say what was traced and what residual
   risk remains.

### Post-Mortem Routine

Use only after a bug fix is known and validated.

Required inputs before drafting:

- Reliable repro exists.
- Root cause is known, not guessed.
- Fix is identified by PR, commit, branch, or patch.
- Validation proves the original failure now passes.

If any input is missing, list what is missing and stop. Do not write a
post-mortem for a hypothesis.

Default structure:

1. Summary
2. Symptom
3. Root cause
4. Why it produced the symptom
5. Fix
6. How it was found
7. Why it slipped through
8. Validation
9. Action items or "None"

Keep it blameless, concrete, and honest about validation coverage.

### Management-Talk Routine

Use when technical work needs to become a leadership, PM, release,
Slack, email, standup, or meeting update.

1. Confirm the channel if unclear.
2. Preserve product names, customer/workload identifiers, ticket IDs,
   PR links, owners, status, risk, and next steps.
3. Remove function names, file paths, structs, commit hashes, line
   numbers, and low-level implementation details unless the audience
   explicitly needs them.
4. Translate mechanism into plain cause-and-effect without dumbing it
   down.
5. Shape output to the channel:
   - Slack: one TL;DR plus two to four short bullets.
   - Standup: one to three direct lines.
   - Email: subject plus two or three short paragraphs.
   - Meeting: speakable bullets.
   - Ticket/status report: structured scan-friendly sections.

Never invent impact, owner, status, dates, validation, or next steps.

### Technical Precedents Logging

Use automatically during a session if the AI resolves a technical blocker, implements an environment-specific workaround, traces unexpected behavior, or locks in a technical design pattern.

1. **Identify the Precedent**: When you successfully debug a problem, find a workaround for shell execution issues, or choose a coding pattern, identify the core lesson/rule.
2. **Log to File**: Append a concise, single-line entry under the `## Validated Precedents` section of `AgentJoJoy/agent-context/technical-precedents.md` in this format:
   `- **[Area]**: [Validated Fact / Workaround] (Date: YYYY-MM-DD, Commit/Context: <ref_or_none>)`
3. **Keep it Clean**: Do not log duplicates. Maintain the existing entries.
4. **Announce**: Notify the user in your response that you have updated `technical-precedents.md` with the new precedent (e.g. "📝 Added to technical precedents: [Area]...").

## Operating Rules

- Prefer these routines as defaults for all projects, not only coding
  work. The same discipline applies to research, writing, planning,
  operations, and decision review.
- If upstream `9arm-skills` is installed locally and the user asks for
  exact 9arm behavior, read the relevant local `SKILL.md`.
- If only this file is available, use these routines directly; do not
  fetch the upstream repo unless the user asks for the latest version.
- Keep attribution when documenting this core layer publicly.
