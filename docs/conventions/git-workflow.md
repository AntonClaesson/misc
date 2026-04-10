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

Include the Linear issue ID in the branch name (per the ticket-first gate). Use short, descriptive names scoped to the initiative:

- `ant-5-add-meal-planner`
- `ant-12-refactor-agent-harness`
- `ant-7-fix-mcp-auth`

If an initiative has sub-tasks, keep one shared branch as the integration point rather than spawning many feature branches.

## Commit Checklist

Before committing non-trivial work:

1. Read the nearest task note.
2. Check `git status` and recent history.
3. Update the task note to reflect the current state.
4. Stage and commit with a message focused on *why*, not *what*.

## When To Push

The remote initiative branch should reflect **committed** progress so others can follow the work on GitHub without waiting for a PR.

Push to `origin` when **any** of these checkpoints is met:

1. **First meaningful commit** on the branch — establish the remote tracking branch early (`git push -u origin <branch>`).
2. **Each subsequent milestone** — after a coherent batch of commits (feature slice, fix, or doc update) that you would be comfortable showing as work-in-progress.
3. **Task note updates** — when you update PLAN.md / TODO.md / WORKLOG.md for a visible milestone, push the commits that go with that note in the same step.
4. **Before PR operations** — opening a PR, updating a PR branch from `main`, or pushing review feedback always implies a push; the branch should already be current from ongoing checkpoints.
5. **End of an agent turn** — if the session produced commits that are not yet on the remote, push before stopping so progress is not stranded locally.

Also push when the user asks or when CI, deploy previews, or another automation needs the remote branch.

**Do not** push instead of committing: commit first, then push. Avoid force-pushing shared initiative branches.

Before every push, verify that the working tree and nearby notes are consistent.

## Pull Requests

Use the GitHub MCP tools (`github-create_pull_request`, `github-pull_request_read`, etc.) for all PR operations rather than shell commands.

### When To Open

- The user explicitly asks for a PR.
- The initiative branch is complete and the user has pre-approved opening PRs.
- A workflow step (CI, deploy) requires a PR as the trigger.

Do not open a PR speculatively. If intent is ambiguous, confirm with the user first.

### PR Content

- **Title:** concise, imperative mood, prefixed with the Linear issue ID (e.g., `ANT-7: Add meal planner`). The issue ID in the title makes the PR searchable from Linear and vice versa.
- **Body:** short summary of what changed and why, plus notes for the reviewer. Include a `## Linear issue` section with a clickable link to the ticket when the PR tool allows it. If the tool strips URLs (e.g., Cursor Cloud Agents), the issue ID in the title is sufficient. Avoid re-listing every commit.
- **Ticket→PR link:** after opening the PR, attach the PR URL as a link on the Linear ticket using `Linear-save_issue`. This is the most reliable cross-link and enables one-click navigation from Linear's board view to the PR.

### After Opening

- Follow the `pr-review-and-merge` skill in `.cursor/skills/` to determine whether to self-merge or escalate.
- **Default: agent self-reviews and merges** routine, well-tested changes.
- **Escalate to the user** for high-risk, destructive, or ambiguous changes, or when the user explicitly requested manual review.
- If escalating, share the PR URL with the user and wait for review feedback.
- Address review comments on the same branch and push.
- Use squash merge by default; rebase merge when commit granularity matters. Merge commits are disabled.

See the `open-pr` skill for PR creation and the `pr-review-and-merge` skill for the full review and merge protocol.

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
