# Agent Records

This folder stores mutable records for the wrapped workspace.

- `progress-tracker.md` — hot index for active work. Resume Check reads this.
- `setup-tracker.md` — temporary hot tracker during setup/onboarding only.
- `setup-history/` — cold archive for completed setup/onboarding history.
- `decisions/` — one file per significant project/workspace decision.
- `work/` — optional cold archive records loaded on demand; see
  `work/README.md`.

Keep `progress-tracker.md` concise and limited to active work handoff.
When setup is complete, move durable setup context out of
`setup-tracker.md` and into `setup-history/`, then clear mutable setup scratch
state inside `setup-tracker.md`'s
`AGENTJOJOY:ARCHIVE-THEN-CLEAR-AFTER-SETUP` marker back to placeholders. Do not
copy setup history into the progress tracker. Use decision files for
significant choices, and promote selected completed or paused work into `work/`
only when the hot index would otherwise lose durable context.
