# Blog Code Review Skill

## 目的
在博客文章发布前进行强制性代码审查,确保HTML质量、内容正确性、响应式布局、SEO优化等各方面符合标准。

---

## 何时触发

- 新文章发布前
- 修改已有文章后
- 用户明确要求"代码审查"或"review"
- 发现问题需要修复后

---

## 审查清单

### 1. 文件基础检查

```bash
# 文件存在性
[ -f blog/[article]/index.html ] || echo "❌ 文件不存在"

# 文件大小(合理范围: 15KB-50KB)
SIZE=$(wc -c < blog/[article]/index.html)
if [ $SIZE -lt 10000 ]; then
  echo "⚠️ 文件过小,可能内容不完整"
elif [ $SIZE -gt 100000 ]; then
  echo "⚠️ 文件过大,可能有冗余内容"
fi

# 文件编码(必须UTF-8)
ENCODING=$(file -b --mime-encoding blog/[article]/index.html)
[ "$ENCODING" = "utf-8" ] || echo "❌ 编码不是UTF-8: $ENCODING"

# 行数(合理范围: 300-800行)
LINES=$(wc -l < blog/[article]/index.html)
echo "文件行数: $LINES"
```

### 2. HTML结构检查

```bash
# DOCTYPE声明
grep -q "<!DOCTYPE html>" || echo "❌ 缺少DOCTYPE"

# HTML标签
grep -q "<html lang=\"zh-CN\">" || echo "❌ 缺少或错误的html lang属性"

# Head标签完整性
grep -q "<meta charset=\"UTF-8\">" || echo "❌ 缺少charset"
grep -q "<meta name=\"viewport\"" || echo "❌ 缺少viewport"

# 标签闭合检查
OPEN_DIV=$(grep -o "<div" | wc -l)
CLOSE_DIV=$(grep -o "</div>" | wc -l)
[ $OPEN_DIV -eq $CLOSE_DIV ] || echo "⚠️ div标签不匹配: $OPEN_DIV 开 vs $CLOSE_DIV 闭"
```

### 3. 内容正确性检查

```bash
# H1标题(必须有且只有1个)
H1_COUNT=$(grep -c "<h1>" blog/[article]/index.html)
if [ $H1_COUNT -eq 0 ]; then
  echo "❌ 缺少H1标题"
elif [ $H1_COUNT -gt 1 ]; then
  echo "❌ 有多个H1标题: $H1_COUNT 个"
else
  echo "✅ H1标题正常"
  grep "<h1>" blog/[article]/index.html | sed 's/<[^>]*>//g'
fi

# 标题乱码检查
if grep "<h1>" blog/[article]/index.html | grep -q "M-"; then
  echo "❌ H1标题有乱码"
fi

# Subtitle检查(通常不应该有)
SUBTITLE_COUNT=$(grep -c "class=\"subtitle\"" blog/[article]/index.html)
if [ $SUBTITLE_COUNT -gt 0 ]; then
  echo "⚠️ 有subtitle ($SUBTITLE_COUNT 个),确认是否需要"
fi

# H2章节数量(合理范围: 3-10个)
H2_COUNT=$(grep -c "<h2" blog/[article]/index.html)
if [ $H2_COUNT -lt 3 ]; then
  echo "⚠️ H2章节过少: $H2_COUNT 个"
elif [ $H2_COUNT -gt 15 ]; then
  echo "⚠️ H2章节过多: $H2_COUNT 个"
else
  echo "✅ H2章节数量合理: $H2_COUNT 个"
fi

# 段落数量(合理范围: 10-50个)
P_COUNT=$(grep -c "<p>" blog/[article]/index.html)
echo "段落数: $P_COUNT"
```

### 4. Meta标签检查

```bash
# Title标签
TITLE=$(grep "<title>" blog/[article]/index.html | sed 's/<[^>]*>//g')
TITLE_LEN=${#TITLE}
if [ $TITLE_LEN -lt 10 ]; then
  echo "❌ Title过短: $TITLE_LEN 字符"
elif [ $TITLE_LEN -gt 70 ]; then
  echo "⚠️ Title过长: $TITLE_LEN 字符"
else
  echo "✅ Title长度合理: $TITLE_LEN 字符"
fi
echo "Title: $TITLE"

# Description
if grep -q "meta name=\"description\"" blog/[article]/index.html; then
  DESC=$(grep "meta name=\"description\"" blog/[article]/index.html | grep -o 'content="[^"]*"' | sed 's/content="//;s/"//')
  DESC_LEN=${#DESC}
  if [ $DESC_LEN -gt 160 ]; then
    echo "⚠️ Description过长: $DESC_LEN 字符"
  else
    echo "✅ Description: $DESC_LEN 字符"
  fi
fi

# Canonical URL
if ! grep -q "rel=\"canonical\"" blog/[article]/index.html; then
  echo "⚠️ 缺少canonical URL"
fi

# Open Graph标签
OG_COUNT=$(grep -c "property=\"og:" blog/[article]/index.html)
if [ $OG_COUNT -lt 3 ]; then
  echo "⚠️ Open Graph标签不完整: $OG_COUNT 个"
fi
```

### 5. 响应式布局检查

```bash
# 必须有的断点
if ! grep -q "@media(max-width:1100px)" blog/[article]/index.html; then
  echo "❌ 缺少1100px断点(TOC隐藏)"
fi

if ! grep -q "@media(max-width:768px)" blog/[article]/index.html; then
  echo "❌ 缺少768px断点(移动端)"
fi

if ! grep -q "@media(max-width:480px)" blog/[article]/index.html; then
  echo "❌ 缺少480px断点(小屏幕)"
fi

# 移动端padding检查
MOBILE_PADDING=$(grep -A5 "@media(max-width:1100px)" blog/[article]/index.html | grep "article-layout" | grep -o "padding:[^}]*")
if echo "$MOBILE_PADDING" | grep -q "260px"; then
  echo "❌ 移动端padding-left还是260px,应该改为24px"
else
  echo "✅ 移动端padding正常"
fi

# Max-width检查
MAX_WIDTH=$(grep "article-layout" blog/[article]/index.html | grep -o "max-width:[0-9]*px" | head -1)
echo "内容区max-width: $MAX_WIDTH"
```

### 6. TOC目录检查

```bash
# TOC存在性
if ! grep -q "class=\"toc\"" blog/[article]/index.html; then
  echo "⚠️ 缺少TOC目录"
else
  # TOC链接数量应该等于H2数量
  TOC_LINKS=$(grep -c "\.toc.*<a href=\"#" blog/[article]/index.html)
  if [ $TOC_LINKS -ne $H2_COUNT ]; then
    echo "⚠️ TOC链接数($TOC_LINKS)与H2数量($H2_COUNT)不匹配"
  else
    echo "✅ TOC链接数量正确"
  fi
fi
```

### 7. 样式和脚本检查

```bash
# CSS变量使用
if ! grep -q "var(--" blog/[article]/index.html; then
  echo "⚠️ 未使用CSS变量"
fi

# 深色模式支持
if ! grep -q "data-theme=\"dark\"" blog/[article]/index.html; then
  echo "⚠️ 可能缺少深色模式支持"
fi

# JavaScript错误检查
if grep -q "console.log\|console.error\|debugger" blog/[article]/index.html; then
  echo "⚠️ 有调试代码残留"
fi
```

### 8. 内容质量检查

```bash
# 不该有的内容
ISSUES=0

# 检查是否有其他文章的标题混入
OTHER_TITLES=(
  "AI产品和传统软件"
  "RAG 解决了什么问题"
  "Workflow 和 Agent"
  "Prompt不是魔法咒语"
  "工具越强，基本功越值钱"
)

for title in "${OTHER_TITLES[@]}"; do
  if grep -q "$title" blog/[article]/index.html; then
    # 检查是否在H1中(如果在H1中说明是正确的)
    if ! grep "<h1>" blog/[article]/index.html | grep -q "$title"; then
      echo "⚠️ 可能混入了其他文章内容: $title"
      ISSUES=$((ISSUES+1))
    fi
  fi
done

# 检查特定不该有的内容(根据文章调整)
if grep -q "我见过不少大模型项目的死法" blog/[article]/index.html; then
  echo "⚠️ 有引言段落(如果不需要)"
fi

if grep -q "三堵墙" blog/[article]/index.html; then
  echo "⚠️ 有'三堵墙'内容(如果已删除)"
fi

if grep -q "pm-walls" blog/[article]/index.html; then
  echo "⚠️ 有pm-walls章节(如果已删除)"
fi

# 检查空段落
EMPTY_P=$(grep -c "<p></p>" blog/[article]/index.html)
if [ $EMPTY_P -gt 0 ]; then
  echo "⚠️ 有 $EMPTY_P 个空段落"
fi
```

### 9. 性能检查

```bash
# 文件大小
SIZE_KB=$((SIZE / 1024))
echo "文件大小: ${SIZE_KB}KB"

# 图片检查(如果有)
IMG_COUNT=$(grep -c "<img" blog/[article]/index.html)
if [ $IMG_COUNT -gt 0 ]; then
  echo "图片数量: $IMG_COUNT"
  # 检查是否有alt属性
  IMG_NO_ALT=$(grep "<img" blog/[article]/index.html | grep -cv "alt=")
  if [ $IMG_NO_ALT -gt 0 ]; then
    echo "⚠️ 有 $IMG_NO_ALT 个图片缺少alt属性"
  fi
fi

# 外部资源检查
EXTERNAL_LINKS=$(grep -c "http://" blog/[article]/index.html)
if [ $EXTERNAL_LINKS -gt 0 ]; then
  echo "⚠️ 有 $EXTERNAL_LINKS 个http链接(应该用https)"
fi
```

### 10. 可访问性检查

```bash
# 语义化标签
if ! grep -q "<article>" blog/[article]/index.html; then
  echo "⚠️ 缺少<article>标签"
fi

if ! grep -q "<nav>" blog/[article]/index.html; then
  echo "⚠️ 缺少<nav>标签"
fi

# 链接检查
LINKS=$(grep -o "<a href=\"[^\"]*\"" blog/[article]/index.html | wc -l)
echo "链接数量: $LINKS"

# 检查是否有空链接
EMPTY_LINKS=$(grep -c "href=\"#\"" blog/[article]/index.html)
if [ $EMPTY_LINKS -gt 0 ]; then
  echo "⚠️ 有 $EMPTY_LINKS 个空链接"
fi
```

---

## 自动化审查脚本

创建 `blog/code-review.sh`:

```bash
#!/bin/bash
# 博客文章代码审查脚本

ARTICLE=$1

if [ -z "$ARTICLE" ]; then
  echo "用法: ./code-review.sh [article-name]"
  exit 1
fi

HTML_FILE="$ARTICLE/index.html"

if [ ! -f "$HTML_FILE" ]; then
  echo "❌ 文件不存在: $HTML_FILE"
  exit 1
fi

echo "=========================================="
echo "代码审查: $ARTICLE"
echo "=========================================="
echo ""

ERRORS=0
WARNINGS=0

# 1. 文件基础
echo "【1】文件基础"
SIZE=$(wc -c < $HTML_FILE)
LINES=$(wc -l < $HTML_FILE)
ENCODING=$(file -b --mime-encoding $HTML_FILE)

echo "大小: $((SIZE/1024))KB ($SIZE 字节)"
echo "行数: $LINES"
echo "编码: $ENCODING"

if [ "$ENCODING" != "utf-8" ]; then
  echo "❌ 编码错误"
  ERRORS=$((ERRORS+1))
fi

if [ $SIZE -lt 10000 ]; then
  echo "⚠️ 文件过小"
  WARNINGS=$((WARNINGS+1))
fi
echo ""

# 2. HTML结构
echo "【2】HTML结构"
grep -q "<!DOCTYPE html>" $HTML_FILE && echo "✅ DOCTYPE" || { echo "❌ 缺少DOCTYPE"; ERRORS=$((ERRORS+1)); }
grep -q "<html lang=\"zh-CN\">" $HTML_FILE && echo "✅ HTML lang" || { echo "⚠️ HTML lang"; WARNINGS=$((WARNINGS+1)); }
grep -q "<meta charset=\"UTF-8\">" $HTML_FILE && echo "✅ Charset" || { echo "❌ 缺少charset"; ERRORS=$((ERRORS+1)); }
grep -q "<meta name=\"viewport\"" $HTML_FILE && echo "✅ Viewport" || { echo "❌ 缺少viewport"; ERRORS=$((ERRORS+1)); }
echo ""

# 3. 标题检查
echo "【3】标题检查"
H1_COUNT=$(grep -c "<h1>" $HTML_FILE)
if [ $H1_COUNT -eq 1 ]; then
  echo "✅ H1数量正确"
  H1=$(grep "<h1>" $HTML_FILE | sed 's/<[^>]*>//g' | xargs)
  echo "H1: $H1"
  if echo "$H1" | grep -q "M-"; then
    echo "❌ H1有乱码"
    ERRORS=$((ERRORS+1))
  fi
else
  echo "❌ H1数量错误: $H1_COUNT"
  ERRORS=$((ERRORS+1))
fi

H2_COUNT=$(grep -c "<h2" $HTML_FILE)
echo "H2章节: $H2_COUNT 个"
if [ $H2_COUNT -lt 3 ] || [ $H2_COUNT -gt 15 ]; then
  echo "⚠️ H2数量异常"
  WARNINGS=$((WARNINGS+1))
fi
echo ""

# 4. Meta标签
echo "【4】Meta标签"
TITLE=$(grep "<title>" $HTML_FILE | sed 's/<[^>]*>//g')
echo "Title: $TITLE (${#TITLE}字符)"
if [ ${#TITLE} -gt 70 ]; then
  echo "⚠️ Title过长"
  WARNINGS=$((WARNINGS+1))
fi

if grep -q "meta name=\"description\"" $HTML_FILE; then
  DESC=$(grep "meta name=\"description\"" $HTML_FILE | grep -o 'content="[^"]*"' | sed 's/content="//;s/"//')
  echo "Description: ${#DESC}字符"
  if [ ${#DESC} -gt 160 ]; then
    echo "⚠️ Description过长"
    WARNINGS=$((WARNINGS+1))
  fi
fi

grep -q "rel=\"canonical\"" $HTML_FILE && echo "✅ Canonical" || { echo "⚠️ 缺少canonical"; WARNINGS=$((WARNINGS+1)); }
echo ""

# 5. 响应式
echo "【5】响应式布局"
grep -q "@media(max-width:1100px)" $HTML_FILE && echo "✅ 1100px断点" || { echo "❌ 缺少1100px断点"; ERRORS=$((ERRORS+1)); }
grep -q "@media(max-width:768px)" $HTML_FILE && echo "✅ 768px断点" || { echo "❌ 缺少768px断点"; ERRORS=$((ERRORS+1)); }
grep -q "@media(max-width:480px)" $HTML_FILE && echo "✅ 480px断点" || { echo "❌ 缺少480px断点"; ERRORS=$((ERRORS+1)); }

MOBILE_PADDING=$(grep -A5 "@media(max-width:1100px)" $HTML_FILE | grep "article-layout" | grep -o "padding:[^}]*")
if echo "$MOBILE_PADDING" | grep -q "260px"; then
  echo "❌ 移动端padding-left错误"
  ERRORS=$((ERRORS+1))
else
  echo "✅ 移动端padding正常"
fi
echo ""

# 6. 内容质量
echo "【6】内容质量"
SUBTITLE_COUNT=$(grep -c "class=\"subtitle\"" $HTML_FILE)
[ $SUBTITLE_COUNT -eq 0 ] && echo "✅ 无subtitle" || { echo "⚠️ 有subtitle"; WARNINGS=$((WARNINGS+1)); }

P_COUNT=$(grep -c "<p>" $HTML_FILE)
echo "段落数: $P_COUNT"

EMPTY_P=$(grep -c "<p></p>" $HTML_FILE)
[ $EMPTY_P -eq 0 ] && echo "✅ 无空段落" || { echo "⚠️ 有 $EMPTY_P 个空段落"; WARNINGS=$((WARNINGS+1)); }
echo ""

# 7. TOC
echo "【7】TOC目录"
if grep -q "class=\"toc\"" $HTML_FILE; then
  TOC_LINKS=$(grep "\.toc" $HTML_FILE | grep -c "<a href=\"#")
  if [ $TOC_LINKS -eq $H2_COUNT ]; then
    echo "✅ TOC链接数正确: $TOC_LINKS"
  else
    echo "⚠️ TOC链接($TOC_LINKS) ≠ H2数量($H2_COUNT)"
    WARNINGS=$((WARNINGS+1))
  fi
else
  echo "⚠️ 缺少TOC"
  WARNINGS=$((WARNINGS+1))
fi
echo ""

# 总结
echo "=========================================="
echo "审查完成"
echo "=========================================="
echo "错误: $ERRORS"
echo "警告: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "✅ 通过审查,可以发布"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo "⚠️ 有警告,建议修复后发布"
  exit 0
else
  echo "❌ 有错误,必须修复后才能发布"
  exit 1
fi
```

---

## 使用方法

### 发布前审查

```bash
cd /root/.openclaw/workspace/projects/allen-site/blog

# 运行代码审查
./code-review.sh [article-name]

# 如果有错误,修复后重新审查
# 如果只有警告,评估是否需要修复
# 如果通过,继续发布流程
```

### 集成到发布流程

在发布前强制执行代码审查:

```bash
# 1. 质量检查
./qa-check.sh [article]

# 2. 代码审查
./code-review.sh [article]

# 3. 本地预览
python3 -m http.server 8000 &

# 4. 通过后才部署
```

---

## 审查标准

### 必须修复(ERRORS)
- 文件编码不是UTF-8
- 缺少DOCTYPE或基本meta标签
- H1标题数量不是1个
- H1标题有乱码
- 缺少响应式断点
- 移动端padding错误

### 建议修复(WARNINGS)
- 文件大小异常
- Title或Description过长
- H2数量异常
- 有空段落
- TOC链接数量不匹配
- 有subtitle(如果不需要)

---

## 记住的原则

1. **代码审查是强制的,不是可选的**
2. **有ERRORS必须修复,不能发布**
3. **WARNINGS要评估,重要的必须修复**
4. **审查通过后才能部署到生产**
5. **审查脚本要持续更新,加入新的检查项**
