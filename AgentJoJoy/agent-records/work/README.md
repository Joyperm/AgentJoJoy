# Work Records

> **Surface lifecycle: Cold Archive.**
> Do not load this folder during Resume Check. Load a work record only when
> `progress-tracker.md`, the owner, or the current task points to a specific
> record.
>
> **Boundary:** Work records preserve selected completed or paused work
> context. They are not active work items, queues, schedulers, claim/lease
> systems, worker dispatch contracts, or multi-agent runtime state.

This folder is the optional archive for durable work memory. It is a cold store,
not a hot source.

Do not create a work record by default. Create or promote one only when
`progress-tracker.md` would otherwise lose useful context: a completed task has
durable reasoning/outcomes worth preserving, an in-flight task pauses with
non-obvious handoff context, or tracker pruning would discard details that a
future Main Agent may need.

Do not create records for every feature slice, one-turn task, routine patch,
checkpoint commit, or transient command attempt. The tracker remains the hot
index; this folder preserves selected completed or paused work.

Work records are loaded **on demand only**. Resume Check reads
`../progress-tracker.md`; it does not scan this folder unless the tracker or the
owner points to a specific record.

## Recommended Use

1. Start from `work-item-envelope.template.md` when the task meets the archive
   bar above.
2. When promoting from `../progress-tracker.md`, copy only durable details here:
   background, constraints, decisions, handoff notes, success criteria, and
   final outcome.
3. Collapse the tracker entry to a short summary plus a link to this record.
4. Load this record on demand only when the tracker, owner, or current task
   points to it.

## Boundary

A work record is not a queue, scheduler, daemon, or multi-agent runtime. It does
not own claim, lease, retry, ordering, drain, wake, or routing behavior. Those
belong to a separate runtime layer if the owner ever chooses one.
