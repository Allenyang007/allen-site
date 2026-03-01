# Agent 产品设计系列文章 — 需求规划

> 创建时间: 2026-02-25 23:50
> 状态: 需求确认完毕，待执行

## 系列概述
- 四篇系列博客，发布到 allen00.top/blog/
- 主题：从 Claude Code、OpenAI Codex、OpenClaw 三款产品深度拆解 Agent 产品设计
- 先出预览链接，用户确认后再正式发布

## 写作要求
- 第一人称，产品经理视角
- 深入浅出：有深度但不堆技术黑话，用类比和场景解释
- 终端/GitHub 基础简单带一下
- 小白能入门，深度用户有收获，纯小白放弃
- 字数不卡上限，写够写透
- 去 AI 味（humanizer 审查）
- 信息准确，查官方文档核实
- 图文并茂

## 四篇结构

### 第一篇：AI Agent 到底是什么？从三款产品说起（科普入门）
- 预估字数：4000-5000
- Chatbot → Copilot → Agent 三层递进（建筑行业类比）
- Agent 核心公式：LLM + 观察 + 思考 + 行动 + 记忆
- Agent vs Workflow 区分
- Claude Code / Codex / OpenClaw 三款产品概览
- 为什么 2026 是 Agent 元年

### 第二篇：三款 Agent 产品架构深度拆解（技术深度）
- 预估字数：6000-8000
- Claude Code：单进程 Agent Loop、三阶段循环、工具三层、权限模型、CLAUDE.md
- OpenAI Codex：云端并行、codex-1 模型、沙盒环境、AGENTS.md、GitHub 集成、三种形态（Web/CLI/IDE）
- OpenClaw：Gateway+Client 分离、多渠道、Skill 插件、三层记忆、心跳、Cron、模型无关
- 三者架构对比表
- MCP 协议在三者中的角色
- 需要架构图（Mermaid 渲染）

### 第三篇：产品经理的 Agent 设计心得（产品方法论）
- 预估字数：4000-5000
- 五个核心设计决策（本地vs云端、单任务vs并行、工具系统、记忆、安全）
- 懂业务比懂技术更重要（举例说明）
- Agent 用户场景分层（轻量/中等/重度）
- Agent 进化路径（被动→主动、健忘→记忆、单一→协作、封闭→开放）
- 如果我来设计一个 Agent 产品的 6 步

### 第四篇：Claude Code / Codex / OpenClaw 实战操作指南（上手教程）
- 预估字数：5000-7000
- 终端和 Git 基础简介
- Claude Code：安装→CLAUDE.md 配置→权限设置→日常使用→子代理→进阶技巧
- Codex：安装（npm/brew）→ChatGPT 登录→Web/CLI/IDE 三种用法→AGENTS.md→GitHub 集成
- OpenClaw：部署→配置→Skill 安装→记忆系统→心跳→Cron→多渠道
- 入门→进阶分层

## 配图方案
- 架构图/流程图：用 Mermaid 渲染成 PNG（我来做）
- 概念配图/封面图：出描述+Gemini 提示词清单（用户用 Gemini 生成）
- 配图清单单独一个文档交付

## 参考素材
- 之前的架构研究报告：/root/.openclaw/workspace/projects/allen-site/blog/research-agent-architecture.md（732行）
- 课件 M6：/root/.openclaw/workspace/projects/courseware/content/M6-Agent架构与设计模式.md（1149行）
- 课件 M8：/root/.openclaw/workspace/projects/courseware/content/M8-MCP与A2A工具生态.md（1610行）
- OpenAI Codex 官方介绍：https://openai.com/index/introducing-codex/
- Codex GitHub：https://github.com/openai/codex
- Codex 文档：https://developers.openai.com/codex

## 交付物
1. 四篇 HTML 页面，部署到 allen00.top/preview/agent-series/（临时预览，不挂正式导航）
2. Mermaid 渲染的架构图 PNG（嵌入 HTML）
3. 配图需求清单 markdown 文件（描述+Gemini 提示词），通过下载链接交付给用户
4. 用户确认后再正式发布到 /blog/ 目录
