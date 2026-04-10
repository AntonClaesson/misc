# Open Agent Backend — Architecture Plan

## Goal

Build a self-hosted, open-source agent backend that can serve as an alternative to Cursor Cloud Agents. The system should provide a chat interface for interacting with coding agents, support open-source and commercial LLMs, integrate with GitHub and Linear via MCP servers, and handle credentials securely in a public repo.

## Context

The current agent harness uses Cursor Cloud Agents exclusively. Cursor provides:
- Chat UI (web-based)
- Model access (Claude, GPT, etc. — paid via Cursor subscription)
- MCP server hosting (GitHub, Linear — injected automatically)
- VM-based sandboxed execution with computer use
- Screenshot/video verification of agent work

This works well but creates a single-vendor dependency and incurs significant token costs. The open-source backend should provide optionality — not replace Cursor entirely, but allow cheaper, more flexible agent interactions for many tasks.

### Design philosophy

**Tracer bullet first.** Get the minimal end-to-end system working (chat → model → tool use → result) before polishing any individual layer. Each milestone should produce a runnable system.

---

## Architecture Decisions

### Decision 1: Chat UI

The chat UI is what the user interacts with. It needs to support multi-turn conversations, tool/function calling visibility, and ideally agent-style interactions.

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **LibreChat** (35K stars) | Native MCP support; built-in agent framework; multi-provider endpoints; Docker Compose deployment; OAuth/LDAP auth; code interpreter; active development | Heavier stack (MongoDB + Meilisearch); more opinionated architecture |
| **Open WebUI** (127K stars) | Largest community; MCP support via mcpo proxy; pipeline architecture; simpler initial setup; Ollama-native | MCP support is indirect (via proxy); agent capabilities less mature; less enterprise auth |
| **Custom UI** | Full control; exactly what we need | Massive effort; reinventing solved problems; maintenance burden |

#### Recommendation

**LibreChat.** It has first-class MCP support, a built-in agent framework that can orchestrate tool calls, multi-provider model configuration, and solid auth. Open WebUI has a larger community but its MCP integration is indirect and its agent capabilities are less developed. A custom UI is not worth the effort given the maturity of these options.

**Status:** Awaiting user decision.

---

### Decision 2: Model Routing / LLM Access

How the system accesses LLMs — both commercial APIs and local/self-hosted models.

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **OpenRouter** (managed SaaS) | 5-min setup; 300+ models; free tier available; no infra to manage | 5.5% markup; all prompts pass through their servers; no local model support natively |
| **LiteLLM** (self-hosted proxy) | Open-source; no markup (pay provider prices only); full data control; supports 100+ providers + Ollama local models; caching, logging, rate limiting | More setup (15-30 min); you manage the proxy; production scaling is on you |
| **Direct provider endpoints** | Simplest; no intermediary; LibreChat has native multi-provider support | No unified routing, logging, or fallback; managing many API keys in config |
| **Hybrid: LiteLLM + OpenRouter fallback** | Best of both; local models via LiteLLM, exotic models via OpenRouter when needed | More complex config; two systems to understand |

#### Recommendation

**Start with LiteLLM** for the tracer bullet. It's open-source, self-hosted (aligns with our goals), supports Ollama for local models AND commercial APIs, and adds no markup. LibreChat has native LiteLLM integration via Docker Compose. OpenRouter can be added later as an additional endpoint if needed for specific models.

If the user prefers minimal setup and doesn't mind the 5.5% markup, OpenRouter is a valid simpler alternative for the initial pass. Both can coexist.

**Status:** Awaiting user decision.

---

### Decision 3: MCP Server Hosting (GitHub + Linear)

In Cursor, GitHub and Linear MCP servers are injected automatically. When self-hosting, we need to run these ourselves and connect them to the chat UI.

#### Approach

This is less of a choice and more of an implementation detail — we need self-hosted MCP servers regardless of other decisions:

- **GitHub MCP:** Official server at `github/github-mcp-server` (MIT license). Run via Docker or npx. Requires a GitHub Personal Access Token (PAT).
- **Linear MCP:** Official MCP server available. Also community options like `locomotive-agency/linear-mcp` with production-grade rate limiting. Requires a Linear API key.

Both servers communicate via stdio or HTTP/SSE. LibreChat can connect to them directly as MCP servers. Open WebUI would need the mcpo proxy bridge.

#### Security model

Since the repo is public, credentials must never be committed:
- API keys stored in `.env` files (gitignored)
- Docker secrets or environment variables for production
- Document the required keys in README without values
- Provide `.env.example` with placeholder values

#### Recommendation

Use official MCP servers (GitHub, Linear) run as Docker containers alongside LibreChat. Credentials via `.env` files and Docker environment variables. This is straightforward and well-documented.

**Status:** No decision needed — implementation detail. Proceed as described.

---

### Decision 4: Agent Framework / Tool Orchestration

How the system orchestrates multi-step agent workflows (read files, edit code, run commands, etc.).

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **LibreChat built-in agents** | Zero additional infrastructure; configure via UI; native MCP tool access; code interpreter built-in | Less customizable than a standalone framework; tied to LibreChat's agent abstraction |
| **fast-agent** (Python framework) | Sophisticated MCP support; CLI-first; multi-provider; composable agent patterns | Separate process; need to integrate with chat UI; Python dependency |
| **mcp-agent** (Python framework) | Anthropic's agent patterns; durable execution via Temporal; full MCP lifecycle | Heavier; Temporal dependency for production; more suited to backend workflows |
| **Custom agent layer** | Full control over tool orchestration, prompts, retry logic | Significant development effort; maintenance burden |

#### Recommendation

**Start with LibreChat's built-in agent framework** for the tracer bullet. It already integrates with MCP servers and supports tool calling. This gets us to an end-to-end working system fastest. If we hit limitations (e.g., need more sophisticated multi-step planning, custom tool orchestration), we can introduce a dedicated agent framework later.

**Status:** Awaiting user decision.

---

### Decision 5: Execution Environment

How the agent executes code, edits files, and runs commands. In Cursor, this happens inside a sandboxed VM.

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **LibreChat code interpreter** | Built-in; sandboxed (Python, Node.js, Go, etc.); no extra setup | Limited to what LibreChat supports; may not match Cursor's full file-system access |
| **Docker sandbox per session** | Full isolation; can mount repo volumes; install any tools | More infrastructure; container orchestration needed |
| **Direct host execution** (development mode) | Simplest; agent runs commands on the host | No isolation; risky for untrusted code; fine for personal use |
| **Defer** (focus on chat + tool calling first) | Fastest to first working system | Code execution comes later |

#### Recommendation

**Defer full sandboxed execution for the tracer bullet.** Focus on getting chat → model → MCP tool calls (GitHub, Linear) working first. LibreChat's code interpreter provides basic execution. Full Docker-sandboxed execution with repo access can be a later milestone.

For personal use on a local machine, direct host execution is acceptable for the initial version — the user is the only operator.

**Status:** Awaiting user decision.

---

### Decision 6: Deployment Model

Where and how the system runs.

#### Options

| Option | Pros | Cons |
|--------|------|------|
| **Local Docker Compose** | Simple; everything on one machine; fast iteration; no cloud costs | Only accessible from local machine; need decent hardware for local models |
| **Cloud VM (e.g., Hetzner, DigitalOcean)** | Accessible anywhere; can run GPU instances for local models | Monthly cost; more ops; network security considerations |
| **Hybrid** (local dev, cloud for persistent) | Best flexibility; develop locally, deploy to cloud when stable | Two environments to maintain |

#### Recommendation

**Start with local Docker Compose.** This is the simplest path to a working system, keeps costs at zero, and is perfect for personal use. Cloud deployment can be added as a later milestone if remote access is desired.

**Status:** Awaiting user decision.

---

## Milestone Structure

Based on the tracer-bullet approach, the work breaks into progressive milestones:

### Milestone: Open Agent v0 — Tracer Bullet

Get a minimal end-to-end system running: chat UI → model → tool calls → results visible in chat. No polish, just proof of concept.

**Scope:**
1. Docker Compose stack: LibreChat + MongoDB + LiteLLM proxy
2. LiteLLM configured with at least one model (e.g., OpenRouter free tier or local Ollama)
3. GitHub MCP server running in Docker, connected to LibreChat
4. Linear MCP server running in Docker, connected to LibreChat
5. Credential management via `.env` (gitignored) with `.env.example` committed
6. Basic agent configured in LibreChat that can use GitHub + Linear tools
7. README with setup instructions
8. End-to-end test: ask the agent to read a GitHub repo file or list Linear issues

### Future milestones (not detailed yet)

- **v1 — Local models:** Ollama integration for running open-source models locally
- **v2 — Agent refinement:** Custom system prompts, repo-aware context, multi-step workflows
- **v3 — Code execution:** Sandboxed execution environment for file edits and command running
- **v4 — Parity features:** Computer use equivalent, screenshot verification, artifact handling

---

## Ticket Breakdown (v0 Tracer Bullet)

Each ticket = one issue = one branch = one PR, per repo conventions.

All tickets are in the **"Open Agent v0 — Tracer Bullet"** milestone in Linear.

| Order | Ticket | Title | Priority | Depends on |
|-------|--------|-------|----------|------------|
| 1 | ANT-22 | Scaffold open-agent project structure | High | ANT-18 (decisions) |
| 2 | ANT-21 | Set up LibreChat via Docker Compose | High | ANT-22 |
| 3 | ANT-20 | Add LiteLLM proxy to the Docker Compose stack | High | ANT-21 |
| 4 | ANT-19 | Add GitHub MCP server to the stack | Medium | ANT-21 |
| 5 | ANT-23 | Add Linear MCP server to the stack | Medium | ANT-21 |
| 6 | ANT-24 | Configure a basic LibreChat agent with GitHub + Linear tools | Medium | ANT-19, ANT-20, ANT-23 |
| 7 | ANT-25 | Document setup and run end-to-end validation | Medium | All above |

Tickets 3–5 can be worked on in parallel once LibreChat is running (ANT-21).

---

## Decisions Log

| # | Decision | Choice | Date | Rationale |
|---|----------|--------|------|-----------|
| — | All decisions | Pending | 2026-04-09 | Awaiting user input on recommendations above |

---

## Blockers

- Architecture decisions need user sign-off before implementation can begin.

## Next Steps

1. User reviews and decides on each of the 6 architecture decisions above.
2. Once decisions are made, create the Linear milestone and individual tickets.
3. First implementing agent picks up ticket #1 (scaffold).
