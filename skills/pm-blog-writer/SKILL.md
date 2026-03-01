---
name: pm-blog-writer
description: >
  为 Allen 的个人网站 (allen00.top) 撰写产品经理思考专栏博客文章。
  当用户要求写博客、写文章、发布产品思考、写专栏时触发。
  支持：接收用户观点/素材 → 生成高质量中文产品思考文章 → 匹配网站设计系统的HTML → 本地预览 → 确认后发布。
---

# Blog Writer for Allen's Tech

为 allen00.top 生成博客文章，支持两种模式。

## 判断写作模式

用户不会明确说"写 PM 文章"或"写技术文章"，根据意图判断：

**PM 思考**（默认）：用户聊产品观点、行业思考、工作感悟、方法论、职业认知
→ 读 `references/writing-style.md`

**技术深度**：用户明确要写技术教程、架构分析、工具对比、代码相关
→ 读 `references/tech-style.md`

拿不准就按 PM 思考处理。

## 项目路径

- 网站仓库: `/root/.openclaw/workspace/projects/allen-site/`
- 博客目录: `/root/.openclaw/workspace/projects/allen-site/blog/`
- 博客列表页: `/root/.openclaw/workspace/projects/allen-site/blog/index.html`
- HTML 模板: `references/blog-template.html`

## 工作流程

### 1. 接收输入 & 判断意图

用户可能给：
- 自己的观点/思考（零散也行，帮他组织）
- 参考文章链接
- 一个话题方向
- Notion 里的文章素材

根据内容判断模式，不需要问用户。

### 2. 研究补充

如有参考链接，用 `web_fetch` 深度阅读。
如话题需要更多素材，用 Tavily 搜索。

### 3. 撰写文章

根据模式读取对应的写作风格参考，撰写文章。

**去 AI 味（必须，联动 humanizer skill）：**
写作全程遵守写作风格文件中的"去 AI 味"章节（已内化 humanizer 核心规则）。
写完后用自检清单过一遍。如果需要更深度的审查，读取 humanizer 完整指南：
`/root/.openclaw/workspace/skills/humanizer/SKILL.md`

核心原则：文章读起来像一个人在跟你聊天，不像一篇"AI 生成的文章"。

### 4. 生成 HTML

读取 `references/blog-template.html` 生成完整单文件 HTML。

规则：
- 路径: `blog/{slug}/index.html`，slug 英文短横线
- PM 短文（<3000字）：不需要目录侧栏，用单列布局
- 技术长文（>5000字）：需要目录侧栏，用双列布局
- 必须支持深色/浅色模式
- 必须响应式
- 日期: YYYY年M月D日 | 作者: Allen

### 5. 本地预览（必须）

```bash
cd /root/.openclaw/workspace/projects/allen-site
# 杀掉旧的预览进程
pkill -f "python3 -m http.server 8080" 2>/dev/null || true
python3 -m http.server 8080 &
```

告知用户预览：`http://43.153.49.71:8080/blog/{slug}/`
**等用户确认后才能进入下一步。不要自动发布。**

### 6. 用户确认后发布

```bash
cd /root/.openclaw/workspace/projects/allen-site
git add .
git commit -m "blog: {简述}"
git push origin main
cd /var/www/allen-site && git pull origin main
```

同时更新 `blog/index.html` 添加新文章卡片。

## 注意事项

- 文章必须有观点，不是搬运
- 引用标注来源
- 避免 AI 味（参考 writing-style.md 的红线）
- © 2026 Allen
