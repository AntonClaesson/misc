---
name: open-pr
description: Open, update, and manage pull requests using the GitHub MCP server. Use when the user asks to open a PR, when an initiative branch is ready for review, or when working with PR reviews and merges.
---

# Open Pull Request

Use this skill when a branch is ready for review, or when the user asks to open, update, or manage a pull request.

All branching and commit rules are in `AGENTS.md`. This skill covers the PR lifecycle specifically.

## Prerequisites

- The GitHub MCP server is available (tool names vary by agent backend — use whichever PR creation tool is in your toolset).
- Work has been committed to an initiative branch (not `main`).
- The branch has been pushed to the remote. Per `docs/conventions/git-workflow.md`, agents should already be pushing at checkpoints while work is in progress; if the branch is not on the remote yet, push with `git push -u origin HEAD` before proceeding.

## When To Open A PR

Open a PR when **all** of the following are true:

1. The user explicitly asks, **or** you have completed the agreed-upon scope and the user has pre-approved opening a PR.
2. The branch has at least one meaningful commit beyond `main`.
3. Nearby task notes are up to date.

**Do not** open a PR speculatively. If intent is ambiguous, ask first.

## How To Open

Use the GitHub MCP server's PR creation tool (not shell `gh` commands) to stay within the MCP toolset.

### Preparing the PR

Before calling the tool:

1. Run `git log main..HEAD --oneline` to review what will be included.
2. Run `git diff main...HEAD --stat` to see the file-level summary.
3. Ensure task notes reflect the current state.

### Title

- Concise, matches the initiative purpose.
- Use imperative mood (e.g., "Add meal planner", "Fix MCP auth token refresh").

### Body

Structure the body as:

```
## Summary
<2-4 bullet points explaining what changed and why>

## Notes for reviewer
<Anything the reviewer should pay attention to: open questions, trade-offs, areas of uncertainty>
```

Keep it focused. Do not re-list every commit — the reviewer can see the diff.

### Title — include the Linear issue ID

Always prefix the PR title with the Linear issue ID (e.g., `ANT-7: Add meal planner`). This makes the ticket searchable from the PR list and connects the PR to its planning context.

### Linking to the Linear ticket

The PR should reference its Linear ticket so reviewers can find the planning context. The preferred approaches, in order:

1. **Clickable link in the body** — include a `## Linear issue` section with `[ANT-<number>](https://linear.app/antonclaesson/issue/ANT-<number>)`. This is the ideal format when the tool allows it.
2. **Issue ID in title + body** — if the PR tool strips URLs (Cursor Cloud Agents' `ManagePullRequest` tool blocks `linear.app` URLs), ensure the issue ID appears in the PR title (e.g., `ANT-7: Add meal planner`). The issue ID is searchable in Linear and GitHub.

Regardless of which approach the PR tool allows, the **Ticket→PR link** (added after opening — see below) is always the primary navigable connection.

### Example parameters

Use the GitHub MCP PR creation tool with parameters like:

- **owner / repo:** from the git remote
- **title:** `"ANT-7: Add meal planner project"`
- **head:** `"add-meal-planner"`
- **base:** `"main"`
- **body:** structured summary, reviewer notes, and optionally a `## Linear issue` section with a link to the ticket

> **Note:** If the PR creation tool rejects `linear.app` URLs (as Cursor Cloud Agents do), omit the `## Linear issue` section. The issue ID in the title is sufficient for the PR→Ticket direction. The Ticket→PR link (next step) provides the clickable navigation.

## After Opening

After opening the PR:

### 1. Attach the PR link to the Linear ticket

Use the Linear MCP server's issue update tool to add the PR URL as a link attachment on the corresponding Linear issue. Pass the issue ID (e.g., `ANT-<number>`) and a `links` array with the PR URL and title. This is the most reliable cross-link because it is not subject to PR tool restrictions and makes the ticket directly navigable to its PR from Linear's board view.

### 2. Follow the review-and-merge skill

Follow the `pr-review-and-merge` skill to decide whether to self-merge or escalate to the user.

- **Default:** agent self-reviews and merges routine, well-tested changes.
- **Escalate:** share the PR URL with the user for high-risk, destructive, or ambiguous changes, or when the user explicitly requested manual review.
- If the user leaves review comments, address them on the same branch and push.

## Requesting Reviews

- Use the GitHub MCP tool for requesting a Copilot review if the user wants automated feedback before their own review.
- Use the GitHub MCP tool for updating a PR with `reviewers` to request human reviewers when asked.

## Merging

- Follow the `pr-review-and-merge` skill for the full review-and-merge protocol.
- Default to `merge_method: "squash"` for a clean one-commit-per-initiative history.
- Use `merge_method: "rebase"` when the branch has multiple commits worth preserving individually.
- Merge commits are disabled on this repo — do not use `merge_method: "merge"`.

## Post-Merge Cleanup

After a PR is merged (by the agent after self-review, or by the user):

1. Verify the merge using the GitHub MCP PR read tool — confirm the PR's `merged` status is `true`.
2. Switch to `main` and pull: `git checkout main && git pull`.
3. Delete the local branch: `git branch -d <branch-name>`.
4. **Keep the remote branch.** Do not delete it — remote branches are preserved for future context and history.

This leaves the workspace on a clean, up-to-date `main` and ready for the next task.

## Other Useful MCP Operations

The GitHub MCP server provides tools for these common PR operations. Tool names vary by agent backend — use whichever matching tool is in your available toolset.

| Task | What to look for |
|------|-----------------|
| Read PR details | PR read/get tool |
| View PR diff | PR diff tool |
| List PR files | PR files tool |
| Read review comments | PR review comments tool |
| Check CI status | PR check runs tool |
| Add a PR comment | Issue/PR comment tool |
| Update PR title/body | PR update tool |
| Update branch from main | PR branch update tool |
