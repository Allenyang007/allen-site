# Claude Code 与 OpenClaw 架构深度拆解

## 前言

Claude Code 是 Anthropic 官方推出的 CLI Agent 产品，而 OpenClaw 是一个开源的 Agent 框架。两者都试图解决同一个问题：如何让大语言模型（LLM）在真实环境中自主执行任务。但它们的实现路径、设计理念和产品形态有显著差异。这篇报告从产品经理视角深入拆解两者的底层架构，帮助理解 Agent 产品设计的核心抉择。

---

## 一、Claude Code 架构解析

### 1.1 整体架构：单一进程内的 Agent Loop

Claude Code 采用**单一进程、单一 Agent**的架构模式。用户在终端运行 `claude` 命令后，会启动一个 Node.js 进程（或 Electron 封装版本），这个进程内部运行着一个完整的 Agent Loop。

**架构图（文字描述）**：
```
用户输入 → CLI REPL → Agent Loop → Model API（Claude API）
                ↓
            工具执行层（文件读写、Bash、浏览器等）
                ↓
            结果回流到上下文 → 下一轮推理
```

Claude Code 的核心哲学是**"一个会话、一个上下文"**。所有操作都在同一个进程内完成，工具调用是同步阻塞的，直到工具返回结果才会继续下一轮模型调用。这种设计的好处是简单、可预测；坏处是单个会话无法真正并行处理多个任务。

从官方文档可以看到："The agentic loop is powered by two components: models that reason and tools that act. Claude Code serves as the agentic harness around Claude: it provides the tools, context management, and execution environment that turn a language model into a capable coding agent."

### 1.2 Agent Loop 的三阶段循环

Claude Code 的 Agent Loop 遵循固定的三阶段：

**阶段一：Gather Context（收集上下文）**
- 读取用户输入
- 加载 CLAUDE.md 项目配置
- 加载已启用的 Skills 描述
- 加载 MCP 服务器工具定义
- 读取历史对话

**阶段二：Take Action（执行动作）**
- 调用 Claude API 进行推理
- 模型决定调用哪个工具
- 工具执行（可能是文件读写、Bash 命令、网络请求等）
- 工具结果返回给模型

**阶段三：Verify Results（验证结果）**
- 模型分析工具执行结果
- 决定是否需要继续行动
- 或者生成最终回复给用户

这三个阶段不是线性的，而是循环往复的。文档描述得很清楚："When you give Claude a task, it works through three phases: gather context, take action, and verify results. These phases blend together."

### 1.3 工具系统设计

Claude Code 的工具系统分为三个层级：

**层级一：Built-in Tools（内置工具）**
这是 Claude Code 最核心的工具集，包括：
- File operations: Read, Edit, Write（文件读写）
- Search: Grep, Glob（文件搜索）
- Execution: Bash（命令执行）
- Web: WebFetch, WebSearch（网络请求）
- Code intelligence: 跳转到定义、查找引用等（需安装插件）

**层级二：Skills（技能）**
Skills 是用户自定义的工作流模板。每个 Skill 是一个目录，包含 SKILL.md 文件。Skills 的特点是**按需加载**——系统提示词中只包含 Skills 的描述列表，完整内容只有在 Skill 被调用时才会加载。

**层级三：MCP Servers（外部服务）**
MCP（Model Context Protocol）是 Anthropic 推出的开放协议，允许 Claude Code 连接外部服务。每个 MCP Server 会暴露一组工具，Claude Code 会将其工具定义合并到系统提示词中。

从成本文档可以看到 MCP 的问题："Each MCP server adds tool definitions to your context, even when idle... MCP servers can consume significant context before you start working." 这引出了工具搜索（Tool Search）机制——当工具定义超过上下文窗口的 10% 时，Claude Code 会延迟加载工具，直到模型实际需要时才注入上下文。

### 1.4 权限控制模型

Claude Code 的权限系统是其安全设计的核心，采用**多层叠加**策略：

**权限模式（Permission Modes）**：
- `default`: 每次敏感操作都询问
- `acceptEdits`: 自动接受文件编辑，但命令仍需确认
- `plan`: 只读模式，用于安全分析
- `dontAsk`: 自动拒绝未预授权的操作
- `bypassPermissions`: 完全跳过权限检查（危险）

**权限规则语法**：
```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Read(~/.zshrc)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "WebFetch"]
  }
}
```

规则按 `deny → ask → allow` 顺序匹配，第一个匹配的生效。这种设计让管理员可以通过 managed settings 在企业环境中强制实施安全策略。

**沙盒机制**：
Claude Code 还提供 OS 级沙盒，通过限制文件系统和网络访问来隔离 Bash 命令。沙盒与权限系统是互补的——权限控制 Claude "能尝试做什么"，沙盒控制"实际能访问什么"。

### 1.5 上下文管理策略

上下文管理是 Claude Code 最复杂的部分之一，因为 LLM 的上下文窗口有限（Sonnet 4.6 是 200K tokens）。

**上下文组成**：
1. System Prompt（系统提示词）
2. CLAUDE.md 项目配置
3. 技能描述列表
4. MCP 工具定义
5. 对话历史（用户消息 + 助手消息 + 工具调用结果）
6. 附件/文件内容

**自动压缩机制（Auto-compaction）**：
当会话接近上下文上限时，Claude Code 会自动触发压缩：
- 首先清除旧的工具输出
- 然后对历史对话进行摘要，生成 "compaction summary"
- 摘要替换被压缩的历史，保留最近的消息完整

文档说明："Claude Code manages context automatically as you approach the limit. It clears older tool outputs first, then summarizes the conversation if needed."

**用户可控的压缩**：
用户可以发送 `/compact` 命令手动触发压缩，还可以指定压缩时的关注点，例如 `/compact Focus on API changes`。也可以在 CLAUDE.md 中添加 "Compact Instructions" 段落来指导压缩策略。

**Session Pruning（会话修剪）**：
与压缩不同，修剪是在内存中临时移除旧的工具结果，不会写入会话历史。这是每次调用模型前的预处理步骤。

### 1.6 子代理（Sub-agents）实现

Claude Code 支持子代理，但实现方式比较特殊：

**子代理不是真正的并行**：子代理通过 `Task` 工具调用，但它运行在同一个进程中。子代理有自己的上下文窗口和系统提示词，但父代理必须等待子代理完成后才能继续。

**预定义的子代理类型**：
- **Explore**: 只读探索，使用 Haiku 模型，用于快速搜索代码库
- **Plan**: 研究型代理，用于 Plan Mode 下的代码分析
- **General-purpose**: 通用型，可以做修改

子代理的配置示例：
```yaml
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---
You are a code reviewer...
```

子代理可以限制工具集（如禁止 Write/Edit），但无法真正并行执行——这是 Claude Code 架构的根本限制。

### 1.7 与 Claude API 的交互

Claude Code 底层调用 Anthropic 的 Messages API。关键细节：

**Prompt Caching（提示词缓存）**：
Claude Code 利用 Anthropic 的 prompt caching 功能来降低成本。系统提示词、CLAUDE.md、工具定义等静态内容会被缓存，重复调用时只计费增量部分。

**Extended Thinking（扩展思考）**：
对于复杂任务，Claude Code 支持 Extended Thinking 模式，让模型在回答前进行更深入推理。这通过设置 `thinking.budget_tokens` 参数实现。

**模型切换**：
用户可以通过 `/model` 命令在会话中切换模型（如从 Sonnet 切换到 Opus），Claude Code 会重新初始化 API 客户端，但保留会话历史。

---

## 二、OpenClaw 架构解析

### 2.1 整体架构：Gateway + Client 分离

OpenClaw 采用**分离式架构**：
- **Gateway（网关）**：一个长期运行的 daemon 进程，负责维护所有渠道连接（WhatsApp、Telegram、Discord 等），管理会话存储，执行 Agent Loop
- **Clients（客户端）**：CLI、Web UI、macOS App 等，通过 WebSocket 连接到 Gateway
- **Nodes（节点）**：可选的远程设备（手机、服务器），通过 WebSocket 提供额外能力（摄像头、屏幕录制等）

**架构图（文字描述）**：
```
┌─────────────────────────────────────────────────────────────┐
│                        Gateway (daemon)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ WhatsApp     │  │ Telegram     │  │ Agent Loop       │  │
│  │ Provider     │  │ Provider     │  │ (pi-agent-core)  │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ Slack        │  │ Discord      │  │ Session Manager  │  │
│  │ Provider     │  │ Provider     │  │ (JSONL storage)  │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                    ↑ WebSocket
    ┌───────────────┴───────────────┐
┌───┴───┐  ┌──────────┐  ┌─────────┐
│ CLI   │  │ WebChat  │  │ macOS   │
└───────┘  └──────────┘  └─────────┘
```

这种架构的核心优势是**渠道无关性**——同一个 Gateway 可以同时处理 WhatsApp、Telegram、Discord 等多个渠道的消息，并将它们路由到同一个或不同的 Agent。

### 2.2 Gateway 的 Daemon 模式与会话管理

**Daemon 模式**：
Gateway 作为守护进程运行（`openclaw gateway`），持续监听 18789 端口（默认）。它维护所有渠道的 WebSocket 连接，并管理用户会话的生命周期。

**会话存储**：
会话数据存储在 `~/.openclaw/agents/<agentId>/sessions/`：
- `sessions.json`: 会话索引，记录 sessionKey → sessionId 的映射
- `<sessionId>.jsonl`: 会话历史（JSON Lines 格式）

OpenClaw 的会话隔离策略比 Claude Code 更复杂。文档描述："Direct chats collapse to `agent:<agentId>:<mainKey>` (default `main`), while group/channel chats get their own keys."

**DM Scope 配置**：
```json5
{
  session: {
    dmScope: "per-channel-peer",  // 选项: main, per-peer, per-channel-peer, per-account-channel-peer
  }
}
```
这个设计是为了多用户场景的安全——默认的 `main` 模式让所有私聊共享同一个会话，这在多人使用同一 Agent 时会导致信息泄露风险。

### 2.3 Skill 插件系统

OpenClaw 的 Skill 系统是其扩展能力的核心，设计哲学是**"工具即文档"**。

**Skill 的存储位置**（按优先级排序）：
1. `<workspace>/skills/` —— 工作区级（最高优先级）
2. `~/.openclaw/skills/` —— 用户级
3. Bundled skills —— 随安装包附带

**Skill 格式**：
每个 Skill 是一个目录，包含 `SKILL.md`：
```markdown
---
name: nano-banana-pro
description: Generate images via Gemini
metadata:
  { "openclaw": { "requires": { "bins": ["uv"], "env": ["GEMINI_API_KEY"] } } }
---
使用 Gemini 生成图片...
```

**Gate 机制**：
Skill 可以通过 `metadata.openclaw.requires` 声明依赖条件：
- `bins`: 必须存在的可执行文件
- `env`: 必须存在的环境变量
- `config`: 必须存在的配置项

只有所有条件满足，Skill 才会被加载到系统提示词中。

**配置注入**：
用户可以在 `openclaw.json` 中为 Skill 提供配置：
```json5
{
  skills: {
    entries: {
      "nano-banana-pro": {
        enabled: true,
        apiKey: "...",
        env: { GEMINI_API_KEY: "..." }
      }
    }
  }
}
```

### 2.4 Agent Loop 实现细节

OpenClaw 的 Agent Loop 实现比 Claude Code 更复杂，因为它需要处理**多会话并发**。

**入口点**：
- Gateway RPC: `agent` 和 `agent.wait`
- CLI: `agent` 命令

**执行流程**：
1. `agent` RPC 验证参数，解析 sessionKey，返回 `{ runId, acceptedAt }`
2. `agentCommand` 运行 Agent：
   - 解析模型和默认配置
   - 加载 Skills 快照
   - 调用 `runEmbeddedPiAgent`
3. `runEmbeddedPiAgent`：
   - 通过**队列**序列化运行（保证同一会话只有一个活跃 run）
   - 订阅 pi-agent-core 事件
   - 强制执行超时
4. `subscribeEmbeddedPiSession` 将 pi-agent-core 事件桥接到 OpenClaw 事件流

**队列机制**：
OpenClaw 使用**lane-aware FIFO queue** 来管理并发：
- 每个 sessionKey 有自己的 lane，保证同一会话的串行执行
- 全局 lane（`main` 默认并发为 4，`subagent` 为 8）限制总体并发数

文档说明："A lane-aware FIFO queue drains each lane with a configurable concurrency cap... This prevents tool/session races and keeps session history consistent."

### 2.5 记忆系统：三层架构

OpenClaw 的记忆系统是其与 Claude Code 最大的差异之一，采用**三层架构**：

**第一层：Daily Notes（日常笔记）**
- 文件路径：`memory/YYYY-MM-DD.md`
- 内容：当天的运行日志、对话摘要
- 加载策略：自动加载今天和昨天的文件

**第二层：Long-term Memory（长期记忆）**
- 文件路径：`MEMORY.md`
- 内容：凝练的知识、用户画像、重要决策
- 加载策略：**只在主会话、私聊场景加载**，群组中不加载以保护隐私

**第三层：Vector Search（向量搜索）**
- 存储：SQLite + sqlite-vec 扩展
- 索引内容：MEMORY.md 和 memory/*.md
- 搜索方式：语义搜索（向量相似度）+ BM25 关键词搜索（混合搜索）

**自动记忆刷新**：
当会话接近压缩阈值时，OpenClaw 会触发一次"静默记忆刷新"——在压缩前提醒 Agent 将重要信息写入 memory 文件。配置如下：
```json5
{
  agents: {
    defaults: {
      compaction: {
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000,
          systemPrompt: "Session nearing compaction. Store durable memories now."
        }
      }
    }
  }
}
```

### 2.6 多渠道路由系统

这是 OpenClaw 最强大的功能——**真正的全渠道 Agent**。

**渠道支持**：
WhatsApp（Baileys）、Telegram（GrammY）、Slack、Discord、Signal、iMessage、飞书、Matrix、Mattermost 等。

**会话 Key 的生成规则**：
- 私聊：`agent:<agentId>:<mainKey>` 或 `agent:<agentId>:<channel>:dm:<peerId>`（取决于 dmScope）
- 群组：`agent:<agentId>:<channel>:group:<groupId>`
- 频道：`agent:<agentId>:<channel>:channel:<channelId>`
- 线程：`...:thread:<threadId>`

**路由绑定（Bindings）**：
管理员可以配置消息如何路由到不同的 Agent：
```json5
{
  agents: {
    list: [
      { id: "home", default: true },
      { id: "work", workspace: "~/.openclaw/workspace-work" }
    ]
  },
  bindings: [
    { agentId: "home", match: { channel: "whatsapp", accountId: "personal" } },
    { agentId: "work", match: { channel: "whatsapp", accountId: "biz" } },
    { agentId: "work", match: { channel: "telegram", peer: { kind: "direct", id: "@boss" } } }
  ]
}
```

**Broadcast Groups（广播组）**：
还可以配置广播组，让一个消息同时触发多个 Agent：
```json5
{
  broadcast: {
    "120363403215116621@g.us": ["alfred", "baerbel"]
  }
}
```

### 2.7 心跳机制（Heartbeat）

Heartbeat 是 OpenClaw 的**主动检查机制**，让 Agent 可以主动向用户报告状态。

**工作原理**：
- Gateway 按配置间隔（默认 30 分钟）触发心跳
- 发送预设的 prompt（默认：读取 HEARTBEAT.md 并检查待办事项）
- Agent 决定是否有事情需要报告
- 如果有，发送消息；如果没有，回复 `HEARTBEAT_OK`（会被静默处理）

**配置示例**：
```json5
{
  agents: {
    defaults: {
      heartbeat: {
        every: "30m",
        target: "last",  // 发送到最近使用的渠道
        prompt: "Read HEARTBEAT.md...",
        activeHours: { start: "08:00", end: "22:00" }
      }
    }
  }
}
```

**Heartbeat vs Cron**：
- Heartbeat：与主会话集成，复用上下文，适合轻量级检查
- Cron：独立会话执行，可以指定不同模型，适合独立任务

### 2.8 Cron 定时任务系统

Cron 是 OpenClaw 的**调度器**，支持复杂的定时任务。

**两种执行模式**：

1. **Main Session 模式**：
   - 触发一次心跳事件
   - 在下一次心跳时执行
   - 复用主会话上下文

2. **Isolated Session 模式**：
   - 创建独立会话 `cron:<jobId>`
   - 使用指定模型执行
   - 结果可以发送到指定渠道

**CLI 示例**：
```bash
# 一次性提醒
openclaw cron add \
  --name "Reminder" \
  --at "20m" \
  --session main \
  --system-event "Check calendar" \
  --wake now

# 定时早报（独立会话 + 发送到 Slack）
openclaw cron add \
  --name "Morning brief" \
  --cron "0 7 * * *" \
  --tz "America/Los_Angeles" \
  --session isolated \
  --message "Summarize overnight updates" \
  --announce \
  --channel slack \
  --to "channel:C1234567890"
```

**失败重试**：
Recurring jobs 在连续失败后会进入指数退避：30s → 1m → 5m → 15m → 60m，成功一次后重置。

### 2.9 子代理系统（sessions_spawn）

OpenClaw 的子代理是真正的**后台并行执行**。

**调用方式**：
```json
{
  "task": "Research the latest server logs",
  "label": "research logs",
  "model": "minimax/MiniMax-M2.1",
  "runTimeoutSeconds": 300,
  "cleanup": "keep"
}
```

**执行流程**：
1. 主代理调用 `sessions_spawn`，立即返回 `{ status: "accepted", runId, childSessionKey }`
2. 子代理在独立的 `subagent` lane 中排队执行
3. 子代理完成后，通过 "announce" 机制将结果发送回原会话
4. 子代理会话默认 60 分钟后自动归档

**工具限制**：
子代理默认没有以下工具：
- `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`（不能嵌套）
- `gateway`, `agents_list`（系统管理工具）
- `memory_search`, `memory_get`（应通过 prompt 传入必要信息）

**并发控制**：
```json5
{
  agents: {
    defaults: {
      subagents: {
        maxConcurrent: 8,  // 默认 8 个并发
        archiveAfterMinutes: 60
      }
    }
  }
}
```

### 2.10 上下文压缩与 Safeguard

OpenClaw 也有上下文压缩，但比 Claude Code 更激进。

**压缩触发条件**：
```json5
{
  agents: {
    defaults: {
      compaction: {
        reserveTokensFloor: 20000,  // 保留 20K tokens
        softThresholdTokens: 4000   // 提前 4K 触发
      }
    }
  }
}
```

**压缩流程**：
1. 触发 memoryFlush（提醒 Agent 写记忆）
2. 调用模型对历史进行摘要
3. 生成 compact entry 替换旧历史
4. 可能触发 retry（用压缩后的上下文重新运行）

**Session Pruning**：
与 Claude Code 不同，OpenClaw 的 pruning 默认**移除旧的工具结果**，但保留工具调用记录（仅移除结果内容）。

---

## 三、架构对比分析

### 3.1 Agent Loop 设计哲学

| 维度 | Claude Code | OpenClaw |
|------|-------------|----------|
| **进程模型** | 单一进程，单一会话 | Gateway daemon + 多个 Client/Session |
| **并发性** | 伪并行（子代理阻塞父代理） | 真并行（子代理独立队列） |
| **渠道** | 仅 CLI/IDE 内部 | 全渠道（WhatsApp、Telegram、Slack 等） |
| **上下文边界** | 会话即边界 | Agent 即边界，会话只是子集 |

Claude Code 的设计是**"个人编程助手"**——假设一个用户在一个终端里工作。OpenClaw 的设计是**"团队基础设施"**——假设多个用户通过多个渠道访问。

### 3.2 工具系统：静态 vs 动态

**Claude Code**：
- Built-in tools 是硬编码的
- Skills 是静态文件
- MCP 需要重启才能加载新服务器
- 工具定义常驻上下文（除非启用 tool search）

**OpenClaw**：
- Skills 支持运行时热重载（watcher）
- 可以通过插件动态扩展
- 工具调用通过配置注入，而非硬编码
- 支持条件加载（gate 机制）

Claude Code 的工具系统更适合**稳定性优先**的场景；OpenClaw 更适合**灵活性优先**的场景。

### 3.3 上下文管理策略

两者都面临同样的上下文限制，但策略不同：

**Claude Code**：
- 压缩是自动的，用户可控性弱
- 依赖 CLAUDE.md 来保持持久知识
- 子代理的隔离是"软隔离"（共享进程）

**OpenClaw**：
- 压缩前有 memoryFlush 提醒
- 三层记忆系统（Daily + Long-term + Vector）
- 子代理是"硬隔离"（独立会话、独立队列）

OpenClaw 的记忆系统更接近人类记忆的工作方式——有短期笔记、有长期知识、有关联搜索。

### 3.4 持久性与记忆

**Claude Code**：
- Auto Memory（实验性功能）：自动提取关键信息写入 CLAUDE.md
- 会话独立，没有跨会话记忆
- Checkpoints 用于撤销文件修改，不是记忆

**OpenClaw**：
- 显式的 memory/ 目录结构
- Vector search 支持语义检索
- 支持跨会话、跨渠道的记忆共享（通过 MEMORY.md）

### 3.5 并发与子代理

这是两者最大的技术差异：

**Claude Code**：
```
Main Session ──spawn──→ Sub-agent (blocked, same process)
    ↑                         ↓
  wait ←────────────────── result
```

**OpenClaw**：
```
Main Session ──spawn──→ Sub-agent (queue, async)
    │                         ↓
  continue ←────────────── announce (callback)
```

OpenClaw 的队列机制（lane-aware FIFO queue）是真正的异步架构，Claude Code 的子代理只是同步委托。

### 3.6 安全模型

**Claude Code**：
- 权限规则 + 沙盒双层防护
- 企业版支持 managed settings（IT 强制策略）
- 所有工具调用需用户批准（除非预授权）

**OpenClaw**：
- Tool policy（allow/deny）
- Exec approvals（命令执行审批）
- Sandboxing（Docker 容器隔离）
- Per-agent 权限配置

两者都支持细粒度权限，但 OpenClaw 的 per-agent 配置在多租户场景更灵活。

### 3.7 可扩展性

**Claude Code**：
- Skills（模板）
- MCP（外部服务）
- Hooks（生命周期脚本）
- 扩展点是"向外"的（调用外部服务）

**OpenClaw**：
- Skills（模板 + 工具）
- Plugins（完整插件系统）
- Hooks（Gateway 事件）
- 扩展点是"向内"的（修改 Gateway 行为）

Claude Code 是**产品化**思路——提供固定能力，通过标准协议扩展。OpenClaw 是**平台化**思路——提供基础设施，允许深度定制。

---

## 四、产品设计启发

### 4.1 对 AI 产品经理的启示

**1. 上下文是稀缺资源，设计时要精打细算**

Claude Code 的 context costs 文档透露：平均每个开发者每天消耗 $6，90% 用户低于 $12。OpenClaw 的技能列表会消耗约 24 tokens 每个。这些数字说明上下文管理直接影响成本。

启示：
- 不要默认加载所有能力
- 支持按需加载（如 tool search、skill on-demand）
- 提供上下文使用可视化（/context, /cost 命令）

**2. 会话边界决定产品形态**

Claude Code 的"一个终端、一个会话"设计适合个人编程。OpenClaw 的"Gateway + 多渠道"设计适合团队助理。你的目标用户是谁，决定了架构选择。

启示：
- ToC 场景可以简化（单会话）
- ToB 场景需要隔离（多会话、权限）
- 混合场景需要灵活的路由（Bindings）

**3. 记忆是差异化关键**

两个产品都在记忆上下功夫。Claude Code 的 auto memory 是隐式的，OpenClaw 的三层记忆是显式的。用户测试表明，显式记忆让用户更有控制感。

启示：
- 给用户可见的记忆存储（文件/数据库）
- 支持记忆的显式管理（CRUD）
- 语义检索是标配（vector search）

**4. 安全不能事后考虑**

Claude Code 的 permission system 和 OpenClaw 的 exec approvals 都是核心设计，不是补丁。Agent 能执行代码，安全必须是第一位的。

启示：
- 默认拒绝（fail closed）
- 分层权限（用户/项目/企业）
- 审计日志（所有工具调用记录）

### 4.2 可以借鉴到 ResearchMate 的设计点

**借鉴 1：Skill 的 Gate 机制**

ResearchMate 可以学习 OpenClaw 的 Skill gating，让研究技能只在特定条件下可用：
- 检测到 PDF 文件时启用 PDF 解析技能
- 检测到数据源连接时启用数据分析技能
- 用户未配置 API key 时隐藏对应技能

**借鉴 2：Heartbeat + Cron 的组合**

ResearchMate 可以结合两者的优点：
- Heartbeat 用于轻量级检查（新文献提醒、数据源更新）
- Cron 用于重型任务（定期报告生成、数据同步）
- 两者共用相同的调度基础设施

**借鉴 3：Session Pruning 策略**

研究场景会产生大量中间结果（搜索、浏览、笔记）。可以学习 OpenClaw：
- 保留工具调用记录，但移除详细结果
- 定期摘要（compaction）保留研究结论
- 支持用户标记"保留这条结果"

**借鉴 4：多渠道路由**

如果 ResearchMate 需要支持团队协作，可以参考 OpenClaw 的 bindings：
- 不同项目路由到不同的研究 Agent
- 特定关键词触发特定技能
- 支持广播（一个发现通知多个渠道）

**借鉴 5：三层记忆系统**

ResearchMate 的研究记忆可以设计为：
- **Session Memory**: 当前研究会话的临时笔记
- **Project Memory**: 项目级别的知识库（已验证的结论）
- **User Memory**: 用户级别的偏好和跨项目知识

每层使用不同的存储和检索策略。

**借鉴 6：异步子代理**

Claude Code 的子代理是阻塞的，用户体验受限。ResearchMate 应该采用 OpenClaw 的异步模式：
- 用户提交研究任务后立即返回
- 后台执行（可能耗时几分钟）
- 完成后通知用户
- 支持查看进度和取消任务

---

## 五、结论

Claude Code 和 OpenClaw 代表了 Agent 架构的两种范式：

- **Claude Code** = 个人编程助手，强调简洁、一致、开箱即用。架构选择服务于"一个开发者在终端里高效工作"。

- **OpenClaw** = 团队 Agent 平台，强调灵活、可扩展、全渠道。架构选择服务于"多个用户通过多个渠道访问多个 Agent"。

对于 ResearchMate 这样的研究助手产品，关键决策包括：

1. **用户是单人还是团队？** 单人用 Claude Code 模式，团队用 OpenClaw 模式。
2. **输入渠道是否固定？** 固定用简单架构，多渠道需要 Gateway。
3. **任务是否需要长时间运行？** 需要的话必须异步（OpenClaw 模式）。
4. **记忆是否需要跨会话？** 需要的话必须显式设计记忆系统（OpenClaw 模式）。

最后，两个产品有一个共同点：**Agent 的价值不在于模型能力，而在于如何管理上下文、如何设计工具、如何处理失败、如何让用户保持控制。** 这些是产品经理最应该关注的。

---

**参考资料**：
- Claude Code 官方文档: https://code.claude.com/docs
- OpenClaw 文档目录: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/
- OpenClaw Gateway 架构: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/concepts/architecture.md
- OpenClaw Agent Loop: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/concepts/agent-loop.md
- OpenClaw Memory: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/concepts/memory.md
- OpenClaw Sub-Agents: /root/.nvm/versions/node/v22.22.0/lib/node_modules/openclaw/docs/tools/subagents.md
