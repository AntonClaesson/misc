---
name: open-pr
description: Open, update, and manage pull requests using the GitHub MCP server. Use when the user asks to open a PR, when an initiative branch is ready for review, or when working with PR reviews and merges.
---

# Open Pull Request

Use this skill when a branch is ready for review, or when the user asks to open, update, or manage a pull request.

All branching and commit rules are in `AGENTS.md`. This skill covers the PR lifecycle specifically.

## Prerequisites

- The GitHub MCP server is available (tools prefixed `github-`).
- Work has been committed to an initiative branch (not `main`).
- The branch has been pushed to the remote. If not, push with `git push -u origin HEAD` before proceeding.

## When To Open A PR

Open a PR when **all** of the following are true:

1. The user explicitly asks, **or** you have completed the agreed-upon scope and the user has pre-approved opening a PR.
2. The branch has at least one meaningful commit beyond `main`.
3. Nearby task notes are up to date.

**Do not** open a PR speculatively. If intent is ambiguous, ask first.

## How To Open

Use `github-create_pull_request` (not shell `gh` commands) to stay within the MCP toolset.

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

## Related
<Link to task note, issue, or prior discussion if applicable>
```

Keep it focused. Do not re-list every commit — the reviewer can see the diff.

### Example call

```
github-create_pull_request
  owner: <repo-owner>
  repo: <repo-name>
  title: "Add meal planner project"
  head: "add-meal-planner"
  base: "main"
  body: |
    ## Summary
    - Scaffold meal planner project under projects/meal-planner
    - Implement recipe parser and weekly plan generator
    - Add README with run instructions

    ## Notes for reviewer
    - Recipe parser uses heuristic matching; may need tuning for edge cases

    ## Related
    - Task note: projects/meal-planner/PLAN.md
```

## After Opening

After opening the PR, follow the `pr-review-and-merge` skill in `.cursor/skills/` to decide whether to self-merge or escalate to the user.

- **Default:** agent self-reviews and merges routine, well-tested changes.
- **Escalate:** share the PR URL with the user for high-risk, destructive, or ambiguous changes, or when the user explicitly requested manual review.
- If the user leaves review comments, address them on the same branch and push.

## Requesting Reviews

- Use `github-request_copilot_review` if the user wants automated feedback before their own review.
- Use `github-update_pull_request` with `reviewers` to request human reviewers when asked.

## Merging

- Follow the `pr-review-and-merge` skill for the full review-and-merge protocol.
- Default to `merge_method: "squash"` for a clean one-commit-per-initiative history.
- Use `merge_method: "rebase"` when the branch has multiple commits worth preserving individually.
- Merge commits are disabled on this repo — do not use `merge_method: "merge"`.

## Post-Merge Cleanup

After a PR is merged (by the agent after self-review, or by the user):

1. Verify the merge using `github-pull_request_read` (method: `get`) — confirm `merged` is `true`.
2. Switch to `main` and pull: `git checkout main && git pull`.
3. Delete the local branch: `git branch -d <branch-name>`.
4. **Keep the remote branch.** Do not delete it — remote branches are preserved for future context and history.

This leaves the workspace on a clean, up-to-date `main` and ready for the next task.

## Other Useful MCP Tools

| Task | Tool |
|------|------|
| Read PR details | `github-pull_request_read` (method: `get`) |
| View PR diff | `github-pull_request_read` (method: `get_diff`) |
| List PR files | `github-pull_request_read` (method: `get_files`) |
| Read review comments | `github-pull_request_read` (method: `get_review_comments`) |
| Check CI status | `github-pull_request_read` (method: `get_check_runs`) |
| Add a PR comment | `github-add_issue_comment` |
| Update PR title/body | `github-update_pull_request` |
| Update branch from main | `github-update_pull_request_branch` |
