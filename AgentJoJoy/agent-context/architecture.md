# Architecture Context

> 📋 **Optional template** — keep only if this is a coding project.
> Personal cheatsheet of the project's architecture. The authoritative
> source is whatever the team has committed (e.g. README,
> `.cursor/rules/project-overview.mdc`, ADRs). When they disagree with
> this file, the team source wins — update this file to match.

---

## Stack

<!-- AUTO-FILL from package.json / requirements.txt / Cargo.toml /
     go.mod. List as a table grouped by layer. Sample shape: -->

| Layer | Technology | Role |
|-------|-----------|------|

_(not set)_

## System Boundaries

<!-- AUTO-FILL from top-level folder structure + reading README.
     One bullet per folder/module with a one-line purpose. Highlight
     folders the user must NOT modify casually (libraries, generated
     code, vendored UI). -->

_(not set)_

## Storage Model

<!-- ASK USER + AUTO-FILL from config: which databases, file stores,
     caches, queues. For each, note the access pattern (e.g.
     "PostgreSQL — all relational data, scoped by tenantId"). -->

_(not set)_

## Auth and Access

<!-- AUTO-FILL from auth module + role enums. Note: auth mechanism
     (JWT / session / OAuth), role hierarchy, any tenant/workspace
     scoping. -->

_(not set)_

## Invariants

<!-- ASK USER + scan for guards: the rules that must always hold for
     the system to be correct. Examples:
       - "Every query is tenant-scoped"
       - "Multi-step writes use transactions"
       - "Controllers stay thin; logic in services"
     These are the things AI must never violate. -->

_(not set)_

## Cross-Cutting Concerns

<!-- AUTO-FILL from scanning for shared modules: logging, audit
     trail, notifications, feature flags, etc. Each with a one-line
     summary of when it kicks in. -->

_(not set)_

## What I Don't Know Yet

<!-- Living list of architecture questions to answer when relevant
     code is touched. Add entries as gaps surface. -->

_(none yet)_
