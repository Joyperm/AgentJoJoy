# AgentJoJoy — Generic AI Workspace Template

A workspace template for working with AI coding assistants (Claude Code, Codex, Cursor, Gemini) across multiple projects — both brand-new projects and existing repositories. Designed to feel like working with a **senior dev mentor** who knows when to just execute and when to teach.

---

## Concept

Each project gets its own **wrapper folder** containing:

- The actual project content (a git repo, docs, anything)
- A `AgentJoJoy/` sibling holding personal AI context
- A central `CLAUDE.md` / `AGENTS.md` at the root that drives the AI

### Context & Tool Mapping

| Context | Tool | Entry Point | Onboarding Path |
| :--- | :--- | :--- | :--- |
| **Team repo (work)** | Claude Code + Cursor | `CLAUDE.md` + `AGENTS.md` | Path 2 + English default |
| **Personal project** | Claude / Codex / Gemini | `CLAUDE.md` / `AGENTS.md` | Path 1 + preferred language |

---

## Workspace Lifecycle

The template automatically detects the workspace state at session start:

```mermaid
graph TD
    A[Start Session in Workspace] --> B{Classify State}
    B -->|T1: Un-onboarded Wrapper| D{Choose Onboarding Path}
    B -->|T2: Onboarding Started| E[Resume Intake Flow]
    B -->|T3: Fully Onboarded| F[Resume Check Protocol]

    D -->|Path 1: New Project| G[Scaffold & Auto-fill templates]
    D -->|Path 2: Existing Project| H[Read-only scan & Pre-fill templates]
    D -->|Skip| I[Bypass Onboarding for Session]

    F --> J[Check Git Status & progress-tracker.md]
    J --> K[Ask to continue active task or start new task]
```

### Onboarding Paths (Intake Phase)

- **Path 1 — New project**: AI asks minimal questions, proposes a folder structure, and scaffolds empty templates.
- **Path 2 — Existing project**: AI scans the project read-only (README, manifests, git status), extracts context, fills metadata, and proposes a portable rules snippet for the target repo.

### Daily Session (Resume Phase)

When a session starts in a fully onboarded workspace (**T3**), the AI reads `progress-tracker.md`, checks git status, reports active worktrees/branches, and asks whether to resume the current task or start a new one.

---

## Git Sync Strategies

When the upstream base branch (`main`) moves while you have work in progress, AgentJoJoy helps you choose the best sync strategy:

- **Merge** — preserves history. Recommended when task commits are already pushed or under PR review.
- **Rebase** — replays commits onto the latest `main`. Recommended when task commits are local-only and clean.
- **Squash & Rebase** — collapses noisy WIP commits into one before replaying. Recommended for messy/WIP local work.

See [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md) for the full decision guide.

---

## Folder Structure

### Daily Tracking
- [`progress-tracker.md`](progress-tracker.md) — central list of active branches, worktrees, tasks in progress, and next steps. Read first by the AI.

### Project Metadata (AI-fillable)
- [`AgentJoJoy/agent-context/project-overview.md`](AgentJoJoy/agent-context/project-overview.md) — project identity, type, stack, work areas.
- [`AgentJoJoy/agent-context/architecture.md`](AgentJoJoy/agent-context/architecture.md) — codebase architecture, invariants, boundaries (optional).
- [`AgentJoJoy/agent-context/standards.md`](AgentJoJoy/agent-context/standards.md) — code style and testing guidelines.
- [`AgentJoJoy/agent-context/ui-context.md`](AgentJoJoy/agent-context/ui-context.md) — UI framework context (optional).
- [`AgentJoJoy/agent-context/domain-language.md`](AgentJoJoy/agent-context/domain-language.md) — project-specific glossary (optional).

### Workflow & AI Rules
- [`CLAUDE.md`](CLAUDE.md) / [`AGENTS.md`](AGENTS.md) — entry points that load automatically and define session start protocols.
- [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) — canonical SPEC-1 to SPEC-9 rules.
- [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) — AI permission boundaries.
- [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) — step-by-step Path 1 / Path 2 onboarding guide.
- [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) — wrapper, team repo, and worktree ownership model.
- [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md) — branch sync recommendations and operational tips.
- [`AgentJoJoy/workflow-guide.md`](AgentJoJoy/workflow-guide.md) — English onboarding manual.
- [`AgentJoJoy/workflow-guide-th.md`](AgentJoJoy/workflow-guide-th.md) — Thai onboarding manual.
- [`AgentJoJoy/agent-tools/`](AgentJoJoy/agent-tools/) — local helper tools (Gap Reporter, Clean Ejection script, Worktree Auto-Sync).
- [`AgentJoJoy/agent-templates/`](AgentJoJoy/agent-templates/) — reusable snippets and portable inserts.
- [`AgentJoJoy/agent-decisions/`](AgentJoJoy/agent-decisions/) — key decisions log.

### Portable Skills (SKILL.md)
- [`AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md`](AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md) — portable routines for Debugging, Code Review, Root Cause Analysis, and Management-Talk rewriting.
- [`AgentJoJoy/skills/grill-me/SKILL.md`](AgentJoJoy/skills/grill-me/SKILL.md) — structured design interview for vague plans.

---

## How to Use

### Option A — Initialize Directly via AI (Recommended for Empty Folders)

If you're starting a new project in a completely empty folder, you don't need to copy files manually. Just open your AI assistant (Claude Code or Cursor) in the empty folder and paste this prompt:

```text
Please clone the AgentJoJoy template here, move the files to the root, clean up template-only artifacts, and initialize a new project workspace.

Commands to run:
1. git clone https://github.com/Joyperm/AgentJoJoy.git temp_jojoy
2. Move all files from temp_jojoy/ to current directory (including hidden files)
3. Remove-Item -Recurse -Force temp_jojoy, .git
4. Read CLAUDE.md / AGENTS.md and start the onboarding intake flow.
```

The AI will execute these commands, load the workspace rules, and guide you through onboarding.

### Option B — Manual Folder Copy

1. Clone or download this repository, then copy the wrapper folder to your desktop or workspace and rename it to your project name.
2. Open Claude Code (or Cursor) at the workspace root.
3. The AI detects an uninitialized workspace and prompts you to choose **Path 1** (new project) or **Path 2** (existing project).
4. Answer the brief onboarding questions and choose your engagement mode (`execute` or `teach`).
5. The AI fills the metadata templates and configures the workspace.

### Ejecting the Wrapper

To return a workspace to its normal, unwrapped state (e.g., before sharing or removing the personal AI operating layer):

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/eject.ps1 -Action eject
```

This deletes the `AgentJoJoy/` directory, `CLAUDE.md`, `AGENTS.md`, and `progress-tracker.md`.

---

## Features at a Glance

- **Pattern (b) wrapper layout** — keeps assistant context sibling to codebase repos so private files never leak into git history.
- **Auto-load rules** — entry files load automatically for Claude Code and Cursor (with walk-up from subdirectories).
- **Dual engagement modes** — toggle between `execute` (result-focused, terse) and `teach` (pair programming, explains reasoning).
- **Multi-agent coexistence** — clean coordination when Claude Code, Codex, Cursor, or Gemini work side by side.
- **Privacy-first Gap Reporter** — captures redacted workflow friction locally with no remote sync.
- **Dynamic Worktree Auto-Sync** — refreshes a managed git-state block in `progress-tracker.md` at session resume.
- **Portable Skills** — drop-in `SKILL.md` routines for debugging, review, root-cause analysis, and structured design interviews.

---

## License

[MIT License](LICENSE) © 2026 Joyperm
