# Claude Code、Codex、OpenClaw 实战操作指南

> 系列文章（4/4）| 作者：Allen | allen00.top

---

前三篇讲了 Agent 是什么、架构怎么设计的、产品经理能学到什么。这一篇回到实操——手把手教你用这三款产品。

从安装到日常使用，再到进阶配置。每个产品都按"5 分钟上手 → 日常使用 → 进阶技巧"的结构来写。

---

## 零、前置准备

在开始之前，确保你的电脑上有这些基础工具：

### 终端（Terminal）

Mac 用户：打开"终端"应用（在 应用程序 → 实用工具 里），或者用 Spotlight 搜索 "Terminal"。

Windows 用户：推荐用 Windows Terminal（微软商店免费下载），或者 PowerShell。

Linux 用户：你应该不需要我教这个。

终端就是一个文字界面，你输入命令，电脑执行。后面所有安装和操作都在终端里完成。

### Git

Git 是代码版本管理工具。即使你不写代码，用 Agent 也经常需要它。

检查是否已安装：
```bash
git --version
```

如果显示版本号（比如 `git version 2.39.0`），说明已经装了。

如果没有：
- Mac：终端输入 `xcode-select --install`
- Windows：去 git-scm.com 下载安装
- Linux：`sudo apt install git` 或 `sudo yum install git`

### Node.js

Codex CLI 和 OpenClaw 都需要 Node.js。

检查是否已安装：
```bash
node --version
```

需要 v18 或更高版本。没有的话去 nodejs.org 下载 LTS 版本。

### GitHub 账号

三款产品都跟 GitHub 有不同程度的集成。如果还没有 GitHub 账号，去 github.com 注册一个。

---

## 一、Claude Code

### 1.1 五分钟上手

**安装：**

```bash
npm install -g @anthropic-ai/claude-code
```

装完后验证：
```bash
claude --version
```

**首次启动：**

```bash
cd 你的项目目录
claude
```

第一次运行会要求你登录 Anthropic 账号。按提示操作就行，会打开浏览器让你授权。

登录成功后，你就进入了 Claude Code 的交互界面。直接用自然语言跟它说话：

```
> 帮我看看这个项目的目录结构，简单介绍一下每个文件的作用
```

它会自己去读文件、分析代码，然后给你一个概览。

**第一个任务：**

试试让它做点实际的事：

```
> 帮我在 README.md 里加一个"快速开始"章节，包含安装和运行步骤
```

它会：
1. 先读现有的 README.md
2. 分析项目结构，搞清楚怎么安装和运行
3. 写好新内容
4. 问你是否确认修改

注意最后一步——它会先让你确认，不会直接改文件。这就是默认的权限控制在起作用。

### 1.2 日常使用

**常用命令：**

在 Claude Code 的交互界面里，除了自然语言，还有一些斜杠命令：

- `/help` — 查看帮助
- `/status` — 查看当前状态（模型、上下文使用量等）
- `/compact` — 手动压缩上下文（对话太长时用）
- `/clear` — 清空对话历史
- `/cost` — 查看本次会话的 API 消耗

**典型工作流：**

我日常用 Claude Code 的流程大概是这样的：

1. `cd` 到项目目录
2. `claude` 启动
3. 先让它了解项目："读一下项目结构，了解一下这是什么项目"
4. 给具体任务："帮我把 UserService 里的登录逻辑重构一下，现在太乱了"
5. 它开始工作——读代码、分析、改代码、可能还会跑测试
6. 我审查它的改动，确认或要求调整
7. 满意后 `git commit`

**处理复杂任务：**

对于大任务，建议分步给指令，而不是一次性扔一个模糊的大目标：

```
# 不太好的方式
> 帮我重构整个项目

# 更好的方式
> 先帮我分析一下 src/services/ 目录下哪些文件耦合度最高
> （看完分析后）好，先重构 UserService，把数据库操作抽到 Repository 层
> （重构完后）跑一下测试看看有没有问题
```

### 1.3 进阶：CLAUDE.md 配置

CLAUDE.md 是 Claude Code 的项目级配置文件，放在项目根目录。每次启动 Claude Code 都会自动读取它。

一个实用的 CLAUDE.md 模板：

```markdown
# CLAUDE.md

## 项目简介
这是一个 Next.js + FastAPI 的全栈项目，前端在 /frontend，后端在 /backend。

## 代码规范
- TypeScript 严格模式
- 函数命名用 camelCase
- 组件命名用 PascalCase
- 提交信息用中文

## 常用命令
- 前端开发：cd frontend && npm run dev
- 后端开发：cd backend && uvicorn main:app --reload
- 跑测试：cd backend && pytest
- 类型检查：cd frontend && npx tsc --noEmit

## 注意事项
- 不要修改 .env.production 文件
- 数据库迁移用 alembic
- API 路由统一放在 /backend/routers/ 目录
```

有了这个文件，Claude Code 每次启动就知道项目的基本情况，不用你每次都重复交代。

### 1.4 进阶：权限配置

如果你觉得每次都要确认太烦，可以在项目的 `.claude/settings.json` 里配置权限规则：

```json
{
  "permissions": {
    "allow": [
      "Read(*)",
      "Edit(*)",
      "Bash(npm run *)",
      "Bash(pytest *)",
      "Bash(git status)",
      "Bash(git diff *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Read(.env.production)"
    ]
  }
}
```

这样配置后，读写文件和跑测试会自动通过，不再弹确认框。但删除操作和读生产环境配置会被拒绝。

### 1.5 进阶：子代理

处理大任务时，可以让 Claude Code 派子代理：

```
> 这个任务比较大，帮我拆成几个子任务，用子代理分别处理
```

Claude Code 会自动创建子代理会话，每个子代理处理一个子任务，完成后把结果汇总回来。

子代理的好处是不会撑爆主会话的上下文。每个子代理有自己独立的上下文窗口。

---

## 二、OpenAI Codex

### 2.1 五分钟上手

Codex 有三种用法，选最适合你的：

**方式一：Web 版（最简单）**

1. 打开 chatgpt.com/codex
2. 用你的 ChatGPT 账号登录（需要 Plus 或以上）
3. 连接你的 GitHub 账号
4. 选一个仓库，给任务，点"Code"

就这么简单。

**方式二：CLI 版**

```bash
npm install -g @openai/codex
```

安装后运行：
```bash
codex
```

第一次会让你选择登录方式——推荐"Sign in with ChatGPT"，用你的 ChatGPT 订阅额度。

然后就可以直接给任务了：
```bash
codex "帮我写一个 Python 脚本，批量重命名当前目录下的图片文件"
```

**方式三：IDE 插件**

在 VS Code 的扩展商店搜索 "Codex"，安装 OpenAI 官方插件。装完后在编辑器侧边栏就能看到 Codex 面板。

### 2.2 日常使用

**Web 版的典型流程：**

1. 打开 chatgpt.com/codex
2. 选择要操作的 GitHub 仓库
3. 输入任务描述，比如："修复 issue #42 中描述的登录超时问题"
4. 点"Code"（让它写代码）或"Ask"（让它回答问题）
5. Codex 在云端沙盒里开始工作，你可以实时看进度
6. 完成后审查改动
7. 满意的话，直接创建 PR 到 GitHub

**并行任务：**

Codex 最大的优势是并行。你可以同时开多个任务：

- 任务 1：修复登录超时 bug
- 任务 2：给 API 加单元测试
- 任务 3：重构数据库查询逻辑

三个任务同时在不同的沙盒里跑，互不干扰。

**GitHub 集成：**

在 GitHub 的 issue 或 PR 评论里 @codex，它会自动创建任务：

```
@codex 请根据这个 issue 的描述修复 bug，并添加相关测试
```

### 2.3 进阶：AGENTS.md 配置

跟 Claude Code 的 CLAUDE.md 类似，Codex 用 AGENTS.md 来配置项目信息。放在仓库根目录：

```markdown
# AGENTS.md

## 项目结构
- /src — 源代码
- /tests — 测试文件
- /docs — 文档

## 开发环境
- Python 3.11
- 依赖管理：poetry
- 安装依赖：poetry install
- 跑测试：poetry run pytest
- 代码检查：poetry run ruff check .

## 代码规范
- 遵循 PEP 8
- 类型注解必须写
- 每个公开函数必须有 docstring
- 测试覆盖率不低于 80%

## 注意事项
- 不要修改 migrations/ 目录下的已有文件
- 新增 API 端点需要同步更新 docs/api.md
```

### 2.4 进阶：环境配置

Codex 的云端沙盒可以自定义环境。在仓库设置里，你可以指定：

- 安装哪些系统依赖
- 运行哪些初始化命令
- 设置环境变量

这样 Codex 的沙盒环境就能跟你的真实开发环境保持一致，减少"在我机器上能跑"的问题。

### 2.5 Web 版 vs CLI 版怎么选

- 日常任务、不想离开浏览器 → Web 版
- 喜欢终端、需要跟本地文件交互 → CLI 版
- 想在写代码的同时让 Codex 帮忙 → IDE 插件

三种方式共享同一个后端，任务和历史是互通的。

---

## 三、OpenClaw

### 3.1 五分钟上手

OpenClaw 的安装比前两个复杂一些，因为它需要部署在服务器上。但一旦装好，体验是最好的。

**安装：**

```bash
npm install -g openclaw
```

**初始化：**

```bash
openclaw init
```

这会创建一个配置文件和工作目录。按提示配置：
- 选择模型提供商（推荐先用 Gemini，免费额度够用）
- 填入 API Key
- 选择要连接的聊天渠道（可以先跳过，后面再配）

**启动：**

```bash
openclaw gateway start
```

Gateway 会在后台运行。现在你可以在终端里跟它对话：

```bash
openclaw chat
```

或者配置好聊天渠道后，直接在飞书/QQ/钉钉里跟它说话。

### 3.2 日常使用

**终端对话：**

```bash
openclaw chat
> 帮我看看当前目录有什么文件
> 今天天气怎么样
> 帮我设一个 30 分钟后的提醒
```

**通过聊天渠道：**

配置好飞书/QQ Bot 等渠道后，直接在对应 App 里给它发消息就行。跟跟朋友聊天一样自然。

**定时任务：**

```bash
openclaw cron add \
  --name "每日新闻整理" \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "搜索今天的 AI 行业新闻，整理成摘要发给我"
```

这样每天早上 9 点，Agent 会自动执行这个任务。

### 3.3 进阶：Skill 安装

OpenClaw 的能力通过 Skill 扩展。安装 Skill 很简单：

```bash
# 搜索可用的 Skill
openclaw skills search weather

# 安装
openclaw skills install weather
```

一些实用的 Skill 推荐：
- `weather` — 天气查询
- `github` — GitHub 操作
- `summarize` — 内容总结
- `stock-analysis` — 股票分析
- `youtube-watcher` — YouTube 字幕提取

### 3.4 进阶：记忆系统配置

OpenClaw 的记忆系统是它的核心竞争力。工作目录下有几个关键文件：

**MEMORY.md** — 长期记忆
Agent 会自己维护这个文件，把重要的事情记在里面。你也可以手动编辑，告诉它一些背景信息。

**SOUL.md** — Agent 的"性格"
定义 Agent 的行为风格。比如：

```markdown
# SOUL.md
- 说话简洁直接，不废话
- 有自己的观点，不只是附和
- 遇到不确定的事情先查证再回答
- 幽默但不刻意
```

**AGENTS.md** — 行为规范
定义 Agent 的工作流程、安全边界、工具使用规范。

**memory/YYYY-MM-DD.md** — 每日日志
Agent 每天的工作记录。你可以翻看了解它做了什么。

### 3.5 进阶：多渠道配置

OpenClaw 支持同时连接多个聊天渠道。以飞书为例：

1. 在飞书开放平台创建一个应用
2. 获取 App ID 和 App Secret
3. 在 OpenClaw 配置文件里添加飞书渠道配置
4. 重启 Gateway

配置好后，你在飞书里给这个应用发消息，OpenClaw 就会响应。

QQ Bot、钉钉、企业微信的配置流程类似，具体参考 OpenClaw 文档：docs.openclaw.ai

### 3.6 进阶：模型配置和故障转移

OpenClaw 支持配置多个模型，设置优先级和故障转移：

```
主力模型 → 备用模型 1 → 备用模型 2 → ...
```

主力模型挂了或者达到限额，自动切到下一个。用户无感知。

推荐配置：
- 日常对话用便宜的模型（Gemini Flash、GPT-4o-mini）
- 复杂任务用强模型（Claude Opus、GPT-5）
- 设置 2-3 个备用，确保不会完全断线

### 3.7 进阶：心跳和定时任务

心跳是 OpenClaw 最有特色的功能之一。配置好后，Agent 会定期（默认 30 分钟）自己"醒来"检查有没有需要处理的事。

你可以在工作目录下创建 HEARTBEAT.md，写上每次心跳要检查的事项：

```markdown
# HEARTBEAT.md
- 检查 GitHub 有没有新通知
- 检查最近的日志有没有需要整理的
- 如果是工作日早上，看看今天的日程
- 没什么事就回复 HEARTBEAT_OK
```

定时任务（Cron）更灵活，可以设置精确的执行时间：

```bash
# 每天早上 9 点推送天气
openclaw cron add \
  --name "早间天气" \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "查一下今天上海的天气，简短告诉我需不需要带伞" \
  --deliver --channel qqbot --to "你的用户ID"

# 每周一早上发周报提醒
openclaw cron add \
  --name "周报提醒" \
  --cron "0 10 * * 1" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "提醒：今天要写周报。帮我回顾一下上周的工作日志，列出关键事项" \
  --deliver --channel feishu --to "你的飞书ID"
```

管理定时任务：
```bash
openclaw cron list          # 查看所有任务
openclaw cron remove <id>   # 删除任务
```

### 3.8 常见问题排查

**Agent 不回复：**
- 检查 Gateway 是否在运行：`openclaw gateway status`
- 检查模型 API Key 是否有效：`openclaw status`
- 查看日志：`openclaw logs --follow`

**上下文满了：**
- Agent 对话太长会撑满上下文窗口
- 发送 `/compact` 手动压缩，或 `/reset` 重置会话
- Agent 会自动把重要信息存到 MEMORY.md，重置后不会丢失关键记忆

**子代理失败：**
- 检查是否是模型请求被拒（并发限制）
- 看子代理运行时间——如果几秒就结束且 0 token，说明请求没成功
- 重试，或者在主会话里直接执行

**Skill 安装失败：**
- 确保 Node.js 版本 >= 18
- 尝试 `openclaw skills update` 更新 Skill 索引
- 查看具体错误信息

---

## 四、实用技巧汇总

### Claude Code 技巧

1. **善用 CLAUDE.md**：把项目的"潜规则"都写进去，省得每次口头交代
2. **大任务分步给**：不要一次扔一个模糊的大目标，分成明确的小步骤
3. **定期 /compact**：长时间工作后手动压缩上下文，避免 Agent 变"健忘"
4. **用 plan 模式预览**：不确定 Agent 会怎么做时，先用 plan 模式让它只分析不动手

### Codex 技巧

1. **写好 AGENTS.md**：告诉 Codex 怎么跑测试、代码规范是什么，它的输出质量会明显提升
2. **善用并行**：把独立的任务同时丢给它，别一个一个排队
3. **用 @codex 自动化**：在 GitHub issue 里 @codex，省去手动创建任务的步骤
4. **审查要仔细**：Codex 生成的代码质量不错，但不要盲目合并，测试覆盖率要保证

### OpenClaw 技巧

1. **养成让 Agent 记笔记的习惯**：重要的事情说完后加一句"记一下"
2. **定期检查 MEMORY.md**：看看 Agent 记了什么，有错的及时纠正
3. **善用 Skill 生态**：遇到新需求先搜搜有没有现成的 Skill
4. **配置故障转移**：至少配两个模型，主力挂了有备用
5. **心跳不要太频繁**：30 分钟一次够了，太频繁浪费 token

---

## 五、三款产品对比：选哪个？

| 你的需求 | 推荐 |
|---|---|
| 我是程序员，想要一个编程助手 | Claude Code |
| 我需要同时处理多个编程任务 | Codex |
| 我想要一个全天候 AI 助手 | OpenClaw |
| 我不想折腾，开箱即用 | Claude Code 或 Codex Web |
| 我想完全掌控，自己定制 | OpenClaw |
| 我的预算有限 | OpenClaw（可以用免费模型） |
| 我在企业环境里用 | Codex（有企业版）或 Claude Code |

当然，这三个不是互斥的。我自己就同时用着 Claude Code（写代码）和 OpenClaw（日常助手）。

---

## 结尾

这是系列的最后一篇。四篇文章从概念到架构到设计到实操，希望能帮你建立对 Agent 的完整认知。

Agent 时代才刚开始。现在上手，你就是最早一批真正理解和使用 Agent 的人。

去试试吧。

---

*Allen | AI 产品经理 | allen00.top*