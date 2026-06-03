---
name: pattern-detection
description: Meta-skill that monitors the user's workflow pattern (using Recent Actions in progress-tracker.md and in-session memory). Triggers when the same multi-step workflow is performed 3+ times, then classifies the recurring work and routes it to the right automation tier (script / SmartWorker / Skill). Triggers: "repeated workflow", "same steps", "done this 3 times", "nudge to skill", "make a script", "create a subagent", "smartworker", "automate this", "pattern detection", "workflow pattern", "recurring action".
---

# Pattern-Detection Meta-Skill

Use this skill to detect recurring workflows, help the user identify manual repetitions, and route them to the right automation tier — a **script** (mechanical), a **SmartWorker** (knowledge-requiring, runs in a separate context), or a **Skill** (reusable SOP Main applies in-line). The old behavior of always nudging toward a Skill was too narrow; classify first, then nudge.

## When to Trigger Scan

This is a passive meta-skill. The AI should run this scan silently:
- At the start of a session (during or immediately after the Resume Check).
- When updating or reviewing `progress-tracker.md` (specifically the `Recent Actions` list).
- When the user performs the same action sequence 3 or more times within the active session.

## Scan and Match Heuristics (Hybrid Lite)

1. **β Tracker Scan**:
   - Read the `<workspace-root>/progress-tracker.md` file.
   - Inspect the `Recent Actions` section.
   - Look for repeating keywords, files, commands, or manual procedures that appear 3+ times (e.g. "manual db schema backup", "run endpoint check script", "copy assets from X to Y").

2. **γ Session Scan**:
   - Inspect the active session's conversation history in working memory.
   - Look for repetitive task prompts, identical verification commands, or multi-step setups that have been run 3+ times.

3. **Pattern Classification**:
   - Literal repeat: The exact same command or file target modified multiple times.
   - Semantic repeat: Doing similar tasks with slight variations (e.g., "created mock for API A", "created mock for API B", "created mock for API C").

## Tier Classification (do this BEFORE nudging)

Once a pattern is matched, classify the recurring work and recommend the
**lightest tier that solves it** — **script / SmartWorker / Skill**. Do not
default to "Skill".

The canonical taxonomy and the criteria for choosing a tier live in
[`ai-workflow-rules.md` → Work Escalation — Automation Tiers](../../agent-rules/ai-workflow-rules.md)
(single source of truth); SmartWorker mechanics are in
[`agent-smartworkers/README.md`](../../agent-smartworkers/README.md). If the
choice is genuinely ambiguous, name the top two options in the nudge and let
the owner decide.

## Proactive Nudge Routine

If a pattern is matched, output a friendly, conversational nudge that
recommends the **classified tier** (not always a Skill). Avoid using raw
JSON or dry technical blocks.

### Nudge Templates

The nudge must adapt to the conversation language. Below are reference formats:

#### English Context
> **Pattern Detected**: [Short description of the repeating workflow, e.g., "Manually validating and copying API endpoints"]
>
> "I noticed you've performed this workflow 3 times. Based on what it involves, this looks like a good fit for a **[classified tier: script / SmartWorker / Skill]** because [one-line reason]. Want me to set that up?"

Swap the tier and reason to match the classification. If two tiers are
plausible, present both briefly and ask which to use.

#### Non-English Context
When the conversation language is not English, translate the nudge
naturally into the active conversation language. Do not use a hardcoded
translation — adapt dynamically based on the session language.

## Drafting the Artifact (by tier)

If the user accepts the nudge, branch on the classified tier:

- **Script** → propose a small CLI/script/checklist (whatever the
  project uses). Get approval before creating or running anything per
  the workspace permission gates.
- **SmartWorker** → copy the runtime-neutral skeleton from
  [`AgentJoJoy/agent-smartworkers/smartworker-spec.template.md`](../../agent-smartworkers/smartworker-spec.template.md)
  and fill it in. The Main Agent then translates the Governance zone
  into its own runtime's native subagent contract (verifying current
  syntax from the official source first, per Help-First).
- **Skill** → draft a `SKILL.md` skeleton (below).

### Skill Skeleton Format

When the tier is **Skill**:
1. Propose a short, hyphenated skill name (e.g., `api-validation`, `asset-sync`).
2. Create `AgentJoJoy/skills/<suggested-name>/SKILL.md` with the skeleton below.
3. Show the proposed file path to the user.

The drafted file should follow this template exactly:

```markdown
---
name: <suggested-name>
description: <Short 1-2 sentence description of when to trigger and what it does>
---

# <Title Case Name>

## When to use

Trigger when the owner says:
- "<Trigger keyword 1>"
- "<Trigger keyword 2>"

## Step-by-step procedure

### Step 1 — <First Step Name>
<Describe the first step, including any exact commands to run or files to edit.>

### Step 2 — <Second Step Name>
<Describe the second step.>

## Failure recovery

| Failure | Recovery Action |
|---|---|
| <Common error/failure mode> | <How to recover or who to ask> |

## What this skill does NOT do
- <Boundary limit 1>
- <Boundary limit 2>
```

4. Explain to the user that they can edit this drafted skeleton to match their exact needs, and once finalized, they can wire it into the `CLAUDE.md`/`AGENTS.md` skill list for auto-discovery.
