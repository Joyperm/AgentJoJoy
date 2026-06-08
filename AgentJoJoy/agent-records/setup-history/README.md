# Setup History

Cold archive for completed workspace setup and onboarding history.

Use this folder after setup/onboarding is complete and
`setup-tracker.md` no longer needs to stay hot. Archive only durable setup
context: chosen onboarding path, workspace model decisions, rule-surface
choices, migration notes, and links to significant decision records.

After archiving durable setup context, clear mutable content inside
`setup-tracker.md`'s `AGENTJOJOY:ARCHIVE-THEN-CLEAR-AFTER-SETUP` marker back
to placeholders. Preserve the marker comments for future setup changes.

Do not load this folder during Resume Check. Resume Check reads
`../progress-tracker.md` only. Load setup history on demand when the
owner asks about setup, onboarding, migrations, or workflow-rule history.

Suggested archive filename:

```text
YYYY-MM-DD-setup-history.md
```

Keep `../progress-tracker.md` focused on active work handoff. Do not
copy setup history into the progress tracker.
