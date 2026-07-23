#!/usr/bin/env bash
# apply.sh — 将中文补丁应用到 Hermes Agent 的 commands.py
# 用法: ./apply.sh [HERMES_SOURCE_DIR]
#   HERMES_SOURCE_DIR 默认为 ~/.hermes/hermes-agent
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_SRC="${1:-$HOME/.hermes/hermes-agent}"
TARGET="$HERMES_SRC/hermes_cli/commands.py"
PATCH_FILE="$SCRIPT_DIR/patches/commands_zh.patch"

if [[ ! -f "$TARGET" ]]; then
    echo "错误: 找不到 $TARGET"
    echo "请确认 Hermes Agent 源码目录路径，或作为参数传入: ./apply.sh /path/to/hermes-agent"
    exit 1
fi

if [[ ! -f "$PATCH_FILE" ]]; then
    echo "错误: 找不到补丁文件 $PATCH_FILE"
    exit 1
fi

# 备份
BACKUP="$TARGET.bak.$(date +%Y%m%d_%H%M%S)"
cp "$TARGET" "$BACKUP"
echo "已备份: $BACKUP"

# 应用补丁
cd "$HERMES_SRC"
if patch -p1 < "$PATCH_FILE"; then
    echo "补丁应用成功！"
    echo ""
    echo "下一步: 重启 gateway 让修改生效"
    echo "  systemctl --user restart hermes-gateway"
    echo ""
    echo "如需还原:"
    echo "  cp $BACKUP $TARGET"
    echo "  systemctl --user restart hermes-gateway"
else
    echo "补丁应用失败，正在还原..."
    cp "$BACKUP" "$TARGET"
    echo "已还原。可能是 Hermes 版本更新导致行号偏移，请尝试手动修改或提 issue。"
    exit 1
fi
