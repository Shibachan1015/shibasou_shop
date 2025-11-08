#!/bin/bash
# マルチエージェント開発用ブランチ/worktreeセットアップスクリプト

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

echo "📋 機能名: ${FEATURE_NAME}"
echo "📦 メインブランチ: ${MAIN_BRANCH}"
echo "🔨 Builder A ブランチ: ${BRANCH_A}"
echo "⚡ Builder B ブランチ: ${BRANCH_B}"
echo ""

# 現在のブランチを確認
CURRENT_BRANCH=$(git branch --show-current)
echo "現在のブランチ: ${CURRENT_BRANCH}"

# メインブランチを作成・チェックアウト
echo ""
echo "1️⃣ メインブランチを作成中..."
if git show-ref --verify --quiet refs/heads/${MAIN_BRANCH}; then
    echo "   ⚠️  ブランチ ${MAIN_BRANCH} は既に存在します"
    read -p "   既存のブランチを使用しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   キャンセルしました"
        exit 1
    fi
    git checkout ${MAIN_BRANCH}
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

echo ""
echo "✅ セットアップ完了！"
echo ""
echo "次のステップ:"
echo "  1. Planner で仕様を作成: docs/specs/${FEATURE_NAME}.md"
echo "  2. Builder A で実装: git checkout ${BRANCH_A}"
echo "  3. Builder B で実装: git checkout ${BRANCH_B}"
echo "  4. Verifier でレビュー"
echo "  5. 統合: git checkout ${MAIN_BRANCH} && git merge --squash ${BRANCH_A} && git merge --squash ${BRANCH_B}"

