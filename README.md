# ShibasouShop

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix


# README.md — Shibasou Shop (Docker 開発手順)

Phoenix/Elixir/PostgreSQL を**完全 Docker 化**した開発環境です。
ホストに Elixir/Erlang/psql を入れずに動きます（Node もコンテナ内）。

---

## 0. 前提

* **Docker Desktop**（Windows は WSL2 統合を有効に）
* ポート: `4000`（Web）, `5432`（DB）
* 初回だけ **UID/GID の環境変数**をセットしておくと権限で詰まりません

```bash
# WSL / Linux / macOS 共通
export UID=$(id -u); export GID=$(id -g)
```

> Windows＋WSL の方は **Docker Desktop の Settings → Resources → WSL Integration** をオンにしてください。

---

## 1. クイックスタート（最短 3 コマンド）

```bash
# 1) ビルド＆起動（初回〜変更時）
docker compose up -d --build

# 2) 依存取得（Hex, Mix deps）
docker compose run --rm app mix deps.get

# 3) DB 作成＆マイグレーション
docker compose exec app mix ecto.create
docker compose exec app mix ecto.migrate
```

> ブラウザ: [http://localhost:4000](http://localhost:4000)

---

## 2. ディレクトリ構成（抜粋）

```
.
├─ docker-compose.yml
├─ Dockerfile
├─ config/
│   ├─ config.exs
│   └─ dev.exs            # hostname: "db" に修正済み
├─ lib/
│   └─ shibasou_shop/...
├─ assets/                # Node modules はコンテナ側で管理
├─ priv/repo/
│   ├─ migrations/        # 生成系
│   └─ seeds.exs
└─ README.md
```

---

## 3. 重要な設定ポイント

### 3.1 `config/dev.exs`（DB 接続先はコンテナ名）

```elixir
config :shibasou_shop, ShibasouShop.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "db",           # ← ここが "localhost" ではなく "db"
  database: "shibasou_shop_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### 3.2 `docker-compose.yml`（権限と起動コマンド）

* `user: "${UID:-1000}:${GID:-1000}"` で **非 root 実行**
* 起動時に必要ディレクトリを **自動作成+chown** してから `mix phx.server`

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        UID: "${UID:-1000}"
        GID: "${GID:-1000}"
    user: "${UID:-1000}:${GID:-1000}"
    environment:
      - MIX_ENV=dev
      - PORT=4000
    volumes:
      - .:/app
      - mix-cache:/app/.mix
      - hex-cache:/app/.hex
      - rebar-cache:/app/.cache/rebar3
      - npm-cache:/app/assets/node_modules
    depends_on:
      db:
        condition: service_healthy
    command: >
      bash -lc "
        mkdir -p .mix/archives .hex .cache/rebar3 assets/node_modules &&
        chown -R ${UID:-1000}:${GID:-1000} .mix .hex .cache/rebar3 assets/node_modules || true &&
        mix phx.server
      "

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: shibasou_shop_dev
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 3s
      timeout: 3s
      retries: 20
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
  mix-cache:
  hex-cache:
  rebar-cache:
  npm-cache:
```

---

## 4. よく使うコマンド（チートシート）

```bash
# 起動 / 再起動 / 停止
docker compose up -d
docker compose up -d --force-recreate
docker compose down

# ログ
docker compose logs --tail=100 app
docker compose logs -f app

# 依存取得 / コンパイル / サーバ起動
docker compose run --rm app mix deps.get
docker compose exec app mix compile

# DB 周り
docker compose exec app mix ecto.create
docker compose exec app mix ecto.migrate
docker compose exec app mix ecto.rollback

# seeds を Endpoint 起動なしで実行（ポート競合回避）
docker compose run --rm -e PHX_SERVER=false app mix run priv/repo/seeds.exs

# IEx で接続（Endpoint 起動しない）
docker compose exec -e PHX_SERVER=false app iex -S mix

# IEx + サーバ同時（UI見ながらデバッグ）
docker compose run --rm -p 4000:4000 app iex -S mix phx.server
```

---

## 5. 生成系（Context/Schema/Migration）

```bash
# 例：Outsole（底材）スキーマを Catalog コンテキストに追加（マイグレーションは別で書く）
docker compose exec app mix phx.gen.context Catalog Outsole outsoles \
  code:string name:string price_delta_cents:integer \
  stock_qty:integer allocated_qty:integer backordered_qty:integer \
  image_layer_url:string enabled:boolean --no-migration

# マイグレーションファイルの生成（名前は自由）
docker compose exec app mix ecto.gen.migration add_outsoles

# マイグレーション実行
docker compose exec app mix ecto.migrate
```

> 生成物は `lib/shibasou_shop/catalog/outsole.ex` などに出力。
> 既存コンテキストに追加するか、新規コンテキストを切るかは粒度で判断してください。

---

## 6. トラブルシュート集

### 6.1 `permission denied`（VSCode で保存できない / EACCES）

コンテナが root で作ったファイルを編集しようとして失敗しています。
**所有者を自分に戻す**か、**UID/GID を指定して再起動**してください。

```bash
# ① ワークツリー全体の所有者を自分に戻す
sudo chown -R "$USER:$USER" .

# ② UID/GID をセットして再起動
export UID=$(id -u); export GID=$(id -g)
docker compose down
docker compose up -d --force-recreate
```

### 6.2 `could not make directory "/app/.mix/archives/hex-..."`（ENOENT）

`/app/.mix/archives` などが未作成のまま `mix` が動いています。
**起動前に一度だけ作成＆chown** すれば解決。

```bash
docker compose run --rm --user 0:0 app bash -lc '\
  mkdir -p /app/.mix/archives /app/.hex /app/.cache/rebar3 /app/assets/node_modules && \
  chown -R '"$UID:$GID"' /app/.mix /app/.hex /app/.cache/rebar3 /app/assets/node_modules \
'
docker compose up -d --force-recreate
```

> 再発防止のため、`docker-compose.yml` の `command:` に `mkdir -p && chown` を入れています（本 README 3.2 参照）。

### 6.3 `port 4000 already in use`（`:eaddrinuse`）

既に `app` が 4000 で待ち受け中に、別プロセスで Endpoint を立てようとしたケース。
**PHX_SERVER=false** で実行するか、一時的に停止してください。

```bash
# Endpoint 起動せずに seeds 実行
docker compose run --rm -e PHX_SERVER=false app mix run priv/repo/seeds.exs

# or 一時停止 → 実行 → 再開
docker compose stop app
docker compose run --rm app mix run priv/repo/seeds.exs
docker compose start app
```

### 6.4 `service "app" is not running`

`exec` は常駐中コンテナが必要です。`up -d` で起動してから再実行。

```bash
docker compose up -d
docker compose exec app mix ecto.migrate
```

### 6.5 キャッシュ系ボリュームの権限が壊れた（最終手段）

Named volume を作り直します（**DBは消さない**）。

```bash
docker compose down
docker volume rm shibasou_shop_mix-cache shibasou_shop_hex-cache \
                 shibasou_shop_rebar-cache shibasou_shop_npm-cache || true
export UID=$(id -u); export GID=$(id -g)
docker compose up -d --force-recreate
```

---

## 7. 開発の流れ（推奨）

1. `docker compose up -d` で常駐
2. `mix phx.gen.context` / `mix ecto.gen.migration` でモデル追加
3. マイグレーション反映 `mix ecto.migrate`
4. seeds で初期データ投入（`PHX_SERVER=false` 推奨）
5. `lib/shibasou_shop_web/live` に LiveView を追加／更新
6. B2B/B2C 機能を段階実装（CSV Import, Backorder, Pricing など）

---

## 8. 参考（IEx ワークフロー）

```bash
# サーバ動かしたまま Repo だけ使いたい
docker compose exec -e PHX_SERVER=false app iex -S mix

# IEx 内で
iex> alias ShibasouShop.Repo
iex> alias ShibasouShop.Catalog.{Ten, Hanao, Outsole}
iex> Repo.all(Ten)
```

---

## 9. よくある質問

* **Q: `assets/` の `npm install` はどこでやる？**
  A: 基本は不要です。Phoenix 1.7+ の v4 Tailwind/Esbuild は Mix タスクが自動で取得します。
  必要なら `docker compose run --rm app npm --prefix assets install` を使ってください。

* **Q: ホスト側 Node を使って良い？**
  A: 使えますが、**node_modules をコンテナ側の volume に固定**しているため、ズレる時は
  `npm-cache` ボリュームを削除して再生成してください（6.5 参照）。

---

## 10. 次にやること（このプロジェクト向け）

* セミオーダー（**天／鼻緒／底材**）の Ecto スキーマと互換ルールのテーブル設計
* `Orders.allocate(order, allow_backorder?: boolean)` の骨子
* B2B **CSV インポート**（LiveView + NimbleCSV）雛形
* `/admin` に **BO（受注残）一覧**と**再引当ジョブ**トリガー

---

困ったらこの README の **6. トラブルシュート**から順にチェックしてください。
詰まったログを貼ってくれれば、すぐにパッチを書きます。👊
