# latest (2.x) estoura os 512 MB do plano free da Render (task runners sempre ligados).
FROM n8nio/n8n:1.107.4

USER root
COPY docker-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
USER node

ENV TZ=America/Sao_Paulo \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    N8N_LISTEN_ADDRESS=0.0.0.0

EXPOSE 5678

ENTRYPOINT ["tini", "--", "/custom-entrypoint.sh"]
