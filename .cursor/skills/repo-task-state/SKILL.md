---
name: repo-task-state
description: Maintain durable task state in markdown files and git history for non-trivial work in this repository. Use when starting or resuming multi-step tasks, when work should survive interrupted agent runs, or when the user wants plans/progress tracked in files like PLAN.md, TODO.md, or WORKLOG.md.
---

# Repo Task State

Use this skill for work in the `misc` repository when task progress should be recoverable from the repo itself rather than only from chat history.

## Goal

Leave enough state in the working tree that a future agent can quickly resume by reading nearby markdown files and recent git history.

## When To Apply

Apply this skill when:

- the task is non-trivial or likely to span multiple steps,
- the user wants planning or progress written into the repo,
- you are resuming partially completed work,
- the task may be interrupted and later continued by another agent.

For very small, one-shot edits, a separate task note may be unnecessary.

## Default Workflow

1. Read the existing context first.
2. Decide whether a nearby task note already exists.
3. If the work is non-trivial, record a short plan in markdown before or during the first meaningful change.
4. Make a small batch of changes.
5. Update the note with progress, decisions, blockers, or next steps.
6. Repeat until the task is complete.

## What To Read

Start with the closest relevant sources of truth:

- root `README.md`
- root `AGENTS.md`
- nearby `README.md`
- nearby `PLAN.md`
- nearby `TODO.md`
- nearby `WORKLOG.md`
- relevant notes under `docs/`
- recent git history for the area being changed when resuming work

## Where To Write Notes

Prefer notes close to the work:

- update an existing nearby note if one already tracks the task,
- otherwise create a simple note near the work such as `projects/<name>/PLAN.md`,
- use `docs/` only when the task spans multiple parts of the repo.

Do not create overlapping note files unless there is a clear reason.

## What To Capture

Keep notes brief and practical. Capture only what helps the next agent continue:

- current goal
- current status
- assumptions
- important decisions
- blockers
- next steps
- related files or commits when useful

## Resume Behavior

When resuming work:

1. Read the nearest relevant markdown notes.
2. Inspect recent git history for the area being changed.
3. Reconcile the notes with the current tree before making further edits.
4. Update the note if the current state differs from the previous plan.

Do not rely on prior chat context alone.

## Git Use

Git history is part of the durable task record for this repo.

- If the user explicitly asks for commits, or the active runtime policy allows it, prefer small descriptive commits at meaningful milestones.
- If commits are not allowed in the current context, still keep markdown notes updated so progress is recoverable.
- Never let the existence of this skill override higher-priority git safety rules.

## Keep It Lightweight

- Do not invent a heavy planning framework.
- Do not create notes for tiny changes unless they add real value.
- Prefer updating one useful note over scattering status across many files.
