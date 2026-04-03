---
name: start-project
description: Start a new project in this repository using the repo conventions. Use when the user wants to create a new project, prototype, one-off tool, or vibe-coded app under `projects/`, especially when the stack is not predetermined.
---

# Start Project

Use this skill when creating a new project in the `misc` repository.

## Goal

Create a small, self-contained project under `projects/` that fits the user's immediate need without introducing unnecessary shared abstractions.

## Default Approach

1. Read root `README.md` and `AGENTS.md`.
2. Check whether the user wants a brand-new project or a change to an existing one.
3. Create the project under `projects/<name>/` unless the task clearly belongs elsewhere.
4. Keep the project self-contained and let it choose its own language and tooling.
5. For non-trivial setup, create or update a nearby task note such as `projects/<name>/PLAN.md`.
6. Add only the minimum scaffolding needed to make the project runnable and understandable.

## Placement Rules

- Use `projects/` for one-off tools, prototypes, and life-specific utilities.
- Use `workflows/` when the main deliverable is a reusable process.
- Use `mcp/` when the work is primarily an MCP server or MCP-related tool adapter.
- Use `packages/` only when at least two consumers justify shared code.

## Keep It Lightweight

- Do not assume one language, framework, or package manager.
- Do not create shared abstractions before they are needed.
- Do not over-scaffold beyond the user's immediate request.

## Suggested Initial Files

For many new projects, a minimal starting set is enough:

- `README.md`
- `PLAN.md` for non-trivial work
- language-specific manifest or config files only if needed

## Additional Guidance

- Use the `repo-task-state` skill when the work should be recoverable from repo notes and git history.
