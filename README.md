# n8n no Render

Servidor **n8n self-hosted** neste repositório (`RobsonFounar/N8N`). Só n8n: Docker + Postgres no Render. Não misture com o site itatiba-casas nem com outros apps.

## Limites do plano free (importante)

O Blueprint sobe no **plano free**. Isso tem restrições reais:

- **Web service free dorme** após 15 minutos sem tráfego. A próxima request acorda o n8n com cold start (webhooks e crons falham enquanto estiver dormindo).
- **Postgres grátis expira em 30 dias.** Depois disso o banco some. Faça upgrade se for usar de verdade.
- Cada workspace Render tem **no máximo um Postgres free**.
- O n8n pode ficar apertado em 512 MB. A Render recomenda o plano `1c-2g` (ou maior) para o web service quando sair do teste.

## Deploy (Blueprint)

O MCP do Render **não está autenticado** neste ambiente, então o Apply precisa ser feito no Dashboard:

1. Faça login em [Render](https://dashboard.render.com/).
2. Abra o Blueprint deste repo:

   **[Aplicar Blueprint](https://dashboard.render.com/blueprint/new?repo=https://github.com/RobsonFounar/N8N)**

3. Conecte o GitHub se ainda não estiver conectado.
4. Confira o branch (use `main` depois do merge, ou o branch desta PR).
5. Clique em **Apply** / **Deploy Blueprint**.

Atalho equivalente: [render.com/deploy](https://render.com/deploy?repo=https://github.com/RobsonFounar/N8N).

## O que o Blueprint cria

| Recurso | Nome | Plano |
| --- | --- | --- |
| Web service (Docker `n8nio/n8n`) | `n8n` | free |
| Postgres | `n8n-db` | free (expira em 30 dias) |

O entrypoint liga o n8n em `0.0.0.0:$PORT` (porta injetada pelo Render) e define `WEBHOOK_URL` a partir de `RENDER_EXTERNAL_URL`. Timezone: `America/Sao_Paulo`. `N8N_ENCRYPTION_KEY` é gerada pelo Render (`generateValue`) e **não deve ser alterada** depois do primeiro deploy.

## Primeiro acesso

1. Abra a URL `https://<servico>.onrender.com` do web service.
2. Crie a conta owner do n8n no wizard inicial.
3. Confira Settings → n8n URL / webhooks (deve refletir o domínio `onrender.com`).

## Arquivos

- `Dockerfile` — imagem oficial `n8nio/n8n`
- `docker-entrypoint.sh` — bind `0.0.0.0:$PORT` + `WEBHOOK_URL`
- `render.yaml` — web service + Postgres

## Depois do teste

No `render.yaml`, troque `plan: free` por um plano pago (web: `1c-2g` ou maior; Postgres: `basic-256mb` ou maior) e faça um novo sync do Blueprint **antes** dos 30 dias do banco grátis.
