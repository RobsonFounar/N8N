#!/bin/sh
set -eu

# Render injeta PORT. O n8n escuta em N8N_PORT.
export N8N_LISTEN_ADDRESS="${N8N_LISTEN_ADDRESS:-0.0.0.0}"
export N8N_PORT="${PORT:-${N8N_PORT:-5678}}"

export TZ="${TZ:-America/Sao_Paulo}"
export GENERIC_TIMEZONE="${GENERIC_TIMEZONE:-America/Sao_Paulo}"

# URL pública do serviço no Render (https://<servico>.onrender.com)
if [ -n "${RENDER_EXTERNAL_URL:-}" ]; then
  base="${RENDER_EXTERNAL_URL%/}"
  export WEBHOOK_URL="${WEBHOOK_URL:-${base}/}"
  export N8N_EDITOR_BASE_URL="${N8N_EDITOR_BASE_URL:-${base}/}"
  export N8N_PROTOCOL="${N8N_PROTOCOL:-https}"

  host="${base#https://}"
  host="${host#http://}"
  export N8N_HOST="${N8N_HOST:-$host}"
fi

# Proxy TLS do Render: um hop na frente do n8n.
export N8N_PROXY_HOPS="${N8N_PROXY_HOPS:-1}"

exec n8n
