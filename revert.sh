#!/usr/bin/env bash
# revert.sh — 还原 commands.py 到最近的备份
# 用法: ./revert.sh [HERMES_SOURCE_DIR]
set -euo pipefail

HERMES_SRC="${1:-$HOME/.hermes/hermes-agent}"
TARGET="$HERMES_SRC/hermes_cli/commands.py"

# 找最近的备份文件
LATEST_BAK=$(ls -t "$TARGET".bak.* 2>/dev/null | head -1)

if [[ -z "$LATEST_BAK" ]]; then
    echo "错误: 找不到 $TARGET 的备份文件"
    echo "如果没有备份，可以从 Hermes 源码重新获取原始文件:"
    echo "  cd $HERMES_SRC && git checkout -- hermes_cli/commands.py"
    exit 1
fi

echo "将使用备份还原: $LATEST_BAK"
cp "$LATEST_BAK" "$TARGET"
echo "还原成功！"

echo ""
echo "下一步: 重启 gateway"
echo "  systemctl --user restart hermes-gateway"
