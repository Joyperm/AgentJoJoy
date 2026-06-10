# AGENTS — Multi-Agent Entry Point

This file is intentionally thin. It is the entry point for any
AI coding agent (Codex, Aider, Cursor agent mode, etc.) operating
in this workspace. **Do not duplicate the full workspace rules
here** — they live in [`AgentJoJoy/`](AgentJoJoy/).

Claude Code reads `CLAUDE.md` as its entry point. Other agents (or
generic tools) read this `AGENTS.md`. Both point at the same shared
rules.

---

## ⚠️ CRITICAL CONTEXT BUDGET & SCOPE GATES

- **Resume Check Budget (Max 3 Calls)**: Running a 'resume check' must be lightweight and fast. You are strictly limited to a maximum of 3 tool calls (e.g., `git status`, `git branch --show-current`, and reading the active tracker file) to discover the project state. Report the current status and pending tasks, then stop immediately to wait for the user's explicit instructions. Do NOT run tests, lint, or search files unprompted.
- **Review/Audit Budget (Max 3 Calls)**: When asked to 'verify' or 'review' work done by other agents, inspect ONLY the immediate changed files or diff (using `git show <commit>` or `git diff`) and report. Do NOT run redundant verification commands (lint, test, build) or perform exhaustive file searches if the previous agent's history or commit metadata already indicates passing verification.

---

## 🔒 CRITICAL SAFETY GATES (read before any command)

- **Secrets — never leak:** Never *ask for*, print, `echo`, or `cat` a secret
  value in chat. Create the secret file + add to `.gitignore` **first**, then
  have the **human** enter it via `Read-Host -AsSecureString`; reference it by
  env-var *name*, never by value. Full:
  [`ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) →
  "Secret Intake Protocol".
- **Commits & push need approval — and a task instruction is not approval.**
  "Fix it and commit" is the task definition, not the go signal: still show
  the exact edit/command and wait for a separate go. The only carve-out is opt-in
  **Milestone Auto-Commit**: **DEFAULT OFF; Gemini must never auto-commit
  (always propose-and-approve); push always asks.** When enabled, **Claude/Codex
  only** may make *local* milestone commits on a plan the owner approved up
  front (explicit named staging, never `git add -A`). A **teaching box** (in
  chat, session's conversation language, never in the commit message) shows per the
  Teaching toggle (preset default: teach=ON / execute=OFF), separate from the
  auto-commit switch. Full:
  [`ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) →
  "Milestone Auto-Commit & Proactive Teaching".

---

## Session Start — Run the Resume Check First

Before any other work (including generating any greeting or response), classify the workspace state and retrieve in-flight context.

Read `AgentJoJoy/agent-records/progress-tracker.md` to classify the workspace state (and only read `AgentJoJoy/agent-context/project-overview.md` during fresh T1/T2 onboarding sessions, as project overview is already known in T3 Resume mode).

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

1. Read [`AgentJoJoy/agent-records/progress-tracker.md`](AgentJoJoy/agent-records/progress-tracker.md) to understand current in-flight state.
2. If the project contains a git repo, run a single combined command to discover git state (no approval needed — read-only, counts as 1 tool call):
   ```powershell
   git status && git worktree list && git branch --show-current
   ```
3. Report to the user:
   - Current branch + working tree state
   - Active worktrees (if any)
   - In-progress task from the active tracker
   - Any open questions or blockers from the active tracker
4. Ask the user: continue an existing task, or start a new one?

### Step 3 — Git & Multi-Agent Safety Rules

- **Several agents may share this repo — never assume it is clean.**
  - On a clean default branch → `git fetch origin`, report incoming commits if any, then propose the sync command before running it.
  - On a clean agent branch already merged to default → switch to default only with approval, then fetch/report/propose sync.
  - Not on default and not merged, or uncommitted changes → a previous agent left work mid-flight; investigate before touching anything.
- If the git remote requires credentials and they expired, recover auth before continuing. If 5 attempts fail, stop and ask the owner — do not keep probing the credential helper.
- **First-Time Orientation**: For Path 2 (existing) git projects, run the first-time Git/worktree orientation before proposing branch/worktree commands (see [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) for wrapper model details, and [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) → "Sync with new main" for ASCII diagrams and commands).

---

## Source of Truth

Load the smallest context bundle that matches the current task. Do not read
every file in this list on every turn. Reuse context already loaded in the
same session unless the task type changes, the file may have changed, or the
conversation was compacted.

Always obey safety gates and team/project precedence once loaded. Refresh only
the mutable state needed for the task, such as git status, the active tracker,
or the current diff.

### Context Bundles

- **Resume / session start**: `AgentJoJoy/agent-records/progress-tracker.md` plus git state from the
  Resume Check.
- **Before edits**: `workflow-spec.md`, `ai-workflow-rules.md`, and the
  project/team context directly relevant to the files being edited.
- **Debug**: matching core practice skill, `technical-precedents.md`, and the
  smallest runnable/test context needed to reproduce or trace the failure.
- **Review / audit**: the immediate diff/artifact, matching core practice skill,
  and touched call paths only.
- **Onboarding / intake**: `intake-flow.md`, `project-overview.md`,
  `engagement-mode.md`, and `workspace-model.md`.
- **Git / worktree operations**: `workspace-model.md`, `workflow-spec.md`, and
  the active tracker.
- **Skills**: `skills/README.md` plus only the specific matching `SKILL.md`.
- **SmartWorker / worker dispatch** (optional capability only): `ai-workflow-rules.md` → Work
  Escalation, `AgentJoJoy/agent-smartworkers/README.md`, and the target
  SmartWorker spec or template. Load only when the current task needs
  separate-context worker dispatch.
- **Hook enforcement contracts** (optional capability / runtime adapter only):
  existing rule source (`workflow-spec.md` / `ai-workflow-rules.md` as
  applicable), `AgentJoJoy/agent-hooks/README.md`, the target contract, and the
  matching runtime binding doc. Load only for hook design, binding,
  implementation, or audit work.

Available sources:

- [`AgentJoJoy/agent-rules/workflow-spec.md`](AgentJoJoy/agent-rules/workflow-spec.md) — canonical workflow rules (SPEC-1 → SPEC-9)
- [`AgentJoJoy/agent-rules/ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) — AI permission boundaries & 4 Pillars of Workspace Governance
- [`AgentJoJoy/agent-context/project-overview.md`](AgentJoJoy/agent-context/project-overview.md) — what this project is
- [`AgentJoJoy/agent-context/architecture.md`](AgentJoJoy/agent-context/architecture.md) — stack, boundaries, invariants
- [`AgentJoJoy/agent-context/standards.md`](AgentJoJoy/agent-context/standards.md) — code/writing standards
- [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) — detailed Path 1 / Path 2 onboarding flow
- [`AgentJoJoy/agent-rules/workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md) — wrapper ownership model, operational notes, and leak-prevention rules
- [`AgentJoJoy/agent-context/engagement-mode.md`](AgentJoJoy/agent-context/engagement-mode.md) — core hot behavior config: execute/teach and behavior toggles; not persona or safety enforcement
- [`AgentJoJoy/agent-context/ui-context.md`](AgentJoJoy/agent-context/ui-context.md) — optional UI project context; load only when UI work or UI onboarding needs it
- [`AgentJoJoy/agent-context/technical-precedents.md`](AgentJoJoy/agent-context/technical-precedents.md) — triggered technical memory for debug, tooling, environment, and known-workaround tasks
- [`AgentJoJoy/agent-context/domain-language.md`](AgentJoJoy/agent-context/domain-language.md) — optional glossary and domain-language map; load only when terminology matters
- [`AgentJoJoy/skills/README.md`](AgentJoJoy/skills/README.md) — skill layer model: Personal Agent Skills vs Project Skills and precedence when both match
- [`AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md`](AgentJoJoy/skills/agentjojoy-core-practices/SKILL.md) — triggered practice router for debugging, review, RCA, and stakeholder communication
- [`AgentJoJoy/skills/grill-me/SKILL.md`](AgentJoJoy/skills/grill-me/SKILL.md) — triggered thinking routine for brainstorming, planning, and pressure-testing ideas before implementation
- [`AgentJoJoy/skills/pattern-detection/SKILL.md`](AgentJoJoy/skills/pattern-detection/SKILL.md) — optional meta-routine that routes visible repeated work to the right tier (script / SmartWorker / Skill); not a background monitor
- [`AgentJoJoy/skills/lean-output/SKILL.md`](AgentJoJoy/skills/lean-output/SKILL.md) — optional output-brevity style ("smaller mouth, same brain"); active when the Lean Output toggle is on or on demand
- [`AgentJoJoy/agent-smartworkers/`](AgentJoJoy/agent-smartworkers/) — optional SmartWorker capability: single Main dispatches knowledge-requiring workers to a separate context only when justified (3-tier taxonomy; neutral spec + per-runtime binding; not multi-agent orchestration); also holds the Loop Contract template for governed autonomous runs
- [`AgentJoJoy/agent-hooks/`](AgentJoJoy/agent-hooks/) — optional Hook Enforcement Contracts: docs/templates only for owners who want to mechanize selected AgentJoJoy or project-specific gates; no active hooks/scripts/config ship by default
- [`AgentJoJoy/agent-templates/`](AgentJoJoy/agent-templates/) — optional snippet library / portable inserts; load only when inserting or maintaining a snippet
- [`AgentJoJoy/agent-records/`](AgentJoJoy/agent-records/) — progress tracker, temporary setup tracker, decisions, cold setup history, and optional cold work records
- [`AgentJoJoy/agent-records/progress-tracker.md`](AgentJoJoy/agent-records/progress-tracker.md) — current state, decisions, next steps

If this file conflicts with `CLAUDE.md` on agent-specific behavior,
**this file wins** for the agent reading it. For workflow rules
(permission gates, SPEC-* rules), `AgentJoJoy/` files always win.

For existing projects, team/project repo rules are authoritative for
project work. If repo `CLAUDE.md`, repo `AGENTS.md`,
`.cursor/rules/*`, `CONTRIBUTING.md`, style guides, lint/test config,
or other team rules conflict with AgentJoJoy personal preferences,
the team/project rules win for code, docs, architecture, review,
branch, and release decisions.

---

## Multi-Agent Coexistence Rules

When several AI agents share this repo (Claude/Codex on different branches,
Cursor background agents), these rules keep attribution clear and work clean.
Mirrors [`CLAUDE.md`](CLAUDE.md).

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

**Session handoff** — `AgentJoJoy/agent-records/progress-tracker.md` + git state carry most handoffs.
Only when mid-flight state is too subtle for those, write
`AgentJoJoy/session-handoff.md` (owner asks, or real un-inferable mid-flight work);
normal state empty. At session start, if it holds an active handoff, reconcile
with git + tracker, then reset to empty as part of the same session's work (not a
standalone commit). Agents must never approve/merge their own PR.

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

## Commit and PR Behavior (Generic)

- **Never push directly to a default branch** (`main`/`master`/`develop`) — always via PR.
  Owner-chosen exception: one-time empty-repo bootstrap.
- **Branch first, then code** in a worktree under `<workspace-root>/worktree-<task>/`
  (see [`workspace-model.md`](AgentJoJoy/agent-rules/workspace-model.md)).
- **Per-action approval** for commit/push/merge/PR; **strategic choices** (rebase vs
  merge, force vs normal push) are the owner's to name — see
  [`ai-workflow-rules.md`](AgentJoJoy/agent-rules/ai-workflow-rules.md) (Pillar I) + SPEC-1.5.
- **No `--no-verify`** — fix the hook failure instead.
- Run the project's verification (type check, tests, build) before committing; report results.
- Update `AgentJoJoy/agent-records/progress-tracker.md` after meaningful work (concise summary — SPEC-9.1.2).

---

## Language

- **Code and comments**: English
- **Project documentation under `AgentJoJoy/`**: English (so any
  agent can read it without translation)
- **Conversation with the owner**: English by default. Detects and adapts dynamically to other languages (e.g. Thai) if the owner initiates in them. See [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md) for Path 2 team repo audit constraints.

---

## Onboarding Convention

If the owner types `onboard`, `setup workspace`, `intake` (or Thai: `เริ่ม onboarding`) at the start of a session or when requested, you must initiate the guided onboarding walkthrough following [`AgentJoJoy/agent-rules/intake-flow.md`](AgentJoJoy/agent-rules/intake-flow.md).
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
