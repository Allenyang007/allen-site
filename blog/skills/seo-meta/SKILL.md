# SEO Meta Skill

为 allen00.top 的每篇文章/页面生成规范的 HTML meta 标签。

## 适用场景
- 新文章发布前，生成完整 meta 标签
- 检查并修复已有页面的 meta 缺失或不规范问题

---

## Meta 标签规范

### 必填项

```html
<!-- 基础 -->
<title>文章标题 - Allen</title>
<meta name="description" content="150字以内的摘要，包含核心关键词，像一句话介绍">
<meta name="author" content="Allen">
<link rel="canonical" href="https://allen00.top/blog/文章目录/">

<!-- Open Graph（微信/社交分享） -->
<meta property="og:title" content="文章标题">
<meta property="og:description" content="同 description，可以略有不同">
<meta property="og:url" content="https://allen00.top/blog/文章目录/">
<meta property="og:type" content="article">
<meta property="og:image" content="https://allen00.top/blog/images/封面图.png">
<meta property="og:site_name" content="Allen">
<meta property="og:locale" content="zh_CN">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="文章标题">
<meta name="twitter:description" content="同 description">
<meta name="twitter:image" content="https://allen00.top/blog/images/封面图.png">

<!-- 文章结构化数据 -->
<meta property="article:published_time" content="2026-03-01">
<meta property="article:author" content="Allen">
```

### 选填项
```html
<meta name="keywords" content="关键词1, 关键词2, 关键词3">
<meta name="robots" content="index, follow">
```

---

## 字数规范

| 字段 | 推荐长度 | 超出影响 |
|------|---------|---------|
| title | 25-35 个中文字 | 搜索结果被截断 |
| description | 70-120 个中文字 | 超出部分不显示 |
| og:description | 同上 | 社交分享被截 |

---

## 操作流程

### 新文章上线前
1. 读取文章 HTML，找到 `<head>` 区域
2. 检查是否已有 title / description / og 标签
3. 按以下步骤生成：
   - **title**：文章核心主题 + " - Allen"，不超过 35 字
   - **description**：用一句话说清楚"这篇文章讲了什么、对谁有用"，不要复制文章开头，要独立写
   - **keywords**：从文章中提取 3-5 个核心词，中文为主
   - **og:image**：优先用文章配图，没有就用 `/apple-touch-icon.png`
4. 将生成的标签写入 HTML `<head>` 中
5. 检查 canonical URL 是否正确（末尾带 `/`）

### 检查已有页面
用 `read` 读取 HTML，确认：
- [ ] title 存在且不超过 35 字
- [ ] description 存在且 70-120 字
- [ ] canonical 指向正确 URL
- [ ] og:image 图片路径存在
- [ ] 没有重复的 meta 标签

---

## 示例

文章：《Prompt 不是魔法咒语，是需求文档》

```html
<title>Prompt 不是魔法咒语，是需求文档 - Allen</title>
<meta name="description" content="很多人觉得 Prompt 是和 AI 沟通的技巧，但产品经理视角完全不同——Prompt 本质上是需求文档，决定了 AI 的行为边界和输出质量。">
<meta name="keywords" content="Prompt工程, AI产品经理, 需求文档, 大模型">
<link rel="canonical" href="https://allen00.top/blog/prompt-engineering/">
<meta property="og:title" content="Prompt 不是魔法咒语，是需求文档">
<meta property="og:description" content="产品经理视角重新理解 Prompt：它不是沟通技巧，是 AI 的需求文档。">
<meta property="og:url" content="https://allen00.top/blog/prompt-engineering/">
<meta property="og:type" content="article">
<meta property="og:image" content="https://allen00.top/blog/images/prompt-cover.png">
```
