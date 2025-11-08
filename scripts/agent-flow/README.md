# マルチエージェント開発フロー

複数のAIエージェントを並列で使用して、高品質なコードを効率的に開発するためのフローです。

## 📋 全体フロー

**仕様設計 → 並列実装 → 比較/合成 → テスト → マージ**

1. **Planner** で仕様を固める
2. **Builder A** と **Builder B** で並列実装
3. **Verifier** でレビュー
4. **統合** でA+Bを統合
5. **人間の判断** で最終確認

## 🎯 エージェントマッピング

- **composer1-1** = Builder A（堅実実装）
- **composer1-2** = Builder B（軽量/高速実装）
- **composer1-3** = Verifier（レビュー）
- **GPT-5 Codex High** = Planner（仕様設計）

## 🚀 クイックスタート

### 1. ブランチ/Worktree のセットアップ

#### オプションA: ブランチのみ（シンプル）

```bash
./scripts/agent-flow/setup-branches.sh <機能名>
```

例:
```bash
./scripts/agent-flow/setup-branches.sh user-authentication
```

#### オプションB: Worktree を使用（並列作業に最適）

```bash
./scripts/agent-flow/setup-worktrees.sh <機能名>
```

例:
```bash
./scripts/agent-flow/setup-worktrees.sh user-authentication
```

これにより以下が作成されます:
- `feat/<機能名>` - メインブランチ
- `feat/<機能名>/a` - Builder A 用ブランチ
- `feat/<機能名>/b` - Builder B 用ブランチ
- Worktree（オプションBの場合）: `../<機能名>-worktrees/builder-a` と `builder-b`

### 2. Planner で仕様を作成

**方法A: ヘルパースクリプトを使用（推奨）**

```bash
./scripts/agent-flow/show-prompt.sh planner <機能名>
```

出力されたプロンプトを **GPT-5 Codex High** に貼り付ける

**方法B: 手動でファイルを開く**

1. `prompts/01-planner.md` を開く
2. `<機能名>` を実際の機能名に置き換える
3. プロンプトを **GPT-5 Codex High** に貼り付ける

4. 生成された `docs/specs/<機能名>.md` を確認・承認

### 3. Builder A で実装

**プロンプトを取得:**

```bash
./scripts/agent-flow/show-prompt.sh builder-a <機能名>
```

出力されたプロンプトを **composer1-1** に貼り付ける

実装は `feat/<機能名>/a` ブランチ（または worktree）で行う

```bash
# ブランチの場合
git checkout feat/<機能名>/a

# Worktree の場合
cd ../<機能名>-worktrees/builder-a
```

### 4. Builder B で実装（並列）

**プロンプトを取得:**

```bash
./scripts/agent-flow/show-prompt.sh builder-b <機能名>
```

出力されたプロンプトを **composer1-2** に貼り付ける

実装は `feat/<機能名>/b` ブランチ（または worktree）で行う

```bash
# ブランチの場合
git checkout feat/<機能名>/b

# Worktree の場合
cd ../<機能名>-worktrees/builder-b
```

### 5. Verifier でレビュー

**プロンプトを取得:**

```bash
./scripts/agent-flow/show-prompt.sh verifier <機能名>
```

1. Builder A と Builder B の実装を確認
2. 出力されたプロンプトを **composer1-3** に貼り付ける
3. レビュー結果を確認し、必要に応じて修正を依頼

### 6. 統合

**プロンプトを取得:**

```bash
./scripts/agent-flow/show-prompt.sh integration <機能名>
```

1. 出力されたプロンプトを **Planner** または **Verifier** に貼り付ける
2. 統合スクリプトを実行:

```bash
./scripts/agent-flow/integrate.sh <機能名>
```

4. 競合を解決し、テストを実行:

```bash
mix test
mix precommit  # プロジェクトのガイドラインに従って
```

5. コミット:

```bash
git commit -m "feat(<機能名>): integrate A+B"
```

### 7. クリーンアップ（オプション）

作業完了後、ブランチとworktreeを削除:

```bash
./scripts/agent-flow/cleanup.sh <機能名>
```

## 📁 ディレクトリ構造

```
scripts/agent-flow/
├── README.md                    # このファイル
├── prompts/                     # エージェント用プロンプトテンプレート
│   ├── 01-planner.md
│   ├── 02-builder-a.md
│   ├── 03-builder-b.md
│   ├── 04-verifier.md
│   └── 05-integration.md
├── setup-branches.sh           # ブランチセットアップ（シンプル版）
├── setup-worktrees.sh          # Worktreeセットアップ（並列作業推奨）
├── integrate.sh                # A+B統合スクリプト
├── cleanup.sh                  # クリーンアップスクリプト
└── show-prompt.sh              # プロンプト表示ヘルパー
```

## 💡 ベストプラクティス

### 仕様設計のポイント

- ✅ 曖昧な表現を排除
- ✅ セキュリティ（CSRF/XSS/RLS/権限）を考慮
- ✅ エッジケースを明記
- ✅ テスト観点（単体/統合/E2E）を含める

### 実装のポイント

- **Builder A**: 可読性・拡張性・保守性を重視
- **Builder B**: パフォーマンス・最小依存・簡潔性を重視
- 両方とも仕様に完全準拠すること

### レビューのポイント

- 仕様逸脱がないか
- セキュリティホールがないか
- テストカバレッジが十分か
- パフォーマンス懸念がないか

### 統合のポイント

- Aの強み（構造/責務分離）とBの強み（最適化）を統合
- 競合箇所は理由付きで判断
- 統合後は必ずテストを実行

## 🔧 トラブルシューティング

### ブランチが既に存在する場合

スクリプトは既存のブランチを検出し、確認を求めます。既存のブランチを使用するか、削除して再作成するかを選択できます。

### Worktree の削除に失敗する場合

`cleanup.sh` が失敗する場合は、手動で削除してください:

```bash
git worktree remove <worktree-path> --force
```

### 統合時の競合

`integrate.sh` 実行後、競合が発生する可能性があります。手動で解決してください:

```bash
git status  # 競合ファイルを確認
# 競合を解決
git add .
git commit -m "feat(<機能名>): integrate A+B"
```

## 📝 注意事項

- 各エージェントは独立して動作します。プロンプトテンプレートをそのまま貼り付けるだけで使用できます
- Worktree を使用すると、複数のエージェントが同時に作業できます
- 統合後は必ずテストを実行し、すべてのテストが通ることを確認してください
- セキュリティ観点の最終確認は人間が行ってください

## 🎓 参考

このフローは以下の原則に基づいています:

1. **仕様の明確化**: 曖昧さを排除し、全員が同じ理解を持つ
2. **並列開発**: A/Bの2案を同時に実装し、比較検討
3. **自動レビュー**: Verifier が客観的なレビューを提供
4. **統合最適化**: 両方の強みを活かした最終案を作成






memo
実際の使い方を説明します。まず、プロジェクトの状態を確認します。


[2 tools called]


作成したスクリプトをコミットしてから、使用例を示します。


[2 tools called]


使い方の例です。

## 実際の使い方

### ステップ1: 機能を決める

例: 「ユーザー認証機能」を実装する場合

```bash
# 機能名を決める（例: user-authentication）
FEATURE_NAME="user-authentication"
```

### ステップ2: ブランチ/Worktreeをセットアップ

```bash
# Worktreeを使う場合（推奨：並列作業がしやすい）
./scripts/agent-flow/setup-worktrees.sh user-authentication

# または、ブランチのみの場合
./scripts/agent-flow/setup-branches.sh user-authentication
```

### ステップ3: Plannerで仕様を作成

```bash
# プロンプトを表示
./scripts/agent-flow/show-prompt.sh planner user-authentication
```

表示されたプロンプトをコピーして、GPT-5 Codex High（Planner）に貼り付けます。

### ステップ4: Builder AとBで並列実装

**Builder A用プロンプト:**
```bash
./scripts/agent-flow/show-prompt.sh builder-a user-authentication
```

**Builder B用プロンプト:**
```bash
./scripts/agent-flow/show-prompt.sh builder-b user-authentication
```

それぞれのプロンプトを対応するエージェント（composer1-1、composer1-2）に貼り付けます。

### ステップ5: Verifierでレビュー

```bash
./scripts/agent-flow/show-prompt.sh verifier user-authentication
```

### ステップ6: 統合

```bash
./scripts/agent-flow/integrate.sh user-authentication
```

---

## 今すぐ試す場合

1. 実装したい機能を決める
2. セットアップスクリプトを実行
3. 各エージェントにプロンプトを貼り付けて作業

試したい機能があれば教えてください。セットアップから案内します。
