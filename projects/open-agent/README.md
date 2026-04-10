# Open Agent

Self-hosted, open-source agent backend — an alternative to Cursor Cloud Agents for interacting with coding agents via a chat UI, using open-source or commercial LLMs, with self-hosted MCP tool integration.

## Status

`active`

## How To Run

Not yet implemented. See `PLAN.md` for architecture decisions and implementation roadmap.

## Stack

**Decided:**
- TBD — see PLAN.md for architecture options awaiting user decisions.

**Under consideration:**
- Chat UI: LibreChat or Open WebUI
- Model routing: LiteLLM (self-hosted proxy) or OpenRouter (managed SaaS)
- MCP servers: official GitHub MCP server, Linear MCP server (self-hosted via npm/Docker)
- Agent framework: TBD — LibreChat agents, or custom agent layer

## Notes

- Companion to the existing Cursor-based agent workflow defined in `AGENTS.md`.
- Designed to reduce token costs by using open-source models where appropriate.
- Must handle credentials securely — this repo is public.
- Linear issue: [ANT-18](https://linear.app/antonclaesson/issue/ANT-18)
