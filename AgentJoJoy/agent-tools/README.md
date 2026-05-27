# AgentJoJoy Tools

Local helper tools for AgentJoJoy workspaces.

These tools must remain privacy-first and local-first. They should not
contact remote services, upload reports, or mutate project repositories
unless a future tool explicitly documents the action and the owner
approves it.

## Gap Report Collector

`gap-report-collector.ps1` aggregates local redacted gap reports from:

```text
AgentJoJoy/agent-runtime/gaps/gap-*.md
```

It writes generated collector output under:

```text
AgentJoJoy/agent-runtime/gaps/_collector/
AgentJoJoy/agent-runtime/gaps/_exports/
```

Actions:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action check
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action collect
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action export
```

On company machines, pass `-CompanyMachine`:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action collect -CompanyMachine
```

Company-machine policy:

- Remote upload/sync is hard-blocked.
- The collector only writes local files.
- Manual transfer requires owner approval and should happen only after
  reviewing the generated index for unsafe signals.

## Worktree Auto-Sync

`worktree-auto-sync.ps1` scans local git state and updates only the
managed block in:

```text
progress-tracker.md
```

It uses read-only git commands:

```text
git status --short --branch
git worktree list --porcelain
git branch --show-current
```

Actions:

```powershell
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/worktree-auto-sync.ps1 -Action check
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/worktree-auto-sync.ps1 -Action sync
```

Safety rules:

- No fetch, pull, push, rebase, merge, branch switch, or worktree
  mutation.
- `sync` replaces only the
  `AGENTJOJOY:WORKTREE-AUTO-SYNC` managed block in
  `progress-tracker.md`.
- In the AgentJoJoy template source repo, the tool refuses to sync by
  default so reusable blank templates remain clean. Use
  `-AllowTemplateSource` only for intentional tool testing.

## Clean Ejection

`eject.ps1` cleanly removes all AgentJoJoy wrapper files and folders from the workspace to return it to an unwrapped state.

Actions:

```powershell
# Dry-run check (lists files to be deleted)
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/eject.ps1 -Action check

# Perform ejection (prompts for confirmation)
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/eject.ps1 -Action eject

# Perform ejection bypass confirmation (for automated testing/sandbox validation)
powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/eject.ps1 -Action eject -Force
```

Safety rules:

- Confirm intent interactively unless `-Force` is passed.
- Expand targets dynamically to resolve correct paths based on workspace root.
- The script cleans: `CLAUDE.md`, `AGENTS.md`, `progress-tracker.md`, and the `AgentJoJoy/` directory.

