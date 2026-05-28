# Workflow Specification — Worktree-Based Personal Workflow

Canonical, verifiable rules. This file is the source of truth for
*what* the workflow is. Project-specific operational notes live in
`workflow-notes.md`.

Every rule is numbered (e.g. `SPEC-3.2`) so other docs can reference
it precisely.

---

## SPEC-1. Vocabulary

The following terms have specific meanings in this document:

- **SPEC-1.1 — Upstream repo**: the canonical git remote (e.g. a
  GitHub repository the team owns). For projects without a remote,
  the upstream is "local only" and remote-related rules do not apply.
- **SPEC-1.2 — Main checkout**: the local clone of the upstream repo
  that contains the `.git` directory. Used as a reference point and
  as the source for new worktrees. Should normally stay on a single
  branch and remain undisturbed.
- **SPEC-1.3 — Worktree**: a separate working directory that shares
  the main checkout's `.git` directory but has its own branch and
  working files. Created with `git worktree add`. Lives in a sibling
  folder of the main checkout, organized under a workspace root.
- **SPEC-1.4 — Workspace root**: the folder that contains all
  worktrees, the main checkout, and personal context (`AgentJoJoy/`).
  Referred to throughout this spec as `<workspace-root>`.
- **SPEC-1.5 — Base branch**: the upstream branch from which new
  worktrees are created. Default: `main`. If the team uses a different
  base (e.g. `develop`), substitute that branch name throughout.
- **SPEC-1.6 — Task branch**: the branch dedicated to a single task,
  checked out in a worktree. Named per the project's convention —
  commonly `feature/<owner>-<task>`, `fix/<owner>-<task>`, or
  `improve/<owner>-<task>`. Project-specific patterns live in
  `workflow-notes.md`.
- **SPEC-1.7 — AI**: the Claude (or other) agent driving the
  workflow under user direction.
- **SPEC-1.8 — User**: the human directing the AI.

---

## SPEC-2. Lifecycle of One Task

A single task moves through these stages in order. Each stage has
explicit rules below.

```
2.1 Intake → 2.2 Pre-flight → 2.3 Worktree creation → 2.4 Setup →
2.5 Implementation → 2.6 Verification → 2.7 Push → 2.8 PR → 2.9 Review
loop → 2.10 Merge → 2.11 Cleanup
```

### SPEC-2.1 Intake
- Session Start / Resume Check is a pre-task safety check and may run
  before this task restatement. Once the session state is known, this
  intake rule applies to the user's actual task.
- The user states the task. The AI must restate the task back to the
  user in one to three sentences before doing anything else, and wait
  for confirmation that the restatement is correct.
- **Target worktree must be part of the restatement when multiple
  worktrees are active** (parallel mode per SPEC-5). If the task
  does not clearly map to one existing worktree, the AI lists the
  active worktrees with brief identifiers (branch + short summary)
  and asks the user to pick one, or indicates that a new worktree
  is needed. This is a SPEC-3.5 strategic choice and may not be
  inferred without explicit user selection.
- When exactly one worktree is active, the AI may name it implicitly
  in the restatement (e.g. "I'll do this in `<worktree-name>` —
  correct?") but is not required to elaborate.
- When no worktrees are active, target selection is deferred to
  SPEC-2.3 (worktree creation).
- Rationale: a misidentified target worktree causes edits in the
  wrong branch and silent contamination of unrelated work.
  Naming the target during intake catches the mistake at the
  cheapest possible point.

### SPEC-2.2 Pre-flight
- The AI runs read-only inspection: `git status`, `git branch -a`,
  `git worktree list`, `git log -5 --oneline` in the main checkout.
- The AI reads `progress-tracker.md` (if present) to check for
  in-flight work.
- The AI reports findings to the user. The user decides whether to
  proceed with a new worktree, resume an existing one, or abort.

### SPEC-2.3 Worktree creation
- The AI proposes:
  - The worktree path (under workspace root, name aligned with task)
  - The task branch name (per SPEC-1.6 naming)
  - The base branch (default `origin/<base>`, refreshed via
    `git fetch origin` first)
- The AI shows the exact `git worktree add` command and waits for
  user approval before running it.

### SPEC-2.4 Setup
- After the worktree exists, the AI walks through setup as discrete
  steps, each requiring approval if state-changing. Typical setup
  steps include (project-specific list lives in `workflow-notes.md`):
  - Copy environment files (e.g. `.env`) from main checkout
  - Install dependencies (`npm install`, `pip install`, etc.)
  - `git update-index --skip-worktree <files>` for any known-leaked
    tracked-but-ignored files
- The AI reports setup completion before implementation begins.

### SPEC-2.5 Implementation
- The AI may freely read code, run tests, run type checks, run builds.
- **SPEC-2.5.1 — Test-First / TDD Discipline**: When implementing new features or writing new logical modules, the AI is strongly encouraged to draft or stub test suites first (or explicitly define the correct behavior and interface contracts) to establish a verification safety net before implementing core business logic.
- The AI proposes edits, then writes files (file edits are not in the
  same category as git operations — see SPEC-3 for the approval
  taxonomy).
- The AI does not run `git commit` during implementation.

### SPEC-2.6 Verification
- Before any push or PR, the AI runs the project's verification
  commands as appropriate. The specific commands belong in
  `workflow-notes.md`; typical examples:
  - Type check (`npm run check`, `tsc`, `mypy`, etc.)
  - Tests (unit, integration, e2e — scoped to the change)
  - Build, if relevant to the task
- Verification commands are safe to run without extra approval only
  when they are documented or clearly local/read-only for this project.
  If a command may start a long-running service, open an app or
  browser, attach to a runtime, connect to an external system, mutate
  data, send notifications, place orders, run migrations, deploy,
  control hardware/devices, or otherwise affect an environment, treat
  it as a runtime/environment action and ask first.
- The AI reports results to the user. If anything fails, the AI does
  not proceed to push.
- If verification fails because of the local shell, executable
  wrapper, PATH, or runtime environment, the AI reports the failure and
  asks before running an alternate invocation. Examples:
  - PowerShell blocks `npm.ps1`; propose `npm.cmd run <script>`.
  - `python` is unavailable; propose `py`, `python3`, or the project
    venv path.
  - A command needs another shell; propose the exact shell command.
  Even if the fallback is read-only and equivalent, it is still a new
  command choice after the original command failed.

### SPEC-2.7 Push
- The AI proposes the commit message and shows the exact
  `git add` and `git commit` commands, waits for approval.
- After commit, the AI shows the exact `git push -u origin <branch>`
  (or just `git push` after first push), waits for approval.
- Exception: if the upstream remote is empty and the owner explicitly
  chooses a one-time bootstrap, the AI may propose an initial push to
  the default branch. This exception ends after the first remote
  commit exists.
- Template source exception: when the checkout is the AgentJoJoy
  template source repo itself, the owner may explicitly choose direct
  checkpoint pushes to `main`. This exception is for template-source
  development only and must not be applied to copied workspaces or
  Path 2 team repos.

### SPEC-2.8 PR
- The AI proposes the PR title and body.
- The AI shows the exact `gh pr create` command and waits for
  approval.
- After PR creation, the AI shows the PR URL to the user.

### SPEC-2.9 Review loop
- While the PR is awaiting review, the worktree stays alive.
- If the reviewer requests changes:
  - The AI edits in the same worktree
  - The AI follows SPEC-2.6 (verify) and SPEC-2.7 (push) again
- The AI may start another task in parallel — see SPEC-5.

### SPEC-2.10 Merge
- After merge, the AI runs `git fetch origin --prune` (safe; no
  approval needed under SPEC-3.2).
- The AI does not delete the worktree until the user confirms the
  merge was successful and no follow-up is expected.

### SPEC-2.11 Cleanup
- The AI proposes:
  - `git worktree remove <path>`
  - `git branch -d <task-branch>` (local branch delete)
- The AI shows the exact commands and waits for approval.
- After cleanup, the AI updates `progress-tracker.md` (file edit, no
  approval required for this file).

---

## SPEC-3. AI Permission Gates

### SPEC-3.1 — Requires explicit per-action approval
The AI must show the exact command and wait for the user to say go
before executing any of these. Previous approval does not carry over
across operations.

Git (local state):
- `git commit` (any form, including `--amend`)
- `git checkout` / `git switch` to a different branch
- `git merge`, `git rebase`, `git cherry-pick`
- `git reset`, `git revert`
- `git branch -d` / `-D`
- `git stash pop` / `apply` / `drop`
- `git worktree add` / `remove`
- `git update-index --skip-worktree` and similar index manipulation

Git (remote):
- `git push` (any form, any branch)
- `git pull` (note: `git fetch` is SPEC-3.2, but `pull` merges and is
  state-changing)
- Any other operation that writes to a remote

GitHub / PR:
- `gh pr create`, `gh pr merge`, `gh pr close`, `gh pr ready`
- `gh issue create`, `gh issue close`
- Any operation that posts a comment or moves state on a remote
  service

Filesystem (destructive):
- Deleting files or folders the AI did not just create in the current
  session
- Overwriting team-owned files (config at repo root, files in
  team-controlled directories)

Package and build (state-modifying):
- Installing or upgrading dependencies (`npm install <pkg>`,
  `npm upgrade`, `pip install`, etc.)
- Modifying lockfiles (`package-lock.json`, `poetry.lock`, etc.)
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

### SPEC-3.2 — Safe without approval
The AI may run these freely:

- Read any file in the working tree
- `git status`, `git log`, `git diff`, `git branch --list`,
  `git worktree list`, `git ls-files`, `git check-ignore`,
  `git remote -v`
- `git fetch` (no flags or with `--prune`) — updates remote-tracking
  refs only; no working-tree change
- Run documented local tests, type checks, and builds when they are
  clearly local/read-only for this project
- Inspect process / network state (`netstat`, `tasklist`,
  `Get-Process`)
- Read-only DB queries against a non-prod DB, if the user has
  previously authorized DB access

### SPEC-3.3 — File edits
File creation and editing in the working tree are not git operations.
They are governed by:

- The user's overall task definition (don't edit out-of-scope files)
- Team rules (when working on a team repo — e.g. `.cursor/rules/`,
  `CLAUDE.md` at the repo root)
- Common sense (don't delete files without reason)

The AI may freely edit, create, and delete files **within the scope
of the current task**. Approval is required only for destructive
filesystem operations on files the AI did not create in the session.

### SPEC-3.4 — Approval scope
When the user approves an operation, the approval applies to:

- The exact command shown
- A single execution

If the AI wants to run a variant of the approved command (different
flags, different target), the AI must re-request approval.

If a command fails and the AI wants to retry through a different
executable, shell, wrapper, or PATH target, that retry is a variant of
the original command. The AI must explain the failure and ask before
running the fallback.

A user approval to a sequence of clearly-listed steps applies to that
listed sequence only, and ends after the last step completes.

### SPEC-3.5 — Strategic choice gate

Some Claude Code (or other tool) configurations permit specific
commands to run without per-execution approval (via
`settings.local.json` allow lists, hooks, or similar mechanisms).
Those configurations grant **execution authority** — they decide
whether the AI may run a particular command at all.

They do NOT grant **strategic choice authority** — the decision of
*which* command to run when multiple valid options exist. Strategic
choices belong to the user. The AI must ask explicitly every time,
regardless of session approval history, allowlist configuration, or
how many times the user has approved similar choices in this session.

Examples of strategic choices that must always be asked:

- Sync strategy: rebase vs merge (vs reset, vs cherry-pick)
- Uncommitted change handling: commit, stash, or discard
- Conflict resolution: which side wins, or how to combine
- Branch base: from `main`, `develop`, or another branch
- Cleanup timing: now vs deferred (e.g. delete a worktree)
- Force operations: whether to use `--force`/`--force-with-lease`,
  and on which branch
- File deletion: which files to remove when multiple candidates exist
- Test-vs-ship: proceed with a known-failing edge case or block

For each strategic choice, the AI must:

1. List the available options
2. Briefly explain the trade-offs between them
3. Wait for explicit user selection (a "yes" or generic "go" is not
   sufficient — the user must name the choice)
4. Only then propose the resulting command under SPEC-3.1

This rule applies independently of execution-authority configuration.
A configuration that auto-approves `git merge` removes the per-command
prompt, but the AI must still surface "should we merge or rebase?"
before choosing which command to propose. The user retains the
strategic decision regardless of how the executor is configured.

This rule may be relaxed later if the user explicitly writes a new
rule loosening it for a specific class of choices. Until then, the
default is: ask every time.

### SPEC-3.6 — Force push safety

Force push is never the default sync strategy.

The AI must not run or propose force push as the default path. If a
normal push is rejected or a rebase rewrote a branch that has already
been pushed, the AI must first present alternatives:

- Merge instead
- Create a new branch
- Stop and ask the team lead / owner
- Rebase plus `git push --force-with-lease`

The AI must explain the risk and wait for the user to explicitly
choose the force-with-lease option.

Raw `--force` is forbidden. If force is explicitly chosen, use
`--force-with-lease` only, and never use it on protected/default/shared
branches unless the owner explicitly confirms the exceptional case.

### SPEC-3.7 — Block Protection (AI-NO-OVERWRITE)

Any block of code or text wrapped inside these specific HTML comment tags in any file:

<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN -->
...
<!-- AGENTJOJOY:AI-NO-OVERWRITE END -->

is protected from autonomous AI modification.

Rules:
- The AI must **never autonomously edit, delete, overwrite, or modify** any text or settings between these tags — not during refactoring, template upgrades, intake, or any self-initiated action.
- The AI must **preserve the tags themselves** and everything in between exactly as-is unless the user explicitly asks for a change.
- If the AI believes a change is needed inside a protected block, it must **describe the proposed change and wait for explicit user approval** before editing. A generic "go" or "sure" is insufficient — the user must confirm the specific change (per SPEC-3.5).
- When the user explicitly requests a modification to protected content, the AI **may** make the change. The protection guards against autonomous AI action, not against user-directed edits.
- This rule applies to both active session file edits and automated template upgrades.

---

## SPEC-4. Upstream Sync Protocol

This is the protocol that runs when the base branch (e.g.
`origin/main`) has moved while the user has work in progress in a
worktree.

### SPEC-4.1 Detection
- The AI runs `git fetch origin` (safe under SPEC-3.2).
- The AI compares the worktree's branch base with `origin/<base>`:
  - `git log <task-branch>..origin/<base> --oneline` (incoming changes)
  - `git log origin/<base>..<task-branch> --oneline` (local changes)
- The AI reports both lists to the user.

### SPEC-4.2 Pre-sync state assessment
Before any sync, the AI must determine:

- Are there uncommitted changes in the worktree? (`git status`)
- Are there committed changes ahead of `origin/<base>`?
- What is the commit structure of the task branch? Run `git log origin/<base>..<task-branch> --oneline` to analyze how many commits exist, what their messages are, and if they contain WIP or temporary messages.
- Are the files changed locally also changed upstream? (overlap risk)

The AI reports this to the user before proposing a sync strategy.

### SPEC-4.3 Strategy choice
This is a SPEC-3.5 strategic choice — the AI must ask explicitly
every time, regardless of execution-authority configuration.

If the task branch has multiple commits or WIP commits, the AI must present and recommend **Squash / Clean commits** as a pre-sync option (e.g. collapsing commits into a single clean commit first via interactive rebase or soft reset) before rebasing or merging. This simplifies conflict resolution (solving conflicts once instead of per-commit) and prevents messy commits from polluting the team repository history.

The AI presents the following options to the user and asks which to use:

- **Squash first, then Rebase** — collapses multiple commits into a single clean commit first, then replays it on top of the base. (Highly recommended for messy/WIP local-only branches).
- **Rebase** (`git rebase origin/<base>`) — replays local commits individually on top of the new base. Cleaner history. Rewrites local commit hashes. Conflicts surface per-commit.
- **Merge** (`git merge origin/<base>`) — creates a merge commit. Preserves history exactly. Conflicts surface once.

Default suggestion when local commits are not yet pushed: rebase (or squash + rebase).
When local commits are already pushed: merge (avoids needing `--force-with-lease` on the next push).

The AI must recommend a strategy based on branch state before asking
the user to choose. The recommended decision table lives in
`workflow-notes.md` → "Sync recommendation table". The recommendation
does not replace the user's explicit selection under SPEC-3.5.

The user must select explicitly; a generic "go" is insufficient (see
SPEC-3.5).

### SPEC-4.4 Handling uncommitted changes pre-sync
If there are uncommitted changes:

- The AI proposes either:
  - Commit them to the task branch first (preferred), or
  - `git stash` them (clearly labeled, since stash is fragile)
- The user approves the choice before the AI executes.

### SPEC-4.5 Conflict handling
During rebase or merge, if conflicts occur:

- The AI lists the conflicted files
- The AI shows the conflict content for each file
- The AI does **NOT** auto-resolve any conflict
- For each conflict, the AI proposes a resolution and waits for
  approval before writing the file
- After all conflicts resolved, the AI runs `git rebase --continue` or
  completes the merge (these are approval-gated under SPEC-3.1)

### SPEC-4.6 Verification post-sync
After the sync completes:

- The AI runs the project's verification commands (SPEC-2.6)
- The AI reports any failures to the user
- If verification fails, the AI does not push the synced branch

---

## SPEC-5. Parallel Worktrees

### SPEC-5.1 Multiple worktrees may coexist
The user may direct the AI to start a new task while an existing task
is in progress (e.g. awaiting PR review). The AI must support this.

### SPEC-5.2 No branch switching across worktrees
Each worktree owns one task branch. The AI must not check out a
different branch in an existing worktree to switch tasks — create a
new worktree instead.

### SPEC-5.3 Cross-worktree awareness
When working in worktree A, the AI must be aware that:

- Worktree B has its own working files (changes there do not appear
  in `git status` for A)
- Both worktrees share the same `.git` directory, so `git fetch` in A
  also updates B's view of remotes
- A branch checked out in one worktree cannot be checked out in
  another

### SPEC-5.4 Listing
At any time the user may ask "what worktrees are active?" The AI
answers with `git worktree list` plus a brief description of each
(branch, last commit, PR status if known).

---

## SPEC-6. Failure Recovery

### SPEC-6.1 Pre-commit hook failure
- The AI reads the hook output
- The AI proposes a fix that addresses the underlying issue
- The AI must **NOT** propose `--no-verify` or any flag that bypasses
  the hook
- After fixing, the AI re-runs the commit (re-requesting approval per
  SPEC-3.1)

### SPEC-6.2 Test failure
- The AI does not push.
- The AI investigates the failure (reads test output, related code)
- The AI proposes a fix or asks the user for direction
- The AI does not mark the task complete until tests pass

### SPEC-6.3 Push rejected (non-fast-forward)
This happens when the remote branch has moved (someone else pushed,
or the user pushed from another worktree). The AI must:

- Run `git fetch origin` (safe)
- Enter the SPEC-4 upstream sync protocol
- Re-attempt push only after sync succeeds and verification passes
- The AI must **NOT** propose `git push --force` or
  `git push --force-with-lease` without explicit user instruction,
  even after sync. See SPEC-3.6.

### SPEC-6.4 Lost work prevention
The AI must never propose:

- `git reset --hard` when uncommitted changes exist
- `git clean -fd` without first listing what will be deleted
- `git checkout .` or `git restore .` on files with uncommitted edits
- Force-pushing over a branch that has co-authors
- Raw `git push --force`

If any such operation seems needed, the AI must surface the trade-off
clearly and let the user decide.

---

## SPEC-7. Cleanup Protocol

### SPEC-7.1 When to cleanup
A worktree is eligible for cleanup when:

- Its PR has been merged AND
- The user has confirmed no follow-up work is expected on that branch

### SPEC-7.2 Cleanup steps
The AI proposes (in order, each gated):

1. `git fetch origin --prune` (safe; runs automatically)
2. `git worktree remove <path>` (approval required)
3. `git branch -d <task-branch>` (approval required; `-d` not `-D` —
   refuses if branch has unmerged commits, which is the safe default)
4. Update `progress-tracker.md` to record the completion

### SPEC-7.3 Premature cleanup
The AI does not propose cleanup until SPEC-7.1 conditions are met.
If the user requests early cleanup, the AI must confirm awareness of
the risks (e.g. losing local branch state) before proceeding.

---

## SPEC-8. Documentation Update Discipline

### SPEC-8.1 progress-tracker.md
There are two trackers, separated by concern:

- **`<workspace-root>/progress-tracker.md`** — the **REAL WORK**
  tracker. The AI updates this after meaningful state changes in the
  workflow: branch created, PR pushed, merge completed, blocker
  encountered, worktree created/removed, task state changed. File
  edits here are SPEC-3.3 (no approval required). The Resume Check
  Protocol reads this file first.

- **`<workspace-root>/AgentJoJoy/agent-context/progress-tracker-setup.md`** —
  the **SETUP / workspace meta** tracker. The AI updates this when
  workspace structure changes, spec amendments are applied,
  onboarding milestones occur, or AI workflow rules evolve. The AI
  reads this only when the user asks about setup history or
  workflow changes.

When SPEC-2, SPEC-4, SPEC-7, etc. say "update `progress-tracker.md`",
they refer to the WORK tracker at root unless the action is
explicitly about workspace meta.

### SPEC-8.1.1 Dynamic Worktree Auto-Sync

During T3 Resume Check, the AI should refresh the managed
`AGENTJOJOY:WORKTREE-AUTO-SYNC` block in `progress-tracker.md` using
the local helper in `AgentJoJoy/agent-tools/`.

Rules:

- The sync may use only read-only git inspection commands such as
  `git status --short --branch`, `git worktree list --porcelain`, and
  `git branch --show-current`.
- It must not run `git fetch`, `git pull`, `git push`, `git merge`,
  `git rebase`, `git switch`, `git checkout`, `git worktree add`, or
  `git worktree remove`.
- It may replace only the managed auto-sync block. Human task notes,
  current goals, open questions, and recent actions remain manually
  maintained.
- In T0 Template Development mode, do not sync the reusable blank
  `progress-tracker.md` unless intentionally testing the helper.

### SPEC-8.2 workflow-spec.md
This file (the spec) is updated only by deliberate revision, not as
part of normal task workflow. Changes to this file should be
discussed with the user explicitly.

### SPEC-8.3 Team repo docs
When working on a team repo, the AI follows the team's documentation
conventions (typically in `CLAUDE.md`, `CONTRIBUTING.md`, or
`.cursor/rules/*.mdc` at the repo root). Personal notes belong in
`AgentJoJoy/`, never in the team repo.

---

## SPEC-9. Verification Hierarchy

When deciding whether to proceed, the AI applies checks in this
order:

1. Does the user's stated task scope cover this action?
2. Is the action allowed by team rules (when working on a team repo)?
3. Does the action require approval per SPEC-3.1? → ask
4. Is the action a documented step in SPEC-2? → propose it as such
5. Otherwise → proceed (SPEC-3.2)

If any check is ambiguous, the AI asks the user rather than guessing.

