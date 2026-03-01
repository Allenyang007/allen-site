# Blog 文章规划 — allen00.top/blog/

> 定位：个人产品思考与技术理解的沉淀，不是教程，不是引流工具。
> 每篇文章有一个明确的"我的判断"，记录给未来的自己和看得懂的人。

---

## 已发布文章（6篇，不改动）

| # | 目录 | 标题 |
|---|------|------|
| 1 | ai-agent-complete-guide | 从大模型到 Agent：AI 应用的完整技术栈 |
| 2 | ai-pm-fundamentals | 工具越强，基本功越值钱 |
| 3 | agent-series-01 | AI Agent 到底是什么？从三款产品说起 |
| 4 | agent-series-02 | 三款 Agent 产品架构深度拆解 |
| 5 | agent-series-03 | 产品经理的 Agent 设计心得 |
| 6 | agent-series-04 | Claude Code、Codex、OpenClaw 实战操作指南 |

---

## 待写文章（已确认，8篇）

### 第一梯队（优先）

| # | 计划目录 | 标题方向 | 课件来源 | 核心观点 |
|---|---------|---------|---------|---------|
| 7 | ai-product-vs-software | AI 产品和传统软件，思维上的根本断层在哪 | M9 | 不确定性不是 bug，是设计对象 |
| 8 | prompt-as-spec | Prompt 不是魔法咒语，是需求文档 | M4 | 产品视角：Prompt 决定 AI 的行为边界 |
| 9 | rag-two-sides | RAG 解决了什么问题，又带来了什么新问题 | M5 | 不只讲好处，两面都写 |

### 第二梯队

| # | 计划目录 | 标题方向 | 课件来源 | 核心观点 |
|---|---------|---------|---------|---------|
| 10 | workflow-vs-agent | Workflow 和 Agent 的边界在哪——我的判断框架 | M7 | 什么时候用流程图，什么时候需要 Agent |
| 11 | llm-project-delivery | 大模型项目为什么难交付——不是技术问题，是认知问题 | M10 | PM 视角的交付难点拆解 |
| 12 | llm-for-pm | 大模型原理：产品经理的认知边界在哪里 | M3 | 不是教你懂技术，是教你知道边界 |

### 第三梯队（选做）

| # | 计划目录 | 标题方向 | 课件来源 | 备注 |
|---|---------|---------|---------|------|
| 13 | career-switch-thinking | 跨行转型 AI PM：思维层面的变与不变 | M2 | 通用视角，不涉及个人经历细节，待定 |
| 14 | ai-resume-interview | AI 做简历和面试准备，我是这么用的 | M12 | 控制个人信息粒度，待定 |

---

## 写作原则

- **有观点**：每篇有一个明确的"我的判断"，不是综述
- **不暴露个人信息**：案例用"某项目""某团队"，不点名经历细节
- **不写医疗相关内容**
- **不刻意引流**：不堆关键词，不写"小白必看"式标题
- **深度优先**：宁可写得少一点，写透彻，不写凑数的

---

## SEO 规范（每篇发布前必做）

1. 用 `skills/seo-meta/SKILL.md` 生成 meta 标签
2. 用 `skills/seo-audit/SKILL.md` 做发布前检查
3. 发布后用 `skills/seo-sitemap/SKILL.md` 更新 sitemap.xml

---

## 写作流程

1. 从课件提取核心判断和关键案例 → `drafts/` 写 markdown 初稿
2. 补充第一人称观点、去掉教程感
3. 用 `skills/humanizer/SKILL.md` 去 AI 味审查
4. 用 `skills/pm-blog-writer/SKILL.md` 转 HTML（基于 `_article-template.html`）
5. SEO 检查（seo-meta + seo-audit）
6. 部署，更新 `blog/index.html` 和 `sitemap.xml`

---

## 目录结构

```
blog/
├── _article-template.html    # 统一文章模板
├── index.html                # 博客首页
├── BLOG-PLAN.md              # 本文件
├── drafts/                   # markdown 初稿
├── references/               # 研究资料
├── skills/                   # 写作相关 skills
│   ├── frontend-design/
│   ├── humanizer/
│   ├── pm-blog-writer/
│   └── summarizer/
├── images/                   # 共享图片资源
├── agent-series-01/          # 已发布
├── agent-series-02/
├── agent-series-03/
├── agent-series-04/
├── ai-agent-complete-guide/
└── ai-pm-fundamentals/
```

> SEO skills 在 `/allen-site/skills/` 下（seo-meta / seo-audit / seo-sitemap）
