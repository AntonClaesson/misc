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

## Pull Requests

Use the GitHub MCP tools (`github-create_pull_request`, `github-pull_request_read`, etc.) for all PR operations rather than shell commands.

### When To Open

- The user explicitly asks for a PR.
- The initiative branch is complete and the user has pre-approved opening PRs.
- A workflow step (CI, deploy) requires a PR as the trigger.

Do not open a PR speculatively. If intent is ambiguous, confirm with the user first.

### PR Content

- **Title:** concise, imperative mood, matches the initiative purpose (e.g., "Add meal planner").
- **Body:** short summary of what changed and why, notes for the reviewer, link to the task note if one exists. Avoid re-listing every commit.

### After Opening

- Share the PR URL with the user.
- Wait for review feedback before pushing additional changes unless asked to iterate.
- Address review comments on the same branch and push.
- Never merge without explicit user approval.
- Prefer squash merge for single-initiative branches unless the user specifies otherwise.

See the `open-pr` skill in `.cursor/skills/` for the full step-by-step workflow and MCP tool reference.

## Resolving Conflicts

If the initiative branch has diverged from `main`:

1. Prefer rebasing the initiative branch onto `main` for a clean history.
2. If the rebase is complex, merge `main` into the branch instead and note the merge in the task note.
3. Never force-push a shared branch without user confirmation.
