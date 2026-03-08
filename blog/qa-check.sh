#!/bin/bash
# 文章质量检查脚本

ARTICLE=$1

if [ -z "$ARTICLE" ]; then
  echo "用法: ./qa-check.sh [article-name]"
  exit 1
fi

ARTICLE_DIR="$ARTICLE"
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
