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
- **Like:** working with an experienced colleague who knows the
  drill and just gets things done.

### `teach` — AI-writing + teach

- AI does the task AND explains *why* at each meaningful step.
- Surfaces tradeoffs even when one option is obvious — so user
  understands the choice.
- Pauses at decision points to invite user input, not just confirm.
- Notes alternatives that weren't taken.
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

## Automated Gap Reporter

<!-- Set during intake. Values: enabled | disabled -->

**_(not set — ask during intake)_**

> [!NOTE]
> When enabled, the AI may write redacted, privacy-safe friction reports
> to `AgentJoJoy/agent-runtime/gaps/` **during sessions** when it
> observes a workflow obstacle worth remembering. It is not a background
> daemon — it runs only as part of the AI's in-session routine, and the
> AI announces each report it writes with a one-line note (see
> `agentjojoy-core-practices/SKILL.md` → "Gap Observation & Redacted
> Reporting").
> Generated reports and collector outputs are local-only. They must not
> be committed to the wrapped project repo or uploaded from a company
> machine.
>
> **Inspect or manage your reports any time:**
>
> ```powershell
> # List reports with status and category
> powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action list
> # Pattern summary (with optional upstream-share invitation)
> powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action summarize
> # Delete all gap reports and collector outputs
> powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action purge -Force
> ```

### Gap Report Collector

<!-- Set during intake or later owner approval. Values: enabled | disabled -->

**_(not set — default disabled for Path 2 team repos)_**

The Collector is separate from the Reporter:

- **Gap Reporter** controls whether the AI may write redacted local gap
  reports.
- **Gap Collector** controls whether those reports may be aggregated
  into a local index/export bundle.

For Path 2 team repos, leave the Collector disabled by default. Enable
it only with explicit owner approval after considering project and
company data-safety constraints.

When gap reports exist and the Collector is enabled, the owner may run
the local collector:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action collect -CompanyMachine
```

The collector creates a local index under
`AgentJoJoy/agent-runtime/gaps/_collector/` and can create a local export
bundle under `AgentJoJoy/agent-runtime/gaps/_exports/`. It does not
contact remote services. On company machines, remote sync/upload is
hard-blocked by policy; any transfer must be manual, owner-approved,
and reviewed for unsafe signals first.

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
