# Hook Enforcement Contracts

`agent-hooks/` contains optional documentation templates for owners who want
to mechanize selected AgentJoJoy or project-specific gates.

Nothing in this folder is active by default. AgentJoJoy ships no executable
hook scripts, no hook configuration, and no installer here. Owners choose
whether, where, and how to implement any hook.

## Model

AgentJoJoy separates policy from mechanism:

| Layer | Responsibility |
|---|---|
| `agent-rules/` and `workflow-spec.md` | Source of truth for AgentJoJoy governance rules |
| `agent-hooks/` | Optional hook contract templates and runtime binding guidance |
| Owner/project implementation | The actual hook script, runtime config, CI check, or manual mechanism |

Contracts in this folder must not redefine AgentJoJoy rules. When a contract
mechanizes an existing AgentJoJoy gate, it must link back to the rule that
already defines that gate.

## What Ships Here

- [`gate-contract.template.md`](gate-contract.template.md) — a blank neutral
  contract skeleton.
- [`runtime-bindings/claude-code.md`](runtime-bindings/claude-code.md) —
  Claude Code hook binding notes.
- [`runtime-bindings/codex.md`](runtime-bindings/codex.md) — Codex hook binding
  notes.
- [`runtime-bindings/antigravity.md`](runtime-bindings/antigravity.md) —
  Antigravity hook binding notes.

## Non-Goals

This folder does not include:

- `.claude/settings.json`
- `.codex/hooks.json`
- `.agents/hooks.json`
- Git hooks
- CI checks
- executable hook scripts
- install scripts
- active enforcement
- default enablement

## Existing Gate Mappings

Contracts may mechanize existing AgentJoJoy gates only by referencing their
canonical source:

| Gate area | Canonical source | Hook posture |
|---|---|---|
| Mutation / permission approval | [`workflow-spec.md`](../agent-rules/workflow-spec.md) SPEC-1 and [`ai-workflow-rules.md`](../agent-rules/ai-workflow-rules.md) Pillar I | Optional enforcement or ask-owner guardrail |
| Secret Intake Protocol | [`ai-workflow-rules.md`](../agent-rules/ai-workflow-rules.md) Pillar I | Optional enforcement or block/warn guardrail |
| AI-NO-OVERWRITE | [`workflow-spec.md`](../agent-rules/workflow-spec.md) SPEC-1.7 and [`ai-workflow-rules.md`](../agent-rules/ai-workflow-rules.md) Pillar I | Optional enforcement or ask-owner guardrail |
| Public mutation / release safety | SPEC-1, branch protection, and release Safety Shield controls | Usually already enforced elsewhere; use contracts only to document extra local guardrails |

Do not list a behavior here as an "existing gate" unless it already has a
canonical rule source. New ideas such as date-truth checks or ground-truth
before edit checks can be owner-defined hooks, or future framework gates after
their rules are added to `agent-rules/`.

## Owner-Defined Hooks

Owners may design new hooks with the Main Agent for project-specific risks,
quality checks, release policies, customer-facing claims, or local workflow
preferences.

Owner-defined hooks must be:

- explicit and documented
- opt-in
- scoped to a clear install target
- clear about override behavior
- unable to silently bypass or weaken existing AgentJoJoy safety gates

## Install Scope

Even though this folder contains documentation only, every contract should name
the scope an eventual implementation would affect:

| Scope | Meaning |
|---|---|
| Personal-local | Installed only in one user's local runtime or home config |
| Workspace-local untracked | Lives in this workspace but is not committed |
| Repo-shared | Committed to the project repo and affects other users/agents |
| CI/server-side | Runs in shared automation or remote infrastructure |

Repo-shared hooks are team/workspace policy changes. In Path 2 team repos, they
require owner/team approval and must follow the target repo's normal PR/review
process.

## Runtime Binding Matrix

This table is an overview only. Runtime-specific syntax and caveats live in the
binding docs.

| Runtime | Hook support | Enforcement posture |
|---|---|---|
| Claude Code | Native lifecycle hooks | Strongest fit for enforce/ask/block contracts |
| Codex | Native hooks with project trust requirements | Useful guardrail; some paths may be advisory rather than a complete boundary |
| Antigravity | Native hooks plus permission engine | Strong fit for enforce/ask/force_ask contracts |

Use these labels when designing a runtime binding:

- **enforce**: the runtime can reliably block or ask before the action.
- **advisory**: the runtime can warn or guide, but the hook is not a full safety
  boundary.
- **not-feasible**: the runtime lacks a practical hook surface for that contract.

## Safety Guardrails For Any Hook You Implement

Hook contracts are optional, but any implementation created from them must
preserve AgentJoJoy safety boundaries:

- **Fail safe:** if a safety hook cannot decide, crashes, times out, or receives
  malformed input, prefer deny/block or ask-owner behavior over silent allow.
- **Do not leak secrets:** hook scripts must not print, log, echo, serialize, or
  forward secret values through stdout, stderr, transcripts, temp files,
  telemetry, or external services.
- **Do not grant permission silently:** a hook must not convert an operation
  that normally requires owner approval into an automatic allow unless the owner
  explicitly designed and documented that behavior.
- **Do not bypass existing gates:** hook implementations must not weaken SPEC-1
  approval, Secret Intake, AI-NO-OVERWRITE, branch protection, release safety,
  or target repo/team rules.
- **Respect team scope:** repo-shared hooks are team/workspace policy changes
  and must follow the target repo's review and approval process.

## Design Flow

1. Choose whether the hook maps to an existing AgentJoJoy gate or is
   owner-defined.
2. Fill a copy of [`gate-contract.template.md`](gate-contract.template.md).
3. Decide the install scope before writing any implementation.
4. Read the matching runtime binding doc.
5. Implement only after the owner approves the scope and runtime target.
