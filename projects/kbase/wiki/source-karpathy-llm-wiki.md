---
title: "Source: Karpathy's LLM Wiki"
type: source
tags:
  - llm
  - knowledge-management
  - wiki
  - idea-file
created: 2026-04-08
updated: 2026-04-08
sources:
  - karpathy-llm-wiki.md
---

# Source: Karpathy's LLM Wiki

## Metadata

- **Author:** Andrej Karpathy
- **Date:** April 2026
- **Format:** Idea file (GitHub Gist)
- **URL:** https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

## Summary

- LLMs should **build and maintain persistent wikis** rather than re-derive answers from raw documents on every query (the standard [[Retrieval-Augmented Generation|RAG]] approach).
- The wiki is a **compounding artifact** — cross-references, contradictions, and synthesis are established once and kept current, not rediscovered each time.
- Three-layer architecture: **raw sources** (immutable), **the wiki** (LLM-maintained markdown), and **the schema** (configuration file that governs LLM behavior).
- Three core operations: **ingest** (process a new source into the wiki), **query** (answer questions against the compiled wiki), **lint** (health-check for contradictions, orphans, and gaps).
- The pattern applies broadly: personal knowledge, research, reading companions, business/team wikis, competitive analysis, and more.

## Detailed Notes

### The Core Insight

The fundamental problem with [[Retrieval-Augmented Generation|RAG]] is that it re-derives knowledge on every query. There is no accumulation. The LLM Wiki pattern inverts this: knowledge is **compiled once** into a structured wiki and then **kept current** incrementally. According to [[Andrej Karpathy]], "a large fraction of my recent token throughput is going less into manipulating code, and more into manipulating knowledge."

### Architecture

The system has three layers, each with a clear ownership boundary:

1. **Raw sources** — immutable documents curated by the human. The LLM reads but never modifies these.
2. **The wiki** — LLM-generated and LLM-maintained markdown files. Entity pages, topic summaries, comparisons, synthesis. The human reads; the LLM writes.
3. **The schema** — a configuration document (like CLAUDE.md or AGENTS.md) that tells the LLM how the wiki is structured. Human and LLM co-evolve this over time.

### Operations

**Ingest** is the primary growth mechanism. A single source can touch 10-15 wiki pages. Karpathy prefers one-at-a-time ingestion with human involvement over batch processing.

**Query** answers questions by reading the index, drilling into relevant pages, and synthesizing. Key insight: good answers should be **filed back into the wiki** as new pages so explorations compound alongside ingested sources.

**Lint** is periodic maintenance — finding contradictions, stale claims, orphan pages, missing concepts, and weak cross-references. The LLM can also suggest new questions and sources to investigate.

### Navigation

Two special files support navigation at scale:

- **index.md** — content-oriented catalog of all pages, organized by category. The LLM reads this first when answering queries. Works well up to ~100 sources / hundreds of pages without needing embedding-based search.
- **log.md** — chronological, append-only record of operations. Parseable with unix tools.

### Tooling

Karpathy uses [[Obsidian]] as the frontend IDE for browsing the wiki. Recommended tools include [[Obsidian Web Clipper]] for source capture, [[Marp]] for slide generation, and [[Dataview]] for frontmatter queries. At larger scale, a search engine like [[qmd]] (BM25 + vector search with MCP support) can supplement the index file.

### Historical Context

The pattern echoes [[Vannevar Bush]]'s [[Memex]] concept (1945) — a personal knowledge store with associative trails between documents. Bush's vision was private, actively curated, with connections as valuable as the documents themselves. The missing piece was maintenance; LLMs solve that.

### Why It Works

Humans abandon wikis because maintenance burden grows faster than value. LLMs eliminate that cost — they don't get bored, don't forget cross-references, and can touch many files in one pass. The human focuses on curation, direction, and meaning. The LLM handles everything else.

## Pages Updated

- Created: [[Andrej Karpathy]], [[LLM Knowledge Bases]], [[Retrieval-Augmented Generation]], [[Memex]], [[Obsidian]]
- Updated: (none — first ingest)
