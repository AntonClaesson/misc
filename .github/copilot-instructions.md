# Copilot Repository Instructions

Read and follow `AGENTS.md` at the repository root — it is the single source of truth for agent behavior in this repo. It covers directory structure, branching, commits, task state, Linear integration, and all workflow conventions. See the "Copilot CLI specific instructions" section for setup details specific to this backend.

Skills are in `.github/skills/` (symlinked to `.cursor/skills/`). Each skill has a `SKILL.md` with activation criteria and step-by-step instructions.

## MCP Servers

- **GitHub:** Built into Copilot CLI — no additional setup needed.
- **Linear:** Configured in `.github/mcp.json` (auto-loaded by Copilot CLI). Uses the official Linear MCP server with OAuth. On first use you will be prompted to authenticate in your browser.
