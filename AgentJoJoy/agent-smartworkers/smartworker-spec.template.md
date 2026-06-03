# SmartWorker Spec — <NAME>

> Runtime-neutral canonical spec. Copy this skeleton to define a real
> SmartWorker. Keep this layer free of vendor syntax — the Main Agent
> translates the Governance zone into its own runtime's native subagent
> contract at creation time.
>
> **Before writing the runtime binding, the Main Agent MUST verify its
> own runtime's current subagent contract from the official source**
> (Help-First Command Discipline). Do not copy another vendor's syntax.

---

## Behavioral zone (AI may help draft/iterate when the owner directs)

**name:** `<short-identifier>`

**description:** `<one line: when and why Main should dispatch this worker>`

**instructions:**
```
<The worker's task brief / system prompt. Be specific about the goal,
the inputs it will receive, and what "done" looks like. Written in
English.>
```

**return format:**
```
<Exactly what the worker returns to Main — e.g. a short summary, a
structured list, a decision + rationale. Keep it small; the point is to
NOT flood Main's context.>
```

---

<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN -->
## Governance zone (owner-controlled — AI must not change autonomously)

> The owner may always overwrite these. AI must not silently alter a
> worker's authority, model tier, or scope.

**tier:** `<inherit | light | strong>`  <!-- REQUIRED. No default.
  light = read/search-heavy; strong = heavy reasoning; inherit = match Main.
  Norm: prefer light. -->

**permission:** `<read-only (default) | read+write | +command/terminal>`
  <!-- Start read-only. Escalate only if the task requires it AND the
  owner approves. -->

**assigned context scope:** `<the minimum the worker should know to do
  the job — NOT the whole system/project. e.g. which files/dirs/topic.>`

**nesting:** `flat`  <!-- A SmartWorker never spawns another SmartWorker. -->
<!-- AGENTJOJOY:AI-NO-OVERWRITE END -->

---

## Runtime binding (filled by the Main Agent, per its own runtime)

> Not part of the neutral spec. Each Main translates the Governance zone
> into its native contract and stores the binding in its own location
> (e.g. Claude `.claude/agents/`, Codex `.codex/agents/`, Antigravity
> capability config). Verify current field syntax from the official
> source first.
