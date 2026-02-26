# Agent 系列文章 — 配图需求清单

> 共需配图约 12 张：4 张架构图（Mermaid 渲染，我来做）+ 8 张概念配图（Gemini 生成，你来做）

---

## 一、架构图（Mermaid 渲染，我负责）

这些图我用 Mermaid 在线渲染成 PNG，不需要你操作。

| 编号 | 图名 | 用在哪篇 | 状态 |
|---|---|---|---|
| M1 | Agent Loop 通用循环 | 第二篇 开头 | ✅ 已完成 |
| M2 | Claude Code 架构图 | 第二篇 §二 | ✅ 已完成 |
| M3 | Codex 云端并行架构图 | 第二篇 §三 | ⏳ 待重试 |
| M4 | OpenClaw Gateway 架构图 | 第二篇 §四 | ⏳ 待渲染 |

---

## 二、概念配图（Gemini 生成，你负责）

以下每张图给出：用途、内容描述、Gemini 提示词。

### 图 C1：系列封面图
- 用途：四篇文章共用的系列封面 / 社交分享图
- 内容：三个不同风格的 AI Agent 形象并排站立，背景是科技感的电路板纹理，中间有连接线
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create a modern tech illustration showing three distinct AI agent characters standing side by side. Left agent is sleek and minimal (representing Claude Code), middle agent is surrounded by floating cloud icons and parallel task streams (representing Codex), right agent is connected to multiple chat bubbles from different platforms like a hub (representing OpenClaw). Background: dark blue gradient with subtle circuit board patterns. Style: clean vector illustration, tech startup aesthetic, no text. Aspect ratio 16:9.
```

### 图 C2：三层能力递进图
- 用途：第一篇 §一，Chatbot→Copilot→Agent 三层递进
- 内容：三级台阶，从左到右递升。第一级标注"对话"，第二级标注"辅助"，第三级标注"自主"。每级上站着一个角色形象
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create a clean infographic illustration showing three ascending levels/steps from left to right. Level 1 (lowest): a simple chat bubble icon, labeled concept "conversation only". Level 2 (middle): a human figure with a smaller AI helper beside them, labeled concept "assisted work". Level 3 (highest): an autonomous robot figure with tools and gears around it, labeled concept "independent action". Use a gradient background from light to dark blue. Style: modern flat illustration, minimal, professional. No text labels. Aspect ratio 16:9.
```

### 图 C3：Agent 核心公式图
- 用途：第一篇 §二，智能体 = LLM + 观察 + 思考 + 行动 + 记忆
- 内容：中心是一个大脑图标（LLM），周围环绕四个元素：眼睛（观察）、灯泡（思考）、齿轮（行动）、书本（记忆），用连接线串成环形
- 尺寸：1:1 方形

**Gemini 提示词：**
```
Create a diagram-style illustration with a glowing brain icon at the center representing LLM. Around it in a circular arrangement are four icons connected by flowing lines: an eye icon (observation), a lightbulb icon (thinking), a gear/wrench icon (action), and a book/memory icon (memory). The connecting lines form a cycle showing the flow between these elements. Background: clean white or very light gray. Style: modern tech illustration, clean lines, vibrant but professional colors. No text. Square format 1:1.
```

### 图 C4：Agent vs Workflow 对比图
- 用途：第一篇 §三
- 内容：左右对比。左边是一条固定的流水线（Workflow），节点之间用直线连接，路径固定。右边是一个灵活的网络（Agent），节点之间有多条可选路径，有些路径是虚线表示"可能走也可能不走"
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create a split comparison illustration. Left side: a rigid assembly line / flowchart with fixed nodes connected by straight arrows, representing a Workflow - mechanical, predictable, factory-like. Right side: a flexible network of nodes with multiple possible paths, some solid some dashed, representing an Agent - adaptive, dynamic, brain-like. Use contrasting colors: left side in cool grays/blues (mechanical), right side in warm oranges/purples (intelligent). Clean modern style, no text. Aspect ratio 16:9.
```

### 图 C5：Claude Code 使用场景图
- 用途：第一篇 §四 或第四篇 §一
- 内容：一个开发者坐在电脑前，终端窗口里显示代码和 AI 对话，旁边有文件图标和代码符号飘浮
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create an illustration of a developer working at a terminal/command line interface. The screen shows a mix of code and conversational AI text. Around the workspace, floating icons represent files, code brackets, search symbols, and git branches. The mood is focused and productive, like late-night coding. Dark theme terminal on screen. Style: modern tech illustration, slightly isometric perspective, warm desk lamp lighting contrast with cool screen glow. No text on screen should be readable. Aspect ratio 16:9.
```

### 图 C6：Codex 并行任务图
- 用途：第一篇 §四 或第四篇 §二
- 内容：一个用户在中心，周围有 3-5 个云端沙盒同时运行，每个沙盒里有不同的任务（修 bug、写测试、重构等），用虚线连回用户
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create an illustration showing parallel cloud computing for coding tasks. A central user figure is connected to 4-5 floating cloud sandbox environments, each running a different task simultaneously (shown by different colored progress indicators). Each sandbox contains a miniature code editor view. Lines connect all sandboxes back to the central user. Background: light gradient suggesting cloud/sky. Style: clean isometric illustration, modern SaaS product aesthetic. No readable text. Aspect ratio 16:9.
```

### 图 C7：OpenClaw 多渠道连接图
- 用途：第一篇 §四 或第四篇 §三
- 内容：中心是 OpenClaw 的 Gateway 节点，周围连接着各种聊天平台的图标（飞书、QQ、钉钉、Telegram、Discord 等），像一个轮毂连接辐条
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create a hub-and-spoke illustration with a central AI agent node (glowing, tech-styled) connected to multiple messaging platform icons arranged in a circle around it: chat bubbles in different colors representing various platforms (enterprise chat, social messaging, team collaboration tools). Each connection line pulses with data flow indicators. The central hub also connects downward to server/database icons. Background: dark tech gradient. Style: modern network diagram illustration, clean and professional. No logos or text. Aspect ratio 16:9.
```

### 图 C8：MCP 协议 USB-C 类比图
- 用途：第二篇 §六
- 内容：左边是混乱的各种不同接口线缆（代表传统 API 集成），右边是统一的 USB-C 接口（代表 MCP），中间有一个箭头表示"标准化"
- 尺寸：16:9 横版

**Gemini 提示词：**
```
Create a before-and-after comparison illustration. Left side (before): a tangled mess of different cables, connectors, and adapters in various shapes and colors, representing fragmented API integrations - chaotic and frustrating. Right side (after): a single clean USB-C style universal connector with multiple devices happily connected through it, representing MCP standardization - clean and organized. An arrow or transition effect connects the two sides. Style: modern product illustration, clean lines, satisfying visual contrast between chaos and order. No text. Aspect ratio 16:9.
```

---

## 使用说明

1. 把上面的 Gemini 提示词逐个喂给 Gemini，生成图片
2. 图片命名建议：c1-cover.jpg, c2-three-levels.jpg, c3-agent-formula.jpg ... 
3. 生成后发给我，我嵌入到 HTML 页面里
4. 如果某张图效果不好，可以微调提示词重新生成
5. 建议用 Gemini 的高质量模式，输出 1024px 以上分辨率
