---
title: "Obsidian"
type: entity
tags:
  - tool
  - knowledge-management
  - markdown
created: 2026-04-08
updated: 2026-04-08
sources:
  - karpathy-llm-wiki.md
---

# Obsidian

A markdown-based knowledge management application that operates on local files. Used by [[Andrej Karpathy]] as the frontend IDE for browsing [[LLM Knowledge Bases|LLM-maintained wikis]].

## Role in the LLM Wiki Pattern

In the [[LLM Knowledge Bases]] workflow, Obsidian serves as the **human-facing frontend**. The LLM agent creates and maintains wiki pages; the human browses them in Obsidian. As Karpathy describes it: "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase."

## Key Features for Wiki Use

- **Graph view** — visualizes connections between pages, showing hubs and orphans. The best way to see the shape of a wiki.
- **Wikilinks** — `[[Page Name]]` syntax for fast internal linking. Powers backlinks and graph view.
- **Native Mermaid rendering** — diagrams render directly in preview mode.
- **MathJax support** — LaTeX math via `$...$` and `$$...$$`.
- **Local-first** — all data is plain markdown files on disk. Works naturally with git for version history.

## Useful Plugins and Tools

According to [[source-karpathy-llm-wiki|Karpathy's gist]]:

- **Obsidian Web Clipper** — browser extension that converts web articles to markdown for sourcing.
- **Marp plugin** — renders markdown-based slide decks from wiki content.
- **Dataview plugin** — runs queries over page frontmatter (tags, dates, etc.) to generate dynamic tables and lists.

## Related

- [[LLM Knowledge Bases]] — the pattern Obsidian supports as a frontend
- [[Andrej Karpathy]] — recommends Obsidian for this workflow
