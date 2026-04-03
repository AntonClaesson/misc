# 0001: Initial Repo Shape

## Status

Accepted

## Context

This repository starts empty and is intended to support personal, agent-assisted work across many possible languages and frameworks.

The expected near-term use is:

- small one-off projects,
- vibe-coded tools,
- future personal MCP servers,
- reusable skills,
- emerging workflows.

Long-running production-style apps are not a current priority.

## Decision

Use a polyglot-first monorepo organized by purpose rather than runtime.

Top-level areas:

- `projects/`
- `workflows/`
- `mcp/`
- `packages/`
- `templates/`
- `scripts/`
- `docs/`
- `data/`

Agent skills live in `.cursor/skills/`, not as a top-level directory.

## Consequences

- New work can use any language or framework without changing repo-wide assumptions.
- Most new product-like work should begin in `projects/`.
- Shared code should be introduced gradually, only when useful.
- Sensitive personal data should stay outside version control.
- Future agents should use `README.md` and `AGENTS.md` as the first source of guidance.
