# AI Workflow Rules — Personal

How the user works with Claude / Cursor / other AI agents on this
project. These rules sit beside team/project rules and cover how AI is
allowed to act on the owner's machine.

## Approach

Spec-first within the project's existing structure. The project's
team rules (typically in `CLAUDE.md` at repo root and `.cursor/rules/`)
define what is allowed and how code/docs should look.

When rules appear to conflict:

- Team/project repo rules win for repo content and conventions:
  code standards, architecture, review requirements, documentation
  policy, branch policy, and release process.
- AgentJoJoy safety gates win for actions taken by AI on the owner's
  machine: approvals, destructive commands, remote writes, secrets,
  production access, force operations, and personal context boundaries.

Follow the stricter rule and ask the owner when the boundary is unclear.

## AI Permission Boundaries — Ask Before You Execute

The AI may **suggest** any operation, but must **never execute** state-
or remote-changing commands without my explicit, per-action approval.
A previous approval does not carry over to a new operation, even if
similar. Each time, ask first, show the exact command, then wait for
me to say go.

### Requires my approval before execution

Git (local state):
- `git commit` (any form, including `--amend`)
- `git checkout` / `git switch` to a different branch
- `git merge`, `git rebase`, `git cherry-pick`
- `git reset`, `git revert`
- `git branch -d` / `-D` (delete)
- `git stash pop` / `apply` / `drop` (anything that moves state)
- `git worktree add` / `remove`
- `git update-index --skip-worktree` and similar index manipulation

Git (remote):
- `git push` to any branch (including new branches)
- `git pull` (fetch is fine; merging into local is not)
- Anything talking to a remote that writes (push, push --force, etc.)

GitHub / PR:
- `gh pr create`, `gh pr merge`, `gh pr close`, `gh pr ready`
- `gh issue create`, `gh issue close`
- Any operation that posts a comment, opens a PR, or moves state on a
  remote service

Filesystem (destructive):
- Deleting files or folders the AI did not just create in this session
- Overwriting team-owned files (see `Protected Files / Folders` below)

Package and build:
- Installing or upgrading dependencies (`npm install <pkg>`,
  `npm upgrade`, `pip install`, `poetry add`, etc.)
- Modifying lockfiles (`package-lock.json`, `poetry.lock`,
  `Cargo.lock`, etc.)
- Running migrations or DB schema changes

Runtime / environment actions:
- Starting development servers, workers, schedulers, emulators,
  containers, browsers, desktop/mobile apps, terminals, or other
  long-running runtimes
- Running scripts with unclear side effects
- Running e2e suites that open browsers, call external services, or
  use non-local environments
- Deploying, applying infrastructure, seeding data, sending
  notifications, charging money, placing orders, trading, controlling
  hardware/devices, or touching production-like accounts/sessions
- Compiling/running/attaching to runtime-hosted projects when the
  project docs do not explicitly mark the action as a safe local
  verification command

### Safe to do without asking

- Read any file in the working tree
- `git status`, `git log`, `git diff`, `git branch --list`,
  `git worktree list`, `git ls-files`, `git check-ignore`
- `git fetch` (read-only — updates remote-tracking refs only)
- Run documented local tests, type checks, and builds when they are
  clearly local/read-only for this project
- Read-only DB queries against a non-prod DB, if I've previously
  authorized DB access
- Inspect process / network state (`netstat`, `tasklist`, etc.)

### Command fallback after environment/runtime failure

If a command fails because of the local shell, executable wrapper, or
runtime environment, do not silently switch to a different invocation.
Report the failure, propose the fallback command, and wait for the owner's
approval before running it.

Examples:

- PowerShell blocks `npm.ps1`; propose `npm.cmd run <script>` before
  retrying.
- `python` is not on PATH; propose `py`, `python3`, or the project
  venv path before retrying.
- A command works only in another shell; propose the exact shell and
  command before retrying.

This applies even when the fallback is intended to be equivalent and
read-only. The original command failed; the fallback is a new command
choice.

### Strategic choices require explicit selection (SPEC-3.5)

Separate from execution permission. **Even when a command is
allowlisted** in `settings.local.json` (so the AI may run it without
prompting), the **choice of which command to run** among multiple
valid options is reserved for me.

Examples — the AI must ask every time, regardless of session history:

- Sync strategy: rebase vs merge (vs reset, vs cherry-pick)
- Uncommitted state: commit vs stash vs discard
- Conflict resolution: which side wins, or how to combine
- Branch base: from `main`, `develop`, or another
- Cleanup timing: now vs deferred
- Force push: whether at all, with-lease vs raw `--force`
- File deletion when multiple candidates exist

For each, the AI must:
1. List the options
2. Briefly explain trade-offs
3. Wait for me to name the choice (a generic "go" / "ได้เลย" is
   insufficient — I must pick by name)
4. Only then propose the resulting command (under SPEC-3.1)

Full definition: [workflow-spec.md](workflow-spec.md) → SPEC-3.5.

Force push is never the default path. Raw `git push --force` is
forbidden. If force is explicitly chosen after alternatives are
explained, use `--force-with-lease` only and never on
protected/default/shared branches without another explicit exception.

This rule can be relaxed later by writing a new rule that loosens it
for a specific class of choices. Until then, default = ask every
time.

### Why this rule exists

I want to keep a clear mental model of git and remote state. AI
suggestions are valuable; AI execution of irreversible operations is
not, until I've verified what's about to happen. This rule applies in
every session — re-confirm each time. If I've granted blanket
permission for a specific scope of work, that scope ends when the
current task completes.

## Environment Isolation — Worktree-Based

I do not develop directly in the main team checkout. Instead:

1. Main checkout (`<workspace-root>/<repo-folder>/`) is kept on the
   branch I have under review. Idle, untouched.
2. New work happens in a git worktree under
   `<workspace-root>/worktree-<task>/` with its own branch off
   `origin/main` (or whichever base branch the team is using).
3. Each worktree gets its own dependencies (`node_modules`, `venv`,
   etc.) and environment file copy (`.env`).
4. Any tracked-but-should-be-ignored files (e.g. a local settings
   file that leaked into the repo) are neutralized per worktree with
   `git update-index --skip-worktree`.

Full mechanics: see `workflow-notes.md`.

## Scoping Rules

- One feature unit (or one bug) per branch / per worktree.
- Prefer small, verifiable increments. If a change cannot be verified
  end to end in one sitting, it is too broad — split it.
- Do not combine unrelated system boundaries in a single
  implementation step (e.g. don't mix a UI tweak with a backend
  refactor in the same branch).

## When to Split Work

Split an implementation if it combines any of:

- Frontend changes with backend changes that are not tightly coupled
  to the same feature
- Multiple unrelated modules / domains
- Schema migration + new business logic + new UI all at once
- Behavior that is not clearly defined in the team's rules or in a
  reviewed spec / ticket

## Handling Missing Requirements

- Don't invent product behavior the team hasn't specified.
- If a requirement is ambiguous and there is no team doc covering it,
  flag it in `<workspace-root>/progress-tracker.md` under "Open
  Questions" and ask the lead/owner before proceeding.
- Don't infer schema, status enums, or status transitions — read the
  actual entity files and existing usages in the codebase.

## Protected Files / Folders

Project-specific protected paths live in `workflow-notes.md` (filled
in during intake). General categories to treat as protected by
default:

- **Team rule files** (e.g. `.cursor/rules/*`, `CLAUDE.md` at repo
  root) — team-owned
- **Team planning files** (e.g. `.cursor/plans/*`) — team-owned
- **Per-developer settings that leak** (e.g.
  `.claude/settings.local.json` when tracked despite `.gitignore`) —
  use `skip-worktree` instead of editing
- **Vendored / generated UI libraries** (e.g. `components/ui/`
  shadcn primitives) — treat as a library, don't re-implement
- **Schema definitions** (e.g. `shared/schema.ts`, ORM model files) —
  changes need lead review; never edit speculatively
- **Build config** (e.g. `vite.config.ts`, `tsconfig.json`,
  `webpack.config.js`) — touch only when the task explicitly requires it

Do not modify any of the above without explicit instruction.

## Keeping Personal Docs in Sync

Update files when the underlying reality changes:

- **`<workspace-root>/progress-tracker.md`** (work tracker, at root)
  — after every meaningful work action (branch created, PR pushed,
  merge done, blocker found)
- **`AgentJoJoy/agent-context/progress-tracker-setup.md`** (setup tracker) — when
  workspace structure changes or spec is amended
- **`AgentJoJoy/agent-context/architecture.md`** — if I learn something new about
  the stack or invariants
- **`AgentJoJoy/agent-context/standards.md`** — if team rules change
- **`AgentJoJoy/agent-rules/workflow-notes.md`** — if my workflow evolves (new
  gotchas, new tooling)
- **`AgentJoJoy/agent-decisions/`** — log significant decisions as their
  own file (`YYYY-MM-DD-topic.md`)

Team repo docs (`README*.md`, `*.md` at root) are owned by the team —
don't update them without a clear ask.

## Before Moving to the Next Task

Checklist before starting anything new:

1. Current branch is either merged or actively in review
2. Type check / lint passes in the worktree
3. Tests for the change exist and pass
4. Workspace-root `progress-tracker.md` reflects the completed work
5. The worktree is either cleaned up (`git worktree remove`) or
   parked deliberately

## Anti-Patterns to Avoid

- **AI executing git push / pull / commit / merge without asking me
  first.** Even when it "looks obvious." See "AI Permission Boundaries"
  at the top of this file.
- Editing the team's rule files (`.claude/`, `.cursor/`, etc.)
  casually — even if AI suggests it, push back unless the change is a
  deliberate PR
- Creating `*_SUMMARY.md`, `FIX.md`, or any explanatory markdown
  inside the team repo (when team rules forbid it)
- Using `--no-verify` on commits — investigate hook failures, don't
  bypass them
- Switching branches in the main checkout while a PR is in review —
  use a worktree instead
- Copying secrets/credentials into `AgentJoJoy/` — they belong only
  in the team repo's `.env` or a proper secrets manager

