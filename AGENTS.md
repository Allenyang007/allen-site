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

---

## 博客发布细节检查清单 (必须执行)

### 发布前检查

#### 1. 文章分类验证
```bash
# 检查所有文章的分类统计
curl -s https://allen00.top/blog/ | grep 'data-category=' | grep -o 'data-category="[^"]*"' | sort | uniq -c

# 验证总数
curl -s https://allen00.top/blog/ | grep -c 'data-category='
```

**要求:**
- 只能有两种分类: `product` 和 `tech`
- 不能有 `thinking` 或其他分类
- 产品思考 + 技术博客 = 总文章数

#### 2. Stats Bar验证
```bash
curl -s https://allen00.top/blog/ | grep -A2 '<div class="stats-bar">'
```

**要求:**
- 只显示文章总数,不显示字数
- 不显示标签数
- 格式: `<strong>N</strong> 篇文章`

#### 3. 分类筛选按钮验证
```bash
curl -s https://allen00.top/blog/ | grep "filter-btn"
```

**要求:**
- 三个按钮: 全部/产品思考/技术博客
- 使用 `.filter-btn` 和 `.active` 类
- 选中状态有明显视觉区分(绿色背景)

#### 4. 文章日期验证
```bash
curl -s https://allen00.top/blog/ | grep "📅" | head -12
```

**要求:**
- 新发布的多篇文章日期要分散(不能都是同一天)
- 按日期倒序排列(最新的在前)
- 日期格式: YYYY-MM-DD

#### 5. JavaScript功能验证
```bash
# 检查filterPosts函数
curl -s https://allen00.top/blog/ | grep -A20 "function filterPosts"

# 检查初始化
curl -s https://allen00.top/blog/ | grep "filterPosts('all')"
```

**要求:**
- 页面加载时调用 `filterPosts('all')`
- 使用 `.active` 类标记选中按钮
- 无JavaScript语法错误

### 发布后验证

#### 浏览器功能测试
1. 访问 https://allen00.top/blog/
2. 检查文章是否全部显示(不是空白页)
3. 点击"产品思考"按钮,验证筛选结果
4. 点击"技术博客"按钮,验证筛选结果
5. 点击"全部"按钮,验证显示所有文章
6. 检查选中按钮是否有绿色高亮

#### 响应式测试
- 桌面端(>1100px): 正常布局
- 平板端(768-1100px): 正常布局
- 手机端(<768px): 正常布局,筛选按钮换行

### 常见错误及修复

#### 错误1: 文章分类不匹配
**现象:** 点击筛选按钮后文章数量不对

**检查:**
```bash
# 找出所有分类
curl -s https://allen00.top/blog/ | grep 'data-category=' | grep -o 'data-category="[^"]*"' | sort -u
```

**修复:** 将所有 `thinking` 改为 `product` 或 `tech`

#### 错误2: 筛选按钮无视觉反馈
**现象:** 点击按钮后没有高亮效果

**检查:**
```bash
# 检查是否有.active样式
curl -s https://allen00.top/blog/ | grep "\.filter-btn\.active"
```

**修复:** 确保CSS中有 `.filter-btn.active` 样式定义

#### 错误3: 文章不显示
**现象:** 页面空白,但HTML中有post-card

**检查:**
```bash
# 检查fade-in初始化
curl -s https://allen00.top/blog/ | grep "filterPosts('all')"
```

**修复:** 确保页面加载时调用 `filterPosts('all')`

---

## 文章分类规范

### 分类定义

**product (产品思考):**
- 产品设计方法论
- 产品经理技能
- 产品决策思考
- 跨行业产品经验

**tech (技术博客):**
- 技术架构分析
- 工具使用指南
- 技术原理解析
- 实战操作教程

### 分类判断标准

**优先看内容主题:**
- 如果主要讲"怎么做产品决策" → product
- 如果主要讲"技术如何实现" → tech
- 如果既有产品又有技术,看哪个占比更大

**示例:**
- "AI产品和传统软件的思维断层" → product (产品思维)
- "RAG解决了什么问题" → tech (技术原理)
- "产品经理需要懂大模型原理吗" → product (产品视角)
- "Prompt不是魔法咒语,是需求文档" → tech (技术应用)

### 禁止使用的分类
- ❌ `thinking` (已废弃,统一改为product或tech)
- ❌ `default` (必须明确分类)
- ❌ 自定义分类 (只能用product和tech)

---

## 部署流程完整版 (v1.7.4)

### 1. 写作阶段
1. 读 BLOG-PLAN.md 确认文章规划
2. 在 drafts/ 写Markdown初稿
3. 用 humanizer 去AI味
4. 转HTML (基于_article-template.html)
5. SEO优化 (meta标签)

### 2. 分类与日期
6. **确定文章分类** (product或tech)
7. **设置发布日期** (多篇文章要分散日期)

### 3. 更新首页
8. 在 blog/index.html 正确位置插入文章卡片
9. 设置正确的 `data-category`
10. 更新 stats-bar 文章总数

### 4. 部署
11. 同步到生产环境
12. 更新 sitemap.xml
13. Git commit + tag

### 5. 验证 (必须执行)
14. 运行分类验证脚本
15. 检查stats-bar显示
16. 测试筛选按钮功能
17. 浏览器实际测试
18. 响应式布局测试

### 6. 文档
19. 更新 BLOG-PLAN.md 已发布列表
20. 记录到 memory/YYYY-MM-DD.md

---

## 自动化验证脚本

创建 `/root/.openclaw/workspace/projects/allen-site/blog/verify-blog.sh`:

```bash
#!/bin/bash
echo "=========================================="
echo "博客发布验证"
echo "=========================================="
echo ""

# 1. 分类统计
echo "【1】文章分类统计"
curl -s https://allen00.top/blog/ | grep 'data-category=' | grep -o 'data-category="[^"]*"' | sort | uniq -c
total=$(curl -s https://allen00.top/blog/ | grep -c 'data-category=')
echo "总计: $total 篇"
echo ""

# 2. Stats Bar
echo "【2】Stats Bar"
curl -s https://allen00.top/blog/ | grep -A2 '<div class="stats-bar">'
echo ""

# 3. 筛选按钮
echo "【3】筛选按钮"
curl -s https://allen00.top/blog/ | grep "filter-btn" | grep -o 'id="filter-[^"]*"'
echo ""

# 4. JavaScript初始化
echo "【4】JavaScript初始化"
curl -s https://allen00.top/blog/ | grep "filterPosts('all')" && echo "✅ 初始化正常" || echo "❌ 初始化缺失"
echo ""

# 5. 文章可见性
echo "【5】文章标题(前6篇)"
curl -s https://allen00.top/blog/ | grep -o "<h2>.*</h2>" | head -6 | nl
echo ""

echo "=========================================="
echo "验证完成"
echo "=========================================="
```

使用方法:
```bash
chmod +x /root/.openclaw/workspace/projects/allen-site/blog/verify-blog.sh
/root/.openclaw/workspace/projects/allen-site/blog/verify-blog.sh
```


---

## 2026-03-08 部署经验总结

### 本次部署遇到的8个问题

1. **博客首页空白** - JavaScript初始化缺失
2. **文章分类不匹配** - thinking/product/tech混用
3. **Stats Bar显示错误** - 未更新统计数字
4. **文章日期都是同一天** - 未分散日期
5. **筛选按钮样式反复修改** - 未本地预览
6. **文章页面右侧空白** - max-width设置不当
7. **文章标题错误** - HTML生成时内容混乱
8. **移动端左侧大量空白** - padding未移除

详细记录见: `ISSUES-TRACKING.md`

### 强制执行的规则(2026-03-08更新)

#### 规则1: 本地预览优先
```bash
# 启动本地服务器
cd /root/.openclaw/workspace/projects/allen-site
python3 -m http.server 8000 &

# 浏览器访问 http://localhost:8000/blog/
# 确认无误后再部署
```

#### 规则2: 验证脚本必跑
```bash
# 发布前必须运行
./blog/verify-blog.sh

# 所有检查项必须通过
```

#### 规则3: 样式决策一次到位
- 参考现有页面的样式
- 在本地预览中确认效果
- 不要发布后再反复调整

#### 规则4: 文档先行
- 新功能先写文档
- 按文档执行
- 执行后更新文档

### 文章分类规范(强制)

**只允许两种分类:**
- `product` - 产品思考
- `tech` - 技术博客

**禁止使用:**
- ❌ `thinking` (已废弃)
- ❌ `default` (必须明确分类)
- ❌ 任何自定义分类

**检查方法:**
```bash
# 检查是否有非法分类
curl -s https://allen00.top/blog/ | grep 'data-category=' | grep -o 'data-category="[^"]*"' | sort -u

# 应该只输出:
# data-category="product"
# data-category="tech"
```

### 移动端适配规范(强制)

**响应式断点:**
- 1100px: TOC隐藏,padding改为对称
- 768px: 汉堡菜单,字号缩小
- 480px: 最小屏幕,进一步优化

**关键规则:**
- TOC隐藏时,必须移除padding-left
- 所有padding必须对称(上右下左)
- 最小字号不低于11px

**检查方法:**
```bash
# 检查移动端padding
curl -s https://allen00.top/blog/[article]/ | grep -A2 "@media(max-width:1100px)" | grep "padding"

# 应该是对称的,如: padding:88px 24px 60px 24px
```

### HTML生成规范(避免内容混乱)

**问题:** 生成HTML时可能混入其他文章的标题/描述

**预防措施:**
1. 使用统一的模板文件
2. 每次只生成一篇文章
3. 生成后立即检查H1标题和subtitle
4. 不要批量替换,容易出错

**检查方法:**
```bash
# 检查文章标题是否正确
curl -s https://allen00.top/blog/[article]/ | grep "<h1>" | grep -o ">.*<"

# 对比Markdown源文件的标题
head -10 blog/drafts/draft-[article].md | grep "^# "
```

### 样式规范(避免反复修改)

**筛选按钮样式(最终版):**
```css
.filter-btn.active{
  background:linear-gradient(135deg,var(--accent-green),var(--accent-blue));
  color:#fff;
  border-color:transparent;
  box-shadow:0 2px 8px rgba(34,197,94,0.3)
}
```

**原则:**
- 使用主题色(绿色/蓝色渐变)
- 与页面整体风格协调
- 有明显的选中状态区分

### 部署检查清单(完整版)

#### 阶段1: 发布前(本地)
```bash
# 1. 启动本地服务器
python3 -m http.server 8000 &

# 2. 浏览器预览
# http://localhost:8000/blog/

# 3. 检查清单
- [ ] 文章列表显示正常
- [ ] 筛选按钮功能正常
- [ ] 筛选按钮样式协调
- [ ] Stats Bar数字正确
- [ ] 文章分类正确(只有product/tech)
- [ ] 文章日期已分散
- [ ] 随机点开3篇文章检查内容
- [ ] 文章标题正确
- [ ] 文章内页无空白
- [ ] 移动端预览正常(F12设备模拟)

# 4. 运行验证脚本
./blog/verify-blog.sh
```

#### 阶段2: 部署
```bash
# 1. 同步到生产
rsync -av --delete \
  --exclude='.git' --exclude='node_modules' --exclude='drafts' \
  /root/.openclaw/workspace/projects/allen-site/ \
  /var/www/allen-site/

# 2. 重载nginx
systemctl reload nginx

# 3. Git提交
git add .
git commit -m "类型: 简述"
git tag -a vX.Y.Z -m "版本说明"
git push origin main --tags
```

#### 阶段3: 发布后验证
```bash
# 1. 运行线上验证
./blog/verify-blog.sh

# 2. 浏览器测试
- [ ] 访问 https://allen00.top/blog/
- [ ] 测试筛选功能(全部/产品/技术)
- [ ] 随机点开3篇文章
- [ ] 移动端测试(375px/768px/1024px)

# 3. 问题记录
# 如有问题立即记录到ISSUES-TRACKING.md
```

### 常用命令速查

```bash
# 启动本地服务器
cd /root/.openclaw/workspace/projects/allen-site && python3 -m http.server 8000 &

# 验证博客
./blog/verify-blog.sh

# 同步到生产
rsync -av --delete --exclude='.git' --exclude='node_modules' --exclude='drafts' \
  /root/.openclaw/workspace/projects/allen-site/ /var/www/allen-site/

# 重载nginx
systemctl reload nginx

# 检查文章分类
curl -s https://allen00.top/blog/ | grep 'data-category=' | grep -o 'data-category="[^"]*"' | sort | uniq -c

# 检查移动端padding
curl -s https://allen00.top/blog/[article]/ | grep -A2 "@media(max-width:1100px)"
```

---

## 博客发布规范化流程 (2026-03-08 更新)

### 强制执行的质量保证流程

基于实际部署经验,建立10阶段检查清单,避免反复修改和低级错误。

#### 阶段1: 内容准备 (Markdown)

```bash
# 验证Markdown文件
cat blog/drafts/draft-xxx.md | head -30

# 必检项:
✓ 标题使用中文破折号"——"(不是英文--)
✓ description简洁(不超过100字)
✓ 日期格式YYYY-MM-DD
✓ 没有多余的引言段落
✓ 章节结构清晰
✓ 没有"三堵墙"等不需要的内容
```

#### 阶段2: HTML生成

**方法1: 使用subagent (推荐)**
```bash
# 派发给subagent生成
sessions_spawn(
  task="从Markdown生成HTML",
  runtime="subagent"
)
```

**方法2: 手动转换**
- 使用已有文章作为模板
- 替换标题、内容、TOC
- 确保UTF-8编码

#### 阶段3: 内容验证 (必须)

```bash
cd blog/[article-name]

# 1. 检查H1标题
grep "<h1>" index.html
# 必须: 标题正确,无乱码

# 2. 检查subtitle
grep "subtitle" index.html
# 必须: 无结果(除非明确需要)

# 3. 检查meta description
grep "meta name=\"description\"" index.html
# 必须: 简洁或无

# 4. 检查章节数
grep -c "<h2" index.html
# 必须: 与Markdown一致

# 5. 检查编码
file index.html
# 必须: UTF-8 Unicode text

# 6. 检查特殊字符
grep "——" index.html | cat -A
# 必须: 无乱码(M-开头的字符)
```

#### 阶段4: 布局验证

```bash
# 检查响应式断点
grep "@media" index.html | grep -o "max-width:[0-9]*px"

# 必检项:
✓ 有1100px断点(TOC隐藏)
✓ 有768px断点(移动端)
✓ 有480px断点(小屏幕)
✓ 移动端padding对称(88px 24px 60px 24px)
✓ 桌面端max-width: 900px
```

#### 阶段5: 本地预览 (必须)

```bash
# 启动本地服务器
cd /root/.openclaw/workspace/projects/allen-site
python3 -m http.server 8000 &

# 浏览器访问: http://localhost:8000/blog/[article-name]/

# 必检项:
✓ 标题显示正确
✓ 内容完整无混乱
✓ TOC可点击跳转
✓ F12切换移动端模式(375px/768px/1024px)
✓ 深色模式正常
✓ 无JavaScript错误
```

#### 阶段6: 质量检查脚本

```bash
# 运行自动化检查
cd blog
./qa-check.sh [article-name]

# 脚本会检查:
- 文件编码
- 标题乱码
- subtitle
- meta标签
- 章节数量
- 响应式断点
- 不该有的内容
```

#### 阶段7: 部署到生产

```bash
cd /root/.openclaw/workspace/projects/allen-site

# 1. 先pull最新代码
git pull

# 2. 同步文件
rsync -av blog/[article-name]/ /var/www/allen-site/blog/[article-name]/

# 3. 重启nginx (不是reload!)
systemctl restart nginx

# 4. 等待生效
sleep 2
```

#### 阶段8: 线上验证 (必须)

```bash
URL="https://allen00.top/blog/[article-name]/"

# 1. 检查HTTP状态
curl -I $URL | grep "200 OK"

# 2. 检查H1标题
curl -s $URL | grep "<h1>" | sed 's/<[^>]*>//g'

# 3. 检查文件大小
curl -s $URL | wc -c

# 4. 检查乱码
curl -s $URL | grep "M-" && echo "❌ 有乱码!" || echo "✅ 无乱码"

# 5. 检查不该有的内容
curl -s $URL | grep "我见过不少" && echo "⚠️ 有引言" || echo "✅ 正常"
```

#### 阶段9: 浏览器验证 (必须)

```
1. 打开无痕窗口 (Ctrl+Shift+N)
2. 访问文章URL
3. 检查标题、内容、布局
4. F12切换移动端模式
5. 测试375px/768px/1024px
6. 检查深色模式
7. 点击TOC链接测试
```

#### 阶段10: Git提交

```bash
cd /root/.openclaw/workspace/projects/allen-site

git add blog/[article-name]/
git commit -m "feat: 新增文章 [标题]

- 内容: [简述]
- 字数: [约XXX字]
- 分类: product/tech
- 日期: YYYY-MM-DD"

git push origin main

# 打tag
git tag -a v1.x.x -m "新增文章: [标题]"
git push origin --tags
```

---

## 常见问题及解决方案

### 问题1: 标题显示乱码

**现象:** 中文破折号"——"显示为M-eM-$M-'等乱码

**原因:** 文件编码不是UTF-8

**解决:**
```bash
# 检查编码
file index.html

# 如果不是UTF-8,重新生成
# Python脚本必须指定encoding='utf-8'
```

### 问题2: 删除内容不生效

**现象:** 多次删除某段内容,浏览器仍显示

**原因:** 浏览器缓存或nginx缓存

**解决:**
```bash
# 1. 重启nginx(不是reload)
systemctl restart nginx

# 2. 告诉用户强制刷新
# Ctrl+Shift+R (Windows)
# Cmd+Shift+R (Mac)

# 3. 或使用无痕模式验证
```

### 问题3: 移动端布局很窄

**现象:** 桌面端正常,移动端内容区域很窄,左右大量空白

**原因:** TOC隐藏后padding-left没有移除

**解决:**
```bash
# 检查1100px断点的padding
grep -A5 "@media(max-width:1100px)" index.html

# 必须是对称的:
# padding: 88px 24px 60px 24px
# 不能是: padding: 88px 24px 60px 260px
```

### 问题4: 文章内容混乱

**现象:** HTML中混入其他文章的标题或内容

**原因:** 从备份恢复时没有验证,或正则表达式匹配错误

**解决:**
```bash
# 不要盲目相信备份文件
# 部署前必须验证H1标题
grep "<h1>" index.html

# 如果错误,从Markdown重新生成
```

### 问题5: Git推送失败

**现象:** `! [rejected] main -> main (fetch first)`

**原因:** 远程有新提交,本地和远程不一致

**解决:**
```bash
git pull --rebase
git push origin main
```

---

## 10条核心原则 (必须遵守)

1. **不要相信工具输出,要验证实际结果**
   - 工具说"已删除",不代表真的删除了
   - 必须用grep/curl验证

2. **部署后必须重启nginx,不是reload**
   - `systemctl restart nginx`
   - 不是`systemctl reload nginx`

3. **用户说"还在"就是真的还在**
   - 不要争辩"我这边没有"
   - 立即检查线上文件

4. **所有文件操作指定UTF-8编码**
   - Python: `open(file, 'r', encoding='utf-8')`
   - 避免乱码问题

5. **正则表达式用非贪婪匹配**
   - 用`.*?`不用`.*`
   - 明确指定结束标记

6. **移动端必须测试**
   - F12设备模拟
   - 测试375px/768px/1024px

7. **本地预览是必须的,不是可选的**
   - `python3 -m http.server 8000`
   - 部署前必须在浏览器中检查

8. **Git操作前先pull**
   - `git pull`
   - 避免冲突

9. **删除后立即验证**
   - `grep -c "删除的内容" file`
   - 确认结果为0

10. **不要反复修改同一个问题,一次做对**
    - 理解需求
    - 验证结果
    - 不要说10次"已删除"

---

## 快速命令参考

```bash
# 质量检查
./blog/qa-check.sh [article-name]

# 本地预览
python3 -m http.server 8000 &

# 部署
rsync -av blog/[article]/ /var/www/allen-site/blog/[article]/
systemctl restart nginx

# 验证
curl -s https://allen00.top/blog/[article]/ | grep "<h1>"

# 博客首页验证
./blog/verify-blog.sh
```

---

## 相关文档

- **Blog QA Skill**: `blog/skills/blog-qa/SKILL.md` - 完整的问题总结和解决方案
- **质量检查脚本**: `blog/qa-check.sh` - 自动化验证工具
- **博客验证脚本**: `blog/verify-blog.sh` - 首页验证工具
- **写作规划**: `blog/BLOG-PLAN.md` - 文章规划和写作原则

---

## 🚨 关键注意事项 (必须遵守)

### 1. 移动端适配 (最高优先级)

**问题:** 移动端内容区域很窄,左右大量空白

**原因:** padding-left还是260px(桌面端TOC宽度),在移动端没有改为对称

**解决:**
```css
/* 桌面端 (>1100px) */
.article-layout { padding: 88px 24px 60px 260px; }

/* 移动端 (<1100px) - 必须对称! */
@media(max-width:1100px) {
  .article-layout { padding: 88px 24px 60px 24px; }  /* 不是260px! */
}
```

**强制检查:**
- 每次发布前F12测试移动端(375px/768px/1024px)
- 检查padding: `grep -A5 "@media(max-width:1100px)" index.html | grep padding`
- 如果看到260px立即修复: `sed -i 's/padding:88px 24px 60px 260px/padding:88px 24px 60px 24px/g' index.html`

### 2. 网站风格统一

**必须保持一致的元素:**
- CSS变量: var(--bg), var(--text), var(--primary)
- 深色模式: data-theme="dark"
- 字体: -apple-system, BlinkMacSystemFont, "Segoe UI"
- 主色调: #2563eb (蓝色)
- 圆角: 12px
- 阴影: 0 2px 8px rgba(0,0,0,0.1)
- 导航栏样式
- TOC样式
- 代码块样式
- 链接hover效果

**检查方法:**
```bash
# 对比导航栏
diff <(grep -A10 "class=\"nav\"" blog/index.html) \
     <(grep -A10 "class=\"nav\"" blog/[article]/index.html)

# 检查CSS变量
grep "var(--" blog/[article]/index.html | head -5
```

### 3. 博客首页同步更新 (必须!)

**每次发布新文章必须更新:**
1. 添加文章卡片(放在最前面)
2. 更新文章总数
3. 更新分类统计
4. 测试筛选功能

**文章卡片模板:**
```html
<article class="blog-card" data-category="product" data-date="2026-03-08">
  <div class="card-header">
    <span class="category-tag product">产品思考</span>
    <span class="date">2026-03-08</span>
  </div>
  <h2><a href="/blog/[article]/">文章标题</a></h2>
  <p class="excerpt">文章摘要...</p>
  <div class="card-footer">
    <span>📖 8 分钟阅读</span>
  </div>
</article>
```

**验证:**
```bash
# 检查新文章是否在首页
curl -s https://allen00.top/blog/ | grep "[article]"

# 检查文章总数
grep -c "class=\"blog-card\"" blog/index.html
```

### 4. 发布前后版本对比

**部署前:**
```bash
# 1. 检查本地文件
ls -lh blog/[article]/index.html

# 2. 如果是更新,对比线上版本
diff <(curl -s https://allen00.top/blog/[article]/ | grep "<h1>") \
     <(grep "<h1>" blog/[article]/index.html)
```

**部署后:**
```bash
# 1. HTTP状态
curl -I https://allen00.top/blog/[article]/ | grep "200 OK"

# 2. H1标题
curl -s https://allen00.top/blog/[article]/ | grep "<h1>" | sed 's/<[^>]*>//g'

# 3. 章节数量
curl -s https://allen00.top/blog/[article]/ | grep -c "<h2"

# 4. 无乱码
curl -s https://allen00.top/blog/[article]/ | grep "M-" && echo "❌ 有乱码" || echo "✅ 无乱码"

# 5. 浏览器验证(无痕模式)
# - 访问文章URL
# - F12测试移动端
# - 检查首页
```

### 5. 相关文件一起更新

**每次发布必须更新:**
- `blog/[article]/index.html` - 文章本身
- `blog/index.html` - 博客首页(添加卡片)
- `sitemap.xml` - SEO(添加URL)
- `blog/BLOG-PLAN.md` - 规划文档(更新状态)

**可选更新:**
- `README.md` - 如果提到文章列表
- `about/index.html` - 如果提到文章数量

**部署命令:**
```bash
# 同步所有相关文件
rsync -av blog/[article]/ /var/www/allen-site/blog/[article]/
rsync -av blog/index.html /var/www/allen-site/blog/
rsync -av sitemap.xml /var/www/allen-site/

# 重启nginx
systemctl restart nginx
```

---

## 📋 发布检查清单 (打印使用)

每次发布新文章时,逐项勾选:

```
□ 1. 内容完整(严格按照MD)
□ 2. H1标题正确无乱码
□ 3. Meta标签正确
□ 4. 响应式断点完整(1100/768/480)
□ 5. 移动端padding对称(无260px) ⚠️
□ 6. F12测试移动端(375/768/1024) ⚠️
□ 7. CSS变量和风格统一 ⚠️
□ 8. 深色模式正常
□ 9. 博客首页已更新 ⚠️
□ 10. 文章卡片已添加
□ 11. 统计数据已更新
□ 12. sitemap.xml已更新 ⚠️
□ 13. 本地预览正常
□ 14. 部署到生产
□ 15. 重启nginx(不是reload)
□ 16. 线上验证(curl) ⚠️
□ 17. 浏览器验证(无痕) ⚠️
□ 18. 移动端实测 ⚠️
□ 19. Git提交(清理备份)
□ 20. 打版本tag
```

⚠️ = 最容易遗漏的步骤

---

## 🔗 相关文档

- **完整检查清单**: `blog/skills/blog-publish-checklist/SKILL.md`
- **质量检查**: `blog/skills/blog-qa/SKILL.md`
- **代码审查**: `blog/skills/blog-code-review/SKILL.md`
- **质量检查脚本**: `blog/qa-check.sh`
- **代码审查脚本**: `blog/code-review.sh`
