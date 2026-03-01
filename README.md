# Allen's Tech 个人网站 — allen00.top

## 项目概述
Allen 的个人技术网站，包含首页、AI 指南、博客、工具、关于页面。

## 目录结构
```
allen-site/
├── index.html          # 首页（卡片式布局）
├── README.md           # 本文件
├── package.json
├── favicon.*           # 网站图标
├── guide/              # AI Agent 深度指南
├── blog/               # 博客（详见 blog/BLOG-PLAN.md）
├── about/              # 关于页面
└── preview/            # 预览/测试
```

## 部署
- 域名: allen00.top → 43.153.49.71
- Nginx: root 指向本目录
- HTTPS: Let's Encrypt 自动续期
- 缓存: HTML no-cache, 静态资源 7d

## GitHub
- 仓库: https://github.com/Allenyang007/allen-site
- 本地: /root/.openclaw/workspace/projects/allen-site/

## 博客写作
详见 `blog/BLOG-PLAN.md`，包含已完成和待写文章的完整规划。
