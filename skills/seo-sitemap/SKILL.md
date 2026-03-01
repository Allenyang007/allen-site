# SEO Sitemap Skill

维护 allen00.top 的 sitemap.xml 和 robots.txt，帮助搜索引擎发现和抓取页面。

## 适用场景
- 新文章上线后，更新 sitemap
- 定期检查 sitemap 是否完整
- 初次生成 robots.txt

---

## 文件位置

| 文件 | 服务器路径 | 访问地址 |
|------|-----------|---------|
| sitemap.xml | `/root/.openclaw/workspace/projects/allen-site/sitemap.xml` | https://allen00.top/sitemap.xml |
| robots.txt | `/root/.openclaw/workspace/projects/allen-site/robots.txt` | https://allen00.top/robots.txt |

---

## sitemap.xml 规范

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

  <!-- 首页 -->
  <url>
    <loc>https://allen00.top/</loc>
    <lastmod>2026-03-01</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>

  <!-- 博客首页 -->
  <url>
    <loc>https://allen00.top/blog/</loc>
    <lastmod>2026-03-01</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>

  <!-- 文章页（每篇文章一个 url 块） -->
  <url>
    <loc>https://allen00.top/blog/文章目录/</loc>
    <lastmod>发布日期 YYYY-MM-DD</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>

  <!-- About 页 -->
  <url>
    <loc>https://allen00.top/about/</loc>
    <lastmod>2026-02-23</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.6</priority>
  </url>

</urlset>
```

### priority 参考
| 页面类型 | priority |
|---------|---------|
| 首页 | 1.0 |
| 博客首页 | 0.9 |
| 文章页 | 0.8 |
| About | 0.6 |

---

## robots.txt 规范

```
User-agent: *
Allow: /

Sitemap: https://allen00.top/sitemap.xml
```

简单允许全部抓取，Sitemap 地址声明。

---

## 操作流程

### 新文章上线后
1. 读取现有 `sitemap.xml`
2. 在 `</urlset>` 前插入新文章的 `<url>` 块
3. 更新博客首页的 `<lastmod>` 为今天日期
4. 保存，通过 git push 部署到服务器

### 当前已收录页面（截至 2026-03-01）

```
https://allen00.top/
https://allen00.top/about/
https://allen00.top/blog/
https://allen00.top/blog/ai-agent-complete-guide/
https://allen00.top/blog/ai-pm-fundamentals/
https://allen00.top/blog/agent-series-01/
https://allen00.top/blog/agent-series-02/
https://allen00.top/blog/agent-series-03/
https://allen00.top/blog/agent-series-04/
```

### 提交给搜索引擎（手动，偶尔做）
- Google Search Console：https://search.google.com/search-console
- 提交 sitemap URL：https://allen00.top/sitemap.xml
