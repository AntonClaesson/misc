# kbase

Personal LLM knowledge base — a "second brain" built on the Karpathy LLM Wiki pattern.

## Status

`active`

## How It Works

Instead of using RAG to re-derive answers from raw documents on every query, an LLM agent incrementally builds and maintains a persistent wiki — a structured, interlinked collection of markdown files. When a new source is added, the agent reads it, extracts key information, and integrates it into the existing wiki by updating entity pages, revising topic summaries, and maintaining cross-references. The knowledge compounds over time.

- **You** curate sources, ask questions, and direct the analysis.
- **The LLM** does the summarizing, cross-referencing, filing, and bookkeeping.
- **The wiki** is the persistent, compounding artifact.

## Directory Layout

```
projects/kbase/
  raw/          # Immutable source documents (markdown only). The LLM reads
                # from here but never modifies these files.
  wiki/         # LLM-maintained wiki pages. The LLM owns this directory
                # entirely — it creates, updates, and cross-references pages.
  SCHEMA.md     # Agent operating guide. Tells LLMs how the wiki is
                # structured and what workflows to follow.
  README.md     # This file.
```

## Using with Obsidian

Point an Obsidian vault at `projects/kbase/`. The `wiki/` folder contains interlinked markdown pages with wikilinks, Mermaid diagrams, and LaTeX math — all rendered natively by Obsidian. Use graph view to explore connections between pages.

## Stack

- Plain markdown (no code, no build step)
- Obsidian as the viewing/browsing frontend
- Mermaid for diagrams (rendered natively in Obsidian)
- LaTeX for math (`$...$` inline, `$$...$$` block)
- LLM agents (via Cursor Cloud Agents) for all wiki maintenance

## Agent Guide

See [SCHEMA.md](SCHEMA.md) for the full operating manual — wiki conventions, page types, ingest/query/lint workflows, and frontmatter schema.

To ingest a URL or raw source file, use the `kbase-ingest` skill in `.cursor/skills/` — it walks through the full workflow from fetching content to opening a PR.

To visually verify wiki pages render correctly in Obsidian before merging, use the `kbase-verify` skill — it covers launching Obsidian on the Cloud Agent's VNC desktop, checking Mermaid/LaTeX/wikilinks, and taking screenshots as PR evidence.
