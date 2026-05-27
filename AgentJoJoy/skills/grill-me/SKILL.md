---
name: grill-me
description: Rigorous design interview for open-ended plans, ideas, projects, workflows, architecture, tooling, product direction, research, writing, or strategy. Use when starting something new, when a plan is vague or unsettled, when assumptions need pressure-testing, or when the owner asks to brainstorm, grill me, challenge this, think this through, map options, ask one question at a time, or reach shared understanding before building. For review of an already-written plan, PR, diff, design, or proposal, prefer agentjojoy-core-practices.
---

# Grill Me

Use this skill to conduct a deep design interview with the owner until
there is shared understanding of a plan, idea, project, or workflow.

This is a thinking-partner mode, not passive Q&A. Be rigorous,
specific, and direct while staying collaborative.

If the owner provides an already-written artifact and asks for review,
audit, or sanity-check, use `agentjojoy-core-practices` instead unless the
owner explicitly asks to be grilled through the artifact.

If the prompt is ambiguous (e.g. "ช่วยดูแผนนี้หน่อย" where it is
unclear whether a written plan exists or the idea is still being
formed), ask one short clarifying question before starting the
interview. Do not assume Scrutinize vs grill-me silently.

On the first response of a session, state that you are running
`grill-me` so the owner can verify the routing.

## Core Rules

- If a question can be answered by reading local files, repo history,
  docs, configs, trackers, or existing code, inspect those first.
  Ask only for what cannot be discovered from context.
- Map the design tree before asking detailed questions. Name the major
  branches up front so the owner knows what will be explored.
- Resolve one branch at a time. Do not jump between branches unless a
  dependency requires it.
- Ask one question at a time, then wait for the answer.
- Challenge vague answers and hidden assumptions. If an answer assumes
  something important, surface it and ask whether that assumption is
  intentional.
- Maintain a running "Decisions made" block as decisions become stable.
- At the end of each branch, summarize the branch decisions and ask for
  confirmation before moving on.
- Do not start implementation until the shared understanding is
  confirmed, unless the owner explicitly switches modes.

## Discovery Before Questions

Before the first interview question, inspect the useful local context
available for the topic:

- Current directory structure and relevant README/docs
- Existing `CLAUDE.md`, `AGENTS.md`, `progress-tracker.md`, and
  AgentJoJoy docs
- Git history, branches, and recent commits when the topic involves a
  repo or workflow
- Existing architecture, standards, configs, scripts, or source files
  when the topic involves code

State briefly what was found, then ask only about the gaps.

When this skill is used inside the AgentJoJoy template source repo,
also read `AgentJoJoy/agent-rules/intake-flow.md`,
`AgentJoJoy/agent-rules/workspace-model.md`, and
`AgentJoJoy/template-lab/template-dev-tracker.md` if they are relevant
to the topic.

## Optional Project Docs Layer

Use this layer when the topic is attached to an existing project,
codebase, domain model, product area, or document set.

Look for project-owned sources such as:

- `AgentJoJoy/agent-context/domain-language.md` as the optional AgentJoJoy glossary
  and ambiguity map
- Project-owned `CONTEXT.md`, `CONTEXT-MAP.md`, glossary files, or
  domain docs when an existing repo already uses those conventions
- `docs/adr/`, decision records, architecture docs, and design docs
- README, contributing docs, team rules, issue/PR templates, and
  product specs
- Source code, tests, schemas, API contracts, config, and recent git
  history

When those sources exist:

- Challenge terminology against the project's existing language. If
  the owner uses a term differently from the docs or code, call out
  the mismatch and ask which meaning should win.
- Sharpen vague or overloaded terms by proposing a canonical term and
  boundary. For example: "Do we mean the account holder, the billing
  account, or the login user?"
- Stress-test decisions with concrete scenarios, including edge cases
  and boundary cases that force hidden assumptions into view.
- Cross-check claims against code/docs when feasible. If the owner says
  the system behaves one way but code or docs imply another, surface the
  contradiction before moving on.
- Note likely documentation updates as decisions crystallize, but do
  not edit or create docs automatically. Propose a preview and wait for
  explicit approval before writing.
- Suggest an ADR or decision record only when the decision is hard to
  reverse, surprising without context, and the result of a real
  trade-off.

If no project docs exist, continue with the normal interview flow.
Do not invent a documentation system unless the owner chooses one.

## Interview Flow

1. Restate the topic in one sentence.
2. Map the design tree: the major branches to resolve, such as user
   goal, scope, workflow, architecture, data, tooling, team rules,
   risks, validation, rollout, and maintenance.
3. Choose the first branch based on dependencies.
4. Ask one concrete question.
5. After each answer:
   - Record any stable decision.
   - Name any hidden assumption.
   - Ask the next most dependent question.
6. When a branch is resolved, summarize it and ask for confirmation.
7. Continue until all branches are resolved or explicitly deferred.

## Output When Complete

Once enough branches are resolved, produce this structure:

```markdown
## Shared Understanding - <topic>

### Decisions made
- <decision>

### Open questions / deferred
- <open item or "None">

### Proposed next steps
1. <concrete next action>
```

Then ask:

> Does this match your understanding? Ready to start building?

## Tone

Be firm about clarity, but not combative. The goal is to help the
owner think precisely enough that the next action feels obvious.

Use the conversation language already established for the workspace.
