# File Ownership Map

This file declares which files in a wrapped AgentJoJoy workspace
belong to the **template** versus the **user**. Used by upgrade flows
to decide what is safe to overwrite when a newer template version is
pulled in.

If you are upgrading a workspace from one AgentJoJoy version to another,
respect these rules. Get the canonical upgrade prompt from the remote public
README or target release README instead of relying on the local root
`README.md`; onboarded workspaces may remove that bootstrap file.

---

## Template-owned (safe to overwrite on upgrade)

These files are part of the template's core behavior. The user should
not normally modify them; if they do, modifications will be overwritten
on upgrade. If you have local tweaks, document them in
`AgentJoJoy/agent-records/decisions/` so an upgrade can re-apply them
deliberately.

- `CLAUDE.md` (workspace root)
- `AGENTS.md` (workspace root)
- `AgentJoJoy/agent-rules/*` — all rule files (SPEC, intake-flow, workspace-model, file-ownership, ai-workflow-rules)
- `AgentJoJoy/agent-templates/*` — optional snippet library / portable inserts
- `AgentJoJoy/skills/README.md`
- `AgentJoJoy/skills/agentjojoy-core-practices/**/*` — core template skills
- `AgentJoJoy/skills/grill-me/**/*` — core template skills
- `AgentJoJoy/skills/pattern-detection/**/*` — core template skills
- `AgentJoJoy/skills/lean-output/**/*` — core template skills
- `AgentJoJoy/workflow-guide.md`
- `AgentJoJoy/workflow-guide-th.md`
- `AgentJoJoy/agent-records/README.md` — records folder guide
- `AgentJoJoy/agent-records/decisions/README.md` — decision format guide only
- `AgentJoJoy/agent-records/work/README.md` — work-record format guide only
- `AgentJoJoy/agent-records/work/work-item-envelope.template.md` — work-record template only
- `CHANGELOG.md` (workspace root)
- `LICENSE` (workspace root)
- `VERSION` (workspace root)

---

## User-owned (never overwrite on upgrade)

These files hold **your project's** content. An upgrade must never
modify them. If a new template version requires a structural change
to one of these, the upgrade should propose a manual migration with
explicit per-section approval — not a file overwrite.

- `AgentJoJoy/agent-records/progress-tracker.md` — your daily work tracker
- `AgentJoJoy/agent-records/setup-tracker.md` — temporary setup/onboarding tracker
- `AgentJoJoy/agent-records/setup-history/` — cold setup/onboarding history
- `AgentJoJoy/agent-records/work/*.md` — your detailed work records, except template/readme files
- `AgentJoJoy/agent-context/*` — everything except files that explicitly say "Set during intake" templates with no user content yet (see Mixed below)
- `AgentJoJoy/agent-records/decisions/*.md` — your project's decision log, except the format-guide `README.md`
- `AgentJoJoy/skills/*` (except core template skills: `agentjojoy-core-practices/`, `grill-me/`, `pattern-detection/`, `lean-output/`, and `README.md`) — your custom project-specific skills
- The wrapped project folder itself (the sibling `<code-or-content>/` directory) — entirely off-limits to template upgrades
- `README.md` (workspace root) — template-provided bootstrap scaffolding only.
  After onboarding, move the README responsibility to `<project-folder>/README.md`
  and remove or explicitly defer cleanup of the root scaffold with owner
  approval.
- Any block of text or code wrapped in `<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN -->` and `<!-- AGENTJOJOY:AI-NO-OVERWRITE END -->` in any file (even inside Template-owned or Mixed files) — these blocks are strictly User-owned and must be skipped and preserved exactly as-is during upgrades.

---

## Mixed (settings — preserve user values while updating structure)

These files use template structure but the user fills specific values.
On upgrade, an AI-driven upgrade should **preserve user-set values**
and only update prose/structure/comments around them.

- `AgentJoJoy/agent-context/project-overview.md` — preserve filled values (Project Name, Type, Stack, etc.); update template sections that are still placeholders.
- `AgentJoJoy/agent-context/architecture.md` — same pattern.
- `AgentJoJoy/agent-context/standards.md` — same pattern.
- `AgentJoJoy/agent-context/ui-context.md` — same pattern.
- `AgentJoJoy/agent-context/domain-language.md` — same pattern.
- `AgentJoJoy/agent-context/engagement-mode.md` — preserve user's chosen mode (`execute` / `teach`); update surrounding prose/notes/example commands.
- `AgentJoJoy/agent-context/technical-precedents.md` — preserve all logged precedents; update template structure/prose if it changed.

---

## Upgrade behavior summary

| Bucket | Action |
|---|---|
| Template-owned | Overwrite with new version after per-file approval (SPEC-3) |
| User-owned | Never touch. Period. |
| Mixed | Diff and ask. Preserve user values; update structure only with approval. |

When in doubt, **ask the user before changing a file**. Drift caused
by manual edits is fine — silent overwrites that lose user work are
not.
