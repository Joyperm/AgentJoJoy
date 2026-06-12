# SmartWorker Spec — <NAME>

> **Surface lifecycle: Optional Capability.**
> Create a real SmartWorker spec only when a concrete recurring task or
> owner request justifies separate-context worker dispatch. Do not create
> one during normal onboarding, Resume Check, or routine one-off work.
>
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
> worker's authority, model tier, provider/runtime, privacy/cost policy,
> or scope.

**tier:** `<inherit | light | strong>`  <!-- REQUIRED. No default.
  light = read/search-heavy; strong = heavy reasoning; inherit = match Main.
  Norm: prefer light. A tier is an execution slot, not a permanent truth
  about capability — see the calibration field below. -->

**calibration:** `<optional but required before BATCH/unattended use on a new
  work type — list of (work type → tier → pilot result + date). A tier is not
  suitable for a work type until a small pilot batch passed the owner's
  quality threshold on that work type. Run the pilot, record the pass here;
  re-calibrate when the model behind the tier changes.>`

**concurrency:** `<optional — for batch fan-out: max parallel workers per
  batch + provider rate-limit note. Default 1 (sequential). Parallel dispatch
  is allowed ONLY for calibrated work types, with disjoint write targets per
  worker and a per-batch (not per-worker) budget ceiling. No subtask runs
  twice: single assignment via a dispatch manifest (a real file when the
  batch is unattended or may outlive one session), retry only
  confirmed-failed items, prefer overwrite-by-key outputs over appends.>`

**permission:** `<read-only (default) | read+write | +command/terminal>`
  <!-- Start read-only. Escalate only if the task requires it AND the
  owner approves. -->

**assigned context scope:** `<the minimum the worker should know to do
  the job — NOT the whole system/project. e.g. which files/dirs/topic.>`

**nesting:** `flat`  <!-- A SmartWorker never spawns another SmartWorker. -->

**provider / runtime:** `<optional — local / alternative-provider workers only:
  provider class, NOT a model name — e.g. Ollama, LM Studio, llama.cpp, or any
  OpenAI-compatible endpoint>`

**model-capability assumption:** `<optional — local / alternative-provider
  workers only: capability label the task needs — e.g. local-light /
  local-code / local-reasoning / local-embed. The Main Agent verifies the
  owner's actually-installed runtime/model before binding (Help-First). Local
  tool-calling is advisory by default unless a specific model+runtime pair has
  been validated.>`

**privacy:** `<optional — local / non-frontier workers only: local-only | cloud-ok-after-redact | cloud-ok>`
  <!-- Owner policy. A local worker defaults to local-only. Secrets always follow
  the Secret Intake Protocol regardless of this field. -->

**cost policy:** `<optional — e.g. prefer local for triage; escalate to a frontier model only if needed; budget cap>`
<!-- AGENTJOJOY:AI-NO-OVERWRITE END -->

---

## Runtime binding (filled by the Main Agent, per its own runtime)

> Not part of the neutral spec. Each Main translates the Governance zone
> into its native contract and stores the binding in its own location
> (e.g. Claude `.claude/agents/`, Codex `.codex/agents/`, Antigravity
> capability config). Verify current field syntax from the official
> source first.
