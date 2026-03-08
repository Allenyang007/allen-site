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
