# kbase Schema

You are maintaining a personal LLM knowledge base — a "second brain." This file is your operating manual. Follow it precisely when creating, updating, or querying wiki pages.

## Architecture

```
projects/kbase/
  raw/          # Immutable source documents. Read from here; never modify.
  wiki/         # Your workspace. All wiki pages live here.
  SCHEMA.md     # This file. Your rules and conventions.
  README.md     # Human-facing project overview.
```

**Raw sources** are immutable. They go into `raw/` and stay unchanged. They are your source of truth.

**The wiki** is your workspace. You create, update, and maintain every file in `wiki/`. The human reads and browses it in Obsidian; you do all the writing.

## Content Rules

- All wiki pages are plain markdown files in `wiki/`.
- Use **Obsidian-style wikilinks** for internal cross-references: `[[Page Name]]`. Do not use standard markdown links for internal pages.
- Use **Mermaid** diagrams in fenced code blocks (` ```mermaid `) for visual content — flowcharts, sequence diagrams, mind maps, ER diagrams, state machines, etc.
- Use **LaTeX** for math: `$...$` inline, `$$...$$` block. Obsidian renders these via MathJax.
- **No binary files.** No images, PDFs, drawio files, or any non-text content. If something needs a visual, use Mermaid or describe it in text.
- Write in clear, direct prose. Prefer concrete facts over vague summaries. Cite which raw source(s) a claim comes from.

## File Naming

- Use **kebab-case** for all wiki filenames: `llm-knowledge-bases.md`, `andrej-karpathy.md`.
- Names should be descriptive and stable. Use the primary name of the entity or topic.
- No dates in filenames. Dates belong in frontmatter.
- Special files use their exact names: `index.md`, `log.md`.

## Frontmatter

Every wiki page (except `index.md` and `log.md`) must have YAML frontmatter:

```yaml
---
title: "Page Title"
type: entity | topic | source
tags:
  - tag-one
  - tag-two
created: 2026-04-08
updated: 2026-04-08
sources:
  - raw-filename.md
  - "Description of verbal/external source"
---
```

Fields:

| Field | Required | Description |
|---|---|---|
| `title` | Yes | Human-readable page title. |
| `type` | Yes | One of: `entity`, `topic`, `source`. |
| `tags` | Yes | List of lowercase kebab-case tags for categorization. |
| `created` | Yes | ISO date when the page was first created. |
| `updated` | Yes | ISO date of the most recent substantive edit. |
| `sources` | Yes | List of raw filenames or descriptions that contributed to this page. |

Update the `updated` field whenever you make a substantive change to a page. Do not update it for trivial formatting fixes.

## Page Types

### Entity Pages

A page about a specific person, place, tool, book, organization, or concept with its own distinct identity.

- Filename: the entity's primary name in kebab-case (e.g., `andrej-karpathy.md`).
- `type: entity` in frontmatter.
- Structure: start with a one-paragraph summary, then use sections for details. Common sections: Background, Key Ideas, Related Work, Connections.
- Link generously to other entity and topic pages.

### Topic Pages

A broader subject that synthesizes information across multiple sources and entities.

- Filename: the topic in kebab-case (e.g., `llm-knowledge-bases.md`).
- `type: topic` in frontmatter.
- Structure: start with a concise overview, then use sections to break down subtopics. Include a "Related" section with wikilinks to connected pages.
- Topic pages are where synthesis and cross-referencing happen. They should connect dots between entities and sources.

### Source Summary Pages

One page per ingested raw source. Captures key takeaways and links to the entity/topic pages the source contributed to.

- Filename: `source-` prefix followed by a short descriptor (e.g., `source-karpathy-llm-wiki.md`).
- `type: source` in frontmatter.
- Structure:
  1. **Metadata** — author, date, URL or origin.
  2. **Summary** — 3-5 bullet points of key takeaways.
  3. **Detailed Notes** — deeper extraction, organized by theme.
  4. **Pages Updated** — list of wikilinks to entity/topic pages that were created or updated from this source.

### Index (`wiki/index.md`)

The master catalog of all wiki pages. No frontmatter needed.

- Organized by category: Entities, Topics, Source Summaries.
- Each entry: a wikilink followed by a one-line description.
- Keep alphabetically sorted within each category.
- Update the index every time you create a new page.

### Log (`wiki/log.md`)

Chronological, append-only record of operations. No frontmatter needed.

Each entry follows this format:

```
## [YYYY-MM-DD] operation | Short description

Brief details of what was done.
- Pages created: [[Page One]], [[Page Two]]
- Pages updated: [[Page Three]]
```

Valid operations: `ingest`, `query`, `lint`, `init`, `maintenance`.

The log should be parseable with simple tools: `grep "^## \[" wiki/log.md | tail -5` gives the last 5 entries.

## Operations

### Ingest

Processing a new raw source into the wiki. This is the primary way the wiki grows.

1. **Read** the source file from `raw/`.
2. **Create a source summary page** in `wiki/` following the source page conventions above.
3. **Create new entity/topic pages** for significant concepts, people, tools, etc. that don't already have pages.
4. **Update existing entity/topic pages** with new information from the source. When new information contradicts existing content, note the contradiction explicitly and cite both sources.
5. **Add wikilinks** across all affected pages. Every new page should link to at least one existing page, and at least one existing page should link back.
6. **Update `wiki/index.md`** with entries for every new page.
7. **Append to `wiki/log.md`** with an ingest entry listing pages created and updated.

When ingesting, prefer depth over breadth. It is better to create a few well-developed pages with good cross-references than many shallow pages.

### Query

Answering a question against the wiki.

1. **Read `wiki/index.md`** to identify relevant pages.
2. **Read those pages** and follow wikilinks to gather related context.
3. **Synthesize an answer** with citations to specific wiki pages.
4. If the answer is substantial and reusable, **offer to file it as a new topic page** in the wiki so the knowledge compounds.

### Lint

Health-checking the wiki. Run periodically or when the wiki feels stale.

Check for:

1. **Contradictions** — pages that make conflicting claims. Note the contradiction and cite sources.
2. **Stale content** — claims that newer sources have superseded. Update or flag.
3. **Orphan pages** — pages with no inbound wikilinks from other pages. Add links or consider whether the page is needed.
4. **Missing pages** — concepts mentioned in wikilinks that don't have their own page yet. Create them or remove the broken links.
5. **Weak cross-references** — pages that discuss related concepts but don't link to each other. Add the links.
6. **Gaps** — important subtopics or questions that the wiki doesn't address yet. Suggest new sources to look for.

After linting, append a lint entry to `wiki/log.md` summarizing findings and actions taken.

## Guidelines

- **Be precise.** Attribute claims to specific sources. "According to [[source-karpathy-llm-wiki]], the key advantage is..." is better than "The key advantage is..."
- **Prefer updating over creating.** If an existing page covers the topic, update it. Don't create a new page for every nuance.
- **Keep pages focused.** One entity or topic per page. If a page grows beyond ~1000 words, consider splitting it into sub-topics.
- **Maintain bidirectional links.** If page A links to page B, page B should generally link back to page A somewhere.
- **Evolve the schema.** If you find these conventions don't fit a particular use case, note the issue and suggest an update to this file. Do not silently deviate.
