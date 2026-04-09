# Git Workflow Convention

Elaborates on the branch and git model in `AGENTS.md`.

## Branch Protection

`main` is protected by GitHub rulesets:

- **Direct pushes blocked** — all changes must go through a pull request.
- **Force pushes blocked** — history cannot be rewritten on `main`.
- **Deletion blocked** — `main` cannot be deleted.

Never attempt to push directly to `main` or use `--force` on any shared branch.

## Merge Methods

Only squash merge and rebase merge are enabled. Merge commits are disabled.

- **Squash merge** (default): use for most initiative branches — produces one clean commit on `main`.
- **Rebase merge**: use when the branch has multiple commits that each stand on their own and the granularity is worth preserving.

When merging via `github-merge_pull_request`, pass `merge_method: "squash"` (default) or `merge_method: "rebase"`.

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
- Use squash merge by default; rebase merge when commit granularity matters. Merge commits are disabled.

See the `open-pr` skill in `.cursor/skills/` for the full step-by-step workflow and MCP tool reference.

### Post-Merge Cleanup

Once a PR is merged:

1. Verify the merge via `github-pull_request_read` (method: `get`).
2. Check out `main` and pull the latest.
3. Delete the initiative branch locally.
4. **Keep the remote branch** — do not delete it. Remote branches are preserved for future context and history.

This keeps the workspace clean and ready for the next task.

## Resolving Conflicts

If the initiative branch has diverged from `main`:

1. Prefer rebasing the initiative branch onto `main` for a clean history.
2. If the rebase is complex, merge `main` into the branch instead and note the merge in the task note.
3. Never force-push a shared branch. Force pushes to `main` are blocked by branch protection.
