# Agent Guidance

This repository is a polyglot monorepo for personal, agent-assisted work.
This file is the single source of truth for agent behavior in this repo.

## What Belongs Where

- `projects/`: one-off tools, vibe-coded apps, prototypes, life-specific utilities.
- `workflows/`: reusable operational flows, prompt-driven processes, playbooks.
- `mcp/`: personal MCP servers, tool adapters, MCP-related support code.
- `packages/`: shared libraries or tooling — only when multiple consumers justify it.
- `templates/`: starter scaffolds for recurring project shapes.
- `scripts/`: repo-level helper scripts.
- `docs/`: short notes, decisions, and repo conventions.
- `data/`: non-sensitive sample, derived, or disposable data only.

Agent skills live in `.cursor/skills/`.

## Current Biases

- Prefer small, self-contained projects over shared abstractions.
- Default new app-like work into `projects/`.
- Keep root-level tooling minimal so each project can use its own stack.

## Branch And Git Model

`main` is the stable, user-reviewed branch.

**Default workflow:**

1. Create or reuse an initiative branch for the current piece of work.
2. Commit progress to that branch, not directly to `main`.
3. Merge to `main` only after user verification.

**Direct-to-main exception:** trivial, self-contained docs or meta changes (typo fixes, README tweaks) may go directly to `main`. When in doubt, use a branch.

**Commit style:**

- Prefer small, descriptive commits at meaningful milestones.
- Update the nearest task note before committing non-trivial work.
- Keep commit messages focused on purpose, not mechanics.

**Push policy:**

- Do not push unless the user explicitly asks or the workflow clearly requires it.
- Before pushing, ensure the working tree and nearby markdown notes are consistent.

**Resume behavior:**

- Read the nearest markdown notes and inspect recent commits on the initiative branch.
- Reconcile notes with the current tree before making further changes.
- Do not rely on prior chat context alone.

## Task State

For non-trivial work, leave enough state in the repo that a future agent can resume without chat history.

**Default loop:**

1. Read nearby markdown context before making changes.
2. Record a short plan in a nearby markdown file if one does not already exist.
3. Make a small batch of changes.
4. Update the note with progress, decisions, or next steps.
5. Repeat until complete.

**Where to write notes:**

- Prefer notes close to the work (e.g., `projects/<name>/PLAN.md`).
- Use `docs/` only when the task spans multiple areas of the repo.
- Prefer updating an existing note over creating a new one.

**What to capture:** current goal, status, assumptions, decisions, blockers, next steps, related files or commits.

See `docs/conventions/agent-workflow.md` for the full list of files to check and additional detail.

## Project Lifecycle

Every project directory should have a `README.md` that includes at minimum:

- project name and one-line purpose,
- `status`: one of `active`, `done`, `paused`, or `abandoned`,
- how to run it (if applicable),
- stack / key dependencies.

See `templates/project-readme.md` for a starting point.

## Safety

- Never commit secrets, credentials, tokens, or private personal data.
- Treat `.env` files, local exports, and machine-specific artifacts as ignored.
- Prefer sanitized examples over real personal data in version control.

## Decision Summary

- Polyglot-first, purpose-organized monorepo.
- Branch-first workflow; `main` is user-reviewed.
- Agent state lives in markdown notes and git history.
- Skills live exclusively in `.cursor/skills/`.
