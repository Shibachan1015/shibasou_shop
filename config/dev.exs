import Config

# --- Repo：Composeのdbに接続（hostname= "db" / database= "shibasou_dev"） ---
config :shibasou_shop, ShibasouShop.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "db",
  database: "shibasou_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# --- Endpoint：0.0.0.0 bind + watchers + live_reload を1ブロックに集約 ---
config :shibasou_shop, ShibasouShopWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dev_secret_key_base_dummydummydummy",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:shibasou_shop, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:shibasou_shop, ~w(--watch)]}
  ],
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/shibasou_shop_web/(?:controllers|live|components|router)/?.*\.(ex|heex)$"
    ]
  ]

# --- dev用フラグ・ログ・デバッグ ---
config :shibasou_shop, dev_routes: true
config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false
