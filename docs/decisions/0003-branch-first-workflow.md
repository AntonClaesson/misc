# 0003: Branch-First Agent Workflow

## Status

Accepted

## Context

The repo initially had no branching convention. All guidance said "commit to main" and "don't push unless asked." This works for a single session but breaks down when two workstreams run in parallel or when an agent session is interrupted mid-task on main.

## Decision

Treat `main` as the stable, user-reviewed branch. Agents should work on initiative branches by default and merge to `main` only after user verification.

A narrow exception allows trivial, self-contained docs or meta changes to go directly to `main`.

## Consequences

- Parallel work is safe by default.
- User retains a review gate before anything lands on `main`.
- Agents need to create or reuse branches, adding a small amount of ceremony.
- Resume behavior now includes checking which branch the previous work was on.
