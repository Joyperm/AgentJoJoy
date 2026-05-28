# Onboarding Guide — AgentJoJoy

Welcome to **AgentJoJoy**. It is a workspace wrapper for working with
AI assistants across new projects and existing repositories while
keeping personal AI context separate from project code.

---

## 1. Start Here

For a new workspace, use GitHub's **Use this template** button:

1. Create a new repository from the AgentJoJoy template.
2. Clone your new repository to your machine.
3. Open Claude Code, Codex, Cursor, or Gemini at the workspace root.
4. Ask the AI to read `CLAUDE.md` / `AGENTS.md` and start onboarding.
5. Choose **New Project**, **Existing Project**, or **Skip** when the
   AI asks.

If you already have an AgentJoJoy workspace, do not create a fresh
template copy to upgrade it. Use the upgrade prompt in `README.md` so
your project notes, decisions, gap reports, and custom skills are
preserved.

---

## 2. Core Concept

AgentJoJoy uses a **wrapper workspace**:

```text
WorkspaceRoot/
├─ CLAUDE.md / AGENTS.md          # AI entry points
├─ progress-tracker.md            # Daily project/task tracker
├─ AgentJoJoy/                    # Personal AI context and rules
│  ├─ agent-context/              # Project metadata and notes
│  ├─ agent-rules/                # Workflow and safety rules
│  ├─ agent-tools/                # Local helper scripts
│  ├─ skills/                     # Portable and project skills
│  ├─ workflow-guide.md           # English guide
│  └─ workflow-guide-th.md        # Thai guide
├─ TeamRepo/                      # Optional existing project repo
└─ worktree-task-a/               # Optional task worktree
```

The important boundary is simple:

- Personal AI context lives in `AgentJoJoy/` and wrapper-level files.
- Project code lives in the project repo or task worktree.
- Team/project commits should not include your personal AI operating
  layer.

---

## 3. Onboarding Paths

When an AI session starts in a fresh workspace, the AI classifies the
workspace and asks how to proceed.

### New Project

Choose this when starting from scratch. The AI helps clarify the
project goal, proposes a folder structure, and fills only the context
you approve.

### Existing Project

Choose this when wrapping an existing repo, document set, or research
folder. The AI scans read-only first, explains the wrapper model, and
asks before moving, cloning, linking, or writing anything.

For team repos, English is recommended by default because IDE logs,
screenshares, PR-linked transcripts, or audit exports may be visible to
teammates.

### Skip

Choose this when you want to ask a direct question without setting up
the workspace yet. The AI leaves templates unchanged.

---

## 4. Safety Rules

The AI may read files and run read-only inspection commands, but it
must ask before state-changing actions such as:

- commits, pushes, pulls, branch switches, merges, rebases, tags, or
  PR actions
- dependency installs or lockfile changes
- destructive file operations
- migrations, deployments, environment writes, or unclear scripts
- starting long-running runtimes unless the project marks them safe

Secrets belong in the project `.env`, a secret manager, or CI
variables. Never copy credentials into `AgentJoJoy/`.

---

## 5. Useful Options

### Distraction-Free Mode

During onboarding, you can ask the AI to configure VS Code to hide
internal AgentJoJoy files from the Explorer sidebar. The AI creates or
updates `.vscode/settings.json` surgically, preserving unrelated
editor settings.

### Gap Reporter

The Gap Reporter is opt-in. When enabled, the AI may write redacted
workflow-friction notes under `AgentJoJoy/agent-runtime/gaps/` during a
session. It must announce each report it writes. Reports are local,
gitignored, and must not contain credentials, source code, private
paths, remotes, emails, or project-sensitive details.

### Gap Collector

The collector is separate from the reporter. It is a local-only
retrospective tool for listing, summarizing, exporting, or purging gap
reports. It does not upload anything.

### Test-First / TDD Preference

During onboarding, you can tell the AI whether to prefer a test-first
workflow. When enabled or appropriate, the AI should write or stub the
failing/reproducing test before implementation or debugging.

### Junction Link Model

For rigid runtime environments that require code to live in a fixed
folder, AgentJoJoy supports a Windows Directory Junction model. The
project can live under the wrapper while the external runtime path
points to it with a junction. The AI must ask before creating or
removing links.

---

## 6. Portable Skills

AgentJoJoy includes two core skill families:

- `agentjojoy-core-practices` — debugging, review, post-mortems, and
  stakeholder updates.
- `grill-me` — one-question-at-a-time design interviews for vague
  plans, new workflows, and architecture decisions.

Project-specific skills may also live under `AgentJoJoy/skills/`.
During upgrades, custom skills are user-owned and should be preserved.

> **Note on invocation.** AgentJoJoy skills don't appear in the `/`
> command palette. They are discovered by the AI reading the
> workspace and matching the skill description against your request.
> Just describe what you want — the AI picks the right skill from
> `AgentJoJoy/skills/`.
>
> **Adding a skill is drag-and-drop.** Drop a folder containing a
> `SKILL.md` into `AgentJoJoy/skills/`; the AI sees it via
> `git status` on the next interaction — no install, no restart, no
> registry update. (Skills the AI itself generates from observed
> patterns are discovered the same way, by definition — the
> generator and discoverer are the same agent.)

---

## 7. Upgrading

For an existing AgentJoJoy workspace, upgrade through the canonical
prompt in `README.md`.

The upgrade flow compares your workspace against a specific release tag
and follows `AgentJoJoy/agent-rules/file-ownership.md`:

- template-owned files can be updated after approval
- mixed files preserve your values while updating structure
- user-owned files are not overwritten

Do not use GitHub's **Use this template** button to upgrade an existing
workspace. That button is for creating a new workspace.

---

## 8. Cross-Platform Note

The AgentJoJoy workflow is document-based and can be used on Windows,
macOS, or Linux. The bundled helper scripts are currently
PowerShell-first and Windows-tested. On macOS/Linux, ask your AI
assistant to translate helper commands to the local shell, and approve
state-changing commands before running them.
