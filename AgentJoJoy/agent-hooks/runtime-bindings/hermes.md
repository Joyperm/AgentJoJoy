# Hermes Agent Hook Binding Notes

Use this file when translating a neutral hook contract into a Hermes Agent
(Nous Research) enforcement design. Guidance only; it does not install or
configure anything. Field names verified live on Hermes Desktop v0.16.0
(2026-06-10) — re-verify against current Hermes docs/source before binding.

## Runtime Posture

Hermes has three hook systems plus a native approvals layer. The only hook
that can **block** is `pre_tool_call` (plugin or shell form). The native
approvals layer (`approvals.mode: manual`, hardline blocklist,
`command_allowlist`) covers *dangerous* commands (rm -rf, chmod 777, DROP
TABLE…), **not** workflow semantics — `git commit`/`push` are not on its
dangerous list, so AgentJoJoy git gates need a `pre_tool_call` hook.

`approvals.cron_mode: deny` (default) is the headless floor: cron jobs
cannot run dangerous commands. Keep it `deny` for autonomous loops.

## Binding Surface

| Mechanism | Can block? | Runs in | Activation requirements |
|---|---|---|---|
| **Plugin** (`HERMES_HOME/plugins/<name>/` = `plugin.yaml` + `__init__.py` with `register(ctx)` → `ctx.register_hook("pre_tool_call", cb)`) | ✅ return `{"action": "block", "message": ...}` | All entry points that load plugins, **including the desktop TUI** | Plugin files **+** `plugins.enabled: [<name>]` in `config.yaml` (user plugins are opt-in by default) |
| **Shell hook** (`config.yaml` → `hooks: pre_tool_call: - matcher/command/timeout`; JSON stdin → JSON stdout) | ✅ same return shape | CLI and gateway startup only — **the desktop TUI (`tui_gateway`) does not register shell hooks in v0.16.0** | Consent: TTY prompt, `HERMES_ACCEPT_HOOKS=1`, or `hooks_auto_accept: true` |
| **Gateway hooks** (`HERMES_HOME/hooks/<name>/HOOK.yaml` + `handler.py`) | ❌ observe only | Messaging gateway only | — |

`HERMES_HOME` on Windows desktop installs is `%LOCALAPPDATA%\Hermes`
(not `~/.hermes` as older docs suggest).

## Decision Mapping

| Contract decision | Hermes posture |
|---|---|
| allow | `pre_tool_call` callback returns `None`/`{}` |
| warn/advisory | Log/observe (gateway hook or non-blocking callback); a warning is not permission |
| ask | Native approvals prompt (dangerous patterns) or block-with-message instructing escalation to the owner |
| deny/block | `pre_tool_call` → `{"action": "block", "message": "<reason + what to do instead>"}` — first valid block wins |

Make the block message instructive: tell the agent to write a BLOCKED
report / escalate to the owner instead of retrying. Observed live: the
agent then hands the action back to the human rather than probing.

## Caveats (every one observed live)

- **Everything fails open and silently.** Hook errors are logged, never
  enforced; an unconsented shell hook is skipped with only a log line; a
  plugin missing from `plugins.enabled` simply doesn't load; the desktop
  TUI skips shell-hook registration entirely. **A gate is not installed
  until a live pre-flight shows it blocking** (e.g.
  `git commit --allow-empty -m "hook-test"`), and it must be re-proven
  after Hermes updates.
- **Context files with invisible unicode are blocked**, disabling workspace
  rules silently: a UTF-8 BOM in `AGENTS.md` triggers
  `blocked: invisible_unicode_U+FEFF`. Ship rule files BOM-less.
- Gate `execute_code` as well as `terminal` — git can be reached via
  Python `subprocess`, not just the shell.
- Hermes auto-curates skills from workspace docs (self-improving layer);
  a cached `workspace-governance` skill can go stale after rule updates —
  the contract/rules files remain the source of truth, not the cached
  skill.
- Hook/plugin code must not leak secret values and must not silently grant
  permission for an operation AgentJoJoy rules reserve for the owner.
