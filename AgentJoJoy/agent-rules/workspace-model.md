# Workspace Model

How AgentJoJoy separates personal AI context from project code.

---

## Core Idea

AgentJoJoy uses a **wrapper workspace**:

```text
JoySpace/
├─ CLAUDE.md / AGENTS.md          # workspace entry points
├─ progress-tracker.md            # reusable project tracker template
├─ AgentJoJoy/                    # AgentJoJoy-owned AI context
│  ├─ workflow-*.md
│  ├─ workspace-model.md
│  ├─ skills/
│  └─ template-lab/               # source repo state only
├─ TeamRepo/                      # team-owned git repo
└─ worktree-task-a/               # task branch worktree for TeamRepo
```

The wrapper is the owner's personal operating layer. The team repo is still
the team's repo. Worktrees are separate folders for task branches that
share the team repo's git history.

---

## Ownership Boundaries

| Location | Owner | Git remote | Commit here? |
|----------|-------|------------|--------------|
| `AgentJoJoy/` | Owner | AgentJoJoy template repo, or none | Only for personal/template workflow changes |
| `progress-tracker.md` at wrapper root | Owner/template | AgentJoJoy template repo, or none | Template content only in this source repo |
| `TeamRepo/` | Team | Team project remote | Yes, only project changes intended for team review |
| `worktree-*` | Team branch | Same remote as `TeamRepo/` | Yes, task-specific project changes |

The default rule:

```text
Personal context lives outside the team repo.
Team commits come only from TeamRepo/ or worktree-*.
```

---

## Why Wrapper Works

Git only tracks files inside a repository's working tree. If
`AgentJoJoy/` is a sibling of `TeamRepo/`, then `git -C TeamRepo
status` cannot see or commit `AgentJoJoy/`.

That means this layout is naturally safe:

```text
JoySpace/
├─ AgentJoJoy/       # outside TeamRepo, not tracked by TeamRepo git
└─ TeamRepo/.git     # TeamRepo git starts here
```

The wrapper keeps personal AI instructions, notes, decisions, and
skills out of team commits without relying on every team repo's
`.gitignore`.

---

## How Personal Context Can Still Leak

The wrapper prevents accidental tracking in normal use, but leaks can
still happen if files cross the boundary.

Do not commit these into a team repo:

- `AgentJoJoy/`
- wrapper-level `CLAUDE.md`
- wrapper-level `AGENTS.md`
- wrapper-level `progress-tracker.md`
- `AgentJoJoy/template-lab/template-dev-tracker.md`
- local bridge files that point back to the wrapper
- tool-local settings such as `.claude/settings.local.json`,
  `.cursor/`, `.vscode/`, or agent permission files unless the team
  explicitly owns them

Common leak paths:

1. **Copied into repo** — a user copies `AgentJoJoy/` or wrapper entry
   files into `TeamRepo/`.
2. **Created in wrong folder** — an agent opens `TeamRepo/` and writes
   personal notes there instead of the wrapper.
3. **Tracked-before-ignored files** — a local settings file was
   committed once, so `.gitignore` no longer protects it.
4. **Bridge file not ignored** — a convenience file inside `TeamRepo/`
   points to `../AGENTS.md` but is not gitignored.
5. **Language leak in IDE sessions** — non-English conversation in
   Path 2 team repo agent sessions may surface in IDE logs,
   screenshare during reviews, PR-attached transcripts, or
   corporate audit exports. Default to English for Path 2;
   non-English requires explicit owner override. See
   `intake-flow.md` → "Path 2 Conversation Language".

If a bridge is needed for a tool that cannot read parent context, make
it local-only and ignored:

```text
TeamRepo/
├─ .gitignore
└─ AGENTS.local.md   # points to ../AGENTS.md, never committed
```

---

## Where To Open Tools

| Task | Open at | Why |
|------|---------|-----|
| Plan, resume, inspect workflow | `JoySpace/` | Sees wrapper docs and all repos/worktrees |
| Edit team code | `worktree-task-a/` | Keeps one task branch isolated |
| Inspect team default branch | `TeamRepo/` | Main checkout stays clean/reference-only |
| Update personal workflow | `JoySpace/` or `AgentJoJoy/` | Avoids touching team repo |

Before editing code, confirm the target path:

```text
Am I editing TeamRepo/worktree code, or AgentJoJoy-owned workflow docs?
```

---

## Main Checkout vs Worktree

The main checkout is the reference clone of the team repo:

```text
TeamRepo/          # main checkout, usually on main
worktree-fix-x/    # task branch fix/owner-x
worktree-add-y/    # task branch feature/owner-y
```

Each worktree has its own files and branch, but shares the same git
object database as `TeamRepo/`.

Use worktrees so one task does not contaminate another:

```text
one task = one branch = one worktree
```

---

## Template Source Repo Special Case

This repository (`Joyperm/AgentJoJoy`) is the source template itself.
Blank placeholders such as `_(not set)_` are expected.

Use:

- `AgentJoJoy/template-lab/.template-source` as the explicit Template
  Development marker.
- `AgentJoJoy/template-lab/template-dev-tracker.md` for real
  development state of this source repo.

Keep as reusable templates:

- `progress-tracker.md`
- `AgentJoJoy/agent-context/progress-tracker-setup.md`
- `AgentJoJoy/agent-context/project-overview.md`
- `AgentJoJoy/agent-context/architecture.md`
- `AgentJoJoy/agent-context/standards.md`
- `AgentJoJoy/agent-context/ui-context.md`
- `AgentJoJoy/agent-context/domain-language.md`

When copying AgentJoJoy into a real project, remove source-repo-only
development artifacts:

- `AgentJoJoy/template-lab/`
- generated files under `AgentJoJoy/agent-runtime/`

---

## Multi-Agent Rules Portability

AgentJoJoy multi-agent coexistence rules (cursor reservation, agent
code-change tags, commit co-author trailer) live in workspace
`CLAUDE.md` / `AGENTS.md`. Agents see them only when an AgentJoJoy
wrapper is present at or above the current working directory.

Path 2 repos used directly without a wrapper do not inherit these
rules. Path 2 intake closes this gap with a dedicated step that asks
which agents will work on the repo and proposes merging a portable
snippet into the target repo's own `CLAUDE.md` / `AGENTS.md`. See:

- `AgentJoJoy/agent-rules/intake-flow.md` -> "Step 6: Multi-Agent Coexistence
  Rules Portability"
- `AgentJoJoy/agent-templates/multi-agent-coexistence-snippet.md`

The snippet uses HTML marker comments so the section can be replaced
idempotently when the agent stack changes (e.g. adding or dropping
Cursor). The owner can opt out per repo; the step is offered, not
forced.

---

## Clean Ejection (Clean Delete)

If you need to completely remove the AgentJoJoy wrapper layer and its files from a workspace (leaving only your clean project directory), you can run the ejection tool:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/eject.ps1 -Action eject
```

### Affected Files
The script will cleanly remove the following files and folders:
- `CLAUDE.md` and `AGENTS.md` (root entry points)
- `progress-tracker.md` (root work tracker)
- `AgentJoJoy/` (all workflow rules, context files, local tools, and runtimes)

The script is safe: it runs in a dry-run check mode by default (`-Action check`) showing you exactly what it will delete. When run with `-Action eject`, it prompts for confirmation before modifying anything on disk unless `-Force` is passed.


