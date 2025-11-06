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
  # 64 bytes 以上のランダム値
  secret_key_base: "V1Sx2z7q8rP0tU3wY6Z9bC2fE5H8J1L4N7Q0T3W6Z9c2f5i8l1o4r7u0x3A6D9G2J5M8P1S4V7Y0B3E6H9K2",
  server: false

# ---- Logger ----
config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime

# ---- Mailer ----
# テストで外部HTTPクライアントを使わない
config :swoosh, :api_client, false
