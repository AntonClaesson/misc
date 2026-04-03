---
name: start-project
description: Start a new project in this repository using the repo conventions. Use when the user wants to create a new project, prototype, one-off tool, or vibe-coded app under `projects/`, especially when the stack is not predetermined.
---

# Start Project

Use this skill when creating a new project in the `misc` repository.

Placement rules, branch model, and task-state conventions are defined in `AGENTS.md`. This skill adds only the project-creation steps.

## Steps

1. Read `AGENTS.md` (always) and the nearest relevant context.
2. Confirm the user wants a new project, not a change to an existing one.
3. Create a branch for the new project (per the branch model in `AGENTS.md`).
4. Create the project directory under `projects/<name>/`.
5. Add a `README.md` using `templates/project-readme.md` as a starting point.
6. For non-trivial setup, add a `PLAN.md` using `templates/task-note.md`.
7. Add only the minimum scaffolding needed to make the project runnable.

## Placement Quick Reference

| Kind of work | Directory |
|---|---|
| App, tool, prototype, utility | `projects/` |
| Reusable operational process | `workflows/` |
| MCP server or adapter | `mcp/` |
| Shared library (multiple consumers) | `packages/` |
