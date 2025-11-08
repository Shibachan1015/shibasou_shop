#!/bin/bash
# A/B実装を統合するスクリプト

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

echo "📋 機能名: ${FEATURE_NAME}"
echo "📦 メインブランチ: ${MAIN_BRANCH}"
echo "🔨 Builder A ブランチ: ${BRANCH_A}"
echo "⚡ Builder B ブランチ: ${BRANCH_B}"
echo ""

# ブランチの存在確認
if ! git show-ref --verify --quiet refs/heads/${MAIN_BRANCH}; then
    echo "❌ エラー: メインブランチ ${MAIN_BRANCH} が存在しません"
    echo "   先に setup-branches.sh または setup-worktrees.sh を実行してください"
    exit 1
fi

if ! git show-ref --verify --quiet refs/heads/${BRANCH_A}; then
    echo "❌ エラー: Builder A ブランチ ${BRANCH_A} が存在しません"
    exit 1
fi

if ! git show-ref --verify --quiet refs/heads/${BRANCH_B}; then
    echo "❌ エラー: Builder B ブランチ ${BRANCH_B} が存在しません"
    exit 1
fi

# メインブランチにチェックアウト
echo "1️⃣ メインブランチにチェックアウト中..."
git checkout ${MAIN_BRANCH}

# 未コミットの変更があるか確認
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  警告: メインブランチに未コミットの変更があります"
    read -p "   続行しますか？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   キャンセルしました"
        exit 1
    fi
fi

# Builder A を統合
echo ""
echo "2️⃣ Builder A の変更を統合中..."
git merge --squash ${BRANCH_A}
echo "   ✅ Builder A の変更をステージングしました"

# Builder B を統合
echo ""
echo "3️⃣ Builder B の変更を統合中..."
git merge --squash ${BRANCH_B}
echo "   ✅ Builder B の変更をステージングしました"

echo ""
echo "✅ 統合完了！"
echo ""
echo "次のステップ:"
echo "  1. 変更内容を確認: git status"
echo "  2. 競合があれば解決: git diff"
echo "  3. テストを実行: mix test"
echo "  4. コミット: git commit -m \"feat(${FEATURE_NAME}): integrate A+B\""
echo ""
echo "⚠️  注意: 統合後は手動で競合を解決し、テストを実行してからコミットしてください"

