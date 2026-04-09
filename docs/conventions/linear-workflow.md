# Linear Workflow Convention

How the `agentify` Linear project connects to this repo and how agents should use Linear when planning and executing work.

This doc layers on top of the existing conventions:

- `AGENTS.md` — top-level agent behavior and repo structure.
- `docs/conventions/git-workflow.md` — branching, commits, PRs, and merges.
- `docs/conventions/agent-workflow.md` — task notes and file-level state.

When in doubt, the repo-level conventions take precedence for git operations. Linear is the planning and tracking layer.

## How Linear Maps to the Repo

The **agentify** project in Linear is the control plane for this repo. All non-trivial work in the repo should be represented as a Linear issue under that project.

Linear hierarchy:

- **Project** (`agentify`) — maps to this repo as a whole.
- **Milestones** — phases or themed groupings (e.g., "Basic Setup", "First Tools"). Use when several issues share a goal or deadline. Skip for standalone tasks.
- **Issues** — the unit of work. One issue = one scoped deliverable = one branch + one PR.

## Issue Lifecycle

### Statuses

The Antonclaesson team uses these statuses. Keep them in sync with the actual git state:

| Status | Meaning | Git state |
|---|---|---|
| **Backlog** | Planned, not yet ready to start. | No branch. |
| **Todo** | Scoped and ready to be picked up. | No branch. |
| **In Progress** | Actively being worked on. | Branch exists, commits in flight. |
| **In Review** | PR open, awaiting review. | PR open against `main`. |
| **Done** | Merged. Work is on `main`. | PR merged, branch deleted. |
| **Canceled** | Dropped or superseded. | Branch deleted if one existed. |

### Status Transitions

Agents must update statuses as work progresses, not just at the end:

1. **Backlog → Todo** — when the issue is scoped, described, and ready for work.
2. **Todo → In Progress** — when an agent (or human) starts working. This is the claim (see "Parallel Agents" below).
3. **In Progress → In Review** — when a PR is opened.
4. **In Review → Done** — after the PR is merged (either by the agent after self-review, or by the user after manual review).
5. **Any → Canceled** — when the work is no longer needed.

## Ticket-First Gate

**Every branch must have a corresponding Linear issue.** Before creating a branch, the agent must:

1. **Search for an existing issue.** Use the Linear MCP tools to list or search issues in the `agentify` project that match the work being requested. Check titles, descriptions, and status.
2. **Reuse if found.** If a matching issue exists (in any non-Done/Canceled state), adopt it. Move it to In Progress and proceed.
3. **Create if not found.** If no matching issue exists, create one in the `agentify` project before writing any code. The new issue must include at minimum:
   - A clear title describing the deliverable.
   - A description that captures what needs to happen, where in the repo, and acceptance criteria.
   - Priority (default to Normal / 3 unless context dictates otherwise).
   - Assignment to the current agent or user (use `"me"`).
4. **Then create the branch**, including the issue ID in the branch name (e.g., `ant-13-enforce-ticket-first`).

This gate applies to **all work** — planned roadmap items, ad-hoc user requests, bug fixes, documentation changes, and refactors. The only exception is trivially small fixes (e.g., a one-line typo correction) where the commit message alone captures full intent; even then, prefer creating a ticket.

**Rationale:** Without this gate, ad-hoc agent work can land in `main` via PRs that have no corresponding Linear record. This breaks traceability and makes it impossible to audit what was done and why through Linear alone.

## Creating Issues

### When to create

- **Always** — per the ticket-first gate above, every branch must have a corresponding issue.
- Markdown task notes (PLAN.md, TODO.md) remain useful for in-flight scratch state, but Linear is the source of truth for what work exists and its status.

### How to scope

- **One issue per deliverable.** "Build meal planner CLI" is good. "Build various tools" is too broad.
- If a task is too large for one agent session, break it into sub-issues before starting.

### What to include in the description

Write descriptions that let another agent pick up the work cold:

- What needs to happen.
- Where in the repo (which directories, files, or areas).
- Constraints, dependencies, or open questions.
- Acceptance criteria if applicable.

### Priority

Use Linear's scale. Default to Normal unless there's a clear reason otherwise:

| Value | Label |
|---|---|
| 1 | Urgent |
| 2 | High |
| 3 | Normal |
| 4 | Low |

### Milestones

- Assign to a milestone when the work belongs to a known phase.
- If no milestone fits, leave the issue unassigned to any milestone.
- Do not create milestones speculatively. Milestones should represent intentional phases with a clear scope.

### Labels

Use labels when they help with filtering or categorization, but don't over-tag. Keep the label set small and meaningful.

## Parallel Agents and Issue Claiming

Multiple Cloud Agents may run concurrently against this repo. The following protocol prevents two agents from working on the same issue.

### Claiming Protocol

Before starting work on any issue, an agent MUST:

1. **Read the issue status from Linear.** If it is `In Progress`, `In Review`, or `Done`, stop — another agent or human owns it.
2. **Check if a branch already exists** for the issue on the remote:
   ```
   git ls-remote --heads origin '*ant-<number>*'
   ```
   If a matching branch exists, the issue is claimed. Back off.
3. **Move the issue to In Progress immediately** — before creating a branch or writing any code. This is the claim.
4. **Only then** create the branch and begin work.

### Race Conditions

Two agents could both read "Todo" before either writes "In Progress." The branch-existence check (step 2) is the secondary guard — only one agent can successfully push a given branch name. If a push fails because the branch already exists on the remote:

- Revert the status change if this agent was the one that made it.
- Abandon the work and report the conflict to the user.

### Best Practice: User-Assigned Work

The safest approach for parallel agents is explicit assignment. When launching multiple agents, tell each one which issue to work on:

- "Work on ANT-5"
- "Work on ANT-6"

This eliminates the race entirely. Agents self-selecting from the backlog is a fallback, not the default.

### One Issue, One Agent

Never have two agents collaborating on the same issue. If the work is too large, break it into sub-issues first, each independently claimable.

## Referencing Linear Issues in Git

- Include the Linear issue ID (e.g., `ANT-5`) in branch names, commit messages, and PR descriptions.
- Linear auto-generates a suggested branch name per issue (e.g., `antonclaesson/ant-5-document-linear-workflow`). Agents may use this or follow the repo's branch naming convention, but should include the issue ID either way.
- The issue ID in branch names also supports the parallel-agent branch-existence check described above.

### Example

For issue ANT-12 "Add weather dashboard":

- Branch: `ant-12-weather-dashboard` or `antonclaesson/ant-12-add-weather-dashboard`
- Commit: `ANT-12: scaffold weather dashboard project`
- PR title: `ANT-12: Add weather dashboard`
- PR body references: `Related: [ANT-12](https://linear.app/antonclaesson/issue/ANT-12)`

## End-to-End Workflow

Putting it all together — from task to merged code:

1. **Ensure a Linear issue exists** — search `agentify` for a matching issue. If none exists, create one (see "Ticket-first gate" above).
2. **Agent claims the issue**: reads status, checks for existing branch, moves to In Progress.
3. **Agent creates a branch** with the issue ID in the name.
4. **Agent does the work**: commits, updates task notes if applicable.
5. **Agent opens a PR** and moves the issue to In Review.
6. **Agent follows the `pr-review-and-merge` skill** to self-review and merge (default) or escalate to the user for high-risk changes.
7. **If escalated:** user reviews, agent addresses feedback, user approves merge.
8. **After merge:** agent (or user) moves the issue to Done.
9. **Cleanup**: branch deleted locally; remote branch preserved.

This keeps Linear, GitHub, and the repo in sync at every step.
