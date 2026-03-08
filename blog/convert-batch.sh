#!/bin/bash
# 批量转换 6 篇博客草稿为 HTML

DRAFTS=(
  "draft-ai-product-vs-software:ai-product-vs-traditional-software"
  "draft-llm-project-delivery:llm-project-delivery-mindset"
  "draft-rag-two-sides:rag-benefits-and-engineering-pitfalls"
  "draft-llm-for-pm:llm-knowledge-for-product-managers"
  "draft-prompt-as-spec:prompt-is-spec-not-magic"
  "draft-workflow-vs-agent:workflow-vs-agent-decision-framework"
)

for item in "${DRAFTS[@]}"; do
  draft="${item%%:*}"
  slug="${item##*:}"
  echo "Processing: $draft -> $slug"
  mkdir -p "$slug"
done

echo "Directories created. Ready for HTML generation."
