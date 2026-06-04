# AgentJoJoy Workspace

This is a generic workspace template for working with AI assistants
(Claude Code, Cursor, etc.) on a project. The actual project content
lives in a sibling folder; personal AI context lives in `AgentJoJoy/`.

This file **loads automatically when Claude is opened in any
subfolder** (Claude Code walks up the directory tree to find every
`CLAUDE.md` and merges them).

---

## ⚠️ CRITICAL CONTEXT BUDGET & SCOPE GATES

- **Resume Check Budget (Max 3 Calls)**: Running a 'resume check' must be lightweight and fast. You are strictly limited to a maximum of 3 tool calls (e.g., `git status`, `git branch --show-current`, and reading the active tracker file) to discover the project state. Report the current status and pending tasks, then stop immediately to wait for the user's explicit instructions. Do NOT run tests, lint, or search files unprompted.
- **Review/Audit Budget (Max 3 Calls)**: When asked to 'verify' or 'review' work done by other agents, inspect ONLY the immediate changed files or diff (using `git show <commit>` or `git diff`) and report. Do NOT run redundant verification commands (lint, test, build) or perform exhaustive file searches if the previous agent's history or commit metadata already indicates passing verification.

---

## Workspace Layout

```
<workspace-root>/                       ← workspace root (this folder)
├─ CLAUDE.md                            ← this file (auto-loads)
├─ progress-tracker.md                  ← REAL WORK tracker
├─ AgentJoJoy/                          ← personal AI context
│  ├─ agent-context/             (project context filled during intake)
│  ├─ agent-rules/               (workflow rules + onboarding logic)
│  ├─ agent-tools/               (local helper tools)
│  ├─ agent-runtime/             (local generated agent state)
│  ├─ skills/                    (portable / project-specific SKILL.md files)
│  ├─ agent-smartworkers/        (Main-dispatched knowledge workers — neutral spec + template)
│  ├─ agent-hooks/               (optional hook enforcement contracts — docs/templates only)
│  ├─ agent-templates/           (reusable snippets / portable inserts)
│  └─ agent-decisions/           (key decisions log)
├─ <code-or-content>/                   ← the actual project (any folder name)
└─ <worktree-N>/                        ← per-task git worktrees (if applicable)
```

`<code-or-content>/` is whatever the project is — a git repo, a
docs folder, a research workspace. May or may not exist depending
on whether this is a new project (Path 1) or an existing one (Path 2).

---

## Session Start Protocol

When you start a new Claude session in this workspace, **before any
other work (including generating any greeting or response)**, you MUST classify the workspace state and retrieve in-flight context.

Read `progress-tracker.md` to classify the workspace state (and only read
`AgentJoJoy/agent-context/project-overview.md` during fresh T1/T2
onboarding sessions, as project overview is already known in T3 Resume
mode).

### Step 1 — Check intake state

Use the loaded contents and [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) →
"Trigger States" to classify the workspace:

- **T1 Fresh Template** → ask whether to start intake, choose Path 1,
  Path 2, or Skip.
- **T2 Partial Intake** → ask whether to resume or restart intake.
- **T3 Onboarded / Resume** → go to Step 3.

### Step 2 — Intake mode

Intake is incomplete. Follow [`intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md)
as canonical — it holds the full Path 1 / Path 2 steps and completion checklist.
Start by asking:

> "It looks like this is a new workspace — start with:
> **New Project** (Path 1), **Existing Project** (Path 2), or **Skip for now**?"

Essentials on both paths:
- Ask in small batches; get approval before creating/moving/cloning anything.
- Read-only discovery first; detect secret files by name, never print values.
- Team/project repo rules are authoritative over personal AgentJoJoy preferences.
- Show an Intake Summary Preview before writing template updates.
- Record first milestone, first slice, verification signal, not-now items, open questions.
- Path 2 git projects: run the first-time Git/worktree orientation (wrapper model +
  `fetch → inspect → choose rebase/merge → verify → push`) before any branch/worktree
  command — recipe in `workspace-model.md` → "Sync with new main".

### Step 3 — Resume mode (Resume Check Protocol)

Templates are filled, this is a normal work session. Run these checks
before doing any new work:

1. Read `progress-tracker.md` (workspace root) to understand current
   in-flight state. Only read `AgentJoJoy/agent-context/progress-tracker-setup.md`
   if the user asks about setup history or recent workflow changes.
2. If `<code-or-content>/` is a git repo, run a single combined command to discover git state (no approval needed — read-only per SPEC-1.2, counts as 1 tool call):
   ```powershell
   git -C "<code-or-content>" status && git -C "<code-or-content>" worktree list && git -C "<code-or-content>" branch --show-current
   ```
3. Report to the user:
   - Current branch + working tree state
   - Active worktrees (if any)
   - In-progress task from the active tracker (if any)
   - Any open questions or blockers from the active tracker
4. Ask the user: continue an existing task, or start a new one?

---

## Engagement Mode

The current AI engagement style (execute vs teach) is recorded in
[`AgentJoJoy/agent-context/engagement-mode.md`](AgentJoJoy/agent-context/engagement-mode.md).
Read that file when:

- The session starts (after Resume Check)
- The user asks to "switch mode" or similar
- Behavior feels off (e.g. AI being too verbose / too terse)

Default during intake: ask the user.

---

## Working Convention

These are set during intake and stored here. Update if they change.

- **Conversation**: _(set during intake — common values: Thai, English)_
- **Code and comments**: English
- **Shell default**: _(detect from OS — Windows: PowerShell; macOS/Linux: bash)_
- **Branch naming**: follow the project's team convention (check
  recent merged PRs). Common patterns:
  `feature/<owner>-<task>`, `fix/<owner>-<task>`,
  `improve/<owner>-<task>`. Avoid tool-reserved prefixes (e.g.
  `cursor/` is reserved for Cursor background agents).

---

## Critical Rules

1. **Ask before any git push / pull / commit / merge / branch switch.**
   (Scoped exceptions: Rules 7–9 below.) The AI may suggest commands and
   explain effects, but must wait for
   the user to say go before executing anything that changes git
   state or talks to a remote. Full list in
    [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md)
    → "Pillar I: Permission Boundaries & Core Safety Gates".

2. **Strategic choices require explicit selection, every time.** Even
   if a command is on the `settings.local.json` allow list (execution
   authority granted), the choice of *which* command to run among
   options (rebase vs merge, commit vs stash, force vs normal push,
   which file to delete) is reserved for the user. The AI must list
   options, explain trade-offs, and wait for the user to **name** the
   choice — a generic "go" / "sure" (Thai: "ได้เลย") is not enough. See
   [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) →
   SPEC-1.5.

3. **Multi-worktree target naming.** When more than one worktree is
   active, the AI's intake restatement must name the target worktree.
   This is a SPEC-1.5 strategic choice — the AI must not infer the
   target. See SPEC-4.1.

4. **Don't touch the team's rule folders** (e.g. `.cursor/rules/`,
   `.claude/` inside the project repo) unless an explicit PR is
   intended. Be especially careful with `settings.local.json` files —
   these are known to leak across developers in many teams.

5. **Read team rules first.** Before writing any code in a team
   repo, consult `CLAUDE.md` at the repo root and any
   `.cursor/rules/*.mdc` present. They override anything in
   `AgentJoJoy/` for code-level decisions.
   Path 2 intake also treats team/project repo rules as authoritative
   over personal AgentJoJoy preferences.

6. **Worktree-first for active tasks.** Don't switch branches in the
   main checkout while a PR is awaiting review. Create a worktree
   as a sibling instead. See
    [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md)
    → "Worktree Workflow".

7. **One-time empty-repo bootstrap exception.** If a remote is empty
   and has no default branch/commits, the owner may explicitly choose
   a one-time bootstrap push to `main`. After that first commit, use
   branch/PR workflow as usual.

8. **Milestone auto-commit & teaching (opt-in, default OFF).** Default OFF;
   **Gemini runtimes must never auto-commit** (always propose-and-approve);
   `git push` always requires approval. When enabled in `engagement-mode.md`
   (AI-NO-OVERWRITE block), **Claude/Codex only** may make *local* milestone
   commits — on a milestone plan you approved up front, with explicit named
   staging (never `git add -A`). A **teaching box** (in chat, in the session's
   conversation language, never in the commit message) is shown per the **Teaching toggle** (preset
   default: teach=ON / execute=OFF), separate from the auto-commit switch. Secrets follow the **Secret Intake
   Protocol** (never asked/printed in chat). Full mechanics:
   [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md)
   → Pillar I "Secret Intake Protocol" + Pillar II "Milestone Auto-Commit &
   Proactive Teaching".

---

## Multi-Agent Coexistence

When several AI agents share this project (Claude/Codex on different branches,
Cursor background agents), these rules keep attribution clear and work clean.
Mirrored in [`AGENTS.md`](AGENTS.md) for non-Claude agents.

**Branch naming** (depends on project type, not agent):
- Team repo (Path 2): follow the team's convention (e.g. `feature/<owner>-<task>`).
  All agents use the same branch scheme. When this repo uses AI co-author
  trailers, the trailer carries agent/model attribution; otherwise commit
  attribution follows the team convention. Agent-prefixed branches (`codex/...`)
  clutter team PR lists.
- Personal (Path 1): owner-named convention; agent prefix optional for solo work.
- Reserved — never create manually: `cursor/...` (Cursor's background agents own these).

**Code change tags** — near a meaningful change, add one marker per
function/class/decision block (not per line): `// CLAUDE: <reason>` (agent's own
name; `#` for Python/shell). Preserve existing markers; update one if you
materially change that block. Skip trivial/mechanical edits.

**Commit attribution** — follow the workspace/repo attribution policy in
`AgentJoJoy/agent-context/standards.md`. AgentJoJoy-owned commits normally use
an AI co-author trailer; Path 2 team repos follow the target repo's existing
convention. If the policy is unset or unclear, ask before adding a trailer.
When AI co-author trailers are enabled, `[Model]` is the exact model running:
`Co-Authored-By: Claude [Model] <claude-bot@users.noreply.github.com>`
(other agents use their own, e.g. `Codex [Model] <codex-bot@...>`).

**Session handoff** — `progress-tracker.md` + git state carry most handoffs.
Only when mid-flight state is too subtle for those, write
`AgentJoJoy/session-handoff.md` (owner asks, or real un-inferable mid-flight work);
normal state empty. At session start, if it holds an active handoff, reconcile
with git + tracker, then reset to empty as part of the same session's work (not a
standalone commit). Agents must never approve/merge their own PR.

---

## Post-Decision Doc Hygiene

After **any** workspace-level decision the user makes (e.g. choosing
an architecture direction, resolving a deferred decision, changing
engagement mode permanently), follow this sequence:

1. **Execute the operational change first**, with explicit approval
   per SPEC-1 / SPEC-1.5.
2. **Propose doc updates** that reflect the new state. List the
   specific files + edits.
3. **Get approval** for the doc updates. A single batch approval is
   acceptable per SPEC-1.4 sequence rule — no need to approve each
   file individually.
4. **Execute** the doc updates after approval.
5. **Log the decision** in
   [`AgentJoJoy/agent-context/progress-tracker-setup.md`](AgentJoJoy/agent-context/progress-tracker-setup.md)
   with date, the chosen option, and a one-line reason summary. For
   significant decisions, also create an entry in
   [`AgentJoJoy/agent-decisions/`](AgentJoJoy/agent-decisions/) (see the
   folder's README for format).
6. **Then** continue with the next item.

> **Order matters**: operational change first (reality on disk),
> doc updates second (docs follow reality), log last (records what
> happened). This prevents drift between code/folder state and
> documentation.

---

## Documentation Layers (How CLAUDE.md and Rules Compose)

When working inside this workspace (or a worktree under it), **three
layers** of rules compose:

```
Layer 1: ~/.claude/CLAUDE.md         ← user-level, cross-project preferences
   +
Layer 2: <this file>                 ← workspace rules (this CLAUDE.md)
   +
Layer 3: <code-or-content>/CLAUDE.md ← team / project rules (if any)
         and <code-or-content>/.cursor/rules/*.mdc
```

They compose because each addresses a different dimension:
- Layer 1 = "who the user is" (preferences, language)
- Layer 2 = "how the user works in this workspace" (permission gates,
  workflow rules)
- Layer 3 = "how code in this repo must look" (team conventions,
  framework structure, tests required)

Priority when they appear to conflict on code-level decisions:
**Layer 3 (team) wins** — personal docs defer to team rules. This
is reinforced in
[`AgentJoJoy/agent-context/standards.md`](AgentJoJoy/agent-context/standards.md).

---

## Where to Open Your Claude Session

| Activity | Open Claude at | Why |
|----------|----------------|-----|
| Plan a task, read context | workspace root | See `AgentJoJoy/` + `<code-or-content>/` as siblings; full overview |
| Update workflow docs | `AgentJoJoy/` | Direct context inside the docs folder |
| Update work tracker | workspace root | `progress-tracker.md` lives at the wrapper root |
| Write code, run git ops | a worktree (preferred) or `<code-or-content>/` | Git ops work immediately as cwd; team rules visible |

This `CLAUDE.md` loads regardless of which subfolder is cwd (Claude
walks up the tree to find it).

---

## Context Loading Policy

Load the smallest context bundle that matches the current task. Do not read
every file below on every turn. Reuse context already loaded in the same
session unless the task type changes, the file may have changed, or the
conversation was compacted.

Always obey safety gates and team/project precedence once loaded. Refresh only
the mutable state needed for the task, such as git status, the active tracker,
or the current diff.

### Context Bundles

| Task | Read |
|------|------|
| Resume / session start | `progress-tracker.md` plus git state from the Resume Check |
| Before edits | `workflow-spec.md`, `ai-workflow-rules.md`, and the project/team context directly relevant to the files being edited |
| Debug | Matching core practice skill, `technical-precedents.md`, and the smallest runnable/test context needed to reproduce or trace the failure |
| Review / audit | Immediate diff/artifact, matching core practice skill, and touched call paths only |
| Onboarding / intake | `intake-flow.md`, `project-overview.md`, `engagement-mode.md`, and `workspace-model.md` |
| Git / worktree operations | `workspace-model.md`, `workflow-spec.md`, and the active tracker |
| Skills | `skills/README.md` plus only the specific matching `SKILL.md` |
| SmartWorker / worker dispatch | `ai-workflow-rules.md` → Work Escalation, `AgentJoJoy/agent-smartworkers/README.md`, and the target SmartWorker spec or template |
| Hook enforcement contracts | Existing rule source (`workflow-spec.md` / `ai-workflow-rules.md` as applicable), `AgentJoJoy/agent-hooks/README.md`, the target contract, and the matching runtime binding doc |

## Canonical Documentation

| File | Purpose |
|------|---------|
| [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) | **Canonical workflow rules** — SPEC-1 through SPEC-9 |
| [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) | AI permission boundaries and the 4 Pillars of Workspace Governance |
| [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) | Detailed Path 1 / Path 2 onboarding flow and completion checklist. |
| [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) | Wrapper ownership model, operational notes, paths, gotchas, and worktree workflow. |
| [`AgentJoJoy/agent-smartworkers/README.md`](AgentJoJoy/agent-smartworkers/README.md) | SmartWorker framework — when/how the single Main Agent dispatches knowledge-requiring workers to a separate context (3-tier taxonomy script/SmartWorker/Skill; runtime-neutral spec + per-runtime binding). Not multi-agent orchestration. |
| [`AgentJoJoy/agent-hooks/README.md`](AgentJoJoy/agent-hooks/README.md) | Optional Hook Enforcement Contracts — docs/templates only, no active hooks/scripts/config; owners choose whether to mechanize selected AgentJoJoy or project-specific gates. |
| [`AgentJoJoy/agent-context/standards.md`](AgentJoJoy/agent-context/standards.md) | Project standards quick reference |
| [`AgentJoJoy/agent-context/architecture.md`](AgentJoJoy/agent-context/architecture.md) | Project stack, boundaries, invariants (optional — coding projects) |
| [`AgentJoJoy/agent-context/project-overview.md`](AgentJoJoy/agent-context/project-overview.md) | What this project is, the user's role |
| [`AgentJoJoy/agent-context/ui-context.md`](AgentJoJoy/agent-context/ui-context.md) | UI stack quick reference (optional — UI projects) |
| [`AgentJoJoy/agent-context/domain-language.md`](AgentJoJoy/agent-context/domain-language.md) | Optional glossary and domain-language map for project terms and ambiguities. |
| [`AgentJoJoy/agent-context/engagement-mode.md`](AgentJoJoy/agent-context/engagement-mode.md) | Current AI engagement style |
| [`AgentJoJoy/agent-context/technical-precedents.md`](AgentJoJoy/agent-context/technical-precedents.md) | Local technical boundary rules and validated precedents |

## State + Planning

| File | Purpose |
|------|---------|
| [`progress-tracker.md`](progress-tracker.md) (at root) | **REAL WORK tracker** — active branches, PRs, worktrees, in-flight tasks. Update after every meaningful work action. Resume Check reads this in normal workspaces. |
| [`AgentJoJoy/agent-context/progress-tracker-setup.md`](AgentJoJoy/agent-context/progress-tracker-setup.md) | **SETUP / workspace meta log** — spec amendments, workspace restructure events, intake completion. Update when workspace structure or workflow rules change. |
| [`AgentJoJoy/agent-decisions/`](AgentJoJoy/agent-decisions/) | Key project decisions (one file per decision, format in folder README). |
| [`AgentJoJoy/skills/README.md`](AgentJoJoy/skills/README.md) | Skill layer model: Personal Agent Skills vs Project Skills and precedence when both match. |
| [`AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md`](AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md) | Portable core practices for debugging, review, post-mortems, and stakeholder communication. |
| [`AgentJoJoy/skills/grill-me/SKILL.md`](AgentJoJoy/skills/grill-me/SKILL.md) | Rigorous design interview for brainstorming, planning, and pressure-testing ideas before implementation. |
| [`AgentJoJoy/skills/pattern-detection/SKILL.md`](AgentJoJoy/skills/pattern-detection/SKILL.md) | Meta-skill that monitors the user's workflow pattern (Recent Actions + in-session memory) and, on a 3+ repeat, classifies it and routes to the right tier (script / SmartWorker / Skill). |
| [`AgentJoJoy/skills/lean-output/SKILL.md`](AgentJoJoy/skills/lean-output/SKILL.md) | Output-brevity communication style ("smaller mouth, same brain") — active when the Lean Output toggle is on or on demand. |

## Skill Layers

Read `AgentJoJoy/skills/README.md` before validating or adding skills.
It defines two layers:

- Personal Agent Skills — portable AgentJoJoy-owned practices that shape how
  AI thinks and collaborates.
- Project Skills — workspace-specific routines for one project or team
  workflow.

Current Personal Agent Skills:

- `AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md` — **read this file
  before answering** when the user's request mentions any of:
  `bug`, `debug`, `failing`, `flaky`, `error`, `crash`, `broken`,
  `repro` (Debug Routine); `review`, `audit`, `sanity-check`,
  `second opinion`, existing `PR`/`diff`/`design`/`plan` to inspect
  (Scrutinize Routine); `RCA`, `root cause`, `post-mortem` after a
  validated fix (Post-Mortem Routine); rewrite for `PM`, `manager`,
  `Slack`, `email`, `standup`, `meeting` (Management-Talk Routine).
- `AgentJoJoy/skills/grill-me/SKILL.md` — **read this file before
  answering** when the user's request mentions any of: `grill`,
  `challenge`, `brainstorm`, `pressure-test`, `interview me`,
  `one question at a time`; or describes a new plan / idea / project /
  workflow / architecture decision that is still being formed.
- `AgentJoJoy/skills/pattern-detection/SKILL.md` — **read this file before
  answering** when the user repeats steps/actions/commands, does a repetitive task,
  or when any workflow/routine is performed 3+ times in the tracker or session.
- `AgentJoJoy/skills/lean-output/SKILL.md` — **read this file before answering**
  when the Lean Output toggle is on in `engagement-mode.md`, or the user asks to
  be terse/lean/brief/concise, `talk lean`, `cut the filler`
  (Thai: `พูดสั้น ๆ`, `เอาสั้น`).

Agents without native skill auto-discovery (e.g. Cursor, Codex) must
follow these references explicitly when a trigger keyword above
matches the user's prompt. Native skill runtimes (e.g. Claude Code
when workspace `SKILL.md` discovery is active) may also invoke the
skill via the runtime Skill tool.

If a Personal Agent Skill and Project Skill both match, use the
Personal Agent Skill for thinking/collaboration style and the Project
Skill for project-specific facts, commands, and workflow details.

This core layer is inspired by `thananon/9arm-skills`, but is
intentionally written as original local guidance so this public repo
does not vendor third-party skill text without a clear license.

---

## Language

- **Code and comments**: English
- **Project documentation under `AgentJoJoy/`**: English (so any agent can read it without translation)
- **Conversation with the owner**: English by default. Detects and adapts dynamically to other languages (e.g. Thai) if the owner initiates in them.

---

## Onboarding Convention

If the owner types `onboard`, `setup workspace`, `intake` (or Thai: `เริ่ม onboarding`) at the start of a session or when requested, you must initiate the guided onboarding walkthrough following [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md).
Refer the owner to:
- [`AgentJoJoy/workflow-guide.md`](AgentJoJoy/workflow-guide.md) (English onboarding manual)
- [`AgentJoJoy/workflow-guide-th.md`](AgentJoJoy/workflow-guide-th.md) (Thai onboarding manual)

---

## Out of Scope for This Workspace

- Storing secrets (DB credentials, API keys) — keep them in the
  project's `.env` or a proper secrets manager, never in
  `AgentJoJoy/`
- Duplicating team rule files (`.cursor/rules/*`, repo-root
  `CLAUDE.md`) — reference, don't copy
- Anything the team's documentation discipline forbids (e.g. some
  teams forbid `*_SUMMARY.md` / `FIX.md` files in the repo for bug
  fixes — check team rules)
