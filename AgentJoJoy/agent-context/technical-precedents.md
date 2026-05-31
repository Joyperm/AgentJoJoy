# Technical Precedents

List of technical facts, validated solutions, and workarounds discovered during work in this workspace. Future AI sessions read this file to avoid repeating past mistakes.

---

## Validated Precedents

<!-- Format:
- **[Area]**: [Validated Fact / Precedent] (Date: YYYY-MM-DD, Commit/Context: <ref>)
-->

- **[Release Discipline]**: The AI must always explicitly execute the dev-only `release-patch` skill (`AgentJoJoy/template-lab/skills/release-patch/SKILL.md`) when a release is requested, rather than suggesting `release.ps1` directly, ensuring all 8 steps and pre-flight audits are run. (Date: 2026-05-30, Commit/Context: 5d98e6d)
