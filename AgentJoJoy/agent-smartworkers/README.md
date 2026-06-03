# AgentJoJoy SmartWorker Framework

A **SmartWorker** is a knowledge-requiring worker that the *single* Main
Agent dispatches into a **separate context** to do recurring work, then
returns only a synthesized result. It is **not** a second Main Agent and
**not** multi-agent orchestration — there is always exactly one Main
Agent in control.

> Status: framework scaffold. This folder holds the **runtime-neutral
> template and rules**, not real SmartWorkers. Create a real one only
> when a concrete recurring task justifies it (see Triggers).

---

## Where SmartWorker sits — the automation tiers

SmartWorker is the **middle** of three automation tiers (script /
SmartWorker / Skill): too much judgment for a script, but better kept out
of Main's own context window.

> The 3-tier taxonomy and the rule for picking a tier are defined **once**,
> canonically, in
> [`ai-workflow-rules.md` → Work Escalation — Automation Tiers](../agent-rules/ai-workflow-rules.md).
> This README only covers the **SmartWorker tier** in detail.

## Why a SmartWorker (the real value)

Its primary value is **context isolation**, *not* just using a cheaper
model. A SmartWorker can read 50 files and return a one-paragraph
summary, keeping Main's context clean. This holds even when the worker
runs on the *same* model as Main. (Cost savings from a lighter model is
a secondary, optional bonus.)

All three target runtimes document this same isolation purpose.

## How it maps to runtimes — neutral spec + per-runtime binding

AgentJoJoy does **not** build a subagent runtime. Claude Code, Codex, and
Antigravity each already have a native subagent mechanism. So the model
mirrors the existing `CLAUDE.md ↔ AGENTS.md` pattern:

- **Canonical SPEC** (`smartworker-spec.template.md`) — runtime-neutral
  intent. **No vendor syntax.**
- **Binding** — each Main translates the neutral intent into its *own*
  runtime's native subagent contract, and uses **only its own** binding.
  (A Gemini Main must not copy Claude's `.claude/agents/` syntax.)

### Contract reference (per runtime)

> ⚠️ This table is an **illustrative reference**, not a source of truth.
> Exact field names/values drift. The Main Agent must **verify its own
> runtime's current subagent contract from the official source before
> writing a binding** — this is required by the existing **Help-First
> Command Discipline** (read the tool's help/docs before first use).

| Neutral concept (canonical) | Claude Code | Codex | Antigravity |
|---|---|---|---|
| permission / tool scope | `tools:` allowlist / `disallowedTools` | `sandbox_mode` | read-only / write / delegation toolsets in `CapabilitiesConfig` |
| model tier | `model: inherit\|haiku\|sonnet\|opus` | `model` + `model_reasoning_effort` | model name (reasoning baked in) / inherit parent |
| instructions | body (system prompt) | `developer_instructions` | system prompt param |
| assigned context scope | prompt + tool allowlist | inherit sandbox + prompt | inherit file read/write dir scopes + task |
| nesting | ❌ not allowed | hierarchy allowed | depth ≤ 10 |
| where defined | `.claude/agents/*.md` | `.codex/agents/*.toml` | `CapabilitiesConfig` + `start_subagent` |

Sources: [Claude Code subagents](https://code.claude.com/docs/en/sub-agents) ·
[Codex subagents](https://developers.openai.com/codex/subagents) ·
[Antigravity SDK — subagents](https://deepwiki.com/google-antigravity/antigravity-sdk-python/8.2-subagents-and-multi-agent-patterns)

## Neutral baseline (lowest common denominator)

To stay portable across all three runtimes, the canonical defaults use
the most restrictive option each vendor allows:

- **Flat — no nesting.** A SmartWorker never spawns another SmartWorker.
  (Claude forbids it outright; this keeps us clearly away from
  multi-agent orchestration.)
- **Read-only by default.** A worker gets write/command access only when
  the task explicitly requires it and the owner approves.
- **Model tier is a required choice at creation** (`inherit | light |
  strong`), with a norm leaning to `light`. There is no silent default —
  whoever creates the worker must decide how much reasoning the task
  needs. `light` for read/search-heavy work; `strong` for heavy
  reasoning; `inherit` to match Main.

## Owner control & protection (two zones)

Every SmartWorker spec has two zones. The owner can always overwrite
both; the tag only blocks *autonomous AI* edits.

- **Governance zone** — `tier`, permission/tool scope, assigned context
  scope, `nesting`. Wrapped in
  `<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN/END -->` so AI cannot silently
  change a worker's authority or model tier.
- **Behavioral zone** — `name`, `description`, `instructions`, return
  format. Not tagged; AI may help draft/iterate these when the owner
  directs.

## Triggers — when to propose creating a SmartWorker

The trigger and routing logic lives in **one place**: the
[`pattern-detection`](../skills/pattern-detection/SKILL.md) meta-skill.
It watches for recurring work (the 3× rule + session memory),
classifies it across the three automation tiers, and nudges toward the
right tier — script, SmartWorker, or Skill. A SmartWorker is proposed
when the recurring work is knowledge-requiring and best kept out of
Main's context.

Owner-initiated requests follow the same routing: if the owner asks for
a SmartWorker, recommend honestly per the actual situation — a script or
a Skill may fit better. Don't push a SmartWorker by default.

---

## Files in this folder

- `README.md` — this file.
- `smartworker-spec.template.md` — the runtime-neutral skeleton to copy
  when creating a real SmartWorker.
