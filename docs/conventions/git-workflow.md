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

## Branch Strategy And When To Push

- `main` is the stable, user-reviewed branch.
- Default: create or reuse one shared feature branch per initiative (e.g., `feature/<initiative-name>`) and push work there.
- Merge to `main` only after user verification.
- Exception: trivial docs/meta updates may go directly to `main` when clearly low-risk and self-contained (e.g., typo fixes in `README.md`, non-controversial decision note updates). Do not use this exception for code or config changes.
- Before any push, make sure the working tree and nearby markdown notes reflect the same state.

## Resume Behavior

When resuming interrupted work:

1. Read the nearest markdown notes.
2. Inspect recent commits for the relevant area.
3. Reconcile the notes, current tree, and git history before continuing.

## Safety

- Never let repo conventions override higher-priority git safety rules.
- Never commit secrets, raw private personal data, or local-only environment files.
- Prefer a clean, understandable history over unnecessary churn.
