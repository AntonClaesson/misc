# misc

Polyglot monorepo for personal, agent-assisted projects, MCPs, and workflows.

## Structure

```text
misc/
├─ projects/   # one-off apps, prototypes, life-specific tools
├─ workflows/  # reusable agent/human workflows and playbooks
├─ mcp/        # personal MCP servers and support code
├─ packages/   # shared code (only when justified by multiple consumers)
├─ templates/  # starter scaffolds for recurring shapes
├─ scripts/    # repo-level helper scripts
├─ docs/       # architecture notes, decisions, conventions
└─ data/       # non-sensitive sample/derived data only
```

## How It Works

- Each project is self-contained and may use any language or framework.
- Most new work starts in `projects/`.
- Agent-facing conventions live in `AGENTS.md`; humans can read it too, but `README.md` is the quick orientation.
- Agents preserve task state in markdown notes so interrupted work can be resumed.
- `main` is the stable branch; work happens on initiative branches and merges after review.

## Getting Started

1. Look through `projects/` for existing work.
2. To start something new, create a directory under `projects/` with a `README.md` (see `templates/project-readme.md`).
3. For non-trivial work, add a `PLAN.md` (see `templates/task-note.md`).
4. Work on a branch; merge to `main` when ready.

## For Agents

See `AGENTS.md` for the full operating model, and `docs/conventions/` for elaboration on specific topics.
