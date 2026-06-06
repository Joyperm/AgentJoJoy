# Progress Tracker — Real Work

> 🎯 **Scope: active project work — branches, PRs, worktrees, in-flight tasks.**
>
> This is the daily-use tracker. The AI's Resume Check Protocol reads
> this file first to understand current work state.
>
> For workspace setup history, AI workflow tweaks, and spec amendments,
> see [`setup-tracker.md`](setup-tracker.md).
>
> Update this file when:
> - A branch is created, pushed, merged, or deleted
> - A PR is opened, reviewed, merged, or closed
> - A worktree is created or removed
> - A task transitions state (started, blocked, completed)
> - Something worth remembering for next session

---

## Current Phase

<!-- AUTO-FILL on intake: e.g. "Onboarding to project X", "Active development", "Maintenance" -->

_(not set)_

## Current Goal

<!-- ASK USER + AUTO-FILL: one or two lines on the current focus -->

_(not set)_

---

## Active Branches

| Branch | Location | Status | PR | Notes |
|--------|----------|--------|----|----|

<!-- AUTO-FILL from `git branch -a` + `gh pr list`. Update after each
     branch operation. -->

_(none yet)_

> Main checkout lives at: _(not set — fill in during intake)_

## Active Worktrees

| Worktree path | Branch | Task | Status |
|---|---|---|---|

<!-- AUTO-FILL from `git worktree list`. Worktrees live as siblings of
     the main checkout under the workspace root, named worktree-<task>. -->

_(none yet)_

---

## In Progress

<!-- One bullet per active task. Move to "Completed" when done. -->

_(no active task)_

## Next Up

<!-- Planned next work. Specific enough to start without re-planning. -->

_(none yet)_

## Completed

<!-- Most recent first. One line per completed task, with date + PR link if relevant. -->

_(empty)_

---

## Open Questions

<!-- Questions raised but unanswered. Surface when natural opportunity
     arises with the relevant person (lead, teammate, stakeholder). -->

_(none yet)_

---

## Recent Actions

> Most recent first. Keep terse — just enough to recover context next
> session. For long explanations, link to setup tracker, a work record,
> or other docs.

<!-- Date-stamped log of meaningful work actions: branch ops, PR
     events, blockers, worktree management, sync events. -->

_(empty — populated after first real work session)_

---

## Where to Find Things (Quick Reference)

| Need | Read |
|---|---|
| Workflow rules (canonical) | [`../agent-rules/workflow-spec.md`](../agent-rules/workflow-spec.md) |
| AI permission gates | [`../agent-rules/ai-workflow-rules.md`](../agent-rules/ai-workflow-rules.md) |
| Operational paths + gotchas | [`../agent-rules/workspace-model.md`](../agent-rules/workspace-model.md) |
| Project overview | [`../agent-context/project-overview.md`](../agent-context/project-overview.md) |
| Architecture | [`../agent-context/architecture.md`](../agent-context/architecture.md) |
| Code / writing standards | [`../agent-context/standards.md`](../agent-context/standards.md) |
| UI context (if applicable) | [`../agent-context/ui-context.md`](../agent-context/ui-context.md) |
| Engagement mode (execute / teach) | [`../agent-context/engagement-mode.md`](../agent-context/engagement-mode.md) |
| Decisions log | [`decisions/`](decisions/) |
| Archived work records | [`work/`](work/) |
| Setup history / spec amendments | [`setup-tracker.md`](setup-tracker.md) |
