# 工作流程问题总结与改进方案

## 本次部署暴露的问题

### 1. 缺乏完整的发布前检查
**问题:**
- 文章分类不一致(thinking/product/tech混用)
- Stats Bar显示错误(6篇→12篇)
- 筛选按钮样式未统一
- 文章日期都是同一天
- 文章页面布局有空白

**根因:** 没有执行完整的检查清单,边发布边发现问题

### 2. 样式决策反复修改
**问题:**
- 筛选按钮样式改了3次(绿色→深色→渐变)
- 每次都是发布后才发现不协调

**根因:** 没有在本地预览确认样式,直接部署到生产

### 3. 文档与实际不同步
**问题:**
- AGENTS.md写了规范,但实际操作时没遵守
- 验证脚本写了,但没在发布前运行

**根因:** 文档是事后补的,不是事前的指导

### 4. 缺少本地验证环境
**问题:**
- 所有修改都直接在生产环境验证
- 没有本地预览就推送

**根因:** 没有本地开发服务器

---

## 改进方案

### 阶段1: 发布前(本地)

#### 1.1 内容准备
```bash
# 检查所有Markdown源文件
ls blog/drafts/*.md

# 确认文章数量
ls blog/drafts/*.md | wc -l
```

#### 1.2 HTML生成
```bash
# 转换为HTML
# 使用统一的模板和脚本

# 检查生成的HTML
for article in blog/*/index.html; do
  echo "$article: $(wc -l < $article) 行"
done
```

#### 1.3 本地预览(必须)
```bash
# 启动本地服务器
cd /root/.openclaw/workspace/projects/allen-site
python3 -m http.server 8000

# 在浏览器访问 http://localhost:8000/blog/
# 检查:
# - 文章列表显示
# - 筛选按钮功能
# - 文章内页布局
# - 响应式效果
```

#### 1.4 样式确认
- [ ] 筛选按钮选中效果与主题色一致
- [ ] 文章卡片布局整齐
- [ ] 文章内页无多余空白
- [ ] 深色模式正常

#### 1.5 数据检查
```bash
# 运行验证脚本
./blog/verify-blog.sh

# 检查:
# - 文章总数正确
# - 分类统计正确(只有product和tech)
# - Stats Bar显示正确
# - 日期已分散
```

### 阶段2: 部署

#### 2.1 同步到生产
```bash
rsync -av --delete \
  --exclude='.git' --exclude='node_modules' --exclude='drafts' \
  /root/.openclaw/workspace/projects/allen-site/ \
  /var/www/allen-site/
```

#### 2.2 重载服务
```bash
systemctl reload nginx
```

#### 2.3 Git提交
```bash
git add .
git commit -m "类型: 简述"
git tag -a vX.Y.Z -m "版本说明"
git push origin main --tags
```

### 阶段3: 发布后验证

#### 3.1 自动化验证
```bash
# 运行线上验证
./blog/verify-blog.sh
```

#### 3.2 浏览器测试
- [ ] 访问 https://allen00.top/blog/
- [ ] 检查文章列表完整
- [ ] 测试筛选功能(全部/产品/技术)
- [ ] 随机点开3篇文章检查内容
- [ ] 测试响应式(手机/平板/桌面)

#### 3.3 问题记录
如果发现问题:
1. 立即记录到 WORKFLOW-ISSUES.md
2. 回滚或快速修复
3. 更新检查清单,避免重复

---

## 强制执行的规则

### 规则1: 本地预览优先
**禁止:** 直接修改生产环境文件
**要求:** 所有改动先在本地预览,确认无误再部署

### 规则2: 样式决策一次到位
**禁止:** 发布后反复调整样式
**要求:** 样式改动必须在本地预览时确定,参考现有页面风格

### 规则3: 验证脚本必跑
**禁止:** 跳过验证直接发布
**要求:** 发布前必须运行 `./blog/verify-blog.sh` 并通过所有检查

### 规则4: 文档先行
**禁止:** 边做边写文档
**要求:** 新功能/新流程先写文档,再执行

---

## 检查清单模板

### 博客文章发布检查清单

**发布前(本地):**
- [ ] Markdown文件已准备(drafts/)
- [ ] HTML已生成(使用统一模板)
- [ ] 本地预览正常(python3 -m http.server)
- [ ] 文章分类正确(只用product/tech)
- [ ] 文章日期已分散(不都是同一天)
- [ ] Stats Bar数字正确
- [ ] 筛选按钮样式协调
- [ ] 文章内页无空白
- [ ] 验证脚本通过

**部署:**
- [ ] rsync同步到生产
- [ ] nginx重载
- [ ] Git提交+tag

**发布后:**
- [ ] 线上验证脚本通过
- [ ] 浏览器功能测试通过
- [ ] 响应式测试通过
- [ ] 记录到memory/

---

## 下次发布的改进

1. **启用本地开发服务器**
   ```bash
   cd /root/.openclaw/workspace/projects/allen-site
   python3 -m http.server 8000 &
   ```

2. **创建预发布脚本**
   ```bash
   #!/bin/bash
   # pre-deploy.sh
   echo "=== 发布前检查 ==="
   ./blog/verify-blog.sh
   echo ""
   echo "=== 本地预览 ==="
   echo "访问 http://localhost:8000/blog/"
   echo "确认无误后按回车继续..."
   read
   ```

3. **样式参考文档**
   创建 STYLE-GUIDE.md,记录:
   - 主题色定义
   - 按钮样式规范
   - 布局规范
   - 响应式断点

4. **问题追踪**
   每次发现问题立即记录:
   - 问题描述
   - 根本原因
   - 解决方案
   - 预防措施
