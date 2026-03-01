# SEO Audit Skill

检查 allen00.top 已发布页面的 SEO 健康度，输出问题清单和修复建议。

## 适用场景
- 批量检查所有已发布文章
- 新文章上线前的最终确认
- 定期（每月）全站审查

---

## 检查清单

### 1. Meta 标签检查
| 项目 | 标准 | 检查方法 |
|------|------|---------|
| title | 存在 + 25-35 中文字 + 结尾含 "- Allen" | grep `<title>` |
| description | 存在 + 70-120 中文字 | grep `meta name="description"` |
| canonical | 存在 + URL 正确 + 末尾有 `/` | grep `rel="canonical"` |
| og:title | 存在 | grep `og:title` |
| og:description | 存在 | grep `og:description` |
| og:image | 存在 + 图片文件实际存在 | grep `og:image` + 验证文件 |
| og:url | 存在 + 与 canonical 一致 | grep `og:url` |

### 2. 页面结构检查
| 项目 | 标准 |
|------|------|
| H1 | 每页只有一个 H1，与 title 主题一致 |
| H2/H3 | 有层级结构，不跳级 |
| 图片 alt | 所有 `<img>` 都有 alt 属性，描述图片内容 |
| 内链 | 文章内有指向其他文章或页面的链接 |
| 外链 | 外链加 `rel="noopener"` |

### 3. 性能基础检查
| 项目 | 标准 |
|------|------|
| 图片大小 | 单张不超过 300KB |
| 页面大小 | HTML 文件不超过 200KB |

---

## 操作流程

### 全站批量审查
```bash
# 检查所有文章页的 title
grep -r "<title>" /root/.openclaw/workspace/projects/allen-site/blog/*/index.html

# 检查 description 是否存在
grep -rl 'name="description"' /root/.openclaw/workspace/projects/allen-site/blog/*/index.html

# 找出缺少 canonical 的页面
grep -rL 'rel="canonical"' /root/.openclaw/workspace/projects/allen-site/blog/*/index.html

# 找出缺少 og:image 的页面
grep -rL 'og:image' /root/.openclaw/workspace/projects/allen-site/blog/*/index.html

# 检查图片 alt 缺失
grep -rn '<img ' /root/.openclaw/workspace/projects/allen-site/blog/*/index.html | grep -v 'alt='
```

### 输出报告格式

审查完成后输出如下格式：

```
## SEO 审查报告 — YYYY-MM-DD

### ✅ 通过
- agent-series-01：全部检查通过
- ...

### ⚠️ 需修复
| 页面 | 问题 | 优先级 |
|------|------|--------|
| ai-agent-complete-guide | 缺少 og:image | 高 |
| ai-pm-fundamentals | description 超过 120 字 | 中 |

### 📋 下一步
1. 修复高优先级问题
2. 更新 sitemap.xml 的 lastmod
```

---

## 问题速查

| 问题 | 原因 | 修复方式 |
|------|------|---------|
| title 太长 | 超过 35 字被搜索结果截断 | 精简，保留核心关键词 |
| 无 description | 搜索引擎自动截取正文，效果差 | 用 seo-meta skill 补写 |
| og:image 路径不存在 | 图片未上传或路径写错 | 检查图片文件，修正路径 |
| 多个 H1 | 页面结构混乱，SEO 权重分散 | 只保留一个 H1 |
| 图片无 alt | 搜索引擎无法理解图片内容 | 补写描述性 alt 文本 |
