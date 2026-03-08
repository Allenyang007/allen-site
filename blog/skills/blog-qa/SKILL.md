# Blog QA & Release Checklist Skill

## 目的
基于2026-03-08部署经验,建立强制执行的质量保证和发布检查流程,避免反复修改和低级错误。

---

## 今天遇到的问题总结

### 问题1: 文章内容混乱
**现象:** 
- 文章HTML中混入了其他文章的标题和内容
- H1标题显示错误(显示其他文章的标题)
- subtitle显示错误内容

**根因:**
- 从备份恢复时没有验证内容
- 批量操作时正则表达式匹配错误
- 没有在部署前检查实际内容

**解决方案:**
- 部署前必须验证H1标题、subtitle、meta标签
- 使用`grep`精确检查关键内容
- 不要盲目相信备份文件

### 问题2: 编码问题导致乱码
**现象:** 标题中的中文破折号"——"显示为乱码

**根因:**
- 文件编码不一致
- Python脚本处理时没有指定UTF-8

**解决方案:**
- 所有文件操作必须指定`encoding='utf-8'`
- 部署后用`cat -A`检查特殊字符
- 使用`file`命令验证文件编码

### 问题3: 删除内容不生效
**现象:** 
- 多次删除某段内容,但浏览器仍显示
- 服务器文件已更新,但用户看到旧版本

**根因:**
- 浏览器缓存
- Nginx缓存
- 没有强制刷新

**解决方案:**
- 每次部署后重启nginx(不只是reload)
- 在HTML头部添加时间戳强制刷新
- 告诉用户使用Ctrl+Shift+R强制刷新
- 或者用无痕模式验证

### 问题4: 正则表达式删除错误
**现象:** 
- 想删除某一节,结果删除了多节
- 或者没删除干净,留下残余

**根因:**
- 正则表达式贪婪匹配
- 没有精确定位边界
- 没有验证删除结果

**解决方案:**
- 使用非贪婪匹配`.*?`
- 明确指定结束标记
- 删除后立即验证(grep -c)

### 问题5: Git冲突和推送失败
**现象:** 
- 推送时提示remote有新提交
- 需要pull --rebase

**根因:**
- 多次提交没有及时同步
- 本地和远程不一致

**解决方案:**
- 每次修改前先`git pull`
- 使用`git pull --rebase`保持线性历史
- 重要修改前检查`git status`

### 问题6: 移动端布局问题
**现象:** 
- 桌面端正常,移动端内容区域很窄
- 左右两侧大量空白

**根因:**
- TOC隐藏后padding-left没有移除
- 响应式CSS不完整

**解决方案:**
- 移动端必须测试(F12设备模拟)
- padding必须对称
- 1100px以下TOC隐藏时,padding-left改为24px

### 问题7: 反复修改同一个问题
**现象:** 
- 同一个内容删除了10次还在
- 每次都说"已删除"但实际没删除

**根因:**
- 没有真正理解用户需求
- 没有验证操作结果
- 依赖工具输出而不是实际检查

**解决方案:**
- 操作后必须验证(curl/grep)
- 不要只看工具输出,要看实际文件
- 用户说"还在"就是真的还在,不要争辩

---

## 强制执行的发布检查清单

### 阶段1: 内容准备(Markdown)

```bash
# 1. 验证Markdown文件
cat blog/drafts/draft-xxx.md | head -30

# 检查项:
- [ ] 标题正确(中文破折号"——")
- [ ] description简洁(不超过100字)
- [ ] 日期格式正确(YYYY-MM-DD)
- [ ] 没有多余的引言段落
- [ ] 章节结构清晰
```

### 阶段2: HTML生成

```bash
# 2. 从Markdown生成HTML
# 使用subagent或手动转换

# 检查项:
- [ ] H1标题正确
- [ ] 没有subtitle(除非明确需要)
- [ ] meta description正确
- [ ] TOC目录正确
- [ ] 所有章节都在
- [ ] 没有混入其他文章内容
```

### 阶段3: 内容验证

```bash
# 3. 验证HTML内容
cd /root/.openclaw/workspace/projects/allen-site/blog/[article-name]

# 检查H1标题
grep "<h1>" index.html

# 检查是否有subtitle
grep "subtitle" index.html

# 检查meta标签
grep "meta name=\"description\"" index.html

# 检查章节数量
grep -c "<h2" index.html

# 检查文件编码
file index.html
# 应该显示: UTF-8 Unicode text

# 检查特殊字符
grep "——" index.html | cat -A
# 不应该有乱码
```

### 阶段4: 布局验证

```bash
# 4. 验证响应式布局
grep "@media" index.html

# 检查项:
- [ ] 有1100px断点(TOC隐藏)
- [ ] 有768px断点(移动端)
- [ ] 有480px断点(小屏幕)
- [ ] padding在移动端是对称的
- [ ] max-width合理(900px)
```

### 阶段5: 本地预览

```bash
# 5. 启动本地服务器
cd /root/.openclaw/workspace/projects/allen-site
python3 -m http.server 8000 &

# 浏览器访问:
# http://localhost:8000/blog/[article-name]/

# 检查项:
- [ ] 标题显示正确
- [ ] 内容完整
- [ ] TOC可点击
- [ ] 移动端布局正常(F12设备模拟)
- [ ] 深色模式正常
```

### 阶段6: 部署到生产

```bash
# 6. 同步到生产环境
cd /root/.openclaw/workspace/projects/allen-site

# 先pull最新代码
git pull

# 同步文件
rsync -av blog/[article-name]/ /var/www/allen-site/blog/[article-name]/

# 重启nginx(不是reload!)
systemctl restart nginx

# 等待2秒
sleep 2
```

### 阶段7: 线上验证

```bash
# 7. 验证线上版本
URL="https://allen00.top/blog/[article-name]/"

# 检查HTTP状态
curl -I $URL | grep "200 OK"

# 检查H1标题
curl -s $URL | grep "<h1>" | grep -o ">.*<"

# 检查文件大小
curl -s $URL | wc -c

# 检查是否有乱码
curl -s $URL | grep "M-" && echo "❌ 有乱码!" || echo "✅ 无乱码"

# 检查是否有不该有的内容
curl -s $URL | grep "我见过不少" && echo "⚠️ 有引言段落" || echo "✅ 无引言"
```

### 阶段8: 浏览器验证

```
# 8. 浏览器实际测试
1. 打开无痕窗口(Ctrl+Shift+N)
2. 访问文章URL
3. 检查标题、内容、布局
4. F12切换到移动端模式
5. 测试375px/768px/1024px
6. 检查深色模式
```

### 阶段9: Git提交

```bash
# 9. 提交到Git
cd /root/.openclaw/workspace/projects/allen-site

git add blog/[article-name]/
git commit -m "feat: 新增文章 [标题]

- 内容: [简述]
- 字数: [约XXX字]
- 分类: product/tech"

git push origin main

# 打tag
git tag -a v1.x.x -m "新增文章: [标题]"
git push origin --tags
```

### 阶段10: 更新索引

```bash
# 10. 更新博客首页
# 在blog/index.html中添加文章卡片

# 验证
./blog/verify-blog.sh

# 检查项:
- [ ] 文章总数正确
- [ ] 分类统计正确
- [ ] 筛选功能正常
```

---

## 快速验证脚本

创建 `/root/.openclaw/workspace/projects/allen-site/blog/qa-check.sh`:

```bash
#!/bin/bash
# 文章质量检查脚本

ARTICLE=$1

if [ -z "$ARTICLE" ]; then
  echo "用法: ./qa-check.sh [article-name]"
  exit 1
fi

ARTICLE_DIR="blog/$ARTICLE"
HTML_FILE="$ARTICLE_DIR/index.html"

if [ ! -f "$HTML_FILE" ]; then
  echo "❌ 文件不存在: $HTML_FILE"
  exit 1
fi

echo "=========================================="
echo "文章质量检查: $ARTICLE"
echo "=========================================="
echo ""

# 1. 文件基本信息
echo "【1】文件信息"
echo "大小: $(wc -c < $HTML_FILE) 字节"
echo "行数: $(wc -l < $HTML_FILE) 行"
echo "编码: $(file -b --mime-encoding $HTML_FILE)"
echo ""

# 2. 标题检查
echo "【2】标题检查"
H1=$(grep "<h1>" $HTML_FILE | sed 's/<[^>]*>//g' | xargs)
echo "H1: $H1"
if echo "$H1" | grep -q "M-"; then
  echo "❌ 标题有乱码!"
else
  echo "✅ 标题正常"
fi
echo ""

# 3. Subtitle检查
echo "【3】Subtitle检查"
SUBTITLE_COUNT=$(grep -c "class=\"subtitle\"" $HTML_FILE)
if [ "$SUBTITLE_COUNT" -gt 0 ]; then
  echo "⚠️ 有subtitle ($SUBTITLE_COUNT 个)"
  grep "class=\"subtitle\"" $HTML_FILE
else
  echo "✅ 无subtitle"
fi
echo ""

# 4. Meta标签检查
echo "【4】Meta标签"
grep "meta name=\"description\"" $HTML_FILE || echo "✅ 无description"
echo ""

# 5. 章节统计
echo "【5】章节统计"
H2_COUNT=$(grep -c "<h2" $HTML_FILE)
echo "H2章节数: $H2_COUNT"
echo ""

# 6. 响应式检查
echo "【6】响应式断点"
grep "@media" $HTML_FILE | grep -o "max-width:[0-9]*px" | sort -u
echo ""

# 7. 特殊字符检查
echo "【7】特殊字符"
if grep -q "M-" $HTML_FILE; then
  echo "❌ 发现乱码字符!"
  grep "M-" $HTML_FILE | head -3
else
  echo "✅ 无乱码"
fi
echo ""

# 8. 不该有的内容
echo "【8】不该有的内容检查"
ISSUES=0

if grep -q "我见过不少" $HTML_FILE; then
  echo "⚠️ 有引言段落"
  ISSUES=$((ISSUES+1))
fi

if grep -q "三堵墙" $HTML_FILE; then
  echo "⚠️ 有'三堵墙'内容"
  ISSUES=$((ISSUES+1))
fi

if grep -q "pm-walls" $HTML_FILE; then
  echo "⚠️ 有pm-walls章节"
  ISSUES=$((ISSUES+1))
fi

if [ $ISSUES -eq 0 ]; then
  echo "✅ 无不该有的内容"
fi
echo ""

echo "=========================================="
echo "检查完成"
echo "=========================================="
```

---

## 使用方法

### 发布新文章

```bash
# 1. 准备Markdown
vim blog/drafts/draft-xxx.md

# 2. 生成HTML(使用subagent或手动)
# ...

# 3. 质量检查
./blog/qa-check.sh xxx

# 4. 本地预览
python3 -m http.server 8000 &
# 浏览器访问 http://localhost:8000/blog/xxx/

# 5. 部署
rsync -av blog/xxx/ /var/www/allen-site/blog/xxx/
systemctl restart nginx

# 6. 线上验证
curl -s https://allen00.top/blog/xxx/ | grep "<h1>"

# 7. 提交
git add blog/xxx/
git commit -m "feat: 新增文章 xxx"
git push origin main
```

### 修改已有文章

```bash
# 1. 修改HTML
vim blog/xxx/index.html

# 2. 质量检查
./blog/qa-check.sh xxx

# 3. 部署
cp blog/xxx/index.html /var/www/allen-site/blog/xxx/
systemctl restart nginx

# 4. 验证
curl -s https://allen00.top/blog/xxx/ | grep "<h1>"

# 5. 提交
git add blog/xxx/index.html
git commit -m "fix: 修复xxx"
git push origin main
```

---

## 常见错误速查

| 错误现象 | 可能原因 | 解决方法 |
|---------|---------|---------|
| 标题乱码 | 编码问题 | 检查UTF-8,重新生成 |
| 内容混乱 | 备份文件错误 | 从Markdown重新生成 |
| 删除不生效 | 浏览器缓存 | Ctrl+Shift+R强制刷新 |
| 移动端很窄 | padding不对称 | 检查@media中的padding |
| 推送失败 | 远程有新提交 | git pull --rebase |
| 文章不显示 | JavaScript错误 | 检查filterPosts初始化 |

---

## 记住的原则

1. **不要相信工具输出,要验证实际结果**
2. **部署后必须重启nginx,不是reload**
3. **用户说"还在"就是真的还在**
4. **所有文件操作指定UTF-8编码**
5. **正则表达式用非贪婪匹配**
6. **移动端必须测试**
7. **本地预览是必须的,不是可选的**
8. **Git操作前先pull**
9. **删除后立即验证**
10. **不要反复修改同一个问题,一次做对**
