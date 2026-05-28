# Intake Flow

Canonical onboarding flow for turning a fresh AgentJoJoy wrapper into a
usable personal AI workspace.

Use this file when templates in `AgentJoJoy/` still show `_(not set)_`
and the checkout is not the AgentJoJoy template source repo.

---

## Goals

Intake has three jobs:

1. Identify what kind of workspace this is.
2. Fill the minimum useful context files without inventing facts.
3. Turn the owner's goal into a small, reviewable plan before work
   begins.
4. Teach the owner enough of the wrapper/worktree model to avoid
   accidental commits or git confusion.

The output is a workspace that future sessions can resume without
asking the same setup questions again.

Intake should reach **useful-enough context, not perfect context**.
Unknowns are allowed when recorded clearly in Open Questions. Do not
keep asking questions just to make every template field complete.

---

## Trigger Conditions

Run intake when all are true:

- `AgentJoJoy/agent-context/project-overview.md` has both "Project Name" and
  "What It Is" set to `_(not set)_`.
- The owner confirms they want to set up a new or existing project.

## Trigger States

At session start, classify the workspace before doing intake work.

### T1 — Fresh Template

The workspace is a copied/new AgentJoJoy wrapper and has not been
onboarded yet.

Signals:

- `Project Name` is `_(not set)_`.
- `What It Is` is `_(not set)_`.
- Not T0.

Action:

- Ask whether to start intake now.
- Offer Path 1, Path 2, or Skip.

### T2 — Partial Intake

Intake appears to have started but not finished.

Signals:

- One of `Project Name` or `What It Is` is filled, but the other is
  blank, or
- Engagement mode is still not set, or
- Key path/remote/progress fields are still blank after some context
  has been filled.

Action:

- Ask whether to resume intake from existing files or restart intake.
- Default recommendation: resume.
- Never overwrite existing filled fields without showing a preview.

### T3 — Onboarded / Resume

The workspace has enough context for normal work.

Signals:

- `Project Name` is filled.
- `What It Is` is filled.
- Engagement mode and working convention are set, or intentionally
  deferred in Open Questions.
- The key items in the Completion Checklist are either filled or
  explicitly recorded as Open Questions.

Action:

- Run Resume Check.
- Read `progress-tracker.md`.
- Continue existing work or ask what task to start.

---

## Auto-Detect Flow

Use this order:

1. Read `AgentJoJoy/agent-context/project-overview.md`.
1. If T3, run Resume mode.
1. If T2, ask to resume or restart intake.
1. If T1, ask whether to start intake.

Auto-detect may identify the state, but it must not write files by
itself. Always ask before running intake or changing templates.

---

## Manual Triggers

The owner can start intake explicitly with:

- `onboard`
- `เริ่ม onboarding`
- `setup workspace`
- `intake`

Manual triggers bypass uncertainty about auto-detection, but still ask
the owner to choose Path 1 or Path 2 before writing anything.

---

## Opening Prompt

Ask in English by default, but include a note that the owner can respond in any language (such as Thai) and the system will dynamically adapt:

```text
It looks like this is a new workspace — start with:
New Project (Path 1), Existing Project (Path 2), or Skip for now?
(Note: You can reply and converse in any language; the system will dynamically detect and adapt to it.
ดูเหมือนนี่จะเป็น workspace ใหม่ — เริ่มจาก โปรเจ็คใหม่ (Path 1), โปรเจ็คที่มีอยู่แล้ว (Path 2), หรือข้าม (Skip)? ท่านสามารถโต้ตอบในภาษาไทยหรือภาษาอื่น ๆ ได้ทันที)
```

Wait for the owner to pick Path 1 or Path 2.

If the owner chooses Skip, do not run intake. Answer the immediate
request only, and leave templates unchanged.

---

## Shared Intake Questions

Ask these in both paths, but do not ask everything at once. Group them
in small batches and confirm before writing files.

### Question Batching

Keep intake conversational:

- Ask at most three to five questions at a time.
- Auto-fill from files before asking the owner.
- Ask only for missing, ambiguous, or risky information.
- If the owner answers "not sure", record it as an Open Question
  instead of blocking the whole intake.
- After each batch, briefly summarize what was learned before moving
  on.

### Onboarding Guidance & Improvisation

To maintain both structure and agent helpfulness:
- **Improvisation & Off-Spec Choices**: In `teach` mode, the agent is allowed to suggest creative off-spec choices or sandbox options (e.g. sandbox trials, intake depth choices). However, the agent MUST explicitly flag them to the user as suggestions outside the core template specifications (e.g., "*(off-spec suggestion)*").
- **Question Surface UX (Modal vs Prose)**: The agent may dynamically choose between using prose (conversational options in chat) and modal prompts (`AskUserQuestion` / `ask_question` tool) depending on what fits the context and the model's strengths. Do not enforce rigid formatting constraints on the question surface, but prefer prose for general conversation to preserve history in session logs, and modals for blocking decisions.
- **Onboarding Guide Structure**: Keep core instruction files inside `AgentJoJoy/` in English to ensure all agents understand them without translation ambiguities. The user-facing onboarding manual (such as `AgentJoJoy/workflow-guide-th.md` or a readme) should be written in Thai for the owner's convenience.

### Owner Preferences

- Conversation language: English by default (detects and adapts dynamically to other languages if spoken by the owner)
- Engagement mode: `execute` or `teach`?
- Shell preference: default detected shell, or a specific one?
- **Distraction-Free Mode** (Recommended for VS Code): Configures the explorer sidebar to hide internal AI system files (`AgentJoJoy/`, `CLAUDE.md`, `AGENTS.md`, `VERSION`, `progress-tracker.md`) to keep the workspace clean and focused.

Write the answers to:

- `CLAUDE.md` → "Working Convention"
- `AgentJoJoy/agent-context/engagement-mode.md`
- `.vscode/settings.json` (create/update to add `files.exclude` if Distraction-Free Mode is enabled)

### Project Identity

- Project name
- Project type: coding, writing, research, mixed, or other
- One-paragraph description
- Why it exists / north star
- Owner role
- Other collaborators
- Out of scope

Write the answers to:

- `AgentJoJoy/agent-context/project-overview.md`

### Workflow Preferences

- Is this personal-only, team repo, or mixed?
- Should the AI default to branch/PR workflow?
- Who reviews work?
- Any files/folders the AI must never edit without explicit approval?
- Are force pushes ever allowed on this project? Default: no. If one
  seems necessary, the AI must present alternatives first and wait for
  explicit owner selection of `--force-with-lease`.
- **Testing & TDD preferences**: Does the project have a test framework? Should the AI prioritize a **Test-Driven Development (TDD) / Test-First** methodology (writing/stubbing tests before writing core logic)?

### Secrets And Environment Safety

Ask and record:

- Where secrets live (`.env`, secret manager, CI variables, etc.).
- Which files may be detected but must not be printed or copied.
- Which environments exist: local, dev, staging, production.
- Which environments are safe for tests, migrations, writes, or
  exploratory queries.
- Which commands can mutate data or infrastructure.

Default safety rule:

```text
Detect secret files by path/name, but do not print secret values.
If environment is unclear, assume it is unsafe and ask.
```

Write the answers to:

- `AgentJoJoy/agent-context/project-overview.md`
- `AgentJoJoy/agent-rules/workflow-notes.md`
- `AgentJoJoy/agent-context/standards.md`

### Planning Baseline

Ask enough to create the first plan:

- What outcome should exist when this phase is done?
- Is there a deadline, milestone, or external dependency?
- What is the smallest useful first slice?
- What should not be touched yet?
- How will the owner know the work is good enough?

Write the answers to:

- `progress-tracker.md`
- `AgentJoJoy/agent-context/project-overview.md`

---

## Path 1 — New Project

Use Path 1 when the owner wants AgentJoJoy to help start a new project
from an empty or mostly empty folder.

### Step 1: Clarify The Project

Ask:

- What are we building?
- Who is it for?
- What is the smallest useful first version?
- Is this code, writing, research, operations, or mixed?
- Any non-negotiable constraints?
- Introduce **Technical Precedents**: Explain that a flat markdown file (`AgentJoJoy/agent-context/technical-precedents.md`) is provided under `agent-context/` to log validated technical solutions and workarounds. The AI will proactively log issues and solutions here so future sessions bypass the same friction.
- Should we enable **Distraction-Free Mode**? (Recommended for VS Code users. If enabled, the AI will create `.vscode/settings.json` to hide internal AI files from your explorer sidebar, keeping your workspace clean).

### Step 2: Propose Structure

Propose a folder structure before creating anything.

Examples:

```text
JoySpace/
├─ AgentJoJoy/
├─ progress-tracker.md
└─ <project-folder>/
```

For a coding project, ask for stack preference only if it is not
obvious or already chosen.

Do not create files/folders until the owner approves the structure.

### Step 3: Fill Templates

Prepare an Intake Summary Preview before writing final template
updates. Include confirmed facts, AI guesses, unknowns, files that will
be updated, and the proposed first milestone/first slice.

After the owner approves the preview, auto-fill what is known from the
owner's answers:

- `AgentJoJoy/agent-context/project-overview.md`
- `AgentJoJoy/agent-context/architecture.md` if coding or system design is involved
- `AgentJoJoy/agent-context/standards.md`
- `AgentJoJoy/agent-context/ui-context.md` only if UI exists
- `AgentJoJoy/agent-context/domain-language.md` only if the project has important glossary,
  domain, stakeholder, or ambiguous terms
- `AgentJoJoy/agent-rules/workflow-notes.md`
- `progress-tracker.md` (root level)
- `AgentJoJoy/agent-context/progress-tracker-setup.md`

Mark uncertain guesses explicitly:

```text
<!-- AI guess: confirm with owner -->
```

### Step 4: Confirm Ready State

Report:

- Project name/type
- Chosen structure
- Engagement mode
- Conversation language
- First milestone and first task slice
- Next concrete step

Then ask whether to start implementation or pause.

---

## Path 2 — Existing Project

Use Path 2 when there is already a project repo, team repo, document
set, research folder, or other existing body of work.

Path 2 has several common shapes:

- **Path 2A-Team — Existing team git/code project:** scan manifests,
  team rules, git state, build/test commands, architecture, and
  protected paths. Team/project repo rules win for project content and
  conventions.
- **Path 2A-Personal — Existing personal git/code project:** scan the
  existing repo with the same read-only discipline, but do not assume
  team review, corporate audit defaults, or team branch policy unless
  the project docs say so.
- **Path 2A-Privacy-Constrained — Existing code project with private
  logic, sensitive source, regulated data, client work, trading,
  finance, medical, credentials, logs, or other private context:**
  record behavior and categories, not implementation details. Treat
  source/config/log/artifact names and values as sensitive until the owner
  explicitly expands scope.
- **Path 2B — Existing non-code project:** scan document structure,
  source/citation rules, writing tone, output formats, review flow,
  naming conventions, and archival/source-of-truth locations.

### Path 2 Priority Rule

For existing projects, the existing project's rules are authoritative
for project work.

Read these before making code, docs, workflow, or style decisions when
they exist:

- repo `CLAUDE.md`
- repo `AGENTS.md`
- `.cursor/rules/*`
- `CONTRIBUTING.md`
- `README*`
- docs/ADR or architecture decision files
- lint/test/build config
- style guides, code review rules, or team workflow docs

When they conflict:

```text
Team/project repo rules > AgentJoJoy personal rules > model defaults
```

### Path 2 Conversation Language

When wrapping a **team repo**, the default conversation language for
agent sessions should be **English** — even if the owner prefers Thai
or another language for personal sessions.

Reason: IDE session logs, screenshare during reviews, audit
exports, and PR-attached transcripts may be visible to the team
or to corporate compliance. Keeping conversations in English
avoids surfacing a language reviewers/auditors cannot read, and
keeps work history looking professional.

The owner can still explicitly override (e.g., "พิมพ์ไทย ตอบไทย,
ไม่ต้องห่วง"), but the agent should:

1. Default-recommend English at Path 2 intake.
2. Briefly state the reason once.
3. Wait for the owner to confirm or override.

For Path 1 (personal/new project) and Path 2 personal existing
projects there is no such team-audit constraint — the owner picks
freely unless the project itself has a different rule.

AgentJoJoy may add personal workflow guardrails outside the repo, but
it must not override team-owned code standards, architecture rules,
review requirements, documentation policy, branch policy, or release
process.

Personal safety gates still apply to actions taken by AI on the owner's
machine. Team/project rules win for repo content and conventions;
AgentJoJoy safety rules win for approvals, destructive commands,
remote writes, secrets, production access, force operations, and
personal context boundaries. When the two appear to conflict, follow
the stricter rule and ask the owner.

Record authoritative team/project rule files in
`AgentJoJoy/agent-context/standards.md` and summarize conflicts or gaps in Open
Questions.

### Step 1: Locate The Existing Project

Ask where it lives:

- Already inside this wrapper as `<code-or-content>/`
- Elsewhere on disk
- Remote only and needs clone

If it is elsewhere, propose one of:

- Move it under the wrapper.
- Clone it under the wrapper.
- Keep it where it is and add clear path notes.
- **Junction Link Model** (For rigid environment dependencies e.g. MQL5 Experts): Move the codebase directory under the wrapper workspace, and create a Directory Junction link (`mklink /j`) pointing from the original external environment path to the new workspace codebase location. This keeps the codebase fully operational in its runtime environment while housing AI control files outside the project repository.

Do not move, clone, symlink, or establish junction links until the owner approves.

### Step 2: Explain Workspace Model

Before git commands, explain the wrapper model using
`AgentJoJoy/agent-rules/workspace-model.md`:

- `AgentJoJoy/` is AgentJoJoy-owned personal context.
- Existing project repo is team-owned or project-owned.
- Worktrees are task folders for project branches.
- Personal context should not be committed into the team repo.

For git projects, also run the first-time Git/worktree orientation in
`AgentJoJoy/agent-rules/workflow-notes.md` → "Sync with new main", including the
ASCII graphs for main drift, rebase, and merge.

### Step 3: Read-Only Scan

Run read-only discovery only:

- Top-level file/folder list
- `README*`
- Manifest files: `package.json`, `pyproject.toml`,
  `requirements.txt`, `Cargo.toml`, `go.mod`, etc.
- Team rule files: repo `CLAUDE.md`, `.cursor/rules/*`,
  `CONTRIBUTING.md`, docs/ADR files when obvious
- Git state: `git status`, `git remote -v`, `git branch --list`,
  `git log -20 --oneline`, `git worktree list`

For privacy-constrained code projects, scan source structure by
category first. Do not summarize source internals, entry points,
include/import relationships, proprietary filenames, implementation
patterns, config values, logs, compiled artifacts, credentials, or
remote URLs unless the owner explicitly approves deeper review. Prefer
wording like:

```text
Source files are present under <category/path>.
Detailed source-pattern summary skipped until the owner approves deeper code
review.
```

For non-code projects, scan read-only:

- Folder structure and file types
- Existing outlines, briefs, notes, drafts, source folders
- Citation/source conventions
- Naming and versioning patterns
- Review/approval notes if present
- Export/output formats if obvious

Do not run `git pull`, branch switches, installs, migrations, or
write commands during this scan.

Also do not run runtime/environment actions during intake. Examples
include starting dev servers, workers, schedulers, emulators,
containers, browsers, desktop/mobile apps, terminals, e2e suites with
external dependencies, deployment scripts, migrations, data seeds, or
unknown helper scripts. Detect these by path/name/config first, record
them as risk categories, and ask before running any of them.

### Step 4: Pre-Fill Context

Auto-fill:

- `AgentJoJoy/agent-context/project-overview.md`: name, what it is, repo path/remote, stack,
  main components, active work areas, authoritative sources
- `AgentJoJoy/agent-context/architecture.md`: stack, boundaries, storage/auth/cross-cutting
  concerns that are visible from code/docs
- `AgentJoJoy/agent-context/standards.md`: authoritative team/project rule files first, then
  observed conventions, testing/doc discipline if visible
- `AgentJoJoy/agent-context/ui-context.md`: only if UI exists
- `AgentJoJoy/agent-context/domain-language.md`: only when project docs/code reveal important
  terms, overloaded vocabulary, relationships, or unresolved ambiguity
- `AgentJoJoy/agent-rules/workflow-notes.md`: key paths, remote, known gotchas, local run
  commands if found
- `progress-tracker.md` (root level): current phase, main checkout, active
  branches/worktrees, in-progress items if any

Use `<!-- AI guess: ... -->` for uncertain inferences.

### Step 5: Ask For Missing Human Context

Ask only what cannot be discovered:

- What is the owner's role on this project?
- Who reviews or owns the project?
- What is out of scope?
- Which environments are safe to test against?
- Are there protected files/folders beyond obvious rule/config files?
- What docs should or should not be created?
- What is the expected verification command before pushing?
- Which runtime/environment actions, if any, are safe to run locally?
  Which require separate approval or should never be run by AI?
- Introduce **Technical Precedents**: Explain that a flat markdown file (`AgentJoJoy/agent-context/technical-precedents.md`) is provided under `agent-context/` to log validated technical solutions and workarounds. The AI will proactively log issues and solutions here so future sessions bypass the same friction.
- Should we enable **Distraction-Free Mode**? (Recommended for VS Code users. If enabled, the AI will create `.vscode/settings.json` to hide internal AI files from your explorer sidebar, keeping your workspace clean).

### Step 6: Multi-Agent Coexistence Rules Portability

AgentJoJoy multi-agent rules (cursor reservation, code change tags,
commit co-author trailer) are visible only when an AgentJoJoy wrapper
is present at or above the working directory. Path 2 repos used
without a wrapper do not see these rules unless they are added to the
target repo's own rule files.

Ask the owner which AI agents will work on this repo (multi-select,
common choices include Claude Code, Codex, Cursor, Antigravity, and
others). Then propose adding the multi-agent coexistence snippet to
the rule files that those agents read:

- Claude Code reads target repo `CLAUDE.md`.
- Codex, Aider, and generic agents read target repo `AGENTS.md`.
- Cursor surfaces vary; if both files exist, update both. See
  `AgentJoJoy/template-lab/validation/cursor-walkup-live.md`.

The snippet is in `AgentJoJoy/agent-templates/multi-agent-coexistence-snippet.md`.
Use the marker comments `<!-- AGENTJOJOY:MULTI-AGENT BEGIN -->` and
`<!-- AGENTJOJOY:MULTI-AGENT END -->` so the section can be replaced
idempotently when the agent stack changes later. Read the snippet
file for the full merge algorithm.

Show the proposed snippet body and the exact list of target files
before writing. Wait for owner approval. The owner can opt out, in
which case record a note in `progress-tracker.md` that the gap is
known and intentional.

Re-running this step replaces the section between the markers; it
never duplicates. The owner can re-run intake or invoke this step
directly when adding or dropping an agent later.

### Step 7: Confirm Filled Context

Show an Intake Summary Preview before writing final template updates:

- Project identity
- Repo location and remote
- Stack and main components
- Team rule files found
- Protected paths
- Verification commands
- Open questions
- Files that will be updated
- Which fields are owner-confirmed
- Which fields are AI guesses
- Which fields remain unknown

Ask for corrections, then write the files.

### Step 8: Ready State

Report:

- Current branch and working tree state
- Active worktrees
- Whether the repo is clean
- If `origin/<base>` has moved, the recommended sync strategy from
  `AgentJoJoy/agent-rules/workflow-notes.md` → "Sync recommendation table"
- First milestone and first task slice
- Next recommended action: resume existing work, create a worktree,
  or pause

Do not start implementation until the owner confirms the first task.

---

## Planning Layer

Run planning after context is filled and before implementation,
worktree creation, or scaffolding.

The plan should be small enough that the next session can start
without re-planning, but not so detailed that it invents requirements.

### Planning Outputs

Create or update:

- `progress-tracker.md` → Current Phase, Current Goal, In Progress,
  Next Up, Open Questions
- `AgentJoJoy/agent-context/project-overview.md` → Active Work Areas

### Planning Shape

Use this structure:

```text
Goal:
- One or two sentences.

Milestone:
- The next meaningful checkpoint.

First slice:
- The smallest task worth doing first.

Verification:
- How we will know it worked.

Not now:
- Explicitly deferred areas.

Open questions:
- Questions that block or shape implementation.
```

### Split Rules

Split work when a proposed task includes more than one major boundary:

- New product behavior plus large refactor
- Frontend plus backend plus database migration
- Team repo changes plus personal workflow changes
- Bug fix plus unrelated cleanup
- Research/writing plus code changes

Prefer one branch/worktree per first slice.

### Planning Stop Conditions

Stop and ask the owner when:

- The goal is not clear enough to choose a first slice.
- The first slice could affect protected files or production data.
- The plan requires a strategic choice such as branch base, rebase vs
  merge, force push, deletion, or migration.
- Verification cannot be defined.

Do not turn uncertain guesses into tasks. Put them in Open Questions.

---

## File Update Rules

- Keep `AgentJoJoy/` documentation in English so every agent can read
  it.
- Talk with the owner in the chosen conversation language.
- Preserve template comments unless replacing them with real content.
- Do not invent architecture, rules, owners, or deployment facts.
- If team docs conflict with AgentJoJoy notes, team docs win for
  code-level decisions.
- Update `AgentJoJoy/agent-context/progress-tracker-setup.md` when intake completes.
- Update root `progress-tracker.md` with real work state for the
  project being onboarded.

---

## Template Cleanup / Packaging

If a real workspace was copied manually from the AgentJoJoy source
repo, remove or omit source-only files before treating intake as
complete:

- `AgentJoJoy/template-lab/`

Keep the blank reusable templates, then fill them for the new
workspace:

- `progress-tracker.md`
- `AgentJoJoy/agent-context/progress-tracker-setup.md`
- `AgentJoJoy/agent-context/project-overview.md`
- `AgentJoJoy/agent-context/architecture.md`
- `AgentJoJoy/agent-context/standards.md`
- `AgentJoJoy/agent-context/ui-context.md`
- `AgentJoJoy/agent-context/domain-language.md`

If a future starter script exists, it should exclude source-only files
automatically. Source repo cleanup is tracked in
`AgentJoJoy/template-lab/validation/packaging-cleanup-checklist.md`.

---

## Completion Checklist

Intake is complete when:

- `project-overview.md` has Project Name and What It Is filled.
- Engagement mode is set.
- Working convention is set.
- Key paths and remote are recorded.
- Team/project rule files are listed.
- Known protected paths and gotchas are recorded.
- Verification commands are recorded or listed as open questions.
- `progress-tracker.md` reflects current active work state.
- Remaining unknowns are listed under Open Questions.
- The first milestone, first slice, and verification signal are
  recorded.

