# 0002: Agent State And Git History

## Status

Accepted

## Context

This repository is intended to support agent-assisted work that may span multiple sessions or be resumed by different agents.

Relying on chat history alone is fragile. The repository itself should preserve enough state for future agents to understand ongoing work.

## Decision

Use markdown notes and git history as the primary durable task record for non-trivial work.

This means:

- agents should read existing notes before starting,
- agents should write concise plans and progress updates into markdown files during multi-step work,
- git history should be kept understandable and used as part of resume context,
- pushing to remote should be intentional rather than automatic.

## Consequences

- Interrupted work becomes easier to resume.
- Future agents can recover context from the tree itself.
- The repo gains lightweight operational memory without requiring heavy process tooling.
- Agents should favor concise notes and meaningful commits over elaborate status systems.
