# AgentJoJoy Workspace

This is a generic workspace template for working with AI assistants
(Claude Code, Cursor, etc.) on a project. The actual project content
lives in a sibling folder; personal AI context lives in `AgentJoJoy/`.

This file **loads automatically when Claude is opened in any
subfolder** (Claude Code walks up the directory tree to find every
`CLAUDE.md` and merges them).

---

## Workspace Layout

```
<workspace-root>/                       ← workspace root (this folder)
├─ CLAUDE.md                            ← this file (auto-loads)
├─ progress-tracker.md                  ← REAL WORK tracker (read first on resume)
├─ AgentJoJoy/                          ← personal AI context
│  ├─ agent-context/             (project context filled during intake)
│  ├─ agent-rules/               (workflow rules + onboarding logic)
│  ├─ agent-tools/               (local helper tools)
│  ├─ agent-runtime/             (local generated agent state)
│  ├─ skills/                    (portable / project-specific SKILL.md files)
│  ├─ agent-templates/           (reusable snippets / portable inserts)
│  ├─ agent-decisions/           (key decisions log)
│  └─ template-lab/              (source-repo-only development artifacts)
├─ <code-or-content>/                   ← the actual project (any folder name)
└─ <worktree-N>/                        ← per-task git worktrees (if applicable)
```

`<code-or-content>/` is whatever the project is — a git repo, a
docs folder, a research workspace. May or may not exist depending
on whether this is a new project (Path 1) or an existing one (Path 2).

---

## Session Start Protocol

When you start a new Claude session in this workspace, **before any
other work (including generating any greeting or response)**, you MUST read `AgentJoJoy/agent-context/project-overview.md` and `progress-tracker.md` to classify the workspace state.

### Step 1 — Check intake state

Use the loaded contents and [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) →
"Trigger States" to classify the workspace:

- **T1 Fresh Template** → ask whether to start intake, choose Path 1,
  Path 2, or Skip.
- **T2 Partial Intake** → ask whether to resume or restart intake.
- **T3 Onboarded / Resume** → go to Step 3.

### Step 2 — Intake mode

This workspace has not been used yet, or intake was never completed.
Follow [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md). Start
by asking the user:

> "ดูเหมือนนี่จะเป็น workspace ใหม่ — เริ่มจาก
> **โปรเจ็คใหม่** (Path 1), **โปรเจ็คที่มีอยู่แล้ว** (Path 2),
> หรือ **ข้ามไว้ก่อน**?"

#### Path 1 — New project

Follow `AgentJoJoy/agent-rules/intake-flow.md` as canonical. In short:

1. Ask small batches of questions for identity, owner preferences,
   secrets/environment safety, and planning baseline.
2. Propose folder structure for `<code-or-content>/` and get approval
   before creating anything.
3. Show an Intake Summary Preview before writing final template
   updates.
4. Fill applicable templates: `AgentJoJoy/agent-context/project-overview.md`,
   `AgentJoJoy/agent-context/architecture.md`, `AgentJoJoy/agent-context/standards.md`, `AgentJoJoy/agent-context/ui-context.md`,
   `AgentJoJoy/agent-context/domain-language.md`, `AgentJoJoy/agent-rules/workflow-notes.md`, `progress-tracker.md` (root level),
   and `AgentJoJoy/agent-context/progress-tracker-setup.md`.
5. Record the first milestone, first slice, verification signal,
   not-now items, and open questions.

#### Path 2 — Existing project

Follow `AgentJoJoy/agent-rules/intake-flow.md` as canonical. In short:

1. Ask where the existing project lives and get approval before moving,
   cloning, or linking anything.
2. Explain the wrapper/team repo/worktree ownership model before git
   commands.
3. Run read-only discovery only: README/manifests, team rule files,
   docs/ADRs, relevant source structure, and git state.
4. Detect secret files by path/name, but do not print secret values.
5. Treat team/project repo rules as authoritative for project content.
6. Show an Intake Summary Preview before writing final template
   updates, including confirmed facts, AI guesses, unknowns, protected
   paths, verification commands, and files to update.
7. Fill applicable templates and record first milestone, first slice,
   verification signal, not-now items, and open questions.
8. If this is a git project, run the **first-time Git/worktree
   orientation** before proposing any branch or worktree commands:
   - Explain the wrapper model: `AgentJoJoy/` is AgentJoJoy-owned personal
     context; the existing repo and task worktrees remain team-owned.
   - Explain the sync mental model in plain language:
     `fetch → inspect → choose rebase/merge → verify → push`.
   - Show the small ASCII graph in `AgentJoJoy/agent-rules/workflow-notes.md`
     → "Sync with new main" so the owner can see what changed.
   - Define the three terms the owner is likely to see:
     `origin/main` = latest team main on remote, task branch =
     the owner's work, worktree = folder checked out to one task branch.
   - Give the default rule of thumb: branch not pushed yet → rebase
     is usually clean; branch already pushed or in PR → merge is
     usually safer; rebase after push requires explicit discussion
     because it leads to `--force-with-lease`.
   - Point to `AgentJoJoy/agent-rules/workflow-notes.md` → "Sync with new main"
     for the reusable recipe.
### Step 3 — Resume mode (Resume Check Protocol)

Templates are filled, this is a normal work session. Run these checks
before doing any new work:

1. Read `progress-tracker.md` (workspace root) to understand current
   in-flight state. Only read `AgentJoJoy/agent-context/progress-tracker-setup.md`
   if the user asks about setup history or recent workflow changes.
2. If this is not T0 Template Development, run the local Worktree
   Auto-Sync helper to refresh the managed git-state block in
   `progress-tracker.md`:
   ```powershell
   powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/worktree-auto-sync.ps1 -Action sync
   ```
   If the helper is absent or fails, continue with the manual
   read-only checks below and report the failure.
3. If `<code-or-content>/` is a git repo, run (no approval needed —
   read-only per SPEC-3.2):
   ```powershell
   git -C "<code-or-content>" status
   git -C "<code-or-content>" worktree list
   git -C "<code-or-content>" branch --show-current
   ```
4. Report to the user:
   - Current branch + working tree state
   - Active worktrees (if any)
   - In-progress task from `progress-tracker.md` (if any)
   - Any open questions or blockers from `progress-tracker.md`
5. Ask the user: continue an existing task, or start a new one?

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
   The AI may suggest commands and explain effects, but must wait for
   the user to say go before executing anything that changes git
   state or talks to a remote. Full list in
   [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md)
   → "AI Permission Boundaries".

2. **Strategic choices require explicit selection, every time.** Even
   if a command is on the `settings.local.json` allow list (execution
   authority granted), the choice of *which* command to run among
   options (rebase vs merge, commit vs stash, force vs normal push,
   which file to delete) is reserved for the user. The AI must list
   options, explain trade-offs, and wait for the user to **name** the
   choice — a generic "go" / "ได้เลย" is not enough. See
   [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) →
   SPEC-3.5.

3. **Multi-worktree target naming.** When more than one worktree is
   active, the AI's intake restatement must name the target worktree.
   This is a SPEC-3.5 strategic choice — the AI must not infer the
   target. See SPEC-2.1.

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
   [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md)
   → "Worktree Workflow".

7. **One-time empty-repo bootstrap exception.** If a remote is empty
   and has no default branch/commits, the owner may explicitly choose
   a one-time bootstrap push to `main`. After that first commit, use
   branch/PR workflow as usual.

8. **Template source repo checkpoint exception.** When this checkout is
   the AgentJoJoy template source repo itself, the owner may explicitly
   choose direct checkpoint commits/pushes to `main`. This exception
   does not apply to copied workspaces or Path 2 team repos.

---

## Multi-Agent Coexistence

When more than one AI agent works on this project (Claude Code +
Codex on different branches, Cursor background agents, etc.), the
following rules keep attribution clear and work uncontaminated.
Mirrored in [`AGENTS.md`](AGENTS.md) for non-Claude agents.

### Branch naming

Branch naming depends on the **project type**, not the agent:

**Team repo (Path 2 / existing project):**
- Follow the team's convention (commonly `feature/<owner>-<task>`,
  `fix/<owner>-<task>`, `improve/<owner>-<task>`)
- **All agents use the same scheme** — the commit co-author trailer
  reveals which agent did the work
- Why: tool-prefixed branches (`codex/...`, `claude/...`) look
  unprofessional in team PR lists and clutter `git branch -a`

**Personal / new project (Path 1):**
- Owner-named convention preferred for consistency
- Tool prefix optional if you want extra clarity for solo work

**Always reserved (never create manually):**
- `cursor/...` — Cursor background agents create these
  automatically. Manually creating one confuses Cursor's agent
  system.

### Code change tags

When making meaningful code additions or behavioral changes, add a
concise marker near the logical block:

```
// CLAUDE: <short reason>     ← TypeScript / JavaScript / Java / etc.
# CLAUDE: <short reason>      ← Python / Ruby / shell
```

(Other agents use their own name: `// CODEX:`, `// CURSOR:`, etc.)

Rules:
- One marker per function, class, or decision block — not per line
- Skip markers for trivial formatting, renames, or mechanical edits
- Preserve existing markers when editing nearby code
- If a different agent materially changes a marked block, update
  the marker so ownership is clear

### Commit attribution

Append a co-author trailer to every commit message:

```
Co-Authored-By: Claude [Opus 4.7] <claude-bot@users.noreply.github.com>
```

`[Model]` must reflect the exact model running. If unsure, ask the
owner before committing.

### Session handoff

The durable source of in-flight state is
[`progress-tracker.md`](progress-tracker.md). Most agent handoffs
work through that file + git state alone.

When mid-flight state is too subtle for git + tracker to convey
(e.g. partial refactor with non-obvious next step), use a dedicated
handoff file:

- Location: `AgentJoJoy/session-handoff.md`
- When to write: only when the owner explicitly asks, OR when
  stopping with real mid-flight work that cannot be safely
  understood from git state + `progress-tracker.md`
- Normal state: empty (no-active-handoff)

At session start, if `session-handoff.md` contains an active
handoff, read it as a temporary clue, reconcile with git state and
`progress-tracker.md`, then reset it back to empty before
continuing.

The reset is session hygiene — don't make it a standalone
deliverable (no separate branch/commit/PR just for the reset).
Include it in whatever real work happens in the same session.

---

## Post-Decision Doc Hygiene

After **any** workspace-level decision the user makes (e.g. choosing
an architecture direction, resolving a deferred decision, changing
engagement mode permanently), follow this sequence:

1. **Execute the operational change first**, with explicit approval
   per SPEC-3 / SPEC-3.5.
2. **Propose doc updates** that reflect the new state. List the
   specific files + edits.
3. **Get approval** for the doc updates. A single batch approval is
   acceptable per SPEC-3.4 sequence rule — no need to approve each
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

## Canonical Documentation (AI Reads These for Rules)

| File | Purpose |
|------|---------|
| [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) | **Canonical workflow rules** — SPEC-1 through SPEC-9 |
| [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) | AI permission boundaries (execution + strategic choice gates) |
| [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) | Detailed Path 1 / Path 2 onboarding flow and completion checklist. |
| [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md) | Operational notes (paths, gotchas, worktree workflow) |
| [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) | Wrapper/team repo/worktree ownership model and leak-prevention rules. |
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
| [`progress-tracker.md`](progress-tracker.md) (at root) | **REAL WORK tracker** — active branches, PRs, worktrees, in-flight tasks. Update after every meaningful work action. Resume Check reads this first. |
| [`AgentJoJoy/agent-context/progress-tracker-setup.md`](AgentJoJoy/agent-context/progress-tracker-setup.md) | **SETUP / workspace meta log** — spec amendments, workspace restructure events, intake completion. Update when workspace structure or workflow rules change. |
| [`AgentJoJoy/agent-decisions/`](AgentJoJoy/agent-decisions/) | Key project decisions (one file per decision, format in folder README). |
| [`AgentJoJoy/skills/README.md`](AgentJoJoy/skills/README.md) | Skill layer model: Personal Agent Skills vs Project Skills and precedence when both match. |
| [`AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md`](AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md) | Portable core practices for debugging, review, post-mortems, and stakeholder communication. |
| [`AgentJoJoy/skills/grill-me/SKILL.md`](AgentJoJoy/skills/grill-me/SKILL.md) | Rigorous design interview for brainstorming, planning, and pressure-testing ideas before implementation. |
| [`AgentJoJoy/skills/pattern-detection/SKILL.md`](AgentJoJoy/skills/pattern-detection/SKILL.md) | Meta-skill that monitors the user's workflow pattern (using Recent Actions in progress-tracker.md and in-session memory). |

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

If the owner types `onboard`, `เริ่ม onboarding`, `setup workspace`, or `intake` at the start of a session or when requested, you must initiate the guided onboarding walkthrough following [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md).
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
