# Changelog

All notable user-facing changes to AgentJoJoy. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the
project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

For internal template-development history, see the private dev repo.

---

## [Unreleased]

_(no changes yet)_

---

## [v1.2.2] — 2026-05-27 — Public Template Cleanup

### Changed
- T0 (Template Development) classification entries are now stripped from the public template during packaging. Public users only see T1/T2/T3 workspace states — T0 is an internal dev concept that was never triggerable in public workspaces.
- T0 signal in `intake-flow.md` generalized to match both public and private dev remotes without exposing the dev repo name.

### Added
- `AGENTJOJOY:DEV-ONLY` marker system in `release.ps1` — any content wrapped in `<!-- AGENTJOJOY:DEV-ONLY BEGIN/END -->` markers is automatically stripped from `.md` files during packaging. Used for T0 sections; extensible for future dev-only content.

---

## [v1.2.1] — 2026-05-27 — On-Demand Learning Patterns

### Added
- `engagement-mode.md` documents three on-demand learning patterns the AI honors in `teach` mode (or in `execute` mode if explicitly requested): **AI proposes / you type** (for muscle memory while learning), **Skeleton only / you fill** (you write the details), and **Tutor-first / code after** (concept walkthrough before any code lands). These are session-level requests — no workspace setting to configure. Origin: a learning-mode pattern from an earlier private workspace iteration; restored here without adding intake friction.

---

## [v1.2.0] — 2026-05-27 — Upgrade Story Phase 1

### Added
- `VERSION` file at workspace root so installed workspaces can identify their template version.
- `AgentJoJoy/agent-rules/file-ownership.md` — explicit map of which files in a wrapped workspace are template-owned (safe to update), user-owned (never overwrite on upgrade), or mixed (preserve user data while updating structure).
- `Upgrading` section in README with a canonical prompt you can paste into your AI assistant to upgrade an existing workspace to a newer template version. The prompt includes an offline/no-network fallback that lets you specify a local clone of the target tag as the source.
- `CHANGELOG.md` (this file) shipped with the public template so users always have release history alongside their workspace.

---

## [v1.1.0] — 2026-05-27 — Transparency & Self-Service

### Added
- **Privacy & Local-First Guarantees** section in the README — explicitly states what the AI may write to your workspace, what it never does (no telemetry, no uploads, no background daemons), and how to inspect or delete your data.
- **Gap Collector self-service actions** for `gap-report-collector.ps1`:
  - `-Action list` — tabular view of all gap reports.
  - `-Action summarize` — group by category, show recent patterns, ends with an opt-in invitation to share a redacted summary upstream via GitHub issue.
  - `-Action purge -Force` — delete all gap reports and collector outputs in one command.
- **Per-write gap-report announcements** — the AI now announces every gap report it writes during a session with a one-line note (e.g. `📝 Noted as gap report: gap-20260527-094530.md (redacted)`). No more silent writes after the initial opt-in.

### Changed
- `engagement-mode.md` clarifies the Automated Gap Reporter is an **in-session AI routine**, not a background daemon, and links the inspect/manage commands directly.

### Fixed
- Release pipeline no longer leaks template-source decision logs into the public template's `agent-decisions/`. Only the format guide `README.md` ships now; your future workspace decisions accumulate normally.

---

## [v1.0.0] — 2026-05-27 — First Public Release

Initial release of the generic AI workspace wrapper.

### Features
- **Pattern (b) wrapper layout** — keeps assistant context sibling to your codebase so private files never leak into git history.
- **Auto-load entry points** — `CLAUDE.md` and `AGENTS.md` load automatically in Claude Code and Cursor, with walk-up from subdirectories.
- **Two onboarding paths** — Path 1 (scaffolded new project) or Path 2 (read-only scan of an existing repo).
- **Dual engagement modes** — toggle between `execute` (terse, result-focused) and `teach` (pair programming with reasoning).
- **Multi-agent coexistence rules** — clean coordination when Claude Code, Codex, Cursor, or Gemini work side by side.
- **Privacy-first Automated Gap Reporter** — opt-in only, captures redacted workflow friction locally with no remote sync.
- **Dynamic Worktree Auto-Sync** — refreshes a managed git-state block in `progress-tracker.md` at session resume using read-only git commands.
- **Portable Skills** — drop-in `SKILL.md` routines for debugging, code review, root-cause analysis, and structured design interviews.
- **Bilingual onboarding** — English and Thai guides.
- **MIT License** — free to use, modify, and distribute.
