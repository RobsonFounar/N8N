#!/bin/sh
set -eu

# Render roteia para PORT. No n8n isso é N8N_PORT.
# Com EXPOSE 5678 + PORT=5678 no Blueprint, os dois ficam iguais.
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

echo "n8n bind ${N8N_LISTEN_ADDRESS}:${N8N_PORT} webhook=${WEBHOOK_URL:-unset}"

exec n8n
