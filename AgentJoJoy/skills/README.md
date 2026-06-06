# Skill Layers & Priority Guidelines

AgentJoJoy treats skills as two logical layers. The layer determines what a skill is allowed to influence, how it is discovered, and which source of truth wins when skills or rules overlap.

## Table of Skill Layers & Priority

| Skill Area / Policy | Focus & Semantic Purpose | Key Sections |
| :--- | :--- | :--- |
| **[Skill Taxonomy](#layer-1---personal-agent-skills)** | The two-layer skill architecture: Personal Agent Skills (portable) vs Project Skills (workspace-specific). | `#Layer-1-Personal`, `#Layer-2-Project` |
| **[Precedence & Conflict Resolution](#when-both-layers-match)** | Strict hierarchy of authority when rules, safety gates, or skill instructions conflict. | `#Priority-of-Precedence`, `#Conflict-Resolution` |
| **[Skill Sandboxing Policy](#skill-sandboxing-and-permission-boundaries)** | Strict safety containment rules prohibiting custom skills from modifying outer wrappers or secrets. | `#Skill-Sandboxing`, `#Wrapper-Protection` |
| **[Discovery & Trigger Heuristics](#skill-discovery-heuristics)** | How AI discovers skills passively or via directive cues, and keyword-based triggering mappings. | `#Skill-Discovery`, `#Trigger-Boundaries` |

---

## Layer 1 - Personal Agent Skills

Personal Agent Skills are AgentJoJoy-owned practices that should travel across projects and agents.

Examples in this repo:
- `agentjojoy-core-practices`
- `grill-me`
- `pattern-detection`
- `lean-output`

Use them for:
- Debugging discipline
- Review / sanity-checking discipline
- Post-mortems and stakeholder communication
- Brainstorming, planning, pressure-testing, and shared understanding

Rules:
- They shape how the AI thinks and collaborates.
- They are portable across projects.
- They must not override team/project repo rules for code, docs, architecture, review, branch, or release decisions.
- They must still obey AgentJoJoy safety gates for approvals, secrets, destructive commands, remote writes, force operations, production access, and personal context boundaries.

---

## Layer 2 - Project Skills

Project Skills are workspace-specific routines derived from one project or team workflow.

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
- They should be created only after intake or after a repeated workflow is clear.
- For Path 2 existing projects, team/project repo rules remain authoritative for project content and conventions.
- They belong in `AgentJoJoy/skills/` unless the team explicitly wants the skill inside the team repo.
- They should summarize procedures and references, not copy secrets or sensitive team content unnecessarily.

---

## SmartWorkers Are Not Skills

SmartWorkers live under `AgentJoJoy/agent-smartworkers/`, not
`AgentJoJoy/skills/`. Use them when recurring work needs project
knowledge, inspection, or synthesis in a separate context before
returning a result to the single Main Agent.

Use a Project Skill when the repeated work is an in-line SOP the Main
Agent should follow in its current context. Use a SmartWorker when the
work would otherwise spend too much Main Agent context but still
requires judgment beyond a mechanical script.

`pattern-detection` may route a 3+ repeat to a script, SmartWorker, or
Skill; it should not assume every recurring workflow becomes a Skill.

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
- A bug report should use `agentjojoy-core-practices` for debugging discipline, then any project skill for this repo's exact test commands.
- A vague feature idea should use `grill-me` for the interview method, then any project skill for domain terms, release constraints, or team review rules.
- A release task should use the project release skill if present, while still respecting AgentJoJoy approval gates for commits, pushes, and remote writes.

### Priority of Precedence

> [!IMPORTANT]
> **RULE HIERARCHY OF AUTHORITY**
>
> If two skills, rules, or instructions give conflicting guidance during a session, the AI must strictly apply the following 5-step order of precedence:
> 
> 1. **Team/Project Repo Rules**: Dictates code structure, style, architecture, and repo-level conventions (e.g. repo `CLAUDE.md`, `.cursor/rules/*`).
> 2. **AgentJoJoy Safety Gates**: Dictates approvals, safety checks, destructive blacklists, secrets protection, and machine operations (e.g. `ai-workflow-rules.md`).
> 3. **Project Skills**: Dictates local runtime stack commands, safe database access parameters, and repo-specific custom workflows.
> 4. **Personal Agent Skills**: Dictates cognitive debugging loops, scrutinize reviews, post-mortem structures, and communication styles.
> 5. **Model Defaults**: Standard reasoning defaults when no overriding wrapper rules exist.
>
> When the boundary is unclear or a conflict is undecidable, **stop execution immediately** and ask the human owner for explicit clarification.

---

## Skill Sandboxing and Permission Boundaries

> [!WARNING]
> **SKILL ISOLATION & WRAPPER SAFETY**
>
> To protect the integrity of the personal operating layer, all skills (including Project Skills or custom skills drafted by AI) must operate strictly within their specialized functional boundaries.
> 
> - A skill is **never permitted** to autonomously modify personal credentials, read or write outer wrapper configurations (`CLAUDE.md`, `AGENTS.md`, `AgentJoJoy/agent-records/progress-tracker.md`), or alter wrapper system rules inside `AgentJoJoy/` that are unrelated to its functional scope.
> - A skill must **strictly respect AI-NO-OVERWRITE blocks** at all times.
> - Any modification of wrapper rules or credentials by a skill requires **explicit, direct, and written permission** from the human owner in the chat.

---

## Skill Discovery Heuristics

To ensure high portability and compatibility across multiple target runtimes, AgentJoJoy utilizes a dual-model skill discovery system:

### 1. Active Discovery (Auto-Scan Runtimes)
- Tools with native workspace skill discovery (such as **Claude Code**) automatically scan the filesystem for directories containing a `SKILL.md` file. 
- These runtimes automatically read, index, and surface these skills in the chat interface (e.g. via `/` commands) without user intervention.

### 2. Passive Discovery (Directive Trigger Runtimes)
- Tools without native filesystem auto-scanning (such as **Cursor** or **Codex**) cannot discover skills automatically. 
- To close this gap, AgentJoJoy wires **explicit directive references and trigger keywords** into the root entry points `CLAUDE.md` and `AGENTS.md`. 
- When a user's prompt matches a directive keyword (e.g. *debug*, *review*, *grill*), the AI is instructed by the entry point to actively locate and read the corresponding `SKILL.md` file, guaranteeing identical skill execution across all environments.
- Cursor wrapper walk-up has been live-validated, so AgentJoJoy does
  not create `.cursor/rules/agentjojoy.mdc` bridge files by default.
  Use a local-only bridge only after an observed discovery failure; in
  team repos, keep that bridge untracked via `.git/info/exclude` unless
  the owner/team explicitly approves sharing it.

---

## Trigger Boundaries

Session start and onboarding protocols happen before normal skill selection:
- Intake trigger states
- Resume Check Protocol
- Explicit owner approval gates

After those protocols are satisfied, use these trigger keyword mappings:

| Situation | Prefer |
|-----------|--------|
| Existing artifact to review: PR, diff, plan, design doc, proposal | `agentjojoy-core-practices` Scrutinize Routine |
| Open-ended idea, vague plan, or unresolved project direction | `grill-me` |
| User says debug, broken, failing, flaky, error, unexpected | `agentjojoy-core-practices` Debug Routine |
| User asks for RCA/post-mortem after validated fix | `agentjojoy-core-practices` Post-Mortem Routine |
| User asks for PM/leadership/Slack/email/standup rewrite | `agentjojoy-core-practices` Management-Talk Routine |
| User asks for project-specific repeated workflow | Project Skill if present; otherwise read project docs/scripts |
| User repeats steps/actions/commands, or asks to detect patterns | `pattern-detection` to route the work to script / SmartWorker / Skill |
| Lean Output toggle on, or user asks to be terse/brief ("talk lean") | `lean-output` |

Ambiguous prompt rule:

```text
"Can you look at this plan?" (Thai: "ช่วยดูแผนนี้หน่อย") with a written plan -> agentjojoy-core-practices
"Help me think through / pressure-test this plan" (Thai: "ช่วยคิด/ถาม/กดดันแผนนี้ให้ชัด") -> grill-me
```
