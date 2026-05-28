# Skill Layers

AgentJoJoy treats skills as two layers. The layer determines what a
skill is allowed to influence and which source of truth wins when
skills overlap.

---

## Layer 1 - Personal Agent Skills

Personal Agent Skills are AgentJoJoy-owned practices that should travel across
projects and agents.

Examples in this repo:

- `agentjojoy-core-practices`
- `grill-me`

Use them for:

- Debugging discipline
- Review / sanity-checking discipline
- Post-mortems and stakeholder communication
- Brainstorming, planning, pressure-testing, and shared understanding

Rules:

- They shape how the AI thinks and collaborates.
- They are portable across projects.
- They must not override team/project repo rules for code, docs,
  architecture, review, branch, or release decisions.
- They must still obey AgentJoJoy safety gates for approvals, secrets,
  destructive commands, remote writes, force operations, production
  access, and personal context boundaries.

---

## Layer 2 - Project Skills

Project Skills are workspace-specific routines derived from one project
or team workflow.

Possible examples:

- "Run this repo's full verification suite"
- "Prepare this project's release notes"
- "Query this project's safe local database"
- "Review this team's UI checklist"
- "Generate documents in this project's house style"

Use them for:

- Repeated local workflows
- Project-specific commands
- Project-specific domain rules
- Project-specific review, release, or documentation procedures

Rules:

- They are scoped to one workspace/project.
- They should be created only after intake or after a repeated workflow
  is clear.
- For Path 2 existing projects, team/project repo rules remain
  authoritative for project content and conventions.
- They belong in `AgentJoJoy/skills/` unless the team explicitly wants
  the skill inside the team repo.
- They should summarize procedures and references, not copy secrets or
  sensitive team content unnecessarily.

---

## When Both Layers Match

Use both layers without letting them fight:

```text
Personal Agent Skill = how to think / collaborate
Project Skill        = project-specific facts / commands / workflow
Team/project rules   = authoritative project content and conventions
AgentJoJoy gates     = approvals and safety on the owner's machine
```

Examples:

- A bug report should use `agentjojoy-core-practices` for debugging discipline,
  then any project skill for this repo's exact test commands.
- A vague feature idea should use `grill-me` for the interview method,
  then any project skill for domain terms, release constraints, or team
  review rules.
- A release task should use the project release skill if present, while
  still respecting AgentJoJoy approval gates for commits, pushes, and
  remote writes.

If two skills give conflicting instructions, apply this order:

1. Team/project repo rules for project content and conventions.
2. AgentJoJoy safety gates for actions on the owner's machine.
3. Project Skills for local workflow details.
4. Personal Agent Skills for thinking and collaboration style.
5. Model defaults.

When the boundary is unclear, stop and ask the owner.

---

## Trigger Boundaries

Session start and onboarding protocols happen before normal skill
selection:

- Template Development mode
- Intake trigger states T0-T3
- Resume Check Protocol
- Explicit owner approval gates

After those protocols are satisfied, use these boundaries:

| Situation | Prefer |
|-----------|--------|
| Existing artifact to review: PR, diff, plan, design doc, proposal | `agentjojoy-core-practices` Scrutinize Routine |
| Open-ended idea, vague plan, or unresolved project direction | `grill-me` |
| User says debug, broken, failing, flaky, error, unexpected | `agentjojoy-core-practices` Debug Routine |
| User asks for RCA/post-mortem after validated fix | `agentjojoy-core-practices` Post-Mortem Routine |
| User asks for PM/leadership/Slack/email/standup rewrite | `agentjojoy-core-practices` Management-Talk Routine |
| User asks for project-specific repeated workflow | Project Skill if present; otherwise read project docs/scripts |

Ambiguous prompt rule:

```text
"ช่วยดูแผนนี้หน่อย" with a written plan -> agentjojoy-core-practices
"ช่วยคิด/ถาม/กดดันแผนนี้ให้ชัด" -> grill-me
```
