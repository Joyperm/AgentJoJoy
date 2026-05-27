# Standards — Quick Reference

> 📋 **Template** — personal cheatsheet distilled from the project's
> conventions. The team's rule files (typically `.cursor/rules/*.mdc`,
> `CLAUDE.md`, or a `CONTRIBUTING.md`) are the source of truth. When
> in doubt, re-read them in the repo.

---

## Authoritative Sources

<!-- AUTO-FILL: list team rule files found in the repo. Examples:
       .cursor/rules/backend-standards.mdc
       .cursor/rules/frontend-standards.mdc
       .cursor/rules/test-after-changes.mdc
       CONTRIBUTING.md
       docs/style-guide.md -->

_(not set)_

## General — Apply Everywhere

<!-- Generic rules that apply regardless of language/framework.
     Keep this list short and high-value. Examples below — adjust
     during intake. -->

- **Never reorganize, rename, or relocate existing files/folders**
  without explicit instruction.
- **Follow existing patterns** rather than inventing new ones.
- **Avoid loose typing** — use explicit interfaces or narrowly
  scoped types (e.g. avoid `any` in TypeScript, `Any` in Python).
- _(add project-specific general rules here during intake)_

## Language / Framework Standards

<!-- AUTO-FILL from package.json / requirements.txt + reading existing
     code. Add one section per primary language/framework in the
     project. Each section lists: folder structure conventions, naming
     conventions, key patterns observed in the codebase.

     For non-coding projects (writing, research), replace with the
     equivalent: voice/tone, document structure, citation style. -->

_(not set)_

## Testing Discipline

<!-- ASK USER + scan for existing test patterns. Cover:
       - When tests are required (bug fix, new feature, etc.)
       - What kind (unit, integration, e2e)
       - Where they live (colocated vs separate folder)
       - How to run them -->

_(not set)_

## Documentation Discipline

<!-- ASK USER: what docs are required for what kinds of changes?
     Examples:
       - "No .md docs in repo for bug fixes — team rule"
       - "Each new module needs a README in the module folder"
       - "ADRs for architectural decisions, in docs/adr/"
     Personal notes belong in AgentJoJoy/, not in the team repo. -->

_(not set)_

## Database / External Service Access

<!-- ASK USER: how does the project access databases, secrets,
     external APIs? List the conventions:
       - Where credentials live (.env / secrets manager)
       - How to query (CLI tool, ORM, etc.)
       - Read-only by default? Confirm before mutating?
       - Which environments are safe to test against
     Never copy credentials into AgentJoJoy/. -->

_(not set)_

## Anti-Patterns (Project-Specific)

<!-- Living list — add patterns the team explicitly avoids, with
     a short reason. Helps AI avoid stumbling into known traps. -->

_(none yet)_
