---
name: pattern-detection
description: Meta-skill that monitors the user's workflow pattern (using Recent Actions in progress-tracker.md and in-session memory). Triggers when the same multi-step workflow is performed 3+ times, nudging the user to draft a custom skill. Triggers: "repeated workflow", "same steps", "done this 3 times", "nudge to skill", "pattern detection", "workflow pattern", "recurring action".
---

# Pattern-Detection Meta-Skill

Use this skill to detect recurring workflows, help the user identify manual repetitions, and nudge them to formalize these patterns into dedicated, reusable custom skills (SOPs).

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

## Proactive Nudge Routine

If a pattern is matched, output a friendly, conversational nudge. Avoid using raw JSON or dry technical blocks.

### Nudge Templates

The nudge must adapt to the conversation language. Below are reference formats:

#### English Context
> **Pattern Detected**: [Short description of the repeating workflow, e.g., "Manually validating and copying API endpoints"]
>
> "I noticed you've performed this workflow 3 times. To make this easier and more reliable, would you like me to draft a custom skill at `AgentJoJoy/skills/<name>/SKILL.md` to codify these steps?"

#### Non-English Context
When the conversation language is not English, translate the nudge
naturally into the active conversation language. Do not use a hardcoded
translation — adapt dynamically based on the session language.

## Drafting the Skeleton

If the user accepts the nudge:
1. Propose a short, hyphenated skill name (e.g., `api-validation`, `asset-sync`).
2. Create `AgentJoJoy/skills/<suggested-name>/SKILL.md` with a clean skeleton structure.
3. Show the proposed file path to the user.

### Skeleton Format

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
