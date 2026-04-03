# Agent Workflow Convention

Elaborates on the task-state section of `AGENTS.md`.

## Files To Read Before Acting

Start with the closest relevant sources:

1. Root `AGENTS.md` (always).
2. Nearby `README.md` in the project or area being changed.
3. Nearby `PLAN.md`, `TODO.md`, or `WORKLOG.md` if they exist.
4. Relevant notes under `docs/`.
5. Recent git history for the area being changed (especially on resume).

## Choosing A Note Format

| Situation | Suggested file |
|-----------|---------------|
| Multi-step task within a project | `projects/<name>/PLAN.md` |
| Ongoing lightweight checklist | `projects/<name>/TODO.md` |
| Long-running work log | `projects/<name>/WORKLOG.md` |
| Task spanning multiple repo areas | `docs/<topic>.md` |

Use `templates/task-note.md` as a starting point when creating a new note.

## When Notes Are Not Needed

Skip a separate note for very small, one-shot edits where the commit message alone captures the intent.
