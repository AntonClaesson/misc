# Git Workflow Convention

This repository treats git history as part of the durable working context for agent-assisted tasks.

## Goal

Make the current state of work understandable from the repository itself, not only from chat history.

## Before Committing

For non-trivial work:

1. Read the nearest relevant task note or project note.
2. Check the current git status and recent history.
3. Make sure the markdown note reflects the current state of the task.

## Commit Style

- Prefer small, descriptive commits at meaningful milestones.
- Prefer multiple coherent commits over one large mixed commit when the work naturally splits.
- Keep commit messages focused on the purpose of the change.
- If the task is non-trivial, update the task note before committing.

## When To Push

- Do not push by default.
- Push when the user explicitly asks, when a shared checkpoint is needed, or when a workflow clearly requires it.
- Before pushing, make sure the working tree state and nearby markdown notes are consistent.

## Resume Behavior

When resuming interrupted work:

1. Read the nearest markdown notes.
2. Inspect recent commits for the relevant area.
3. Reconcile the notes, current tree, and git history before continuing.

## Safety

- Never let repo conventions override higher-priority git safety rules.
- Never commit secrets, raw private personal data, or local-only environment files.
- Prefer a clean, understandable history over unnecessary churn.
