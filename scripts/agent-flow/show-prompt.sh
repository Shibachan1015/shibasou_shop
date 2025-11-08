#!/bin/bash
# プロンプトテンプレートを表示するヘルパースクリプト

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="${SCRIPT_DIR}/prompts"

if [ $# -eq 0 ]; then
    echo "使用方法: $0 <エージェント名> [機能名]"
    echo ""
    echo "利用可能なエージェント:"
    echo "  planner      - Planner（GPT-5 Codex High）用プロンプト"
    echo "  builder-a    - Builder A（composer1-1）用プロンプト"
    echo "  builder-b    - Builder B（composer1-2）用プロンプト"
    echo "  verifier     - Verifier（composer1-3）用プロンプト"
    echo "  integration  - 統合用プロンプト"
    echo ""
    echo "例:"
    echo "  $0 planner user-authentication"
    echo "  $0 builder-a user-authentication"
    exit 1
fi

AGENT="$1"
FEATURE_NAME="${2:-<機能名>}"

case "$AGENT" in
    planner|planner)
        PROMPT_FILE="${PROMPTS_DIR}/01-planner.md"
        ;;
    builder-a|buildera|a)
        PROMPT_FILE="${PROMPTS_DIR}/02-builder-a.md"
        ;;
    builder-b|builderb|b)
        PROMPT_FILE="${PROMPTS_DIR}/03-builder-b.md"
        ;;
    verifier|verify|v)
        PROMPT_FILE="${PROMPTS_DIR}/04-verifier.md"
        ;;
    integration|integrate|i)
        PROMPT_FILE="${PROMPTS_DIR}/05-integration.md"
        ;;
    *)
        echo "❌ エラー: 不明なエージェント名: $AGENT"
        echo ""
        echo "利用可能なエージェント: planner, builder-a, builder-b, verifier, integration"
        exit 1
        ;;
esac

if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ エラー: プロンプトファイルが見つかりません: $PROMPT_FILE"
    exit 1
fi

# プロンプトを表示し、<機能名>を置き換え
sed "s/<機能名>/${FEATURE_NAME}/g" "$PROMPT_FILE"

