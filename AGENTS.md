# Agent Guidance

This repository is a polyglot monorepo for personal, agent-assisted work.
This file is the single source of truth for agent behavior in this repo.

## What Belongs Where

- `projects/`: one-off tools, vibe-coded apps, prototypes, life-specific utilities.
- `workflows/`: reusable operational flows, prompt-driven processes, playbooks.
- `mcp/`: personal MCP servers, tool adapters, MCP-related support code.
- `packages/`: shared libraries or tooling — only when multiple consumers justify it.
- `templates/`: starter scaffolds for recurring project shapes.
- `scripts/`: repo-level helper scripts.
- `docs/`: short notes, decisions, and repo conventions.
- `data/`: non-sensitive sample, derived, or disposable data only.

Agent skills live in `.cursor/skills/`.

## Current Biases

- Prefer small, self-contained projects over shared abstractions.
- Default new app-like work into `projects/`.
- Keep root-level tooling minimal so each project can use its own stack.

## Branch And Git Model

`main` is the stable, user-reviewed branch.

**Default workflow:**

1. Ensure a Linear issue exists for the work (see "Ticket-first gate" below).
2. Create or reuse an initiative branch for the current piece of work.
3. Commit progress to that branch, not directly to `main`.
4. Merge to `main` after self-review (or user review when escalated). See the `pr-review-and-merge` skill.

**Branch protection:** `main` is protected by GitHub rulesets. Force pushes and direct pushes are blocked; all changes must go through a pull request. Never attempt to push directly to `main` or use `--force` on any shared branch.

**Commit style:**

- Prefer small, descriptive commits at meaningful milestones.
- Update the nearest task note before committing non-trivial work.
- Keep commit messages focused on purpose, not mechanics.

**Push policy:**

- Do not push unless the user explicitly asks or the workflow clearly requires it.
- Before pushing, ensure the working tree and nearby markdown notes are consistent.

**Pull requests:**

- When an initiative branch is ready, push and open a PR against `main`.
- After opening, follow the `pr-review-and-merge` skill in `.cursor/skills/` to decide whether to self-merge or escalate to the user.
- **Default: agent self-reviews and merges.** The agent performs a structured self-review (diff audit, test verification, convention compliance) and merges if the change is routine and well-tested.
- **Escalate to the user** when the change is high-risk, destructive, ambiguous, or when the user explicitly requested manual review.
- Use squash merge by default. Use rebase merge when individual commit granularity matters. Merge commits are disabled.
- After a PR is merged, verify via MCP, check out `main`, pull, and delete the initiative branch locally. Keep the remote branch — do not delete it.
- See the `open-pr` skill in `.cursor/skills/` for PR creation steps and MCP tool usage.
- See `docs/conventions/git-workflow.md` for PR content and review conventions.

**Ticket-first gate:**

Every branch must have a corresponding Linear issue. Before creating a branch, the agent must:

1. Search Linear for an existing issue that matches the requested work.
2. If a matching issue exists, use it. If not, create a new issue in the `agentify` project with at least a title, description, and priority.
3. Only then create the branch (including the issue ID in the branch name).

This applies to all work — planned roadmap items and ad-hoc user requests alike. No branch without a ticket.

**Linear integration:**

- The `agentify` project in Linear is the planning and tracking layer for this repo.
- All work must have a corresponding Linear issue. Update issue status as work progresses.
- When multiple agents run in parallel, claim issues before starting work.
- See `docs/conventions/linear-workflow.md` for the full Linear workflow, issue creation guidelines, status mapping, and parallel-agent claiming protocol.

**Resume behavior:**

- Read the nearest markdown notes and inspect recent commits on the initiative branch.
- Reconcile notes with the current tree before making further changes.
- Do not rely on prior chat context alone.

## Task State

For non-trivial work, leave enough state in the repo that a future agent can resume without chat history.

**Default loop:**

1. Read nearby markdown context before making changes.
2. Record a short plan in a nearby markdown file if one does not already exist.
3. Make a small batch of changes.
4. Update the note with progress, decisions, or next steps.
5. Repeat until complete.

**Where to write notes:**

- Prefer notes close to the work (e.g., `projects/<name>/PLAN.md`).
- Use `docs/` only when the task spans multiple areas of the repo.
- Prefer updating an existing note over creating a new one.

**What to capture:** current goal, status, assumptions, decisions, blockers, next steps, related files or commits.

See `docs/conventions/agent-workflow.md` for the full list of files to check and additional detail.

## Project Lifecycle

Every project directory should have a `README.md` that includes at minimum:

- project name and one-line purpose,
- `status`: one of `active`, `done`, `paused`, or `abandoned`,
- how to run it (if applicable),
- stack / key dependencies.

See `templates/project-readme.md` for a starting point.

## Safety

- Never commit secrets, credentials, tokens, or private personal data.
- Treat `.env` files, local exports, and machine-specific artifacts as ignored.
- Prefer sanitized examples over real personal data in version control.

## Decision Summary

- Polyglot-first, purpose-organized monorepo.
- Branch-first workflow; agents self-review and merge by default, escalating to the user for high-risk changes.
- Agent state lives in markdown notes and git history.
- Skills live exclusively in `.cursor/skills/`.

## Cursor Cloud specific instructions

This is a polyglot monorepo. Each project under `projects/` is self-contained with its own stack, dependencies, and dev commands. There are no repo-wide code dependencies.

### Repo-wide tools (baked into VM snapshot)

Obsidian and scrot are installed in the VM snapshot via the update script. They do not need manual installation.

- **Obsidian** — viewer for `projects/kbase/`. Before launching, recreate the vault config as described in `.cursor/skills/kbase-verify/SKILL.md` (Step 1). The `.obsidian/` directory is `.gitignore`d and must be recreated each session.
- Launch: `DISPLAY=:1 obsidian --no-sandbox --disable-gpu &`
- The kbase-ingest and kbase-verify skills in `.cursor/skills/` cover the full kbase workflows.
- **scrot** — used for screenshots during kbase-verify.

### Working on a specific project

Each project is independent. When you start work on a project:

1. Read the project's own `README.md` for stack, dependencies, and run instructions.
2. Install that project's dependencies using its package manager (check for lockfiles: `package-lock.json` → npm, `yarn.lock` → yarn, `pnpm-lock.yaml` → pnpm, `bun.lockb` → bun, `requirements.txt` / `pyproject.toml` → pip/uv, `Cargo.toml` → cargo, `go.mod` → go).
3. Run lint, test, and build commands as documented in that project's README or config files (e.g. `package.json` scripts, `Makefile` targets, `pyproject.toml` scripts).
4. Do not assume repo-wide tooling exists. There is no root `package.json`, `Makefile`, or equivalent.

### Adding a new project's dependencies to the update script

When a new code project is added to the repo and needs dependencies installed on every VM startup, update the VM update script to include that project's install command (guarded so it only runs if the project exists). Example pattern:

```
test -f projects/my-app/package.json && (cd projects/my-app && npm install)
```

Keep the update script minimal and idempotent. Only add dependency-install commands, not service startup or build steps.

### Lint / test / build

- No linter, test runner, or build step exists at the repo level. Each project brings its own.
- For kbase, quality checks are manual: verify wikilinks render, Mermaid diagrams display, and frontmatter is valid per `projects/kbase/SCHEMA.md`.

### Gotchas

- `main` is branch-protected; always work on an initiative branch.
- The `.obsidian/` config is local-only (gitignored) and must be recreated each Cloud Agent session.
- Obsidian may show a "Trust author" dialog on first launch — dismiss it to proceed.
- The VM has `nvm` pre-installed. If a project uses a different Node version manager (e.g. `mise`, `fnm`), disable nvm first.
- For Python projects, prefer `uv` if a `pyproject.toml` is present; fall back to `pip` with `requirements.txt`.
