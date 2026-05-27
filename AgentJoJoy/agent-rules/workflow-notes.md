# Workflow Notes

> 📋 Personal notes for operating against this project's repo without
> breaking the team's setup. Generic worktree workflow lives below.
> Project-specific paths, gotchas, and commands fill in during intake.

---

## Key Paths

<!-- AUTO-FILL during intake: workspace root, main checkout, common
     worktree pattern, user-level Claude config location. Sample
     shape: -->

| Path | What |
|------|------|
| `<workspace-root>/` | **Workspace root** — contains AgentJoJoy/ + repo(s) |
| `<workspace-root>/CLAUDE.md` | Personal workspace rules (loaded by Claude in any subfolder) |
| `<workspace-root>/AgentJoJoy/` | Personal context docs (this folder) |
| `<workspace-root>/<repo-folder>/` | Main checkout of the team repo |
| `<workspace-root>/worktree-<task>/` | Per-task worktrees (siblings of the main checkout) |

Remote: _(set during intake)_

---

## Known Gotchas

<!-- Living list — add project-specific gotchas as discovered. Each
     entry: what the gotcha is, why it bites, how to work around it.
     Example shape preserved below as guidance. -->

### _(no gotchas recorded yet)_

<!-- Example shape:

### `.claude/settings.local.json` tracked despite `.gitignore`

The team repo's `.gitignore` lists `.claude/`, but
`.claude/settings.local.json` was committed before that rule existed,
so git keeps tracking it. Effect: each developer's local Claude
permissions leak into the repo via commits.

**Workaround in every worktree** (run once after creating it):

```powershell
git update-index --skip-worktree .claude/settings.local.json
```

-->

---

## Worktree Workflow — Full Cycle

This section is **generic** and applies to any git project with a
remote. Project-specific commands (install, test, build) appear in
the "Running the Stack Locally" section below.

### 0. Resume Check Auto-Sync

On T3 Resume Check, refresh the generated git-state block in
`progress-tracker.md`:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/worktree-auto-sync.ps1 -Action sync
```

This sync is local and read-only from git's perspective. It does not
fetch, pull, push, rebase, merge, switch branches, create worktrees, or
remove worktrees. It only replaces the managed
`AGENTJOJOY:WORKTREE-AUTO-SYNC` block so the tracker shows the current
local branch/worktree picture before the owner chooses what to do next.

### 1. Create a worktree for a new task

```powershell
# from anywhere — using -C to point at the main checkout
git -C "<workspace-root>/<repo-folder>" fetch origin
git -C "<workspace-root>/<repo-folder>" worktree add `
    "<workspace-root>/worktree-<task>" `
    -b <type>/<owner>-<task> origin/<base>
```

Worktree path naming: use `worktree-<task>` (e.g. `worktree-login-fix`,
`worktree-billing-filter`). Lives as a sibling of the main checkout
and `AgentJoJoy/` under the workspace root.

Branch type prefix follows the team convention — commonly `feature/`,
`fix/`, or `improve/`. Check recent merged PRs for the team's
current scheme.

### 2. First-time setup in the new worktree

```powershell
cd "<workspace-root>/worktree-<task>"
# Copy environment file if .env is gitignored
copy "<workspace-root>/<repo-folder>/.env" .
# Install dependencies (project-specific — see section below)
npm install        # or: pip install -r requirements.txt, etc.
# Neutralize any tracked-but-ignored files that leak
git update-index --skip-worktree <leaked-file>   # if applicable
```

### 3. Develop, test, commit

```powershell
# edit code
npm run check                    # or equivalent type check
npm run test                     # or equivalent test runner
git add <files>
git commit -m "<message>"
```

### 4. Push and open PR

```powershell
git push -u origin <type>/<owner>-<task>
gh pr create --title "..." --body "..."
```

### 5. Park the worktree while in review

Keep the worktree alive in case the reviewer requests changes. Don't
switch branches in this worktree — instead, create another worktree
for the next task.

### 6. Sync with new main (when team merges while you're in flight)

Use this mental model before the commands:

- `origin/main` = the latest team `main` on the remote.
- Your task branch = your commits for one piece of work.
- A worktree = one folder checked out to one task branch.
- `git fetch origin` only updates your local view of the remote; it
  does not change your working files.
- `rebase` moves your task commits on top of the newest `main`. It
  keeps history clean, but rewrites commit IDs.
- `merge` brings newest `main` into your task branch with a merge
  commit. It keeps published history stable.

Picture it like this:

```text
origin/main = latest team main on GitHub
my-branch   = your task branch
```

Before another teammate's work reaches `main`:

```text
main:      A---B
my-branch:     \---C---D
```

After the team merges other work into `main`:

```text
main:      A---B---E---F
my-branch:     \---C---D
```

Your branch still has your work (`C---D`), but it is missing the
newer team commits (`E---F`). Syncing means choosing how to bring
those newer team commits into your branch.

If you choose rebase, Git replays your work on top of the newer
`main`:

```text
main:      A---B---E---F
my-branch:             \---C'---D'
```

The branch looks like it started from the latest `main`. This keeps
history straight, but `C` and `D` become new commits (`C'` and `D'`).

If you choose merge, Git keeps your original commits and creates one
merge commit:

```text
main:      A---B---E---F
my-branch:     \---C---D---M
                    \     /
                     E---F
```

The branch history stays stable, but the graph has an extra merge
commit (`M`).

This is the recipe for SPEC-4. Full rules in
[workflow-spec.md](workflow-spec.md) → SPEC-4.

```powershell
# 1. Save WIP first (pick one)
git status                              # see what's uncommitted
git add . ; git commit -m "WIP: ..."    # option A: commit
git stash push -u -m "WIP for ..."      # option B: stash (incl. untracked)

# 2. Fetch latest
git fetch origin

# 3. Update base — strategic choice per SPEC-3.5: rebase vs merge
git rebase origin/<base>                # cleaner history; rewrites local hashes
# OR
git merge origin/<base>                 # preserves history; adds merge commit

# 4. Resolve conflicts if any
git add <files>
git rebase --continue                   # (rebase path)
# or: git commit                        # (merge path)

# 5. If stashed, restore WIP
git stash pop
```

**Rule of thumb:** branch not yet pushed → rebase is fine. Branch
already pushed and under review → merge avoids needing
`--force-with-lease` on the next push.

### Sync recommendation table

When `origin/<base>` has moved, inspect branch state before asking the
owner to choose a sync strategy. Recommend one option, but still wait
for explicit owner selection.

| Branch state | Recommended sync | Why |
|--------------|------------------|-----|
| Local branch has no local commits | No rebase/merge needed; update from base or create a fresh branch | There is no task work to preserve. |
| Task branch has **single/clean** commits and is **not pushed** | Rebase | Keeps history straight and only rewrites local commits nobody else has seen. |
| Task branch has **multiple/WIP** commits and is **not pushed** | **Squash first, then Rebase** | Collapses messy WIP commits into one clean commit to resolve conflicts only once and keep history clean. |
| Task branch has been pushed but no PR/review exists | Merge by default; Squash/Rebase only if owner explicitly wants clean history | Rebase/Squash would require `--force-with-lease` to push. |
| Task branch has an open PR or reviewer activity | Merge | Avoids rewriting commits reviewers may already be reading. |
| Branch is shared or has co-authors | Merge or stop and ask team lead | Do not rewrite other people's branch history. |
| Branch is default/protected/release | Stop and ask | Never rebase or force-push protected branches by default. |

Signals to inspect:

- `git status --short --branch`
- `git log <branch>..origin/<base> --oneline` for incoming base commits
- `git log origin/<base>..<branch> --oneline` for task branch commits (messages and count)
- Whether the branch has an upstream remote
- Whether there is an open PR or reviewer activity, if known
- Whether commits have co-authors or the branch is shared

Recommendation wording:

```text
origin/main has moved.
Your branch has <N> local commits:
- <hash> <message>
- <hash> <message>

Incoming commits from origin/main:
- <hash> <message>

[Conflict / Overlap Analysis - e.g. "No overlapping files changed" or "Warning: both changed src/main.ts"]

Your branch is <state> (e.g. unpushed with WIP commits).
I recommend <Squash first, then Rebase | Rebase | Merge | Stop> because <reason>.

Options are:
1. Squash first, then Rebase (collapses commits into a single clean commit, then replays it on top of main)
2. Rebase directly (replays all <N> commits individually)
3. Merge directly (creates a merge commit, preserves history exactly)
4. Stop / ask team ...

Which do you choose? (Please type the option name or number)
```

If the owner is new to git, explain this before asking them to choose:

- Before push, rebase/squash only rearranges local commits that nobody else
  has seen.
- After push or PR, rebase/squash changes commits that already exist on the
  remote, so the next push must be `--force-with-lease`.
- `--force-with-lease` is safer than `--force`, but it is still a
  history-rewrite operation and must be discussed explicitly.

### 7. After merge — clean up

```powershell
cd "<workspace-root>/<repo-folder>"
git fetch origin --prune
git worktree remove "<workspace-root>/worktree-<task>"
git branch -d <type>/<owner>-<task>
```

---

## Running the Stack Locally

<!-- AUTO-FILL from package.json scripts (or Makefile, justfile, etc.).
     List the common commands needed during development. Sample shape: -->

```powershell
npm run dev          # development server
npm run check        # type check
npm run test         # tests
npm run build        # production build
```

_(replace with actual commands during intake)_

---

## Database Access

<!-- AUTO-FILL during intake. Cover:
       - Where credentials live (.env / secrets manager)
       - How to query (psql, ORM, dedicated CLI tool, etc.)
       - Which environments exist (prod, dev, staging) and which are
         safe to test against
       - Conventions (read-only by default? LIMIT on exploratory
         queries? confirm prod vs dev before running?)
     Never copy credentials into AgentJoJoy/. -->

_(not set)_

---

## Git Discipline (Generic)

- Never push directly to `main`, `develop`, or `production`
  (or whatever the protected base branches are)
- Empty-repo bootstrap is the only exception: the owner may explicitly
  choose one initial push to `main` when the remote has no commits yet.
  After that, use branch/PR workflow.
- AgentJoJoy template source repo exception: when working in
  `Joyperm/AgentJoJoy` itself, the owner may explicitly choose direct
  checkpoint commits/pushes to `main`. This does not apply to copied
  workspaces or team repos.
- Branch naming follows the team convention (check recent merged PRs
  for the current scheme)
- Don't `--amend` published commits; create a new commit instead
- Don't `--no-verify` — fix hook failures
- One task per branch; bundle related commits, not unrelated ones

---

## Multi-AI Coexistence

When multiple AI tools touch the same repo, things to watch:

- Tool-prefixed remote branches (e.g. `cursor/...` for Cursor
  background agents) — don't manually rebase or merge them unless
  asked
- Tool-specific planning folders (e.g. `.cursor/plans/`, `.claude/`)
  may be team-shared — read for context, don't overwrite
- My personal AI planning, if any, goes in `AgentJoJoy/`, not in
  team-shared folders

---

## Things to Raise With the Team

<!-- Living list of issues to bring to the team lead. Move resolved
     items to AgentJoJoy/agent-decisions/ once addressed. -->

_(none yet)_
