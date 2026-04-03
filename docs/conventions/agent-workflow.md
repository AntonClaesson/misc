# Agent Workflow Convention

This repository prefers lightweight, durable task tracking inside the repo itself.

## Goal

Make interrupted agent runs easy to resume by leaving a clear trail in markdown files and git history.

## Default Pattern

For non-trivial work, agents should:

1. Read existing markdown context before making changes.
2. Record the current plan in a nearby markdown file.
3. Make a small batch of changes.
4. Update the markdown with progress, decisions, blockers, or next steps.
5. Repeat until the task is complete.

## What To Read First

Start with the closest relevant sources of truth:

- root `README.md`
- root `AGENTS.md`
- nearby `README.md`
- nearby `PLAN.md`
- nearby `TODO.md`
- nearby `WORKLOG.md`
- relevant notes in `docs/`
- recent git history for the area being changed

## Where To Write Progress

- Prefer notes close to the work, such as `projects/<name>/PLAN.md`.
- If the task spans multiple parts of the repo, use a note under `docs/`.
- Prefer updating an existing note over creating a new one.

## What To Capture

Keep notes brief and practical:

- current task goal
- current status
- assumptions
- important decisions
- blockers
- next steps
- references to related files or commits when useful

## Git Use

Git history is part of the working memory for this repo.

- When permitted by the active agent policy, prefer small descriptive commits at meaningful milestones.
- On resume, inspect recent commits before continuing.
- Do not rely on chat history alone to reconstruct prior work.

## Keep It Lightweight

- Do not create elaborate planning systems before they are needed.
- Do not create multiple overlapping status files for the same task.
- For very small changes, a separate note may be unnecessary.
