#!/bin/bash

# =================================================================
# Script de Configuração Rápida do GLAB (GitLab CLI)
# =================================================================

# 1. Defina o Hostname/IP do seu GitLab (SEM porta e SEM http://).
#    Importante: o glab faz match do hostname com `git remote -v` sem considerar a porta,
#    então a chave de config precisa ser SOMENTE o hostname/IP.
HOST="<IP_OU_DOMINIO>"

# 2. Defina a porta da sua instância GitLab (deixe vazio "" se for porta padrão 80/443)
PORT="<PORTA>"

# 3. Cole seu Personal Access Token (PAT) abaixo
TOKEN="<COLE_SEU_TOKEN_AQUI>"

# 4. Protocolo da API (http ou https)
PROTOCOL="http"

# Verificação básica
if [ -z "$TOKEN" ]; then
    echo "❌ ERRO: Você precisa editar este arquivo e inserir seu TOKEN."
    exit 1
fi

if [ -n "$PORT" ]; then
    API_HOST="$HOST:$PORT"
else
    API_HOST="$HOST"
fi

echo "🚀 Configurando glab para $HOST (API em $API_HOST via $PROTOCOL)..."

glab config set -h "$HOST" api_protocol "$PROTOCOL" && \
glab config set -h "$HOST" api_host "$API_HOST" && \
glab config set -h "$HOST" token "$TOKEN" && \
glab auth status --hostname "$HOST"

if [ $? -eq 0 ]; then
    echo "✅ Configuração concluída com sucesso!"
else
    echo "❌ Falha na configuração. Verifique seu Host e Token."
fi
