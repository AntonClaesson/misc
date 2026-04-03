# Repository Guidance

This repository is a polyglot monorepo for personal, agent-assisted work.

## Primary Goal

Keep the repo easy for agents to understand and extend without assuming one language, framework, or package manager.

## What Belongs Where

- `projects/`: default location for new one-off tools, vibe-coded apps, prototypes, and life-specific utilities.
- `workflows/`: reusable operational flows, prompt-driven processes, playbooks, and automation definitions.
- `mcp/`: personal MCP servers, tool adapters, and MCP-related support code.
- `skills/`: reusable agent skills and instruction assets.
- `packages/`: shared libraries, schemas, helpers, or tooling only when multiple consumers justify it.
- `templates/`: starter scaffolds for recurring project shapes.
- `docs/`: short notes, decisions, and repo conventions.
- `data/`: non-sensitive sample, derived, or disposable data only.

## Current Biases

- Prefer small, self-contained projects over heavy shared abstractions.
- Do not optimize for long-running production apps yet.
- Default new app-like work into `projects/`, not `apps/`.
- Keep root-level tooling minimal so any project can use its own stack.

## Working Style For Agents

- A project-local skill, `repo-task-state`, exists for this repository and should be used when relevant.
- A project-local skill, `start-project`, exists for creating new work under this repo's conventions.
- Treat markdown notes in the repo as part of the task state, not optional decoration.
- Before starting non-trivial work, read the nearest relevant markdown context such as `README.md`, `AGENTS.md`, `PLAN.md`, `TODO.md`, `WORKLOG.md`, or decision notes.
- When work spans multiple steps, write down the plan and progress in markdown so another agent can resume if the run is interrupted.
- Prefer updating existing task notes over creating duplicate status files.
- Keep notes concise and useful: current goal, assumptions, next steps, blockers, and what changed.
- Prefer storing task notes close to the work, for example inside a project directory; use `docs/` only when the task spans multiple areas of the repo.
- Use git history as part of the project memory. When allowed by the active agent/runtime policy, prefer small, descriptive commits at meaningful milestones rather than one large final commit.
- When resuming work, inspect both the markdown notes and recent git history before making changes.

## Git And Remote Behavior

- Read recent git history and current status before committing or pushing.
- For non-trivial work, update the nearest task note before committing a milestone.
- Prefer small meaningful commits over large mixed commits when the work naturally splits.
- Do not push to remote unless the user explicitly asks or the workflow clearly requires it.
- Before pushing, make sure nearby notes and the working tree reflect the same state.

## Safety Rules

- Never commit secrets, diaries, credentials, tokens, or private raw personal data.
- Treat `.env` files, local exports, and machine-specific artifacts as ignored by default.
- Prefer sanitized examples, mocks, and schemas over real personal data in version control.

## Decision Summary

- This repo is polyglot-first.
- This repo currently focuses on one-off projects and emerging workflows.
- Long-lived app structure can be introduced later if it becomes necessary.
- Agents should preserve task state in markdown and, when permitted, in small meaningful git commits.
