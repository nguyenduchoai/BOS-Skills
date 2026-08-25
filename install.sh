#!/bin/bash
# Cài bộ BOS Skills vào thư mục skill của trợ lý AI trên máy này.
# Chỉ ghi đè 6 thư mục bos-*, không đụng tới skill khác đang có.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skills"
SKILLS=(bos-nhan-vien-moi bos-business-logic bos-data-import bos-golive bos-helpdesk bos-operations)

echo ""
echo "  BOS Skills — cài đặt"
echo "  ────────────────────"

installed=0
for target in "$HOME/.claude/skills" "$HOME/.codex/skills"; do
  base="$(dirname "$target")"
  # Chỉ cài cho công cụ đã có trên máy
  [ -d "$base" ] || continue
  mkdir -p "$target"
  for s in "${SKILLS[@]}"; do
    rm -rf "${target:?}/$s"
    cp -R "$SRC/$s" "$target/$s"
  done
  echo "  ✓ ${#SKILLS[@]} skill → $target"
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "  ✗ Không tìm thấy ~/.claude hay ~/.codex trên máy này."
  echo "    Cài Claude Code trước rồi chạy lại: https://claude.com/claude-code"
  exit 1
fi

echo ""
echo "  Xong. Kiểm tra:  ls ~/.claude/skills | grep bos-"
echo "  Mở lại Claude Code để nạp skill mới."
echo ""
