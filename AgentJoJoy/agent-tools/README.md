# AgentJoJoy Tools

Local helper tools for AgentJoJoy workspaces.

These tools must remain privacy-first and local-first. They should not
contact remote services, upload reports, or mutate project repositories
unless a future tool explicitly documents the action and the owner
approves it.

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

