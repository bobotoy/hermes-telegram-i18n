<div align="center">

# 🌐 Hermes Agent Telegram 命令菜单汉化

将 [Hermes Agent](https://github.com/NousResearch/hermes-agent) Telegram Bot 命令菜单中残留的英文描述汉化为中文

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-WSL%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)](#)
[![Hermes Agent](https://img.shields.io/badge/Hermes%20Agent-compatible-orange.svg)](https://github.com/NousResearch/hermes-agent)

</div>

---

## 📋 背景

Hermes Agent 设置 `display.language: zh` 后会自动翻译大部分命令描述，但 `hermes_cli/commands.py` 中 `COMMAND_REGISTRY` 仍有 **14 条**命令描述为英文。本项目通过一个标准 `patch` 文件将这些描述汉化，重启 gateway 后 Telegram 菜单即显示全中文。

```
Telegram Bot 输入 "/" → 弹出命令菜单 → 显示中文描述 ✅
```

## ✨ 汉化内容

共修改 14 条命令描述：

| # | 命令 | 原文 | 汉化 |
|:-:|:----:|------|------|
| 1 | `/prompt` | Compose your next prompt in $EDITOR (markdown), then send it | 在 $EDITOR 中编写下一条提示（markdown），然后发送 |
| 2 | `/compress` | Compress conversation context (add 'here [N]' to keep recent N turns; --preview shows what would happen) | 压缩对话上下文（加 'here [N]' 保留最近 N 轮；--preview 预览） |
| 3 | `/deny` | Deny a pending dangerous command (optionally with a reason) | 拒绝待处理的危险命令（可附理由） |
| 4 | `/journey` | Open the learning journey timeline | 打开学习旅程时间线 |
| 5 | `/moa` | Run one prompt through the default Mixture of Agents preset, then restore your model | 用默认 Mixture of Agents 预设运行一次提示，然后恢复原模型 |
| 6 | `/model` | Switch model (session-scoped; --global to persist) | 切换模型（会话级；--global 全局持久化） |
| 7 | `/timestamps` | Toggle [HH:MM] timestamps on messages and /history | 切换消息和 /history 上的 [HH:MM] 时间戳 |
| 8 | `/verbose` | Cycle tool progress display: off -> new -> all -> verbose -> log | 循环切换工具进度显示：关 -> 新增 -> 全部 -> 详细 -> 日志 |
| 9 | `/pet` | Toggle or adopt a petdex mascot (/pet, /pet list, /pet <slug>) | 切换或领养 petdex 吉祥物（/pet, /pet list, /pet <slug>） |
| 10 | `/hatch` | Generate a new petdex pet from a description | 从描述生成一个新的 petdex 宠物 |
| 11 | `/learn` | Learn a reusable skill from anything you describe (dirs, URLs, this chat, notes) | 从你描述的任何内容学习可复用技能（目录、URL、本对话、笔记） |
| 12 | `/usage` | Show token usage and rate limits; \`reset\` redeems a banked Codex limit reset | 显示令牌用量和速率限制；\`reset\` 兑换已存储的 Codex 限制重置 |
| 13 | `/subscription` | View your Nous plan and change it in the browser | 查看你的 Nous 套餐并在浏览器中更改 |
| 14 | `/topup` | Show your Nous balance and manage billing on the portal | 查看你的 Nous 余额并在门户管理账单 |

## 🚀 快速使用

### 1. 克隆仓库

```bash
git clone git@github.com:bobotoy/hermes-telegram-i18n.git
cd hermes-telegram-i18n
```

### 2. 应用汉化

```bash
# 自动检测 ~/.hermes/hermes-agent 路径
./apply.sh

# 或指定源码目录
./apply.sh /path/to/hermes-agent
```

脚本会自动：
1. 📸 备份原始 `commands.py`（带时间戳）
2. ✅ 应用 patch 补丁
3. 💡 提示重启 gateway 命令

### 3. 重启 gateway 生效

```bash
# systemd 方式
systemctl --user restart hermes-gateway

# 或手动方式
hermes gateway restart
```

### 4. 效果预览

在 Telegram 客户端中点击 `/` 即可看到全中文命令菜单：

```
/help     显示可用命令
/new      开始新会话（新会话 ID + 历史记录）
/stop     终止所有正在运行的后台进程
/status   显示会话、模型、令牌和上下文信息
/model    切换模型（会话级；--global 全局持久化）
...
```

## 🔄 还原

```bash
# 自动找到最近的备份并还原
./revert.sh

# 或手动用 git 还原
cd ~/.hermes/hermes-agent
git checkout -- hermes_cli/commands.py
systemctl --user restart hermes-gateway
```

## ⚠️ 注意事项

- 本补丁仅修改命令**描述文本**，不改功能逻辑
- Hermes Agent 升级后可能需要重新应用补丁（行号偏移可导致 `patch` 失败）
- 补丁文件使用 `diff -u` 格式，路径相对于 Hermes 源码根目录（`-p1`）
- `display.language: zh` 只翻译部分静态消息，命令描述的完整汉化需要本补丁

## ✓ 验证

应用补丁并重启 gateway 后，可通过 Telegram Bot API 验证：

```bash
# 获取当前菜单命令（需替换 YOUR_BOT_TOKEN）
curl -s "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getMyCommands" | python -m json.tool
```

或在 Telegram 客户端中点击 `/` 查看命令菜单，确认所有描述均为中文。

## 📁 项目结构

```
hermes-telegram-i18n/
├── README.md                  # 本说明文档
├── LICENSE                    # MIT
├── apply.sh                   # 一键应用补丁（自动备份）
├── revert.sh                  # 一键还原（自动找最近备份）
└── patches/
    └── commands_zh.patch      # diff -u 格式补丁文件
```

## 📄 许可

[MIT](LICENSE)
