# 0003: Branch-First Agent Workflow

## Status

Accepted

## Context

Agents may run multi-step work and in parallel. Direct pushes to `main` increase risk and make review harder. The repo already prefers durable markdown notes and small commits; the branch model should match.

## Decision

Adopt a branch-first workflow:

- `main` is the stable, user-reviewed branch.
- Default: one shared feature branch per initiative (e.g., `feature/<initiative-name>`), where agents push checkpoints.
- Merge to `main` only after user verification.
- Exception: trivial docs/meta changes may go directly to `main` when clearly low-risk and self-contained. Do not use this exception for code or config changes.

## Consequences

- Safer iteration and easier parallelism.
- Clearer review surface for the user.
- Agents resume from the initiative branch, using nearby notes and recent commits.
- Slight overhead to create/use initiative branches, offset by lower risk to `main`.
