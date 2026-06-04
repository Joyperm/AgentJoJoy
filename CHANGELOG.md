# Changelog

All notable user-facing changes to AgentJoJoy. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the
project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

For internal template-development history, see the private dev repo.

---

## [Unreleased]

---

## [v2.4.1] — 2026-06-04 — Rule Integrity & Intake-Driven Attribution

### Changed
- **Commit attribution is now intake-driven**: AgentJoJoy no longer treats AI co-author trailers as universal. `standards.md` now records the repo's commit attribution policy, Path 2 intake scans team rules/recent commits before asking, and multi-agent docs/snippets defer to the target repo convention unless the owner/team explicitly enables AI co-author trailers.

### Fixed
- **Public package rule-surface cleanup**: removed internal template-development residue from release-facing docs so copied workspaces only see the normal public workflow. `CLAUDE.md`, `AGENTS.md`, `workspace-model.md`, `workflow-spec.md`, `intake-flow.md`, `progress-tracker-setup.md`, skills docs, and reusable snippets now either hide internal-only guidance during packaging or use public-only wording.

---

## [v2.4.0] — 2026-06-04 — Hook Enforcement Contracts

### Added
- **Hook Enforcement Contracts (`AgentJoJoy/agent-hooks/`)**: added a public docs/template layer for owners who want to mechanize selected AgentJoJoy or project-specific gates. Ships a blank neutral contract template plus Claude Code, Codex, and Antigravity runtime binding notes; no hook scripts, hook configs, installer, CI checks, git hooks, active enforcement, or default enablement are included. Existing AgentJoJoy gates remain sourced in `agent-rules/` / `workflow-spec.md`; `agent-hooks/` only maps optional enforcement contracts back to those rules and supports owner-defined hook contracts with explicit install scope and safety guardrails.

---

## [v2.3.0] — 2026-06-03 — SmartWorker Framework

### Added
- **SmartWorker Framework (`AgentJoJoy/agent-smartworkers/`)**: a runtime-neutral framework for the *single* Main Agent to dispatch a knowledge-requiring worker into a **separate context** and get back only a synthesized result — explicitly **not** multi-agent orchestration. Adds the **SmartWorker** tier to the 3-tier automation taxonomy (mechanical → script; knowledge-requiring + separable → SmartWorker; reusable in-line SOP → Skill), whose canonical definition now lives in `ai-workflow-rules.md` (see the Changed entry below). A SmartWorker's primary value is context isolation, not just cheaper models. AgentJoJoy does not build a subagent runtime — it ships a canonical neutral spec (`smartworker-spec.template.md`) and each Main translates it to its own runtime's native subagent contract (Claude Code / Codex / Antigravity), verifying current syntax from the official source first (Help-First). Includes a required model-tier choice (`inherit | light | strong`, norm-light, no model catalog), a flat no-nesting + read-only-default baseline, and a two-zone template where the governance zone (tier, permission, context scope) is wrapped in `AI-NO-OVERWRITE` so AI cannot silently change a worker's authority while the owner can always override.

### Changed
- **pattern-detection is now a tier router**: on a 3+ repeat it classifies the recurring work and recommends the right tier (script / SmartWorker / Skill) instead of always nudging toward a Skill. Trigger and routing logic live solely in `pattern-detection`; the SmartWorker README points to it as the single source of truth.
- **Worker escalation consolidated to a single source of truth**: the 3-tier automation taxonomy (script / SmartWorker / Skill) is now defined once, canonically, in `ai-workflow-rules.md` ("Work Escalation — Automation Tiers", formerly "Dumb Worker Escalation"). `pattern-detection` and the SmartWorker README now reference that section instead of each restating their own taxonomy table.
- **SmartWorker routing coverage in release-facing docs**: `CLAUDE.md` and `AGENTS.md` now include a SmartWorker / worker-dispatch context bundle, `workflow-guide.md` and `workflow-guide-th.md` explain where SmartWorkers fit, and `skills/README.md` explicitly states that SmartWorkers are not Skills. Release-facing docs also replace stale Worktree Auto-Sync wording with the current read-only Resume Check model.

---

## [v2.2.0] — 2026-06-03 — Configurable Engagement & Lean Output

### Added
- **Lean Output mode + skill (`lean-output`)**: an opt-in output-brevity style — "smaller mouth, same brain" — that compresses delivery (filler, preamble, hedging) only, never reasoning, code, commit/PR correctness, teaching substance, or safety/approval text. Inspired by `JuliusBrussee/caveman` (original local guidance, not vendored). Default OFF; composes with Teaching (teaching stays full, delivery shrinks).

### Changed
- **engagement-mode Autonomy Configuration (preset + toggle)**: `engagement-mode.md` Autonomy Configuration now states an explicit always-on boundary (safety gates + efficiency guards are never toggleable; this surface configures behavior only) and adds owner-controlled behavior toggles — **Teaching box** (preset default: ON in `teach`, OFF in `execute`, with force-on/off overrides) and **Lean Output** (default OFF). The AI never changes the configuration autonomously. Pillar II in `ai-workflow-rules.md` is reconciled: the teaching box is now Teaching-toggle-controlled rather than always-on (still separate from the auto-commit switch).

---

## [v2.1.1] — 2026-06-02 — Code Craft Discipline

### Added
- **Code Craft Discipline (Simplicity First + Surgical Changes)**: Added two code-craft rules to `ai-workflow-rules.md`. **Simplicity First** (under Scope Discipline) requires the minimum code that solves the task — no speculative abstractions, flexibility, configurability, or error handling for impossible cases; choose the simpler approach when several work. **Surgical Changes** (Pillar IV) requires every changed line to trace back to the request — don't improve or refactor adjacent code, match existing style, clean up only the orphans your own change created, never delete pre-existing dead code or touch comments/code you don't understand. A combined always-on entry is front-loaded in the Quick Reference. The two companion principles (Think Before Coding, Goal-Driven Execution) are cross-referenced to existing rules rather than restated.

---

## [v2.1.0] — 2026-06-02 — Main Agent Boundary & AI Trust Discipline

### Added
- **Main Agent Boundary & AI Trust Discipline**: Added Pillar I rules that make the Main Agent the trusted controller for scope, user conversation, safety gates, planning, result review, and automation decisions. External documents, webpages, logs, tool output, worker/model output, and other untrusted content are treated as data rather than authoritative instructions; they cannot grant approval, change scope, request secrets, trigger tools, or disable safety gates unless promoted by the owner, trusted project rules, or explicit Main Agent review.
- **Dumb Worker Escalation**: Added guidance for repeated, mechanical, schema-bound, batchable, or low-judgment work: the Main Agent should recommend a script, checklist command, CLI helper, project skill, small LLM worker, or batch processor instead of spending main-session context as the worker. Worker outputs remain untrusted drafts and must preserve already-handled behavior through Generic Input Handling.

---

## [v2.0.1] — 2026-06-02 — Local-Only Wrapper Repo Setup Guidance

### Changed
- **Local-only wrapper repo setup guidance**: Clarified that when the owner chooses a local-only wrapper repo during initial setup or intake, it tracks wrapper-owned files only, while project-owned folders are ignored unless the owner explicitly says otherwise.

---

## [v2.0.0] — 2026-06-02 — Collaborative Milestones & Workspace Clarity

### Added
- **Milestone Teaching**: For complex work the AI now breaks a task into *milestones* — the smallest slice that is independently verifiable and teaches one concept — and shows a short **teaching box** in chat at each one (why the code works and where it can break), in your conversation language, so you build understanding without slowing down.
- **Milestone Auto-Commit (opt-in, default OFF)**: A new toggle in `engagement-mode.md` lets Claude/Codex make clean *local* checkpoint commits at each approved milestone (pushing always still asks; staging is always explicit, never `git add -A`). Gemini runtimes always fall back to propose-and-approve.
- **Secret Intake Protocol**: A documented, script-free way to bring a secret into the local environment — create the file and add it to `.gitignore` first, enter the value through a masked `Read-Host` prompt, then reference it by env-var name. The AI never asks for or prints a secret value in chat.
- **Generic Input Handling (Dimensions of Variation)**: When building or fixing a tool that processes variable input, the AI handles the input *class* — naming the dimensions of variation and deciding per-axis to handle-or-reject — instead of band-aiding one failing case at a time. Fixes target the root cause for the whole dimension (no special-casing to pass), keep previously-working inputs working, and come with a mandatory regression test (run on-demand).
- **Wrapper Isolation Shield**: intake now proactively keeps the personal wrapper layer out of the project repo — `AgentJoJoy/` is added to the project `.gitignore` (with approval) so AI context can't be accidentally committed/pushed. `.gitignore` only untracks; files stay local for agents to read. Closes a real gap (a single repo initialized at the wrapper root would otherwise sweep `AgentJoJoy/` into project history).

### Changed
- **Front-loaded safety rules**: Added a Quick Reference at the top of `ai-workflow-rules.md` and a Critical Safety Gates block at the top of `AGENTS.md`, both written restriction-before-permission, so agents that only read a file's head still see the hard rules first. Critical Rule 1 now points to its scoped exceptions (Rules 7–9).
- **Tracker conciseness (SPEC-9.1.2)**: The work tracker is kept a short summary; detailed step history lives in the git log (including milestone commits) instead of being transcribed into the tracker.
- **Documentation conciseness pass**: front-loaded and tightened `CLAUDE.md`, `AGENTS.md`, and the Help-First rule (~240 fewer lines, no nuance lost; de-staled commit-attribution examples). New **SPEC-9.4 Documentation Conciseness** codifies "lead with the rule, front-load, concise ≠ lossy" so docs stay readable.

---

## [v1.4.7] — 2026-05-31 — Resume Check Simplification

### Changed
- **Simplified Resume Checks**: Streamlined the startup check process in `CLAUDE.md` and `AGENTS.md` to utilize only read-only CLI commands (like `git status`) instead of running file-writing scripts, resulting in faster and conflict-free onboarding resume sessions.

### Removed
- **Worktree Auto-Sync Script**: Deleted `worktree-auto-sync.ps1` and removed the auto-generated git status table from `progress-tracker.md` to eliminate human/AI edit race conditions and reduce filesystem mutations.

---

## [v1.4.6] — 2026-05-31 — Context Router & Runtime Bridge Discipline

### Added
- **Context-Aware Loading Policy**: Added task-specific context bundles to `CLAUDE.md` and `AGENTS.md` so agents load only the smallest relevant rule/context set for resume, edits, debug, review, onboarding, git/worktree, skills, and release-style tasks. This prevents rigid "read everything every turn" behavior while preserving safety gates and team/project precedence.

### Changed
- **Cursor Runtime Bridge Policy**: Clarified that Cursor wrapper walk-up is the default because it has been live-validated. AgentJoJoy no longer suggests `.cursor/rules/agentjojoy.mdc` or other repo-local bridge files by default; use a local-only bridge only after a real discovery failure, and keep it untracked in team repos unless the owner/team explicitly approves sharing it.
- **Source-of-Truth Routing**: Replaced broad "read all relevant project knowledge" wording with explicit context routing and session reuse guidance: reuse loaded context unless the task type changes, the file may have changed, or the conversation was compacted.

### Removed

---

## [v1.4.5] — 2026-05-31 — Helper Script Hardening & Resume Check Reliability

### Changed
- **Hardened Helper Scripts**: Updated `worktree-auto-sync.ps1` to capture stderr using the system temp directory (preventing untracked file pollution in git status checks), fixed a PowerShell array-count bug, and improved failure details reporting. Improved `eject.ps1` to fall back to a regex-based surgical cleanup of VS Code exclusions when `.vscode/settings.json` contains JSON comments.
- **Aligned Onboarding Guides**: Updated `workflow-guide.md` and `workflow-guide-th.md` to document the **Help-First Command Discipline (Anti-Guessing)** policy and subagent context minimization boundaries.

---

## [v1.4.4] — 2026-05-31 — Anti-Guessing Guardrails & Subagent Context Optimization

### Added
- **Help-First Command Discipline (Anti-Guessing)**: Added a new execution guideline inside `ai-workflow-rules.md` requiring the AI to run help flags (`--help` or `-h`) or read instruction manuals before calling new, unfamiliar, or newly-installed tools/CLIs. This check is enforced as a one-time onboarding action per tool/session to prevent redundant CLI executions, saving context window resources, and defines specific context-minimization criteria for spawning subagents.

---

## [v1.4.3] — 2026-05-30 — Cognitive Scaffolding & Rules Consolidation

### Added
- **3 Onboarding Gateways Table (intake-flow.md)**: Inserted a semantic, fragment-linked Table of Onboarding Gateways (TOC) at the very top of `intake-flow.md` to act as an attention anchor for AI agents, allowing them to instantly locate the correct onboarding path without reading the entire 700+ line document.
- **Security-First Guardrails Warning**: Added a high-priority "Security-First Guardrails Always" warning alert note directly below the onboarding TOC to ensure the AI strictly halts destructive operations, local uncommitted edits, and remote writes during the initial onboarding phase.
- **SOP Discipline via Commit Milestones**: Implemented a pragmatic anti-shortcutting rule inside `ai-workflow-rules.md`. For any complex multi-step standard operating procedure (SOP), the AI must split the work into incremental git commit milestones. The AI must stage and commit the work of each step before editing files or executing commands for the subsequent step, anchoring attention and preventing skipped pre-flight/audit steps due to session familiarity.
- **Skill Sandboxing Safety Rules**: Implemented strict safety containment boundaries in `skills/README.md`, prohibiting custom or project skills from autonomously editing personal credentials, modifying outer wrapper configs, or altering core system rules without explicit and direct human approval.
- **Active vs Passive Skill Discovery Guide**: Codified detailed documentation in `skills/README.md` explaining active skill discovery (auto-scanning files like Claude Code) vs passive directive-based skill discovery (referencing keyword hooks in `CLAUDE.md`/`AGENTS.md` for tools like Cursor/Codex), explaining the unified discovery system's design.

### Changed
- **README & PUBLIC_README Alignment**: Aligned the Features list, Folder Structure descriptions, and What's Done sections in the development `README.md` and the public `PUBLIC_README.md` to reflect all recent cognitive architecture optimizations, including the 4 Pillars, 3 Onboarding Gateways, Consolidated Workspace Model, and Skills Precedence/Sandboxing.
- **4 Pillars of Workspace Governance**: Restructured all safety boundaries, permission gates, and execution limits in `ai-workflow-rules.md` into four logical pillars (Pillar I: Permission Boundaries, Pillar II: Resource Management & Budgets, Pillar III: Scope Discipline, and Pillar IV: Safety & Operational Protections) to optimize context density and attention focus for LLMs.
- **Cognitive Scaffolding & Attention Anchoring**: Added a high-density, semantic Table of Governance Pillars (TOC) with fragment links at the very top of `ai-workflow-rules.md` to serve as a fast cognitive index for AI agents, preventing memory decay.
- **Entry-Point Pointers Realignment**: Updated all safety boundary summaries and reference pointers in `CLAUDE.md` and `AGENTS.md` to cleanly align with the new 4 Pillars organization.
- **Workspace Model & Operations Consolidation**: Consolidated `workflow-notes.md` into `workspace-model.md`, merging conceptual architecture and operational commands into a single, unified workspace source of truth.
- **Table of Workspace & Operations (TOC)**: Integrated a semantic, fragment-linked Table of Workspace & Operations (TOC) at the very top of `workspace-model.md` to serve as a fast cognitive index for AI agents, preventing navigation errors.
- **Relative Path Alignment**: Re-routed all relative links and pointers pointing to `workflow-notes.md` across 10+ core files (including `CLAUDE.md`, `AGENTS.md`, `README.md`, `progress-tracker.md`, `ai-workflow-rules.md`, `intake-flow.md`, and `workflow-spec.md`) to point to the consolidated `workspace-model.md` cleanly.
- **Table of Skill Layers & Priority (TOC)**: Added a semantic, high-density Table of Skill Layers (TOC) with fragment links at the very top of `skills/README.md` as an attention anchor to prevent context decay.
- **5-Step Priority of Precedence Rule**: Codified a strict 5-step rule hierarchy (1. Team rules, 2. Safety gates, 3. Project skills, 4. Personal skills, 5. Model defaults) inside a highly visible warning block in `skills/README.md` to resolve any conflicting instructions between rule sources.

### Removed
- **Removed redundant workflow-notes.md**: Deleted `workflow-notes.md` from the template repository to eliminate file scattering and reduce AI context window bloat.

---

## [v1.4.2] — 2026-05-30 — Safety & Policy Upgrades

### Added
- **Infinite Loop Circuit Breaker**: Introduced the "Rule of Two" loop prevention policy in `ai-workflow-rules.md`. If any terminal command, test execution, or tool call fails twice with a similar error or output, the AI is strictly prohibited from making a third attempt, preventing autonomous "ping-pong" loops.
- **Direct Chat Loop Reflection**: Upon hitting the circuit breaker (2 failures), the AI must immediately halt execution and present a structured "Self-Reflection Loop Interruption" directly in the chat to the user, proposing 2-3 alternative directions.
- **Critical Command Blacklist**: Codified a hard blacklist of destructive git and shell commands (`git clean`, raw `git reset --hard`, local/remote branch deletions, `git push --force`, and `rm -rf` targeting pre-existing folders) that AI is strictly prohibited from running autonomously, even in `execute` mode.
- **Zero-Leak Secrets Policy**: Establishes a zero-leak credentials policy in `ai-workflow-rules.md`. The AI only creates configuration templates (e.g. `.env.example`) or placeholders, letting the user paste the actual secret. Proactively inspects and appends secrets files to `.gitignore` *before* ever writing the file to disk.
- **Hierarchical Data Fetching**: Implemented tiered data-fetching rules in `ai-workflow-rules.md`. For files over 200 lines, the AI must use targeted tools (`grep_search` or line-range views) first rather than reading the entire file. A full-file read on large files is allowed only after a brief 1-line explanation to the user in the chat.

### Changed
- **Optimized Startup File Reads**: Clarified in `CLAUDE.md` and `AGENTS.md` that `AgentJoJoy/agent-context/project-overview.md` is only read during intake/fresh onboarding sessions, resolving a silent contradiction with the 3-tool-call limit.
- **Combined Git State Discovery**: Merged separate git discovery commands (`git status`, `git worktree list`, `git branch --show-current`) inside `CLAUDE.md` and `AGENTS.md` into a single combined shell line, saving tool calls during session startups.
- **Onboarding Secrets Alignment**: Aligned the default secrets protection rule inside `intake-flow.md` with the new **Zero-Leak Secrets Policy** and gitignore check.
- **Blacklist Helper Exemptions**: Added an explicit exception to the `rm -rf` blacklist in `ai-workflow-rules.md` for official AgentJoJoy helper scripts running standard intended clean/ejection parameters.

---

## [v1.4.1] — 2026-05-30 — Scope Discipline & Safety Policies

### Added
- **Strict Tool-Call Budgeting Gates**: Codified a hard ceiling of 3 tool calls for both **Resume Check** and **Review/Audit** tasks inside `CLAUDE.md` and `AGENTS.md` to prevent Thoroughness Overdrive and context window dissolution. The AI must stop and report its findings or ask for permission if the budget is insufficient.
- **5 Core Rules of Scope Discipline**: Formally documented the 5 core rules under `## Scope Discipline` in `ai-workflow-rules.md` (Stop when evidence is sufficient, Trust the first output, No speculative hypotheses, Ask before expanding scope, and Concise reporting) to prevent speculative over-verification.
- **Debug Hypothesis Ledger directive**: Embedded a high-priority link pointing directly to the foundational `Debug Routine` in `agentjojoy-core-practices` from `ai-workflow-rules.md`. Forces AI to log a brief 2-line "Hypothesis Ledger" in the work tracker before writing speculative guess-and-check code trial edits.
- **Multi-Agent Worktree Collision Avoidance**: Introduced a collaborative locking policy in `ai-workflow-rules.md` preventing multiple parallel agents from modifying, switching, or deleting active worktrees owned/declared by another agent, with a strict exception enforced only when receiving explicit, direct instructions from the human owner.

---

## [v1.4.0] — 2026-05-28 — User-Owned Block Protection via AI-NO-OVERWRITE

### Added
- **AI-NO-OVERWRITE tag protection**: Support wrapping custom configurations, codebase rules, or files in `<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN/END -->` HTML comment tags. The AI is prohibited from autonomously modifying anything inside these tags, but may edit protected content when the user explicitly requests it (per SPEC-3.5). Codified as SPEC-3.7.
- **Autonomy Configuration**: Added default, safe autonomy checkboxes inside `AgentJoJoy/agent-context/engagement-mode.md` (wrapped in an `AI-NO-OVERWRITE` block) to allow users to manually customize AI execution limits post-onboarding with zero initial onboarding friction.

### Changed
- **English-first system files**: All system files now use English as the primary language. Thai trigger words (e.g. `เริ่ม onboarding`, `ได้เลย`) are preserved as secondary references in `(Thai: "...")` format for functional detection. Thai prose, UI text, and hardcoded translation blocks have been removed or replaced with dynamic language-adaptive rules.
- **SPEC-3.7 wording clarification**: Updated AI-NO-OVERWRITE rule wording from "strictly off-limits" to "protected from autonomous AI modification" — making it clear that the user can still ask the AI to edit protected blocks (the protection guards against autonomous AI action, not user-directed edits).

---

## [v1.3.1] — 2026-05-28 — Technical Precedents and Gaps Collector Removal

### Added
- **Technical precedents tracking**: Added `AgentJoJoy/agent-context/technical-precedents.md` as a unified, transparent markdown file for AI assistants to read and append local decisions, conventions, and verified workarounds.

### Removed
- **Gaps reporter and collector**: Removed the complex, script-heavy local Gaps Reporter/Collector system (`gap-report-collector.ps1` and `AgentJoJoy/agent-runtime/gaps/` directory) to simplify the template, improve privacy transparency, and remove hidden local file tracking.

---

## [v1.3.0] — 2026-05-28 — Pattern-Detection Meta-Skill for Workflow Automation Awareness

### Added
- **Pattern-detection meta-skill**: Added a new public-facing meta-skill (`AgentJoJoy/skills/pattern-detection/SKILL.md`) that passively scans `Recent Actions` in `progress-tracker.md` and the active session's conversation history for repetitive workflows (3+ times). It nudges the user to formalize the pattern into a custom skill, offering to generate the custom skill skeleton automatically. Wired discoverability into `CLAUDE.md`, `AGENTS.md`, and documented in `AgentJoJoy/skills/README.md`.

### Changed
- **Documented skill discovery model**: Added a short note to `PUBLIC_README.md` (Portable Skills section) and both `workflow-guide.md` and `workflow-guide-th.md` explaining that AgentJoJoy skills do not appear in the `/` command palette. They are discovered by the AI reading the workspace and matching the skill description against the user's request. New skills can be added simply by dropping a folder with a `SKILL.md` into `AgentJoJoy/skills/`. Clarifies the invocation model for users coming from runtime-skill UI mental models (Claude Code/Cowork slash palette).

---

## [v1.2.9] — 2026-05-28 — Scope Discipline

### Added
- **Scope Discipline rule**: New `## Scope Discipline` section in `AgentJoJoy/agent-rules/ai-workflow-rules.md` addressing two common AI-assisted failure modes — human scope creep ("just one more thing" accumulating into a redefined task) and AI scope creep (the AI refactoring adjacent code, adding unsolicited error handling, or making nice-to-have improvements). The rule requires the AI to stay in the lane set by the SPEC-2.1 task restatement, flag drift when detected, surface emergent high-severity issues (security, credentials, data-loss) immediately even if off-scope, and apply mode-aware behavior (strict in `execute`, relaxed mention-only in `teach`, excluded during intake/planning/`grill-me`). `engagement-mode.md` gets a one-line bullet in each mode pointing to the new section. Validated via sandbox-first behavioral testing across 7 scenarios before adoption.

---

## [v1.2.8] — 2026-05-28 — Cross-Locale Helper Reliability

### Fixed
- **PowerShell encoding bug in helper scripts**: `Get-Content` calls in helper scripts did not specify `-Encoding UTF8`. On Windows PowerShell 5.1, the default falls back to the OS ANSI codepage (e.g. `windows-874` on Thai locale), which corrupts multibyte characters such as em-dash (`—`) and emoji (e.g. `🎯`) when reading. When the script then writes back with `-Encoding UTF8`, the corruption becomes permanent in the file. Added explicit `-Encoding UTF8` to all read and write paths in helper scripts. Surfaced when running the helpers on a second Windows machine with a different locale.

---

## [v1.2.7] — 2026-05-27 — Public Doc Link Integrity

### Fixed
- **Workflow guide packaging**: Updated the release packaging script so public releases include `AgentJoJoy/workflow-guide.md` and `AgentJoJoy/workflow-guide-th.md`, matching the README links and file-ownership map.
- **Broken local links in public docs**: Hid internal-only references inside `AGENTS.md`, `CLAUDE.md`, and `AgentJoJoy/skills/README.md` so packaging strips them from public packages. Also corrected the workspace-root link in `AgentJoJoy/agent-context/progress-tracker-setup.md` from `../progress-tracker.md` to `../../progress-tracker.md`.

### Changed
- **Onboarding guides**: Refreshed the English and Thai workflow guides to match the current public setup story: GitHub **Use this template** for new workspaces, upgrade prompt for existing workspaces, opt-in gap reporting, test-first preference, junction links, custom skills preservation, and cross-platform helper-script guidance.

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
- Internal template-development classification entries are now stripped from the public template during packaging. Public users only see reusable workspace states.

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
