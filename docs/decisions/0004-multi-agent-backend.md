# 0004: Multi-Agent Backend Support

## Status

Accepted

## Context

The repo's agent harness was originally built for Cursor Cloud Agents only. Skills lived exclusively in `.cursor/skills/`, workflow docs referenced Cursor-specific paths, and MCP servers (GitHub, Linear) were injected automatically by Cursor's infrastructure.

To reduce token costs and gain flexibility, the user wants to also work with GitHub Copilot CLI locally using the same skills, instructions, and MCP tool access. Future backends (e.g., a self-hosted open-source agent stack) are also planned.

## Decision

Make the agent harness backend-agnostic at its core, with backend-specific sections where needed.

Key changes:

1. **Skills symlink:** `.github/skills/` is a symlink to `../.cursor/skills/`. This lets Copilot CLI (which reads `.github/skills/`) and Cursor (which reads `.cursor/skills/`) use the same skill files without duplication. The canonical location remains `.cursor/skills/` since Cursor was the first backend.

2. **AGENTS.md restructure:** The document now has a generic "Agent Backend Support" section with a table of supported backends, followed by backend-specific subsections (Cursor Cloud, Copilot CLI). Shared guidance (working on projects, lint/test/build) is backend-agnostic.

3. **MCP configuration:** Each backend manages its own MCP server access independently. `.github/mcp.json` is committed with the official Linear MCP server endpoint (OAuth-based, no secrets in the file) for Copilot CLI. GitHub MCP is built into Copilot CLI. Cursor Cloud Agents receive their MCP servers from Cursor's own infrastructure — no repo-level configuration is needed or used.

4. **Copilot instructions:** `.github/copilot-instructions.md` points to `AGENTS.md` as the single source of truth.

5. **Path references generalized:** Skill references in convention docs and other skills no longer include the full `.cursor/skills/` path prefix — they reference skills by name only (e.g., "follow the `pr-review-and-merge` skill").

## Consequences

- New agent backends can be added by creating a new subsection in AGENTS.md and (if needed) additional symlinks or config files.
- The `.github/skills/` symlink requires a Unix-like OS (Linux or macOS). Windows users would need to create a junction or copy.
- Skills remain in one canonical location, reducing the risk of divergence.
- The Linear MCP OAuth flow requires a browser for first-time authentication — this works for local Copilot CLI but not for headless environments.
