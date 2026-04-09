---
name: kbase-ingest
description: Ingest content into the personal knowledge base (kbase). Use when the user provides a URL, article, or document to add to their knowledge base, or when ingesting a file already in projects/kbase/raw/.
---

# kbase Ingest

Use this skill when the user wants to add content to their personal knowledge base. This covers two scenarios:

1. **URL ingest** — the user provides a link to a web article, blog post, or document.
2. **Raw file ingest** — a markdown file is already in `projects/kbase/raw/` and needs to be processed into the wiki.

## Prerequisites

- Read `projects/kbase/SCHEMA.md` before doing anything. It defines all wiki conventions, page types, frontmatter schema, and the detailed ingest workflow. This skill provides the orchestration steps; SCHEMA.md provides the content rules.

## Step 1: Acquire the Source

### If the user provides a URL:

1. Fetch the content using the `WebFetch` tool.
2. Save as a markdown file in `projects/kbase/raw/` with this format:

```markdown
# Article Title

> **Source:** <original URL>
> **Author:** <author if known, otherwise "Unknown">
> **Date:** <publication date if known, otherwise "Unknown">
> **Retrieved:** <today's ISO date>

---

<fetched markdown content>
```

3. Name the file using kebab-case derived from the article title or topic: `raw/<descriptive-name>.md`. Keep it short but recognizable. Examples: `karpathy-llm-wiki.md`, `react-server-components-explained.md`.

4. Strip out navigation chrome, ads, cookie banners, and other non-content boilerplate that `WebFetch` may include. Keep the article's substantive content, code blocks, and any text descriptions of images or diagrams.

5. **Images:** Do not download or embed images. If the source contains images, preserve the image alt-text or captions in the markdown as descriptive text. If an image conveys important information (a diagram, chart, or architecture), describe its content in a text block or recreate it as a Mermaid diagram during the wiki compilation step.

### If a raw file already exists:

1. Confirm the file is in `projects/kbase/raw/`.
2. Read it and proceed to Step 2.

## Step 2: Follow the Ingest Workflow

Read and follow the **Ingest** operation defined in `projects/kbase/SCHEMA.md`. In summary:

1. **Create a source summary page** in `wiki/` (prefixed `source-`).
2. **Create new entity/topic pages** for significant concepts that don't already have pages.
3. **Update existing pages** with new information from the source. Flag contradictions explicitly.
4. **Add wikilinks** — every new page links to at least one existing page, and vice versa.
5. **Update `wiki/index.md`** with all new pages.
6. **Append to `wiki/log.md`** with an ingest entry.

Important: read `wiki/index.md` first to understand what pages already exist. Prefer updating existing pages over creating duplicates.

## Step 3: Git Workflow

1. Create a branch. Include "ingest" and a short descriptor in the name (e.g., `cursor/ingest-react-server-components-f931`).
2. Stage all changed files in `projects/kbase/`.
3. Commit with a message like: `kbase: ingest <source name>` followed by a summary of pages created/updated.
4. Push the branch.
5. Open a PR against `main`.

If the user has pre-approved merging (e.g., "ingest this and merge it"), merge via squash after self-review. Otherwise, leave the PR for review.

## Step 4: Linear (if applicable)

If the ingest is tied to a Linear issue:
- Move the issue to **In Progress** before starting (if not already).
- Move to **In Review** when the PR is opened.
- Move to **Done** after merge.

If there is no Linear issue, that's fine — not every ingest needs a ticket. Quick one-off ingests from a chat message don't require one.

## Quality Checklist

Before committing, verify:

- [ ] Raw file has attribution metadata (source URL, author, date, retrieved date).
- [ ] Source summary page has correct frontmatter (title, type: source, tags, dates, sources).
- [ ] All new entity/topic pages have correct frontmatter.
- [ ] All pages use `[[wikilinks]]` for internal cross-references.
- [ ] Bidirectional links: new pages link to existing pages and existing pages link back.
- [ ] `wiki/index.md` includes all new pages, alphabetically sorted within categories.
- [ ] `wiki/log.md` has an ingest entry listing pages created and updated.
- [ ] No binary files committed (images, PDFs, etc.).
- [ ] Mermaid diagrams used where visual content would help (architecture, flows, comparisons).
