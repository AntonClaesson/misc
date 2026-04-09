---
name: repo-health-check
description: Audit repo workflow instructions, conventions, skills, and project metadata for consistency and staleness, then fix issues or report all clean. Use periodically to reduce technical debt that accumulates across many agent sessions.
---

# Repo Health Check

Use this skill to audit the repo for workflow inconsistencies, stale artifacts, and drift between docs — then fix what matters and skip what doesn't. This is intended to be run periodically (e.g., after several unrelated agent sessions) to catch the low-grade technical debt that no single task is responsible for.

## When To Use

- The user explicitly asks for a health check or repo audit.
- You notice inconsistencies while working on an unrelated task and want to clean them up.
- After a burst of several agent sessions that touched different areas.

## Philosophy

**Fix things that provide lasting benefit. Skip everything else.**

This skill is not about perfection — it's about catching real problems that will confuse future agents or humans. Cosmetic tweaks, reformatting, and subjective style preferences are explicitly out of scope.

---

## What To Skip

Do NOT fix or flag any of the following:

- Minor wording or formatting differences that don't change meaning.
- Missing periods, inconsistent bullet styles, or markdown formatting preferences.
- Files that are correct but could be "better organized."
- Hypothetical future problems that don't affect current functionality.
- Changes to project code, logic, or features — this skill only audits workflow/meta files.

If a check turns up nothing, move on. If the entire audit is clean, report "all clean" and make no changes.

---

## Audit Protocol

Work through each check category in order. For each, note findings as one of:

- **Fix** — a real inconsistency or stale artifact that should be corrected.
- **Skip** — something imperfect but not worth changing.
- **Clean** — no issues found.

### Check 1: Cross-Reference Consistency

Verify that `AGENTS.md`, the three convention docs, and all skills agree on key workflow rules.

**What to compare:**

| Rule | Sources that must agree |
|------|------------------------|
| Default merge policy | `AGENTS.md`, `git-workflow.md`, `open-pr/SKILL.md`, `pr-review-and-merge/SKILL.md` |
| Ticket-first gate | `AGENTS.md`, `linear-workflow.md`, `agent-workflow.md` |
| Branch naming convention | `AGENTS.md`, `git-workflow.md`, `linear-workflow.md` |
| PR content format | `open-pr/SKILL.md`, `git-workflow.md` |
| Post-merge cleanup | `AGENTS.md`, `git-workflow.md`, `open-pr/SKILL.md`, `pr-review-and-merge/SKILL.md` |
| Linear status transitions | `linear-workflow.md`, `pr-review-and-merge/SKILL.md` |
| Task note conventions | `AGENTS.md`, `agent-workflow.md`, `repo-task-state/SKILL.md` |

**How to check:**

1. Read each source for the rule.
2. Compare the stated policy, terminology, and steps.
3. Flag contradictions or stale references. Ignore minor wording differences.

**How to fix:** Update the less-authoritative source to match the more-authoritative one. Authority order: `AGENTS.md` > convention docs > skills.

### Check 2: Stale Task Notes

Look for `PLAN.md`, `TODO.md`, and `WORKLOG.md` files that were left behind after work completed.

**How to check:**

1. Search for these files anywhere in the repo.
2. For each found file, check whether the associated work is done:
   - Is the related Linear issue in Done or Canceled status?
   - Has the related branch been merged?
   - Does the note describe work that is clearly finished?
3. If the work is done and the note adds no lasting reference value, it's stale.

**How to fix:** Delete stale task notes. If a note contains decisions or context worth preserving, move the relevant content to the project's README or a doc under `docs/` before deleting.

**Skip:** Notes for in-progress or paused work. Notes that serve as ongoing reference (e.g., a PLAN.md that doubles as architecture documentation).

### Check 3: Project README Accuracy

Verify that every project under `projects/` has a README with correct metadata.

**How to check:**

For each directory directly under `projects/`:

1. Confirm a `README.md` exists.
2. Verify the `status` field matches reality:
   - `active` — the project is being worked on or maintained.
   - `done` — the project is complete and not expected to change.
   - `paused` — work has stopped but may resume.
   - `abandoned` — the project is no longer relevant.
3. Verify "how to run" instructions still work (if the project has runnable code, check that the documented commands and dependencies are plausible).
4. Verify the stack/dependencies list is current (compare against lockfiles, `Cargo.toml`, `pyproject.toml`, etc.).

**How to fix:** Update incorrect status fields, add missing READMEs using `templates/project-readme.md`, and correct stale run instructions.

**Skip:** Minor README improvements that don't affect correctness.

### Check 4: Skill Freshness

Verify that all skills under `.cursor/skills/` reference current conventions and tools.

**How to check:**

For each `SKILL.md`:

1. Read the skill and list every reference to other files, tools, or conventions.
2. Verify each reference still exists and is current.
3. Check that procedural steps align with the latest `AGENTS.md` and convention docs (e.g., does the skill still say "never merge without user approval" when the convention has changed?).
4. Verify the frontmatter `description` accurately summarizes what the skill does.

**How to fix:** Update stale references, align procedures with current conventions, and correct inaccurate descriptions.

**Skip:** Skills that are correct but could have slightly better wording.

### Check 5: Linear Sync

Verify that Linear issue statuses match the actual git state.

**How to check:**

1. List all non-Done, non-Canceled issues in the `agentify` project.
2. For each In Progress issue:
   - Check if a branch exists on the remote (`git ls-remote --heads origin`).
   - If no branch exists and no agent is actively working on it, the status is stale.
3. For each In Review issue:
   - Check if an open PR exists for it.
   - If the PR was already merged, the issue should be Done.
   - If no PR exists, the status is stale.
4. For each Todo or Backlog issue:
   - Check if a branch unexpectedly exists (would indicate someone started work without updating Linear).

**How to fix:** Update Linear issue statuses to match reality. Move stale In Progress issues back to Todo. Move merged In Review issues to Done.

**Skip:** Issues where the status is ambiguous and you can't determine the correct state.

### Check 6: Orphaned Artifacts

Look for dead files and empty directories that no longer serve a purpose.

**How to check:**

1. Look for empty directories (other than those with `.gitkeep` files that are intentionally empty).
2. Look for files that are not referenced by any other file and don't serve an obvious standalone purpose.
3. Check `templates/` — are all templates still referenced and useful?
4. Check `docs/` — are there notes for topics that are fully resolved or no longer relevant?

**How to fix:** Delete truly orphaned files. If uncertain, leave them.

**Skip:** `.gitkeep` files, intentionally empty directories, files you're unsure about.

### Check 7: Convention Coherence

A catch-all for contradictions or gaps not covered by the specific checks above.

**How to check:**

1. Re-read `AGENTS.md` end-to-end as a fresh agent would.
2. For each directive, ask: "Would following this instruction verbatim lead me to the right outcome?"
3. Look for directives that are technically correct but misleading, or that assume context the reader won't have.
4. Look for gaps — important workflows that aren't documented anywhere.

**How to fix:** Clarify misleading directives, fill gaps with minimal additions.

**Skip:** Improvements that don't address a concrete confusion risk.

---

## Producing Fixes

If any checks found issues worth fixing:

1. **Follow the ticket-first gate.** If you don't already have a ticket for the health check, create one in Linear (the ticket this skill was invoked under, or a new one for ad-hoc runs).
2. **Create a branch** with the issue ID.
3. **Make targeted fixes.** Group related fixes into a single commit when they touch the same file. Separate unrelated fixes into distinct commits.
4. **Commit messages** should reference the check that motivated the fix (e.g., `ANT-15: fix stale merge policy reference in open-pr skill`).
5. **Open a PR** and follow the `pr-review-and-merge` skill to decide whether to self-merge or escalate.

If fixes touch `AGENTS.md` or convention docs in ways that change fundamental behavior (not just fixing stale references), classify the PR as requiring human review per the `pr-review-and-merge` skill.

## Reporting Results

Whether or not you made changes, summarize the audit results:

```
## Health Check Results

| Check | Result | Action |
|-------|--------|--------|
| Cross-reference consistency | Clean / Fixed / Skipped | <brief note> |
| Stale task notes | Clean / Fixed / Skipped | <brief note> |
| Project README accuracy | Clean / Fixed / Skipped | <brief note> |
| Skill freshness | Clean / Fixed / Skipped | <brief note> |
| Linear sync | Clean / Fixed / Skipped | <brief note> |
| Orphaned artifacts | Clean / Fixed / Skipped | <brief note> |
| Convention coherence | Clean / Fixed / Skipped | <brief note> |
```

Include this table in the PR body if fixes were made, or in the response to the user if everything is clean.
