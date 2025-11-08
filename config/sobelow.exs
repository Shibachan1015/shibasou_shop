import Config

# Sobelow configuration
# Skip HTTPS check for non-production environments
# HTTPS is enforced in production via config/runtime.exs and config/prod.exs
config :sobelow,
  skip: ["Config.HTTPS"]
