---
title: "Memex"
type: entity
tags:
  - knowledge-management
  - history
  - concept
created: 2026-04-08
updated: 2026-04-08
sources:
  - karpathy-llm-wiki.md
---

# Memex

A hypothetical device described by [[vannevar-bush|Vannevar Bush]] in his 1945 essay "As We May Think." The Memex was envisioned as a personal, mechanized knowledge store where an individual could store all their books, records, and communications, and retrieve them with speed and flexibility.

## Key Features

- **Associative trails** — the user could create named links between documents, forming personal pathways through information. These trails were meant to mirror how human thought works — by association rather than by index.
- **Private and curated** — unlike a public library, the Memex was personal. The user actively shaped their collection and the connections within it.
- **Connections as valuable as content** — Bush argued that the trails between documents were as important as the documents themselves.

## Relevance to LLM Knowledge Bases

According to [[andrej-karpathy|Karpathy]], the [[llm-knowledge-bases|LLM Knowledge Bases]] pattern is closer in spirit to Bush's Memex than to what the web became. Both are:

- Private, actively curated knowledge stores
- Built on associative connections between documents
- Designed to compound in value through accumulated cross-references

The part Bush couldn't solve was **who does the maintenance** — creating and updating all those associative trails is labor-intensive for humans. LLMs handle that, making the Memex vision practically achievable.

## Related

- [[vannevar-bush|Vannevar Bush]] — originated the concept
- [[llm-knowledge-bases|LLM Knowledge Bases]] — modern realization of the vision
