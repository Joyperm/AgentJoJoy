# Progress Tracker — Setup / Workspace Meta

> 📋 **Scope: workspace setup, AI workflow, spec amendments, onboarding milestones.**
>
> This is NOT the daily-work tracker. For active branches, PRs,
> worktrees, and tasks in flight, see
> [`../../progress-tracker.md`](../../progress-tracker.md) at the workspace
> root.
>
> Update this file when:
> - The workspace structure changes (folders moved, restructured)
> - `workflow-spec.md` is amended (SPEC additions / refinements)
> - Onboarding milestones occur
> - AI workflow rules evolve
> - Deferred decisions are made or revisited

Source of truth for setup-side decisions. Update after every
meaningful workspace/spec change.

---

## Current Phase

<!-- AUTO-FILL on intake: e.g. "Initial setup", "Onboarding", "Active development" -->

_(not set yet)_

## Current Goal

<!-- AUTO-FILL on intake: one or two lines on the current focus -->

_(not set yet)_

## Active Initiatives

| Initiative | Status | Notes |
|------------|--------|-------|

<!-- AUTO-FILL during work: high-level threads of work the user is on -->

## Completed (workspace/spec milestones)

<!-- Append entries here as milestones complete. Format: "- YYYY-MM-DD: <event>" -->

## Deferred Decisions

<!-- Decisions surfaced but not yet made. Move to "Resolved Decisions" once made. -->

## Resolved Decisions

- 2026-05-27: Resolved Onboarding Guides. Rebuilt generic Thai onboarding guide (`workflow-guide-th.md`) and created English onboarding guide (`workflow-guide.md`) outlining wrapper layout, intake flow, safety rules, dynamic language detection, gap reporting, and core skills.

- 2026-05-27: Resolved Public Release Strategy & Tooling. Decided on a Two-Repository model to isolate private validation logs/local path leakage from the clean public GitHub repository. Created `release.ps1` inside `AgentJoJoy/template-lab/` to automate cleanup and copying.
- 2026-05-27: Resolved Ejection (Clean Delete) system. Added `eject.ps1` script inside `AgentJoJoy/agent-tools/` to cleanly remove wrapper files and folders (`CLAUDE.md`, `AGENTS.md`, `progress-tracker.md`, `AgentJoJoy/`) while keeping the project directory and files intact. Verified on Windows with sandbox validation.
- 2026-05-26: Add Automated Gap Reporter to the roadmap. Adopted the design to automatically log redacted, privacy-safe friction reports during real team-project observations to organically improve the template.
- 2026-05-26: Integrated the Automated Gap Reporter setup into onboarding flows (Path 1 and Path 2), configuration settings in `engagement-mode.md`, and observation rules in `skills/agentjojoy-core-practices/SKILL.md`.
- 2026-05-27: Resolved Gap Report Collector & Sync as a local-only
  utility. It aggregates ignored local reports, blocks export when
  unsafe signals are present, and never implements remote upload/sync.
  Company-machine use remains manual-transfer-only after owner review.
- 2026-05-27: Split Gap Reporter and Gap Collector into separate
  settings. The Reporter may be enabled for redacted local note
  creation while the Collector remains disabled; Path 2 team repos
  default the Collector to disabled unless explicitly approved.
- 2026-05-27: Resolved Dynamic Worktree Auto-Sync as a managed
  `progress-tracker.md` block refreshed by a local read-only PowerShell
  helper during T3 Resume Check. T0 template source refuses sync by
  default to keep reusable templates blank.
- 2026-05-27: Chose compatibility-first AgentJoJoy folder
  restructuring before Ejection design. Use `agent-` prefixes for
  AgentJoJoy-owned utility/context/rule folders to reduce semantic
  collision with team repos. Keep `skills/` unchanged for compatibility.
- 2026-05-27: Moved runtime gap-report state out of source validation
  paths. Gap reports now live under `AgentJoJoy/agent-runtime/gaps/`
  so `AgentJoJoy/template-lab/validation/` can mean source-repo
  validation records only.
- 2026-05-27: Moved source-repo-only development artifacts into
  `AgentJoJoy/template-lab/`, including the T0 marker, template
  development tracker, and validation history. This gives Ejection a
  cleaner boundary between reusable runtime wrapper files and
  template-source lab files.

## Open Questions

<!-- Questions raised but unanswered. Bring to user when relevant. -->

## Session Notes

- 2026-05-26: Added the Automated Gap Reporter initiative to the template development tracker table.
- 2026-05-26: Implemented the Automated Gap Reporter setting, intake prompts, and skill routines, and updated notes for the deferred Thai onboarding guide task.
- 2026-05-27: Added the Gap Report Collector tool and clarified the
  packaging behavior so source-repo validation history is removed
  while the empty local gap-report scaffold remains reusable.
- 2026-05-27: Phase 1 folder restructure moved reusable helper tools
  from `AgentJoJoy/tools/` to `AgentJoJoy/agent-tools/` and updated
  references.
- 2026-05-27: Phase 2 moved reusable snippets and decision logs to
  `AgentJoJoy/agent-templates/` and `AgentJoJoy/agent-decisions/`.
- 2026-05-27: Phase 3 moved local generated gap-report runtime state
  to `AgentJoJoy/agent-runtime/gaps/`.
- 2026-05-27: Phase 4 moved template-source-only artifacts to
  `AgentJoJoy/template-lab/`.
