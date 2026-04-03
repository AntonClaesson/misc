# misc

Polyglot monorepo for personal, agent-assisted projects, MCPs, skills, and workflows.

## Current Intent

This repository is a home for small, vibe-coded, one-off projects and future agentic tooling.
It is not currently optimized for long-running production apps.

The structure should make it easy for future agents to:

- discover where new work belongs,
- understand the difference between projects, workflows, MCPs, and skills,
- preserve task state in markdown files inside the repo,
- resume interrupted work by reading notes and git history,
- avoid committing sensitive local data,
- add new work in any language or framework without reshaping the repo.

## High-Level Structure

```text
misc/
├─ projects/   # small one-off apps, prototypes, life-specific tools
├─ workflows/  # reusable agent/human workflows and operating playbooks
├─ mcp/        # personal MCP servers and related support code
├─ skills/     # reusable agent skills/instructions
├─ packages/   # optional shared code, schemas, tooling
├─ templates/  # starter templates for future projects
├─ scripts/    # repo-level helper scripts
├─ docs/       # lightweight architecture notes and decisions
└─ data/       # non-sensitive sample/derived data only
```

## Working Principles

- The repo is polyglot-first: each project may use its own language, framework, and tooling.
- Most work should start in `projects/`.
- `workflows/` is for more reusable operating logic, not just code.
- `packages/` should stay small and only hold shared pieces that are worth coupling.
- Agents should document non-trivial work in markdown files so progress survives interruptions.
- Future work should be understandable from a combination of repo notes and git history.
- Sensitive personal data, secrets, diaries, raw exports, and environment files must stay out of git.

## Agent Operating Model

- Future agents should read repo guidance before starting significant work.
- For multi-step tasks, agents should keep durable state in nearby markdown notes.
- Git history should be treated as part of the repo memory, especially for resumed work.
- Pushing to remote should be intentional rather than automatic.

## Branch Strategy

- `main` is the stable, user-reviewed branch.
- Default: create or reuse one shared feature branch per initiative (for example, `feature/<initiative-name>`) and push work there.
- Merge to `main` only after user verification.
- Exception: trivial docs/meta updates may go directly to `main` when clearly low-risk and self-contained (e.g., typo fixes in `README.md`, updating a decision note). Do not use this exception for code or config changes.

## Near-Term Plan

1. Start by creating projects under `projects/` as specific needs appear.
2. Add `workflows/` only when a repeatable personal or agent-assisted process emerges.
3. Add `mcp/` servers when a workflow needs tools or data access beyond simple scripts.
4. Introduce `packages/` only after duplication becomes real.
5. Add templates once two or more projects share a common setup pattern.

## Ready State

This repo now includes:

- repo-level agent guidance in `AGENTS.md`,
- lightweight agent workflow conventions in `docs/conventions/`,
- project-local Cursor skills in `.cursor/skills/`,
- a reusable task note template in `templates/task-note.md`,
- minimal top-level placeholders so new work has an obvious home.

See `AGENTS.md` for repo conventions intended for future agents and `docs/conventions/` for the lightweight operating patterns.