# Git Workflow Convention

Elaborates on the branch and git model in `AGENTS.md`.

## Branch Naming

Use short, descriptive branch names scoped to the initiative:

- `add-meal-planner`
- `refactor-agent-harness`
- `fix-mcp-auth`

If an initiative has sub-tasks, keep one shared branch as the integration point rather than spawning many feature branches.

## Commit Checklist

Before committing non-trivial work:

1. Read the nearest task note.
2. Check `git status` and recent history.
3. Update the task note to reflect the current state.
4. Stage and commit with a message focused on *why*, not *what*.

## When To Push

Push only when:

- the user explicitly asks,
- a shared checkpoint is needed for collaboration, or
- a workflow (e.g., CI, PR) clearly requires it.

Before pushing, verify that the working tree and nearby notes are consistent.

## Resolving Conflicts

If the initiative branch has diverged from `main`:

1. Prefer rebasing the initiative branch onto `main` for a clean history.
2. If the rebase is complex, merge `main` into the branch instead and note the merge in the task note.
3. Never force-push a shared branch without user confirmation.
