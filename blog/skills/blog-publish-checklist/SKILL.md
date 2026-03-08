# Blog 发布前完整检查清单

## 目的
确保新文章发布时,所有相关内容都正确更新,移动端适配完整,风格统一,避免遗漏任何步骤。

---

## 强制检查项 (每项必须通过)

### 1. 文章内容检查

#### 1.1 内容完整性
- [ ] 严格按照MD源文件生成,不添加不删除
- [ ] 所有章节都在(对比MD的H2数量)
- [ ] 引言段落(如果MD中有)
- [ ] 结尾段落完整
- [ ] 没有混入其他文章的内容

**验证命令:**
```bash
# 检查H2数量
grep -c "<h2" blog/[article]/index.html

# 对比MD文件
grep "^## " blog/drafts/draft-[article].md | wc -l
```

#### 1.2 标题和Meta
- [ ] H1标题正确,使用中文破折号"——"
- [ ] 没有乱码(M-开头的字符)
- [ ] Meta description简洁(不超过160字符)
- [ ] 日期正确(YYYY-MM-DD)
- [ ] 阅读时间合理(根据字数计算)

**验证命令:**
```bash
# 检查H1
grep "<h1>" blog/[article]/index.html | sed 's/<[^>]*>//g'

# 检查乱码
grep "<h1>" blog/[article]/index.html | cat -A | grep "M-"

# 检查meta
grep "meta name=\"description\"" blog/[article]/index.html
```

### 2. 移动端适配检查 (必须)

#### 2.1 响应式断点
- [ ] 1100px断点存在(TOC隐藏)
- [ ] 768px断点存在(移动端)
- [ ] 480px断点存在(小屏幕)

**验证命令:**
```bash
grep "@media(max-width:1100px)" blog/[article]/index.html
grep "@media(max-width:768px)" blog/[article]/index.html
grep "@media(max-width:480px)" blog/[article]/index.html
```

#### 2.2 移动端Padding (关键!)
- [ ] 1100px以下: padding对称 (88px 24px 60px 24px)
- [ ] 768px以下: padding对称 (80px 20px 48px 20px)
- [ ] 480px以下: padding对称 (76px 16px 40px 16px)
- [ ] **绝对不能是**: padding: 88px 24px 60px 260px (这会导致移动端很窄)

**验证命令:**
```bash
# 检查1100px断点的padding
grep -A5 "@media(max-width:1100px)" blog/[article]/index.html | grep "article-layout" | grep "padding"

# 如果看到260px,立即修复:
sed -i 's/padding:88px 24px 60px 260px/padding:88px 24px 60px 24px/g' blog/[article]/index.html
```

#### 2.3 移动端实际测试 (必须!)
- [ ] F12打开开发者工具
- [ ] 切换到设备模拟模式
- [ ] 测试375px (iPhone SE)
- [ ] 测试768px (iPad)
- [ ] 测试1024px (iPad Pro)
- [ ] 检查内容区域宽度正常,无大量空白
- [ ] TOC在移动端隐藏
- [ ] 导航菜单在移动端正常

**常见问题:**
- 移动端内容区域很窄,左右大量空白 → padding-left还是260px
- 文字溢出屏幕 → 缺少word-break
- 图片超出容器 → 缺少max-width:100%

### 3. 网站风格统一检查

#### 3.1 设计系统一致性
- [ ] 使用CSS变量(var(--bg), var(--text), var(--primary)等)
- [ ] 深色模式支持(data-theme="dark")
- [ ] 字体: -apple-system, BlinkMacSystemFont, "Segoe UI"
- [ ] 主色调: #2563eb (蓝色)
- [ ] 圆角: 12px
- [ ] 阴影: 0 2px 8px rgba(0,0,0,0.1)

**验证命令:**
```bash
# 检查CSS变量
grep "var(--" blog/[article]/index.html | head -5

# 检查深色模式
grep "data-theme" blog/[article]/index.html
```

#### 3.2 组件风格一致
- [ ] 导航栏样式与首页一致
- [ ] 面包屑样式统一
- [ ] TOC样式统一
- [ ] 代码块样式统一
- [ ] 链接hover效果一致
- [ ] 按钮样式一致

**对比检查:**
```bash
# 对比导航栏
diff <(grep -A10 "class=\"nav\"" blog/index.html) \
     <(grep -A10 "class=\"nav\"" blog/[article]/index.html)
```

#### 3.3 排版规范
- [ ] 段落间距: 1.5em
- [ ] 行高: 1.8
- [ ] 标题层级清晰(H1>H2>H3)
- [ ] 列表缩进统一
- [ ] 引用块样式统一
- [ ] 代码块有语法高亮

### 4. 博客首页更新 (必须!)

#### 4.1 添加文章卡片
- [ ] 在 `blog/index.html` 中添加新文章
- [ ] 卡片位置: 放在最前面(最新文章)
- [ ] 标题正确
- [ ] 日期正确
- [ ] 分类标签正确(product/tech)
- [ ] 链接正确(/blog/[article]/)

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

#### 4.2 更新统计数据
- [ ] 文章总数 +1
- [ ] 分类统计更新(product/tech)
- [ ] "全部"筛选器数量更新

**验证命令:**
```bash
# 检查文章总数
grep -c "class=\"blog-card\"" blog/index.html

# 检查新文章是否在首页
grep "[article]" blog/index.html
```

#### 4.3 测试筛选功能
- [ ] 点击"全部"显示所有文章
- [ ] 点击"产品思考"只显示product类
- [ ] 点击"技术深度"只显示tech类
- [ ] 新文章在对应分类中显示

### 5. 线上版本对比检查

#### 5.1 部署前对比
```bash
# 1. 检查本地文件
ls -lh blog/[article]/index.html

# 2. 检查线上文件(如果已存在)
curl -I https://allen00.top/blog/[article]/

# 3. 对比内容(如果是更新)
diff <(curl -s https://allen00.top/blog/[article]/ | grep "<h1>") \
     <(grep "<h1>" blog/[article]/index.html)
```

#### 5.2 部署后验证
```bash
# 1. HTTP状态
curl -I https://allen00.top/blog/[article]/ | grep "200 OK"

# 2. H1标题
curl -s https://allen00.top/blog/[article]/ | grep "<h1>" | sed 's/<[^>]*>//g'

# 3. 文件大小
curl -s https://allen00.top/blog/[article]/ | wc -c

# 4. 无乱码
curl -s https://allen00.top/blog/[article]/ | grep "M-" && echo "❌ 有乱码" || echo "✅ 无乱码"

# 5. 章节数量
curl -s https://allen00.top/blog/[article]/ | grep -c "<h2"
```

#### 5.3 浏览器实际验证 (必须!)
- [ ] 打开无痕窗口(避免缓存)
- [ ] 访问文章URL
- [ ] 检查标题、内容、布局
- [ ] F12切换移动端模式
- [ ] 测试375px/768px/1024px
- [ ] 检查深色模式
- [ ] 点击TOC链接测试
- [ ] 检查导航栏
- [ ] 检查面包屑

### 6. 相关文件同步更新

#### 6.1 必须更新的文件
- [ ] `blog/index.html` - 添加文章卡片
- [ ] `sitemap.xml` - 添加新URL
- [ ] `blog/BLOG-PLAN.md` - 更新已发布列表

#### 6.2 可选更新的文件
- [ ] `README.md` - 更新文章列表
- [ ] `about/index.html` - 如果提到文章数量

**sitemap.xml更新:**
```xml
<url>
  <loc>https://allen00.top/blog/[article]/</loc>
  <lastmod>2026-03-08</lastmod>
  <changefreq>monthly</changefreq>
  <priority>0.8</priority>
</url>
```

### 7. Git提交规范

#### 7.1 提交前检查
- [ ] 所有相关文件都已添加
- [ ] 没有遗漏的修改
- [ ] 备份文件已删除或加入.gitignore
- [ ] commit message清晰

**检查命令:**
```bash
# 查看所有修改
git status

# 查看具体改动
git diff

# 查看暂存区
git diff --cached
```

#### 7.2 Commit Message规范
```
feat: 新增文章 [标题]

- 内容: [简述]
- 字数: [约XXX字]
- 分类: product/tech
- 日期: YYYY-MM-DD
- 更新: 博客首页 + sitemap
```

#### 7.3 打版本tag
```bash
# 新增文章打minor版本
git tag -a v1.x.0 -m "新增文章: [标题]"

# 修复文章打patch版本
git tag -a v1.x.y -m "修复: [问题描述]"

git push origin --tags
```

---

## 完整发布流程 (按顺序执行)

### 阶段1: 准备
```bash
cd /root/.openclaw/workspace/projects/allen-site

# 1. 确认MD源文件
cat blog/drafts/draft-[article].md | head -30

# 2. 生成HTML
# (使用subagent或手动)

# 3. 质量检查
./blog/qa-check.sh [article]

# 4. 代码审查
./blog/code-review.sh [article]
```

### 阶段2: 移动端测试 (必须!)
```bash
# 1. 启动本地服务器
python3 -m http.server 8000 &

# 2. 浏览器访问
# http://localhost:8000/blog/[article]/

# 3. F12设备模拟
# - 测试375px/768px/1024px
# - 检查padding是否对称
# - 检查TOC是否隐藏
# - 检查内容区域宽度

# 4. 如果移动端很窄,修复padding
sed -i 's/padding:88px 24px 60px 260px/padding:88px 24px 60px 24px/g' blog/[article]/index.html
```

### 阶段3: 更新相关文件
```bash
# 1. 更新博客首页
vim blog/index.html
# - 添加文章卡片(最前面)
# - 更新文章总数

# 2. 更新sitemap
vim sitemap.xml
# - 添加新URL

# 3. 更新BLOG-PLAN
vim blog/BLOG-PLAN.md
# - 移动到"已发布"列表
```

### 阶段4: 部署
```bash
# 1. 同步到生产
rsync -av blog/[article]/ /var/www/allen-site/blog/[article]/
rsync -av blog/index.html /var/www/allen-site/blog/
rsync -av sitemap.xml /var/www/allen-site/

# 2. 重启nginx (不是reload!)
systemctl restart nginx

# 3. 等待生效
sleep 2
```

### 阶段5: 线上验证
```bash
# 1. 检查文章
curl -s https://allen00.top/blog/[article]/ | grep "<h1>"

# 2. 检查首页
curl -s https://allen00.top/blog/ | grep "[article]"

# 3. 浏览器验证(无痕模式)
# - 访问文章URL
# - 测试移动端
# - 检查首页
```

### 阶段6: Git提交
```bash
# 1. 清理备份文件
rm -f blog/*/*.backup blog/*.backup

# 2. 添加文件
git add blog/[article]/ blog/index.html sitemap.xml blog/BLOG-PLAN.md

# 3. 提交
git commit -m "feat: 新增文章 [标题]

- 内容: [简述]
- 字数: [约XXX字]
- 分类: product/tech
- 更新: 博客首页 + sitemap"

# 4. 推送
git push origin main

# 5. 打tag
git tag -a v1.x.0 -m "新增文章: [标题]"
git push origin --tags
```

---

## 常见错误及预防

### 错误1: 移动端很窄
**现象:** 移动端内容区域很窄,左右大量空白

**原因:** padding-left还是260px(桌面端TOC的宽度)

**预防:**
- 部署前必须F12测试移动端
- 检查1100px断点的padding
- 使用qa-check.sh自动检查

**修复:**
```bash
sed -i 's/padding:88px 24px 60px 260px/padding:88px 24px 60px 24px/g' blog/[article]/index.html
```

### 错误2: 博客首页没更新
**现象:** 新文章发布了,但首页看不到

**原因:** 忘记更新blog/index.html

**预防:**
- 发布流程中强制检查首页
- 部署后验证首页

**修复:**
- 手动添加文章卡片到blog/index.html
- 重新部署blog/index.html

### 错误3: 风格不统一
**现象:** 新文章的样式和其他文章不一样

**原因:** 没有使用统一的模板或CSS变量

**预防:**
- 使用已有文章作为模板
- 检查CSS变量使用
- 对比导航栏等组件

### 错误4: 内容不完整
**现象:** 发布后发现缺少某些章节

**原因:** 生成HTML时没有严格按照MD

**预防:**
- 对比MD和HTML的H2数量
- 使用qa-check.sh检查章节数
- 本地预览时仔细检查

### 错误5: 线上缓存
**现象:** 修改后浏览器还是显示旧版本

**原因:** 浏览器缓存或nginx缓存

**预防:**
- 部署后重启nginx(不是reload)
- 使用无痕模式验证
- 告诉用户Ctrl+Shift+R强制刷新

---

## 检查清单总结

打印这个清单,每次发布时逐项勾选:

```
文章发布检查清单 - [文章名]

□ 1. 内容完整(对比MD)
□ 2. H1标题正确无乱码
□ 3. Meta标签正确
□ 4. 响应式断点完整(1100/768/480)
□ 5. 移动端padding对称(无260px)
□ 6. F12测试移动端(375/768/1024)
□ 7. CSS变量和风格统一
□ 8. 深色模式正常
□ 9. 博客首页已更新
□ 10. 文章卡片已添加
□ 11. 统计数据已更新
□ 12. sitemap.xml已更新
□ 13. 本地预览正常
□ 14. 部署到生产
□ 15. 重启nginx
□ 16. 线上验证(curl)
□ 17. 浏览器验证(无痕)
□ 18. 移动端实测
□ 19. Git提交
□ 20. 打版本tag

签名: ________  日期: ________
```

---

## 记住的原则

1. **移动端测试是必须的,不是可选的**
2. **padding-left在移动端必须对称,不能是260px**
3. **博客首页必须同步更新**
4. **风格必须统一,使用CSS变量**
5. **部署后必须重启nginx**
6. **浏览器验证必须用无痕模式**
7. **严格按照MD生成,不添加不删除**
8. **所有相关文件一起更新**
9. **Git提交前清理备份文件**
10. **每次发布都打版本tag**
