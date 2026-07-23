<div align="center">

# 🌐 Hermes Agent Telegram 命令菜单汉化

将 [Hermes Agent](https://github.com/NousResearch/hermes-agent) Telegram Bot 命令菜单中残留的英文描述汉化为中文

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-WSL%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)](#)
[![Hermes Agent](https://img.shields.io/badge/Hermes%20Agent-compatible-orange.svg)](https://github.com/NousResearch/hermes-agent)

</div>

---

## 📋 背景

Hermes Agent 的 `COMMAND_REGISTRY` 中共有 82 条命令描述，源码原始版本全部为英文。本项目通过一个标准 `patch` 文件将全部 82 条描述汉化为中文。

Telegram 菜单实际注册显示的命令数受 `max_commands` 配置限制（默认 60），其中 52 条为核心命令、其余为 skill/plugin命令。不在菜单中的命令仍可通过手动输入 `/命令名` 使用。

```
COMMAND_REGISTRY  82 条命令描述 → patch 全部汉化
Telegram 菜单    60 条实际注册（默认） → 全中文显示 ✅
```

## ✨ 汉化内容

`COMMAND_REGISTRY` 共 82 条命令描述已全部汉化，按分类统计：

| 分类 | 总数 | Telegram 可见 | 示例 |
|:----:|:----:|:------------:|------|
| Session | 26 | 24 | `/new` 开始新会话 · `/stop` 终止后台进程 · `/status` 显示会话信息 |
| Configuration | 16 | 8 | `/model` 切换模型 · `/voice` 切换语音模式 · `/yolo` 切换 YOLO 模式 |
| Tools & Skills | 18 | 9 | `/skills` 管理技能 · `/cron` 管理定时任务 · `/learn` 学习可复用技能 |
| Info | 14 | 11 | `/help` 显示可用命令 · `/usage` 令牌用量 · `/debug` 上传调试报告 |
| Exit | 1 | 0 | `/quit` 退出 CLI（仅 CLI） |
| **合计** | **82** | **52** | |

> CLI-only 命令（30 条）不出现在 Telegram 菜单中，但汉化同样生效于 CLI 的 `/help` 输出和自动补全提示。

完整英文→中文对照见 [`patches/commands_zh.patch`](patches/commands_zh.patch)

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
- `display.language: zh` 只翻译少量静态消息，不翻译 `COMMAND_REGISTRY` 中的命令描述——命令描述的汉化依赖本补丁

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
