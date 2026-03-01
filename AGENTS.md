# allen00.top - Agent 工作指南

## 项目简介
个人网站，纯静态 HTML/CSS/JS。定位是个人产品思考与技术理解的沉淀，不是引流工具。

## 目录结构
```
allen-site/
├── index.html          # 首页
├── about/              # 关于页
├── blog/               # 博客
│   ├── index.html      # 博客首页
│   ├── BLOG-PLAN.md    # 写作规划（必读）
│   ├── drafts/         # Markdown 初稿
│   ├── references/     # 参考资料
│   ├── skills/         # 博客专用 skills 副本
│   └── [文章目录]/     # 已发布文章
├── skills/             # 全局 skills
└── sitemap.xml         # SEO 站点地图
```

## 可用 Skills（./skills/）

### 写作类
- **humanizer** — 去 AI 味，所有对外文字必过
- **pm-blog-writer** — 博客文章写作流程
- **summarizer** — 内容摘要提炼

### 前端类
- **frontend-design** — 高质量前端界面生成
- **code-review** — 代码审查
- **debug-pro** — 调试排错

### SEO 类
- **seo-meta** — 生成规范 meta 标签（每篇文章发布前必做）
- **seo-sitemap** — 维护 sitemap.xml（每篇文章发布后更新）
- **seo-audit** — 全站 SEO 健康检查

## 博客写作流程（每篇必须按顺序）
1. 读 `blog/BLOG-PLAN.md` 确认待写文章和写作原则
2. 读课件来源文件提炼核心观点
3. 在 `blog/drafts/` 写 Markdown 初稿
4. 用 `skills/humanizer/SKILL.md` 去 AI 味审查
5. 用 `skills/pm-blog-writer/SKILL.md` 转 HTML
6. 用 `skills/seo-meta/SKILL.md` 补全 meta 标签
7. 用 `skills/seo-audit/SKILL.md` 做发布前检查
8. 部署，用 `skills/seo-sitemap/SKILL.md` 更新 sitemap.xml
9. 更新 `blog/index.html` 文章列表

## 代码审查流程（每次改动 HTML/CSS/JS 后必做）
> 详见 `skills/code-review/SKILL.md`（allen-site 专用定制版）

**三步走：**
1. **整体扫描**：页面结构、文件位置、有无明显遗漏（2分钟）
2. **逐项检查**：SEO、性能、响应式、可访问性、代码规范、安全（按清单）
3. **SEO 收尾**：跑 seo-audit 脚本，确认 sitemap 已更新（2分钟）

**严重程度：**
- `[阻塞]` — SEO 严重缺失、页面无法显示、敏感信息泄露 → 必须修复才能发布
- `[重要]` — 移动端异常、图片过大 → 建议修复后发布
- `[优化]` — 代码冗余、命名不规范 → 不阻塞发布

## 写作原则
- 有观点，敢判断，不写综述
- 不暴露个人信息，案例用"某项目""某团队"
- 不写医疗相关内容
- 不刻意引流，不堆关键词

## 规范
- 响应式布局，移动端优先
- 版本管理：功能变更打 tag，加文章只 commit
- 图片单张不超过 300KB
- 外链加 `rel="noopener"`
