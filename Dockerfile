# 安定して存在する公式 Elixir イメージ
FROM elixir:1.18-slim

# 必要ツール（Node.js と psql クライアントを含む）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential inotify-tools curl ca-certificates gnupg \
    postgresql-client npm git \
    && rm -rf /var/lib/apt/lists/*

# Hex/Rebar
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=dev ERL_AFLAGS="-proto_dist inet_tcp"
WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} app && useradd -m -u ${UID} -g ${GID} app
RUN mkdir -p /app && chown -R app:app /app

USER app
WORKDIR /app
