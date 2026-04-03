# Agent Harness Review

Status: reviewed and addressed, April 2026

## Scope

Thorough review of the repo's agent-first operating harness. Original review performed
at commit `5b64fae`. All identified issues have been addressed in a subsequent refactor.

## Issues Found And Resolutions

### 1. Guidance duplicated across five surfaces — RESOLVED

The same instructions were repeated in `AGENTS.md`, `agent-workflow.md`, `git-workflow.md`,
and both Cursor skills. This caused drift risk, token waste, and ambiguity about authority.

**Fix:** Established `AGENTS.md` as the single source of truth. Convention docs now
elaborate on specific topics without repeating core rules. Skills contain only their
unique activation logic and point to `AGENTS.md` for shared behavior.

### 2. `README.md` and `AGENTS.md` overlapped heavily — RESOLVED

Both files described repo structure, working principles, and agent operating model.

**Fix:** `README.md` is now the human-oriented quick orientation. `AGENTS.md` is the
agent operating manual. Overlap is minimal (one cross-reference).

### 3. No branching strategy was active — RESOLVED

The branch-first plan existed in `.cursor/plans/` but had not been applied to any
guidance surface.

**Fix:** Branch-first workflow is now defined in `AGENTS.md` and elaborated in
`docs/conventions/git-workflow.md`. Decision recorded in `docs/decisions/0003-branch-first-workflow.md`.

### 4. `skills/` vs `.cursor/skills/` was confusing — RESOLVED

A top-level `skills/` directory existed with no concrete use case, overlapping with
`.cursor/skills/` where Cursor-discoverable skills actually live.

**Fix:** Removed top-level `skills/` directory. `AGENTS.md` and decision records updated
to reflect that skills live exclusively in `.cursor/skills/`.

### 5. No project lifecycle convention — RESOLVED

No convention existed for signaling whether a project is active, done, or abandoned.

**Fix:** `AGENTS.md` now requires a `status` field in every project `README.md`.
A `templates/project-readme.md` template enforces this.

### 6. No project-README template — RESOLVED

Task-note template existed but no convention for project READMEs.

**Fix:** Added `templates/project-readme.md` with fields for name, status, how to run,
stack, and notes.

## What Was Already Good (Unchanged)

- Clear placement taxonomy across top-level directories.
- Read-before-write culture reinforced at every guidance surface.
- Lightweight-by-design philosophy.
- Early decision records.
- Reasonable safety rails and `.gitignore`.
- Task-note template.

## Remaining Future Considerations

- **Harness-lint script:** A script in `scripts/` that checks structural invariants
  (every top-level dir has a README, no orphaned references, etc.) would catch drift.
  Not urgent until the repo has more content.
- **Per-project conventions:** `.cursor/rules/` files with glob patterns could enforce
  per-language norms once real projects land. Not needed yet.
