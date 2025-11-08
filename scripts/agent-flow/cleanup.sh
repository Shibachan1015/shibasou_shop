#!/bin/bash
# ブランチ/worktreeをクリーンアップするスクリプト

set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
    echo "使用方法: $0 <機能名>"
    echo "例: $0 user-authentication"
    exit 1
fi

# ブランチ名の正規化
FEATURE_NAME=$(echo "$FEATURE_NAME" | tr ' /' '-')

MAIN_BRANCH="feat/${FEATURE_NAME}"
BRANCH_A="${MAIN_BRANCH}/a"
BRANCH_B="${MAIN_BRANCH}/b"

PROJECT_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_ROOT="${PROJECT_ROOT}/../${FEATURE_NAME}-worktrees"
WORKTREE_A="${WORKTREE_ROOT}/builder-a"
WORKTREE_B="${WORKTREE_ROOT}/builder-b"

echo "📋 機能名: ${FEATURE_NAME}"
echo "📦 メインブランチ: ${MAIN_BRANCH}"
echo "🔨 Builder A ブランチ: ${BRANCH_A}"
echo "⚡ Builder B ブランチ: ${BRANCH_B}"
echo ""

# 確認
read -p "⚠️  これらのブランチとworktreeを削除しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "キャンセルしました"
    exit 1
fi

# 現在のブランチを確認
CURRENT_BRANCH=$(git branch --show-current)
if [[ "${CURRENT_BRANCH}" == "${MAIN_BRANCH}" ]] || \
   [[ "${CURRENT_BRANCH}" == "${BRANCH_A}" ]] || \
   [[ "${CURRENT_BRANCH}" == "${BRANCH_B}" ]]; then
    echo ""
    echo "⚠️  現在、削除対象のブランチにいます"
    echo "   メインブランチまたはmain/masterブランチに切り替えてください"
    exit 1
fi

# Worktree を削除
echo ""
echo "1️⃣ Worktree を削除中..."
if [ -d "${WORKTREE_A}" ]; then
    git worktree remove "${WORKTREE_A}" --force 2>/dev/null || rm -rf "${WORKTREE_A}"
    echo "   ✅ Builder A の worktree を削除しました"
fi

if [ -d "${WORKTREE_B}" ]; then
    git worktree remove "${WORKTREE_B}" --force 2>/dev/null || rm -rf "${WORKTREE_B}"
    echo "   ✅ Builder B の worktree を削除しました"
fi

if [ -d "${WORKTREE_ROOT}" ] && [ -z "$(ls -A ${WORKTREE_ROOT})" ]; then
    rmdir "${WORKTREE_ROOT}" 2>/dev/null || true
fi

# ブランチを削除
echo ""
echo "2️⃣ ブランチを削除中..."
if git show-ref --verify --quiet refs/heads/${BRANCH_A}; then
    git branch -D ${BRANCH_A}
    echo "   ✅ Builder A ブランチを削除しました"
fi

if git show-ref --verify --quiet refs/heads/${BRANCH_B}; then
    git branch -D ${BRANCH_B}
    echo "   ✅ Builder B ブランチを削除しました"
fi

if git show-ref --verify --quiet refs/heads/${MAIN_BRANCH}; then
    read -p "   メインブランチ ${MAIN_BRANCH} も削除しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git branch -D ${MAIN_BRANCH}
        echo "   ✅ メインブランチを削除しました"
    else
        echo "   ℹ️  メインブランチは残しました"
    fi
fi

echo ""
echo "✅ クリーンアップ完了！"

