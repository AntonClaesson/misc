---
title: "Retrieval-Augmented Generation"
type: entity
tags:
  - llm
  - rag
  - knowledge-management
  - ai-pattern
created: 2026-04-08
updated: 2026-04-08
sources:
  - karpathy-llm-wiki.md
---

# Retrieval-Augmented Generation

Retrieval-Augmented Generation (RAG) is the dominant approach to grounding LLM responses in external documents. The LLM retrieves relevant chunks from a document collection at query time and generates an answer based on them.

## How It Works

1. Documents are chunked and embedded into a vector store.
2. At query time, the user's question is embedded and used to retrieve relevant chunks.
3. The retrieved chunks are passed to the LLM as context.
4. The LLM generates an answer grounded in the retrieved material.

Products like NotebookLM, ChatGPT file uploads, and most enterprise "chat with your docs" systems use this pattern.

## Limitations

According to [[andrej-karpathy|Karpathy]], RAG has a fundamental limitation: **it re-derives knowledge from scratch on every query.** There is no accumulation. Ask a question that requires synthesizing five documents, and the LLM must find and piece together the relevant fragments every time.

Specific weaknesses compared to the [[llm-knowledge-bases|LLM Knowledge Bases]] pattern:

- No persistent cross-referencing between documents
- Contradictions between sources go undetected
- No compounding — the 100th query is no cheaper or richer than the first
- Synthesis quality depends entirely on retrieval accuracy

## Where RAG Still Fits

RAG remains appropriate when:

- The document collection is very large and changes frequently
- Upfront processing cost needs to be minimal
- Questions are narrow and factual (single-document answers)
- The use case doesn't benefit from accumulated synthesis

## Related

- [[llm-knowledge-bases|LLM Knowledge Bases]] — the alternative pattern that compiles knowledge persistently
- [[andrej-karpathy|Andrej Karpathy]] — contrasted RAG with the LLM Wiki approach
