# Antigravity Hook Binding Notes

Use this file when translating a neutral hook contract into an Antigravity hook
design. This file is guidance only; it does not install or configure hooks.

## Runtime Posture

Antigravity supports native hooks and a separate permission engine. It is a
strong fit for contracts that need allow, deny, ask, or force_ask behavior.

When binding a contract, verify current Antigravity hook and permission syntax
from the official runtime documentation before implementation.

## Binding Surface

Relevant hook surfaces include:

- pre-invocation hooks for checking a task before an agent run
- pre-tool hooks for deciding before a tool executes
- post-tool hooks for observing results after a tool runs
- post-invocation hooks for validating after an agent run
- stop hooks for end-of-turn validation
- the runtime permission engine for allow/deny/ask policy

## Decision Mapping

| Contract decision | Antigravity posture |
|---|---|
| allow | Continue when the contract passes |
| warn/advisory | Surface a warning without treating it as permission |
| ask | Ask the owner when the contract needs a human decision |
| force_ask | Prefer for sensitive operations where owner confirmation is required |
| deny/block | Deny the operation when the contract detects a violation |

## Caveats

- Permission-engine rules and hook decisions should agree. If they conflict,
  choose the stricter behavior and ask the owner.
- Repo-shared hook configuration is a team/workspace policy change.
- Hook output must not leak secrets through logs, stdout, stderr, transcripts,
  telemetry, or temp files.
- If Antigravity cannot represent a contract's fallback behavior exactly, mark
  the binding as advisory or not-feasible rather than pretending it enforces.
