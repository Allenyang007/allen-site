# allen00.top - Agent 工作指南

## 项目简介
个人网站，纯静态 HTML/CSS/JS。品牌名：**Allen on AI**。定位是个人产品思考与技术理解的沉淀，不是引流工具。

## 目录结构
```
allen-site/
├── index.html          # 首页
├── about/              # 关于页
├── guide/              # AI Agent 深度指南（15702字）
├── blog/               # 博客
│   ├── index.html      # 博客首页
│   ├── BLOG-PLAN.md    # 写作规划（必读）
│   ├── drafts/         # Markdown 初稿
│   ├── references/     # 参考资料
│   ├── skills/         # 博客专用 skills 副本
│   └── [文章目录]/     # 已发布文章
├── skills/             # 全局 skills
├── sitemap.xml         # SEO 站点地图
└── robots.txt
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

---

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

---

## 代码审查规则（每次改动 HTML/CSS/JS 后必做）

### SEO 必检项（每个页面）
- `<title>` 存在，格式：`文章标题 - Allen on AI`
- `<meta name="description">` 存在，70-120 中文字
- `<link rel="canonical">` 存在，URL 末尾有 `/`
- `og:title` / `og:description` / `og:image` / `og:url` 全部存在
- 非首屏图片加 `loading="lazy"`，首屏 hero 图不加
- 所有 `target="_blank"` 外链加 `rel="noopener noreferrer"`
- H1 每页只有一个

### 响应式必检项
- 断点覆盖：1100px / 768px / 640px / 480px
- **固定定位侧边栏（TOC等）**：隐藏断点必须 ≥ 内容区 max-width；内容区 1100px 时，侧边栏在 ≤1100px 隐藏，不能等到 768px
- **padding-left 联动**：侧边栏隐藏时对应的 padding-left 同步移除
- **内容区宽度一致**：所有 section 的 .ctn 宽度统一，不用 max-width 单独限制段落宽度
- **移动端最小字号**：480px 下不低于 11px
- 表格在移动端用 `overflow-x:auto` 横向滚动

### CSS 规范
- 颜色用 CSS 变量，不写硬编码值（如 `#ef4444` → `var(--red)`）
- 相邻断点 padding/字号变化不要超过 30%，必要时补中间断点
- 不在媒体查询里重复全局已有的定义（如 `overflow-x:hidden`）
- 响应式 section padding 参考：默认 96px → 1100px 80px → 768px 60px → 640px 48px → 480px 40px

### 品牌一致性
- 全站导航 logo、footer、title、og:site_name 统一用 **Allen on AI**
- 版权用 `© 2026 Allen`

---

## 变更影响范围检查（必须执行）

每次修改任何内容后，必须检查是否影响其他页面：

### 品牌/文案变更
- 全站搜索替换：`grep -rn "旧内容" allen-site/ --include="*.html"`
- 涉及：导航 logo、footer、title、og 标签、正文引用

### CSS/样式变更
- 检查同一 class 是否在多个页面使用：`grep -rn ".class名" --include="*.html"`
- 共用样式改动必须逐页验证效果

### 响应式断点变更
- 同类页面（如所有博客文章）断点规则要统一
- 改一篇博客的响应式，检查其他博客是否有相同问题并一起修

### 链接/路径变更
- 改了文件路径或目录结构，全站搜索旧路径确认无死链
- sitemap.xml 同步更新

### 新增页面
- 同步更新 sitemap.xml 和 blog/index.html（如是博客）
- 导航链接是否需要更新

**口诀：改一处，查全站，确认无遗漏再 push。**

---

## 版本管理
- 功能变更 → `git commit` + `git tag vX.Y.Z`
- 加文章只 `git commit`，不打 tag
- push 命令：`git push origin main && git push origin --tags`

## 写作原则
- 有观点，敢判断，不写综述
- 不暴露个人信息，案例用「某项目」「某团队」
- 不写医疗相关内容
- 不刻意引流，不堆关键词
- 图片单张不超过 300KB


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

---

## 常见问题与解决方案 (2026-03-08更新)

### 问题1: 博客首页文章不显示
**现象:** 访问/blog/页面空白,但HTML中有post-card元素

**根本原因:**
1. CSS设置`.fade-in{opacity:0}`,需要JavaScript添加`.visible`类才显示
2. 页面初始化只设置了按钮样式,没有调用`filterPosts('all')`
3. 文章默认隐藏,需要JavaScript显示

**解决方案:**
```javascript
// 页面加载时调用
filterPosts('all');  // 而不是只设置 opacity
```

### 问题2: 分类筛选器不工作
**现象:** 点击"产品思考"/"技术博客"无法筛选文章

**根本原因:**
- 筛选器按钮: `filterPosts('thinking')` 和 `filterPosts('tech')`
- 文章标签: `data-category="product"` 和 `data-category="tech"`
- 名称不匹配: `thinking` ≠ `product`

**解决方案:**
统一命名,筛选器改为:
```html
<button onclick="filterPosts('product')">产品思考</button>
<button onclick="filterPosts('tech')">技术博客</button>
```

### 问题3: Stats Bar显示错误
**现象:** 显示"6篇文章"但实际有12篇

**解决方案:**
手动更新stats-bar,移除字数统计:
```html
<div class="stats-bar">
  <div class="stat"><strong>12</strong> 篇文章</div>
  <div class="stat"><strong>6</strong> 个标签</div>
</div>
```

### 问题4: JavaScript语法错误
**现象:** 控制台报错,filterPosts函数有多余的`}else{`

**根本原因:**
多次修改导致代码重复和语法错误

**解决方案:**
完整替换filterPosts函数,确保语法正确

---

## 部署验证增强版

在原有验证基础上,新增:

### JavaScript验证
```bash
# 检查filterPosts函数语法
curl -s https://allen00.top/blog/ | grep -A20 "function filterPosts"

# 检查初始化调用
curl -s https://allen00.top/blog/ | grep "filterPosts('all')"
```

### 功能验证
```bash
# 在浏览器控制台测试
filterPosts('all');    // 应显示12篇
filterPosts('product'); // 应显示产品类文章
filterPosts('tech');    // 应显示技术类文章
```

### 视觉验证
- 页面加载后文章立即可见(不需要滚动触发)
- 点击分类按钮可以正确筛选
- Stats Bar显示正确的文章数量

---

## 项目管理改进建议

### 1. 版本管理规范
- 每次修改前先创建备份分支
- 使用`git tag`标记稳定版本
- 出问题时可以快速回滚: `git checkout v1.7.2`

### 2. 测试流程
- 本地修改后先在开发环境测试
- 使用浏览器开发者工具检查JavaScript错误
- 部署到生产前运行完整验证脚本

### 3. 文档维护
- 每次遇到问题都记录到AGENTS.md
- 更新验证清单,避免重复问题
- 保持AGENTS.md与实际代码同步

### 4. 代码审查
- 修改JavaScript前先备份原函数
- 使用正则替换时要精确匹配
- 避免手动拼接HTML,容易出错
