# config/test.exs
import Config

# ---- Repo (test) ----
# CI でもローカルでも同一の環境変数で動くように。
# 既定値は CI の Postgres サービスに合わせています。
config :shibasou_shop, ShibasouShop.Repo,
  username: System.get_env("DB_USER", "postgres"),
  password: System.get_env("DB_PASS", "postgres"),
  hostname: System.get_env("DB_HOST", "localhost"),
  port: String.to_integer(System.get_env("DB_PORT", "5432")),
  # 並列実行時に MIX_TEST_PARTITION を付与できるようにしておく
  database:
    System.get_env("DB_NAME", "shibasou_test") <>
      System.get_env("MIX_TEST_PARTITION", ""),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: String.to_integer(System.get_env("DB_POOL_SIZE", "10")),
  ssl: System.get_env("DB_SSL", "false") == "true",
  parameters: [timezone: "utc"]

# Ecto SQL Sandbox を有効化（必要に応じて test_helper.exs 側でも設定）
config :shibasou_shop, :sql_sandbox, true

# ---- Endpoint ----
# テスト時は HTTP サーバを起動しない
config :shibasou_shop, ShibasouShopWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test_secret_key_base_change_me",
  server: false

# ---- Logger ----
config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime

# ---- Mailer ----
# テストで外部HTTPクライアントを使わない
config :swoosh, :api_client, false
