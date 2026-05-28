# AGENTS — Multi-Agent Entry Point

This file is intentionally thin. It is the entry point for any
AI coding agent (Codex, Aider, Cursor agent mode, etc.) operating
in this workspace. **Do not duplicate the full workspace rules
here** — they live in [`AgentJoJoy/`](AgentJoJoy/).

Claude Code reads `CLAUDE.md` as its entry point. Other agents (or
generic tools) read this `AGENTS.md`. Both point at the same shared
rules.

---

## Session Start — Run the Resume Check First

Before any other work (including generating any greeting or response), read `AgentJoJoy/agent-context/project-overview.md` and `progress-tracker.md` to classify the workspace state and retrieve in-flight context.

### Step 1 — Classify Workspace State

Use the loaded contents and the trigger states in [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) to classify the workspace:

- **T1 — Fresh Template**: Workspace is a new/copied wrapper and has not been onboarded.
  - *Signal*: Project Name/What It Is are `_(not set)_` in [`AgentJoJoy/agent-context/project-overview.md`](AgentJoJoy/agent-context/project-overview.md).
  - *Action*: Ask the owner whether to start onboarding now. Offer Path 1 (New Project), Path 2 (Existing Project), or Skip.
- **T2 — Partial Intake**: Onboarding started but is not complete.
  - *Signal*: Some project overview fields or engagement modes are filled, but others are blank.
  - *Action*: Ask whether to resume onboarding from existing files or restart.
- **T3 — Onboarded / Resume**: Workspace has enough context for normal work.
  - *Signal*: Project Name, What It Is, and Working Convention/Engagement Mode are set.
  - *Action*: Run the Resume Check (Step 2 below).

### Step 2 — Resume Check (T3 State)

If templates are filled, run these checks before doing any new work:

1. Read [`progress-tracker.md`](progress-tracker.md) (workspace root) to understand current in-flight state.
2. If this is not T0 Template Development, run Worktree Auto-Sync to refresh the managed git-state block in [`progress-tracker.md`](progress-tracker.md):
   ```powershell
   powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/worktree-auto-sync.ps1 -Action sync
   ```
   If the helper is absent or fails, continue with manual read-only discovery and report the failure.
3. If the project contains a git repo, run read-only discovery (no approval needed):
   ```powershell
   git status
   git worktree list
   git branch --show-current
   ```
4. Report to the user:
   - Current branch + working tree state
   - Active worktrees (if any)
   - In-progress task from [`progress-tracker.md`](progress-tracker.md)
   - Any open questions or blockers
5. Ask the user: continue an existing task, or start a new one?

### Step 3 — Git & Multi-Agent Safety Rules

- **Several agents may share this repo — never assume it is clean.**
  - On a clean default branch → `git fetch origin`, report incoming commits if any, then propose the sync command before running it.
  - On a clean agent branch already merged to default → switch to default only with approval, then fetch/report/propose sync.
  - Not on default and not merged, or uncommitted changes → a previous agent left work mid-flight; investigate before touching anything.
- If the git remote requires credentials and they expired, recover auth before continuing. If 5 attempts fail, stop and ask the owner — do not keep probing the credential helper.
- **First-Time Orientation**: For Path 2 (existing) git projects, run the first-time Git/worktree orientation before proposing branch/worktree commands (see [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) for wrapper model details, and [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md) → "Sync with new main" for ASCII diagrams and commands).

---

## Source of Truth

Before making changes, read the relevant project knowledge from:

- [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) — canonical workflow rules
- [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) — AI permission boundaries
- [`AgentJoJoy/agent-context/project-overview.md`](AgentJoJoy/agent-context/project-overview.md) — what this project is
- [`AgentJoJoy/agent-context/architecture.md`](AgentJoJoy/agent-context/architecture.md) — stack, boundaries, invariants
- [`AgentJoJoy/agent-context/standards.md`](AgentJoJoy/agent-context/standards.md) — code/writing standards
- [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) — canonical SPEC-1 → SPEC-9
- [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) — permission gates
- [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) — detailed Path 1 / Path 2 onboarding flow
- [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md) — operational notes
- [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) — wrapper/team repo/worktree ownership model and leak-prevention rules
- [`AgentJoJoy/agent-context/engagement-mode.md`](AgentJoJoy/agent-context/engagement-mode.md) — current engagement style
- [`AgentJoJoy/agent-context/technical-precedents.md`](AgentJoJoy/agent-context/technical-precedents.md) — local technical boundary rules and validated precedents
- [`AgentJoJoy/agent-context/domain-language.md`](AgentJoJoy/agent-context/domain-language.md) — optional glossary and domain-language map for project terms and ambiguities
- [`AgentJoJoy/skills/README.md`](AgentJoJoy/skills/README.md) — skill layer model: Personal Agent Skills vs Project Skills and precedence when both match
- [`AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md`](AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md) — portable core practices for debugging, review, RCA, and stakeholder communication
- [`AgentJoJoy/skills/grill-me/SKILL.md`](AgentJoJoy/skills/grill-me/SKILL.md) — rigorous design interview for brainstorming, planning, and pressure-testing ideas before implementation
- [`AgentJoJoy/agent-tools/`](AgentJoJoy/agent-tools/) — local helper tools and sync scripts
- [`AgentJoJoy/agent-templates/`](AgentJoJoy/agent-templates/) — reusable snippets and portable inserts
- [`AgentJoJoy/agent-decisions/`](AgentJoJoy/agent-decisions/) — key decisions log
- [`AgentJoJoy/agent-runtime/`](AgentJoJoy/agent-runtime/) — local generated agent state files
- [`progress-tracker.md`](progress-tracker.md) — current state, decisions, next steps

If this file conflicts with `CLAUDE.md` on agent-specific behavior,
**this file wins** for the agent reading it. For workflow rules
(permission gates, SPEC-* rules), `AgentJoJoy/` files always win.

For existing projects, team/project repo rules are authoritative for
project work. If repo `CLAUDE.md`, repo `AGENTS.md`,
`.cursor/rules/*`, `CONTRIBUTING.md`, style guides, lint/test config,
or other team rules conflict with AgentJoJoy personal preferences,
the team/project rules win for code, docs, architecture, review,
branch, and release decisions.

When this checkout is the AgentJoJoy template source repo itself, use
`AgentJoJoy/template-lab/.template-source` as the explicit source repo
marker and `AgentJoJoy/template-lab/template-dev-tracker.md` for real
development state. Leave
`progress-tracker.md` and `AgentJoJoy/agent-context/progress-tracker-setup.md` as
blank reusable templates unless the task explicitly changes template
content.

If `AgentJoJoy/template-lab/template-dev-tracker.md` appears in a copied workspace
that is not the AgentJoJoy template source repo, treat it as source
repo residue. Ignore it for project state and propose removing it
during intake/package cleanup.

`AgentJoJoy/template-lab/validation/` records source-repo validation work and
should not be treated as reusable project state. Remove source-repo
validation records, local runtime caches, and
`AgentJoJoy/template-lab/.template-source` from copied workspaces.

---

## Multi-Agent Coexistence Rules

When more than one AI agent works on this repo (e.g. Claude Code +
Codex on different branches, or Cursor background agents running
in parallel):

### 1. Branch naming

Branch naming depends on the **project type**, not the agent:

**Team repo (Path 2 / existing project):**
- Follow the team's convention (commonly `feature/<owner>-<task>`,
  `fix/<owner>-<task>`, `improve/<owner>-<task>`)
- **All agents use the same scheme** — the commit co-author trailer
  reveals which agent did the work
- Why: agent-prefixed branches (e.g. `codex/...`, `claude/...`) look
  unprofessional in team PR lists and clutter `git branch -a`

**Personal / new project (Path 1):**
- Owner-named convention preferred for consistency
  (`feature/<owner>-<task>`)
- Agent-specific prefix optional if you want extra clarity for solo work
  (e.g. `agent-name/<task>` for agent-specific experiments)

**Always reserved (never create manually, any project type):**
- `cursor/...` — Cursor background agents create these
  automatically. Manually creating one confuses Cursor's agent
  system.

Don't manually rebase or merge a branch under another agent's
reserved prefix unless explicitly asked.

### 2. Code change tags

When making meaningful code additions or behavioral changes, add a
concise marker near the logical block:

```
// <AGENT>: <short reason>     ← e.g. // CLAUDE: extract pagination helper
# <AGENT>: <short reason>      ← Python / Ruby / etc.
```

Rules:
- One marker per function, class, or decision block — not per line
- Skip markers for trivial formatting, renames, or mechanical edits
- Preserve existing markers when editing nearby code
- If a different agent materially changes a marked block, update
  the marker so ownership is clear

### 3. Commit attribution

Append a co-author trailer to every commit message so authorship
is durable in git history:

```
Co-Authored-By: <Agent Name> [Model] <noreply-bot@users.noreply.github.com>
```

Examples:
- `Co-Authored-By: Claude [Opus 4.7] <claude-bot@users.noreply.github.com>`
- `Co-Authored-By: Codex [GPT-5] <codex-bot@users.noreply.github.com>`

`[Model]` must reflect the exact model running. If unsure, ask the
owner before committing.

### 4. Session handoff (when needed)

The durable source of in-flight state is `progress-tracker.md`.
Most agent handoffs work through that file + git state alone.

When mid-flight state is too subtle for git + tracker to convey
(e.g. partial refactor with non-obvious next step), use a dedicated
handoff file:

- Location: `AgentJoJoy/session-handoff.md`
- When to write: only when the owner explicitly asks for a handoff,
  OR when stopping with real mid-flight work that cannot be safely
  understood from git state + `progress-tracker.md`
- Normal state: empty / contains no-active-handoff template

At session start, if `session-handoff.md` contains an active
handoff, read it as a temporary clue, reconcile with git state and
`progress-tracker.md`, then reset it back to empty before
continuing.

The reset is session hygiene — don't make it a standalone
deliverable (no separate branch/commit/PR just for that reset).
Include it in whatever real work happens in the same session.

---

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

## Commit and PR Behavior (Generic)

- **Never push directly to default branch** (`main`, `master`,
  `develop`, etc.). Always go through a PR.
- **One-time empty-repo bootstrap exception:** If the remote has no
  default branch or commits yet, the owner may explicitly choose a
  one-time bootstrap push to `main`. After that first commit, use the
  normal branch/PR flow.
- **Template source repo checkpoint exception:** In the AgentJoJoy
  template source repo itself, the owner may explicitly choose direct
  checkpoint commits/pushes to `main`. Do not copy this exception into
  Path 2 team repos or generated workspaces.
- **Branch first, then code.** New work in a worktree under
  `<workspace-root>/worktree-<task>/` (see
  [`AgentJoJoy/agent-rules/workflow-notes.md`](AgentJoJoy/agent-rules/workflow-notes.md)).
- **No `--no-verify`** to bypass pre-commit hooks — fix the
  underlying issue.
- **Per-action approval required** for commit, push, merge, PR
  create, etc. — see
  [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md)
  → "AI Permission Boundaries".
- **Strategic choices require explicit user selection** (rebase vs
  merge, force vs normal push, etc.) — see SPEC-3.5.
- **Agents must never approve or merge their own PR.**
- Before committing, run the project's verification commands
  (type check, tests, build) and report results.
- Update `progress-tracker.md` after meaningful work.

---

## Language

- **Code and comments**: English
- **Project documentation under `AgentJoJoy/`**: English (so any
  agent can read it without translation)
- **Conversation with the owner**: English by default. Detects and adapts dynamically to other languages (e.g. Thai) if the owner initiates in them. See [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) for Path 2 team repo audit constraints.

---

## Onboarding Convention

If the owner types `onboard`, `เริ่ม onboarding`, `setup workspace`, or `intake` at the start of a session or when requested, you must initiate the guided onboarding walkthrough following [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md).
Refer the owner to:
- [`AgentJoJoy/workflow-guide.md`](AgentJoJoy/workflow-guide.md) (English onboarding manual)
- [`AgentJoJoy/workflow-guide-th.md`](AgentJoJoy/workflow-guide-th.md) (Thai onboarding manual)

---

## When This File Is Updated

This file rarely changes. Update only when:

- A new agent type or new coordination rule needs to be supported
- Multi-agent coordination patterns evolve
- An agent-specific entry-point behavior changes

For workflow rules (permission gates, SPEC-* rules, intake flow),
update the files under `AgentJoJoy/` instead — those are the
durable source of truth.
