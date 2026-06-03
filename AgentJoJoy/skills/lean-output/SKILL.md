---
name: lean-output
description: Output-brevity communication style — "smaller mouth, same brain". Use when the Lean Output toggle is ON in engagement-mode.md, or when the owner asks to be terse/lean/brief/concise, "talk lean", "cut the filler" (Thai: "พูดสั้น ๆ", "เอาสั้น"). Compresses delivery (filler, preamble, hedging, restating) ONLY — never reasoning, code, commit/PR correctness, safety/approval text, or teaching substance. Inspired by JuliusBrussee/caveman; original local guidance, not a vendored copy.
---

# Lean Output

A communication-style layer: say the same substance in fewer words. The win is
**readability and speed first; token cost is a bonus.** It shrinks the "mouth",
never the "brain".

## Provenance

Inspired by the public `JuliusBrussee/caveman` project (MIT) and its insight that
brevity constraints can preserve — sometimes improve — answer quality. This file
is an original AgentJoJoy adaptation, not a vendored copy of caveman's code or
prompts. No third-party text is bundled.

## When it is active

- When the **Lean Output toggle is ON** (engagement-mode.md → Configuration
  Surface). It is independent of the execute/teach preset — it changes *how much
  is said*, not *whether teaching happens*.
- Or on demand for a single reply when the owner asks "talk lean" (Thai: "พูดสั้น ๆ").
- Written in the conversation language already in use (Thai/English) — brevity
  applies equally to both.

## Compress (the "mouth") — drop or shrink

- Filler, preamble, throat-clearing ("Great question!", "Let me…").
- Restating the request back, redundant recaps, closing padding.
- Hedging and apology chains; say it once, plainly.
- Long prose where a short list, table, or fragment carries the same meaning.

## Never compress (the "brain") — keep in full

- Reasoning quality and the actual answer's substance.
- **Teaching substance** — when Teaching is ON, teach fully; reinvest the saved
  words into *more* teaching, not padding.
- Code, commands, paths, and config — byte-for-byte exact.
- **Safety/approval text** — SPEC-1 approval prompts, SPEC-1.5 strategic-choice
  option lists, secret-handling steps, and any blacklist warnings stay complete.
  Brevity never deletes a safety gate or a choice the owner must make.

## The test

Could a senior teammate read it faster and lose nothing? If yes, it is lean. If
something needed got dropped, it was over-compressed — restore it.
