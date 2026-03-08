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
