#!/bin/bash
# 更新博客首页,添加6篇新文章

NEW_ARTICLES='
<div class="card" onclick="location.href='"'"'/blog/ai-product-vs-traditional-software/'"'"'">
  <div class="card-tag tag-ai">AI产品</div>
  <h3>AI产品和传统软件,思维上的断层在哪</h3>
  <p>从传统软件转做AI产品,最大的认知冲击不是技术,而是对"系统该如何表现"的底层假设被颠覆。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>6 分钟</span>
  </div>
</div>

<div class="card" onclick="location.href='"'"'/blog/llm-project-delivery-mindset/'"'"'">
  <div class="card-tag tag-pm">项目管理</div>
  <h3>大模型项目为什么难交付——不是技术问题,是认知问题</h3>
  <p>大模型项目交付难,根因不在技术,而在团队用传统软件思维管理AI项目。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>7 分钟</span>
  </div>
</div>

<div class="card" onclick="location.href='"'"'/blog/rag-benefits-and-engineering-pitfalls/'"'"'">
  <div class="card-tag tag-tech">RAG</div>
  <h3>RAG 解决了什么问题,又带来了什么新问题</h3>
  <p>从医学 AI 写作项目实战出发,拆解 RAG 检索增强生成的真实收益与工程陷阱。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>8 分钟</span>
  </div>
</div>

<div class="card" onclick="location.href='"'"'/blog/llm-knowledge-for-product-managers/'"'"'">
  <div class="card-tag tag-pm">产品经理</div>
  <h3>产品经理需要懂大模型原理吗</h3>
  <p>AI产品经理不需要会训练模型,但必须理解模型的行为边界。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>7 分钟</span>
  </div>
</div>

<div class="card" onclick="location.href='"'"'/blog/prompt-is-spec-not-magic/'"'"'">
  <div class="card-tag tag-tech">Prompt</div>
  <h3>Prompt不是魔法咒语,是需求文档</h3>
  <p>很多团队拿到AI烂输出就想换模型,但问题往往出在Prompt。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>6 分钟</span>
  </div>
</div>

<div class="card" onclick="location.href='"'"'/blog/workflow-vs-agent-decision-framework/'"'"'">
  <div class="card-tag tag-ai">Workflow</div>
  <h3>Workflow 和 Agent 的边界在哪——我的判断框架</h3>
  <p>基于 59 个 Dify 工作流的实战经验,分享 Workflow 与 Agent 的选型判断框架。</p>
  <div class="card-meta">
    <span>2026年3月8日</span>
    <span>6 分钟</span>
  </div>
</div>
'

echo "New articles HTML prepared. Will be inserted into blog/index.html after subagents complete."
