# Codex Hook Binding Notes

Use this file when translating a neutral hook contract into a Codex hook design.
This file is guidance only; it does not install or configure hooks.

## Runtime Posture

Codex supports native hooks through project or user configuration, and
project-local hooks require an explicit trust step. Treat Codex hooks as useful
guardrails, but do not assume every `PreToolUse` path is a complete enforcement
boundary unless the current official docs say so.

When binding a contract, verify current Codex hook syntax from the official
Codex documentation before implementation.

## Binding Surface

Relevant hook surfaces include:

- prompt submission hooks for inspecting user input before the agent acts
- pre-tool hooks for guardrails before tool execution
- permission-request hooks for sensitive operation boundaries
- post-tool hooks for observing results after a tool runs
- stop hooks for end-of-turn validation

## Decision Mapping

| Contract decision | Codex posture |
|---|---|
| allow | Continue when the contract passes |
| warn/advisory | Recommended for checks Codex cannot fully enforce |
| ask | Defer to owner approval where the runtime supports it |
| force_ask | Use only when the runtime can reliably request owner approval |
| deny/block | Use only for paths the current runtime can reliably block |

## Caveats

- Some Codex hook paths may be advisory guardrails rather than complete
  enforcement boundaries.
- Project-local hook configuration should be treated as a trust-sensitive
  workspace change.
- Hook output must not print or serialize secret values.
- Do not use a hook to bypass AgentJoJoy approval gates. If Codex cannot enforce
  a contract reliably, mark that runtime binding as advisory or not-feasible.
