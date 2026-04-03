---
name: repo-task-state
description: Maintain durable task state in markdown files and git history for non-trivial work in this repository. Use when starting or resuming multi-step tasks, when work should survive interrupted agent runs, or when the user wants plans/progress tracked in files like PLAN.md, TODO.md, or WORKLOG.md.
---

# Repo Task State

Use this skill when task progress in the `misc` repository should be recoverable from the repo itself.

All behavioral rules (where to write notes, what to capture, commit style, branch model) are defined in `AGENTS.md`. This skill adds only the activation logic.

## When To Activate

- The task is non-trivial or multi-step.
- The user wants planning or progress written into the repo.
- You are resuming partially completed work.
- The task may be interrupted and continued by another agent.

For very small, one-shot edits, a separate task note is unnecessary.

## Quick Reference

1. Read nearby context (see `docs/conventions/agent-workflow.md` for the full checklist).
2. Create or update a task note close to the work.
3. Follow the task-state loop from `AGENTS.md`.
4. On resume, reconcile notes and recent git history before continuing.
