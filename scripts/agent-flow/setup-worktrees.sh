#!/bin/bash
# マルチエージェント開発用worktreeセットアップスクリプト

set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
    echo "使用方法: $0 <機能名>"
    echo "例: $0 user-authentication"
    exit 1
fi

# ブランチ名の正規化（スラッシュやスペースをハイフンに）
FEATURE_NAME=$(echo "$FEATURE_NAME" | tr ' /' '-')

MAIN_BRANCH="feat/${FEATURE_NAME}"
BRANCH_A="${MAIN_BRANCH}/a"
BRANCH_B="${MAIN_BRANCH}/b"

# プロジェクトルートを取得
PROJECT_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_ROOT="${PROJECT_ROOT}/../${FEATURE_NAME}-worktrees"

echo "📋 機能名: ${FEATURE_NAME}"
echo "📦 メインブランチ: ${MAIN_BRANCH}"
echo "🔨 Builder A ブランチ: ${BRANCH_A}"
echo "⚡ Builder B ブランチ: ${BRANCH_B}"
echo "📁 Worktree ディレクトリ: ${WORKTREE_ROOT}"
echo ""

# メインブランチを作成・チェックアウト
echo "1️⃣ メインブランチを作成中..."
if git show-ref --verify --quiet refs/heads/${MAIN_BRANCH}; then
    echo "   ⚠️  ブランチ ${MAIN_BRANCH} は既に存在します"
    read -p "   既存のブランチを使用しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   キャンセルしました"
        exit 1
    fi
else
    git checkout -b ${MAIN_BRANCH}
    echo "   ✅ メインブランチ ${MAIN_BRANCH} を作成しました"
fi

# Builder A ブランチを作成
echo ""
echo "2️⃣ Builder A ブランチを作成中..."
if git show-ref --verify --quiet refs/heads/${BRANCH_A}; then
    echo "   ⚠️  ブランチ ${BRANCH_A} は既に存在します"
else
    git checkout -b ${BRANCH_A}
    echo "   ✅ Builder A ブランチ ${BRANCH_A} を作成しました"
fi

# Builder B ブランチを作成
echo ""
echo "3️⃣ Builder B ブランチを作成中..."
if git show-ref --verify --quiet refs/heads/${BRANCH_B}; then
    echo "   ⚠️  ブランチ ${BRANCH_B} は既に存在します"
else
    git checkout -b ${BRANCH_B}
    echo "   ✅ Builder B ブランチ ${BRANCH_B} を作成しました"
fi

# メインブランチに戻る
git checkout ${MAIN_BRANCH}

# Worktree ディレクトリを作成
echo ""
echo "4️⃣ Worktree ディレクトリを作成中..."
mkdir -p "${WORKTREE_ROOT}"

# Builder A の worktree を作成
echo ""
echo "5️⃣ Builder A の worktree を作成中..."
WORKTREE_A="${WORKTREE_ROOT}/builder-a"
if [ -d "${WORKTREE_A}" ]; then
    echo "   ⚠️  Worktree ${WORKTREE_A} は既に存在します"
    read -p "   既存の worktree を削除して再作成しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree remove "${WORKTREE_A}" --force 2>/dev/null || rm -rf "${WORKTREE_A}"
        git worktree add "${WORKTREE_A}" ${BRANCH_A}
        echo "   ✅ Builder A の worktree を作成しました: ${WORKTREE_A}"
    fi
else
    git worktree add "${WORKTREE_A}" ${BRANCH_A}
    echo "   ✅ Builder A の worktree を作成しました: ${WORKTREE_A}"
fi

# Builder B の worktree を作成
echo ""
echo "6️⃣ Builder B の worktree を作成中..."
WORKTREE_B="${WORKTREE_ROOT}/builder-b"
if [ -d "${WORKTREE_B}" ]; then
    echo "   ⚠️  Worktree ${WORKTREE_B} は既に存在します"
    read -p "   既存の worktree を削除して再作成しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree remove "${WORKTREE_B}" --force 2>/dev/null || rm -rf "${WORKTREE_B}"
        git worktree add "${WORKTREE_B}" ${BRANCH_B}
        echo "   ✅ Builder B の worktree を作成しました: ${WORKTREE_B}"
    fi
else
    git worktree add "${WORKTREE_B}" ${BRANCH_B}
    echo "   ✅ Builder B の worktree を作成しました: ${WORKTREE_B}"
fi

echo ""
echo "✅ セットアップ完了！"
echo ""
echo "Worktree の場所:"
echo "  Builder A: ${WORKTREE_A}"
echo "  Builder B: ${WORKTREE_B}"
echo ""
echo "次のステップ:"
echo "  1. Planner で仕様を作成: docs/specs/${FEATURE_NAME}.md"
echo "  2. Builder A で実装: cd ${WORKTREE_A}"
echo "  3. Builder B で実装: cd ${WORKTREE_B}"
echo "  4. Verifier でレビュー"
echo "  5. 統合: git checkout ${MAIN_BRANCH} && git merge --squash ${BRANCH_A} && git merge --squash ${BRANCH_B}"

