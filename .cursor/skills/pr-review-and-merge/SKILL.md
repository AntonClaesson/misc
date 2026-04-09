---
name: pr-review-and-merge
description: Self-review and merge (or escalate) a pull request the agent has opened. Use after opening a PR to decide whether to auto-merge or defer to human review.
---

# PR Review and Merge

Use this skill after opening a PR for work you have completed. It replaces the old "never merge without user approval" default with a structured self-review process that lets agents merge routine, well-tested changes autonomously while escalating high-risk changes to the human.

## When To Use

- After opening a PR for your own work.
- Before marking the Linear issue as Done.

**Skip this skill entirely** if the user explicitly said they want to review and merge the PR themselves (e.g., "open a PR and I'll review it", "leave it for me to merge"). In that case, leave the PR open and tell the user it's ready.

---

## Step 1: Risk Classification

Before reviewing the diff, classify the change into one of two categories. This determines whether you may self-merge or must defer.

### Auto-merge eligible (agent may merge after self-review)

All of the following must be true:

- The change is **additive or narrowly scoped** — it adds new content, fixes a small bug, updates documentation, or modifies code within a single project boundary.
- The change **does not delete or substantially rewrite** existing functionality that other parts of the repo or external consumers depend on.
- The change **does not modify shared infrastructure** that governs agent behavior or repo-wide tooling in a way that could break other workflows. Small, clearly safe additions to these files (e.g., adding a new skill reference) are fine.
- The agent is **confident the change is correct** — tests pass, the diff makes sense, and there are no open questions.
- The user **did not request manual review** for this work.

Examples of auto-merge eligible changes:

| Change | Why |
|--------|-----|
| New project under `projects/` | Self-contained, additive. |
| kbase ingest (new wiki pages) | Additive content, no existing behavior changed. |
| Bug fix in a single project with passing tests | Narrowly scoped, verified. |
| Documentation updates (README, PLAN.md, task notes) | Low risk, no behavior change. |
| New or updated Cursor skill | Additive tooling, does not break existing flows. |
| Small config change within one project | Scoped, non-destructive. |
| Updating workflow docs to add a new convention or clarify existing ones | Additive policy change. |

### Requires human review (agent must NOT merge)

Any one of the following triggers human review:

- **Large-scale deletions or rewrites** — removing or substantially rewriting existing project code, especially code that has been in `main` for a while.
- **Changes to shared infrastructure with breaking potential** — modifying `scripts/`, `packages/`, `templates/`, or MCP server code in ways that could affect multiple consumers.
- **Security-sensitive changes** — anything touching authentication, secrets handling, permissions, or `.gitignore` patterns for sensitive files.
- **Ambiguity or uncertainty** — the agent is not confident the change is correct, the requirements were unclear, or the work involved significant judgment calls the user should validate.
- **User explicitly requested review** — the user said "I'll review", "leave it for me", "open a PR for review", or similar.
- **Changes that redefine core agent behavior** — rewriting (not just extending) the fundamental rules in `AGENTS.md`, workflow conventions, or the safety section.
- **Cross-project changes** — a single PR touches multiple unrelated projects or areas.
- **Destructive data operations** — deleting or overwriting files in `data/` or `projects/kbase/raw/`.

When human review is required, **stop here**. Tell the user the PR is ready for their review, summarize why it needs human eyes, and move the Linear issue to In Review. Do not proceed to Step 2.

---

## Step 2: Self-Review Checklist

If the change is auto-merge eligible, perform a thorough self-review before merging. Go through every item. If any check fails, fix the issue and re-push before continuing.

### 2a: Diff Audit

1. Run `git diff main...HEAD` and read the **full diff**, not just the stat summary.
2. Verify every changed line is intentional and related to the ticket.
3. Confirm no unrelated changes snuck in (stray formatting, unrelated refactors).
4. Look for accidental inclusions: `.env` files, secrets, tokens, API keys, personal data.
5. Verify no debug code, `console.log`, `print()` statements, or hardcoded test values remain unless they are intentional.

### 2b: Test Verification

1. Confirm that all relevant tests pass. If the project has a test suite, run it.
2. If you added new functionality, confirm it was tested (automated tests, manual verification, or both).
3. If the project has a linter or type checker, confirm it passes.
4. For documentation-only changes, verify markdown renders correctly (links resolve, formatting is clean).

### 2c: Convention Compliance

1. **Branch name** includes the Linear issue ID.
2. **Commit messages** are descriptive and reference the issue ID.
3. **PR title and body** follow the format in the `open-pr` skill.
4. **PR → Ticket link** — the PR body contains a **Linear issue** section with a clickable link to the corresponding Linear ticket.
5. **Ticket → PR link** — the Linear ticket has a link attachment pointing back to the PR. If missing, add it now using `Linear-save_issue` with `links`.
6. **Task notes** (PLAN.md, TODO.md) are updated if they exist for this area.
7. **Linear issue** status is current (should be In Progress or In Review).
8. **README** is updated if the change adds a new project or changes how something is run.

### 2d: Scope Verification

1. Re-read the Linear issue description and acceptance criteria.
2. Confirm the PR addresses everything described in the ticket.
3. If the PR only partially addresses the ticket, note what remains and decide whether to merge the partial work or complete it first.

---

## Step 3: Merge

If all checks in Step 2 pass:

1. Mark the PR as ready for review (if it was a draft):
   ```
   gh pr ready <PR-number>
   ```

2. Squash-merge the PR (default) or rebase-merge if commit granularity matters:
   ```
   gh pr merge <PR-number> --squash --delete-branch=false
   ```

3. Switch to `main` and pull:
   ```
   git checkout main && git pull origin main
   ```

4. Delete the local branch:
   ```
   git branch -d <branch-name>
   ```

5. **Keep the remote branch** — do not delete it.

6. Move the Linear issue to **Done**.

---

## Step 4: Post-Merge Verification

After merging:

1. Verify the merge succeeded: check that `main` contains the expected changes.
2. Confirm the Linear issue is in Done status.
3. If the work created a new project, verify the README is accessible from the repo root.

---

## Decision Flowchart

```
Start
  │
  ├─ Did the user request manual review? ──→ YES ──→ STOP: leave PR for human.
  │
  ├─ Does any "requires human review" trigger apply? ──→ YES ──→ STOP: leave PR for human.
  │
  ├─ Is the change auto-merge eligible? ──→ NO ──→ STOP: leave PR for human.
  │
  ├─ Does the self-review checklist pass? ──→ NO ──→ Fix issues, re-push, re-check.
  │
  └─ All clear ──→ MERGE.
```

---

## Handling Failures During Self-Review

If the self-review reveals problems:

1. **Fixable issues** (debug code left in, missing test, formatting) — fix them on the branch, commit, push, and re-run the checklist.
2. **Uncertain issues** (the change might be wrong, requirements are ambiguous) — do NOT merge. Escalate to the user with a clear description of the uncertainty.
3. **Scope creep** (the diff contains changes beyond the ticket) — revert the unrelated changes, commit, push, and re-run the checklist. Or split into separate PRs if the extra work is valuable.

The goal is to only merge when you are confident the change is correct, complete, and safe. When in doubt, defer to the human.
