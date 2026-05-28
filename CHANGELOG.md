# Changelog

All notable user-facing changes to AgentJoJoy. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the
project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

For internal template-development history, see the private dev repo.

---

## [Unreleased]

_(no changes yet)_

---

## [v1.2.6] — 2026-05-27 — Public README UX Polish

### Changed
- **Public README first-run flow**: Reworked the public README around GitHub's **Use this template** button as the primary setup path for new workspaces.
- **README discoverability**: Added a short Quick Start near the top, moved the feature overview higher, reduced internal workflow jargon, and clarified that upgrades use the release-tag comparison flow rather than creating a fresh template copy.
- **Cross-platform guidance**: Clarified that the AgentJoJoy workflow can be used across operating systems while bundled helper scripts are currently PowerShell-first and Windows-tested.

---

## [v1.2.5] — 2026-05-27 — TDD Discipline & Upgrade Protection

### Added
- **Test-First / TDD Discipline**: Integrated Test-Driven Development (TDD) principles directly into the AI execution flow. The agent is encouraged to draft or stub reproducing tests (TDD Red Phase) before writing core code or debugging. Added `SPEC-2.5.1` to `workflow-spec.md`, a TDD preference question to the intake flow (`intake-flow.md`), and updated the debug routine in `agentjojoy-core-practices/SKILL.md`.

### Fixed
- **Custom Skills Upgrade Protection**: Refined `file-ownership.md` to classify custom project skills under `AgentJoJoy/skills/` as user-owned (excluding core template skills `agentjojoy-core-practices/` and `grill-me/`), protecting custom skills from being deleted or overwritten during upgrades.
- **Upgrade Cautions**: Added a warning block to the Upgrading section of the README regarding custom skills preservation for pre-v1.2.4 upgrades.

---

## [v1.2.4] — 2026-05-27 — Junction Link Model

### Added
- **Junction Link Workspace Model**: Official support for Directory Junction Links (`mklink /j`) to decouple the AI wrapper files from environments requiring rigid directory placement (such as MetaTrader 5 / MQL5 Experts).
- **Junction Link Safety Rules**: Added safety warnings and step-by-step detaching guidelines inside `workflow-notes.md` to prevent Windows from follow-deleting source code recursively during link removal, directing developers to use `rmdir` on cmd.exe.
- **Onboarding (Intake) Updates**: Integrated the Junction Link layout option into the Path 2 (Existing Projects) intake flow.
- Added documentation for the Junction Link model layout in `workspace-model.md`.

---

## [v1.2.3] — 2026-05-27 — Distraction-Free Mode

### Added
- Option to enable **Distraction-Free Mode** during the guided onboarding (intake) session. If selected, the AI agent dynamically configures VS Code workspace settings (`.vscode/settings.json`) to hide internal AI system files (`AgentJoJoy/`, `CLAUDE.md`, `AGENTS.md`, `progress-tracker.md`, `VERSION`) from the explorer sidebar, keeping the workspace beautifully clean for human developers while remaining 100% operational for AI agents.
- **Surgically Safe Clean Ejection**: Upgraded the clean ejection script (`eject.ps1`) to automatically detect and clean up Distraction-Free exclusions in `.vscode/settings.json` upon ejection. It surgically removes only the AgentJoJoy system exclusions, leaving any other developer-configured settings (like formatters, tab sizes, etc.) 100% untouched. If `.vscode/settings.json` contains no other settings, it is cleanly deleted along with the empty `.vscode/` directory.

## [v1.2.2] — 2026-05-27 — Public Template Cleanup

### Changed
- T0 (Template Development) classification entries are now stripped from the public template during packaging. Public users only see T1/T2/T3 workspace states — T0 is an internal dev concept that was never triggerable in public workspaces.

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
