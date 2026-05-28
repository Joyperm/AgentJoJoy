# Engagement Mode

How the AI engages with the user during work. Set during intake;
overridable per session.

---

## Current Mode

<!-- Set during intake. Values: execute | teach -->

**_(not set — ask during intake)_**

> [!NOTE]
> If the current mode is unset and the workspace is in Template Development mode (T0), the default is assumed to be `teach`.

---

## Mode Definitions

### `execute` — AI-writing

- AI does the task quietly and efficiently.
- Updates are short — one sentence per meaningful step.
- Decisions made silently if obvious; surfaced only when tradeoff
  is non-trivial.
- Result-focused.
- **Scope discipline (strict)**: stays in the lane that was given;
  flags drift before acting. See `agent-rules/ai-workflow-rules.md`
  → "Scope Discipline".
- **Like:** working with an experienced colleague who knows the
  drill and just gets things done.

### `teach` — AI-writing + teach

- AI does the task AND explains *why* at each meaningful step.
- Surfaces tradeoffs even when one option is obvious — so user
  understands the choice.
- Pauses at decision points to invite user input, not just confirm.
- Notes alternatives that weren't taken.
- **Scope discipline (relaxed)**: may mention adjacent improvements
  as off-scope suggestions (`*(off-scope suggestion)*`), but does
  not execute them unprompted. See
  `agent-rules/ai-workflow-rules.md` → "Scope Discipline".
- **Like:** pair-programming with a senior mentor who's intentionally
  showing their reasoning so the user learns.

**On-demand learning patterns.** While in `teach` mode (and in
`execute` mode if explicitly requested), the user can ask the AI to
slow down for any task or per file. The AI honors these patterns
without needing a config change — just say it:

- **AI proposes, you type** — the AI shows the exact code/command,
  but you type it into your own terminal/editor. Useful for muscle
  memory while learning a new stack, or when you want full control
  over the final keystrokes.
- **Skeleton only, you fill** — the AI provides structure (function
  signatures, file scaffolding, key branches) with the details left
  for you to write. Useful when you understand the shape but want
  the discipline of writing the body yourself.
- **Tutor-first, code after** — the AI explains the concept and
  walks the approach step by step *before* any code lands, so you
  can build the mental model at your own pace.

These are session-level requests, not workspace settings. Mention
them at the start of a task, or mid-task if your needs shift.

Both modes still respect SPEC-3.1 (per-action approval for
state-changing operations) and SPEC-3.5 (strategic choices reserved
for user).

---

## How to Switch

There are three ways to change mode:

### 1. Permanent (project default) — edit this file

Change the "Current Mode" value above. The new value is the default
for all future sessions on this project.

### 2. Temporary (this session only) — tell the AI

In conversation, say something like:
- `"switch to execute mode"` / `"เปลี่ยนเป็น execute"`
- `"switch to teach mode"` / `"เปลี่ยนเป็น teach"`

The AI applies the new mode for the rest of the current session.
Next session reverts to the project default.

### 3. During intake — initial choice

When starting a new project (Path 1) or onboarding to an existing
one (Path 2), the AI asks which mode to start in. The answer
becomes the project default and is written to this file.

---

## Mode Change History

<!-- Log permanent (file-level) mode changes. Format:
     - YYYY-MM-DD: <old> → <new>. Reason: <one line> -->

_(none yet)_
