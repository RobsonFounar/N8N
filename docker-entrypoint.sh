#!/bin/sh
set -eu

# Render roteia para PORT. No n8n isso é N8N_PORT.
export N8N_LISTEN_ADDRESS="${N8N_LISTEN_ADDRESS:-0.0.0.0}"
export N8N_PORT="${PORT:-${N8N_PORT:-5678}}"
export PORT="${PORT:-$N8N_PORT}"

export TZ="${TZ:-America/Sao_Paulo}"
export GENERIC_TIMEZONE="${GENERIC_TIMEZONE:-America/Sao_Paulo}"

if [ -n "${RENDER_EXTERNAL_URL:-}" ]; then
  base="${RENDER_EXTERNAL_URL%/}"
  export WEBHOOK_URL="${WEBHOOK_URL:-${base}/}"
  export N8N_EDITOR_BASE_URL="${N8N_EDITOR_BASE_URL:-${base}/}"
  export N8N_PROTOCOL="${N8N_PROTOCOL:-https}"

  host="${base#https://}"
  host="${host#http://}"
  export N8N_HOST="${N8N_HOST:-$host}"
fi

export N8N_PROXY_HOPS="${N8N_PROXY_HOPS:-1}"

# Pooler do Supabase (IPv4). A Render não alcança o host direto (IPv6).
# O usuário do pooler TEM que ser postgres.<project-ref> — montamos aqui
# para nenhum parser / Blueprint cortar o ponto.
if [ -n "${SUPABASE_PROJECT_REF:-}" ]; then
  export DB_TYPE="postgresdb"
  export DB_POSTGRESDB_HOST="${DB_POSTGRESDB_HOST:-aws-0-us-west-1.pooler.supabase.com}"
  export DB_POSTGRESDB_PORT="${DB_POSTGRESDB_PORT:-5432}"
  export DB_POSTGRESDB_DATABASE="${DB_POSTGRESDB_DATABASE:-postgres}"
  export DB_POSTGRESDB_USER="postgres.${SUPABASE_PROJECT_REF}"
  export DB_POSTGRESDB_SSL_ENABLED="${DB_POSTGRESDB_SSL_ENABLED:-true}"
  export DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED="${DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED:-false}"
  export DB_POSTGRESDB_POOL_SIZE="${DB_POSTGRESDB_POOL_SIZE:-2}"
fi

# Se a Render injetar DATABASE_URL do Postgres antigo, o n8n pode ignorar DB_POSTGRESDB_*.
unset DATABASE_URL 2>/dev/null || true

echo "n8n bind ${N8N_LISTEN_ADDRESS}:${N8N_PORT} webhook=${WEBHOOK_URL:-unset} db_user=${DB_POSTGRESDB_USER:-unset} db_host=${DB_POSTGRESDB_HOST:-unset}"

exec n8n
