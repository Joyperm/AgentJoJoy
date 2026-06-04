# Claude Code Hook Binding Notes

Use this file when translating a neutral hook contract into a Claude Code hook
design. This file is guidance only; it does not install or configure hooks.

## Runtime Posture

Claude Code has native lifecycle hooks and is the strongest fit for contracts
that need enforce/ask/block behavior.

When binding a contract, verify the current Claude Code hook syntax from the
official runtime documentation before implementation. Runtime docs change faster
than AgentJoJoy templates.

## Binding Surface

Relevant hook surfaces include:

- prompt submission hooks for inspecting user input before the agent acts
- pre-tool hooks for deciding before a tool executes
- permission-request hooks for owner-approval boundaries
- post-tool hooks for observing results after a tool runs
- stop hooks for end-of-turn validation
- file-change/config-change hooks where supported by the runtime

## Decision Mapping

| Contract decision | Claude Code posture |
|---|---|
| allow | Continue without interruption when the contract passes |
| warn/advisory | Surface a warning without treating the warning as permission |
| ask | Defer to owner approval when the contract cannot safely decide |
| force_ask | Prefer owner approval when the operation is sensitive or ambiguous |
| deny/block | Block the action when the contract detects a violation |

## Caveats

- Hook output is part of the runtime loop and must not leak secret values.
- A hook must not silently grant permission for an operation that AgentJoJoy
  rules require the owner to approve.
- Repo-shared hook configuration is a team/workspace policy change and must
  follow the target repo's normal review process.
- Use the neutral contract's fallback behavior when Claude Code cannot represent
  a decision exactly.
