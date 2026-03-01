# allen00.top — 代码审查 & SEO 问题报告

**审查日期**：2026-03-01  
**审查范围**：全站 9 个 HTML 页面  
**状态**：只查问题，未修改任何文件

---

## 🔴 阻塞级问题（必须修复才能发布/优化 SEO）

### 1. 全站缺少 `canonical` 标签
**影响页面**：全部 9 个页面  
**问题**：搜索引擎无法确认页面的权威 URL，可能被判定为重复内容，影响收录排名。  
**需要在每个页面 `<head>` 里加**：
```html
<link rel="canonical" href="https://allen00.top/对应路径/">
```

| 页面 | 应填写的 canonical URL |
|------|----------------------|
| 首页 | https://allen00.top/ |
| about/ | https://allen00.top/about/ |
| blog/ | https://allen00.top/blog/ |
| blog/ai-agent-complete-guide/ | https://allen00.top/blog/ai-agent-complete-guide/ |
| blog/ai-pm-fundamentals/ | https://allen00.top/blog/ai-pm-fundamentals/ |
| blog/agent-series-01/ | https://allen00.top/blog/agent-series-01/ |
| blog/agent-series-02/ | https://allen00.top/blog/agent-series-02/ |
| blog/agent-series-03/ | https://allen00.top/blog/agent-series-03/ |
| blog/agent-series-04/ | https://allen00.top/blog/agent-series-04/ |

---

### 2. 全站缺少 Open Graph 标签
**影响页面**：全部 9 个页面  
**问题**：微信/社交平台分享时无法显示标题和封面图，分享效果差。  
**每个页面需要补充**：
```html
<meta property="og:title" content="文章标题">
<meta property="og:description" content="文章摘要">
<meta property="og:url" content="https://allen00.top/对应路径/">
<meta property="og:type" content="article">
<meta property="og:image" content="https://allen00.top/blog/images/封面图.png">
<meta property="og:site_name" content="Allen">
<meta property="og:locale" content="zh_CN">
```

---

### 3. `sitemap.xml` 不存在
**路径**：`/root/.openclaw/workspace/projects/allen-site/sitemap.xml`  
**问题**：搜索引擎无法主动发现全站页面，依赖自然爬取，收录慢。  
**需要**：新建 sitemap.xml，包含全部 9 个页面，并在 Google Search Console 提交。

---

### 4. `robots.txt` 不存在
**路径**：`/root/.openclaw/workspace/projects/allen-site/robots.txt`  
**问题**：缺少爬虫引导，无法声明 Sitemap 地址。  
**需要新建**：
```
User-agent: *
Allow: /

Sitemap: https://allen00.top/sitemap.xml
```

---

### 5. about 页 description 暴露敏感信息
**文件**：`about/index.html`  
**当前内容**：`"关于 Allen — 建筑转行 AI 产品经理，在医疗 AI 行业做大模型和 Agent 落地。"`  
**问题**：含"医疗 AI 行业"字样，与不想暴露个人信息的原则冲突。  
**建议改为**：去掉行业信息，改成更通用的描述。

---

## 🟡 重要级问题（建议修复）

### 6. 全站外链缺少 `rel="noopener"`
**影响页面**：全部文章页  
**问题**：外链可通过 `window.opener` 操控来源页，存在安全隐患。  
**当前各页面外链数量**：

| 页面 | 未加 noopener 的外链数 |
|------|----------------------|
| 首页 | 3 处 |
| ai-agent-complete-guide | 14 处 |
| ai-pm-fundamentals | 3 处 |
| agent-series-01 | 3 处 |
| agent-series-02 | 3 处 |
| agent-series-03 | 3 处 |
| agent-series-04 | 4 处 |

**修复方式**：所有 `target="_blank"` 的外链加上 `rel="noopener noreferrer"`

---

### 7. 首页 title 定位不准
**文件**：`index.html`  
**当前**：`Allen's Tech - AI 产品经理的技术博客`  
**问题**："技术博客"的定位和现在"个人产品思考沉淀"不太匹配，"Tech"品牌名也比较泛。  
**建议**：调整 title 和站点 slogan，与当前定位保持一致。

---

## ✅ 通过项

| 检查项 | 状态 |
|--------|------|
| 每页只有一个 H1 | ✅ 全部通过 |
| viewport meta 存在 | ✅ 全部通过 |
| 图片大小（全部 < 300KB） | ✅ 全部通过 |
| title 基础存在 | ✅ 全部通过 |
| description 基础存在 | ✅ 全部通过 |

---

## 修复优先级建议

| 优先级 | 任务 | 理由 |
|--------|------|------|
| 1 | about 页 description 去掉医疗信息 | 涉及个人信息，最急 |
| 2 | 补全 canonical + og 标签（全站） | SEO 核心，影响收录和分享 |
| 3 | 新建 sitemap.xml + robots.txt | SEO 基础设施 |
| 4 | 全站外链加 noopener | 安全问题 |
| 5 | 首页 title / slogan 调整 | 定位对齐，不紧急 |

---

*报告生成后未修改任何文件，待确认后再执行修复。*
