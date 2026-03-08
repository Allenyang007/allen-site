# 移动端适配检查清单

## 响应式断点
- **1100px**: TOC隐藏,内容区全宽
- **768px**: 汉堡菜单,字号缩小
- **480px**: 最小屏幕,进一步缩小

## 博客首页 (/blog/)

### 必检项
- [ ] Hero区域标题和描述正常显示
- [ ] Stats Bar在小屏幕上不换行或正常换行
- [ ] 筛选按钮在小屏幕上换行显示
- [ ] 文章卡片在小屏幕上单列显示
- [ ] 文章卡片内容不溢出
- [ ] 底部导航正常

### 当前状态
```css
@media(max-width:768px){
  .hero{padding:110px 20px 40px}
  .hero h1{font-size:1.9rem}
  .stats-bar{gap:20px;padding:0 20px 24px}
  .post-card{margin-bottom:16px}
}

@media(max-width:480px){
  .hero h1{font-size:1.6rem}
  .hero p{font-size:.88rem}
  .stats-bar{flex-direction:column;gap:12px}
  .filter-buttons{gap:8px}
  .filter-btn{font-size:.8rem;padding:6px 14px}
}
```

## 文章内页

### 必检项
- [ ] 标题在小屏幕上不换行过多
- [ ] 正文段落宽度合适
- [ ] 代码块横向滚动
- [ ] 图片自适应宽度
- [ ] TOC在移动端隐藏
- [ ] 内容区padding合适

### 当前状态
```css
@media(max-width:1100px){
  .toc{display:none}
  .article-layout{padding:88px 24px 60px}
}

@media(max-width:768px){
  .article-layout{padding:80px 20px 48px}
  .article-meta h1{font-size:1.6rem}
}

@media(max-width:480px){
  .article-layout{padding:76px 16px 40px}
  .article-meta h1{font-size:1.4rem}
  .content p{font-size:.9rem}
}
```

## 常见问题

### 问题1: 筛选按钮在小屏幕上挤在一起
**修复:**
```css
@media(max-width:480px){
  .filter-buttons{
    gap:8px;
    justify-content:center;
  }
  .filter-btn{
    font-size:.8rem;
    padding:6px 14px;
  }
}
```

### 问题2: Stats Bar在小屏幕上横向溢出
**修复:**
```css
@media(max-width:480px){
  .stats-bar{
    flex-direction:column;
    gap:12px;
    align-items:center;
  }
}
```

### 问题3: 文章卡片内容溢出
**修复:**
```css
.post-card{
  overflow:hidden;
}
.post-card h2{
  overflow-wrap:break-word;
  word-break:break-word;
}
```

### 问题4: 文章内页右侧有空白
**已修复:** max-width从1100px改为800px

## 测试方法

### 浏览器开发者工具
1. F12打开开发者工具
2. 点击设备模拟图标
3. 测试以下设备:
   - iPhone SE (375px)
   - iPhone 12 Pro (390px)
   - iPad (768px)
   - iPad Pro (1024px)

### 实际设备测试
- 手机浏览器访问
- 平板浏览器访问
- 横屏/竖屏切换测试

## 快速验证脚本

```bash
#!/bin/bash
# mobile-check.sh

echo "=== 移动端适配检查 ==="
echo ""

echo "【1】博客首页响应式断点"
curl -s https://allen00.top/blog/ | grep "@media" | grep -o "max-width:[0-9]*px"
echo ""

echo "【2】文章页响应式断点"
curl -s https://allen00.top/blog/llm-knowledge-for-product-managers/ | grep "@media" | grep -o "max-width:[0-9]*px"
echo ""

echo "【3】筛选按钮在480px下的样式"
curl -s https://allen00.top/blog/ | grep -A5 "@media(max-width:480px)" | grep "filter"
echo ""

echo "提示: 使用浏览器开发者工具实际测试"
```
