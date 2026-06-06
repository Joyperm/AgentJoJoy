# Agent Records

This folder stores mutable records for the wrapped workspace.

- `progress-tracker.md` — hot index for active work. Resume Check reads this.
- `setup-tracker.md` — workspace setup, onboarding, and workflow/spec history.
- `decisions/` — one file per significant project/workspace decision.
- `work/` — optional archive records loaded on demand; see
  `work/README.md`.

Keep the tracker concise. Use decision files for significant choices, and
promote selected completed or paused work into `work/` only when the hot index
would otherwise lose durable context.
