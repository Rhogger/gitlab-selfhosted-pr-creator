#!/bin/bash

# =================================================================
# Script de Configuração Rápida do GLAB (GitLab CLI)
# =================================================================

# 1. Defina o Host (IP e Porta) do seu GitLab
HOST="<IP:PORT>"

# 2. Cole seu Personal Access Token (PAT) abaixo
TOKEN="<COLE_SEU_TOKEN_AQUI>"

# 3. Protocolo da API (http, https ou ssh)
PROTOCOL="http"

# Verificação básica
if [ "$TOKEN" == "<COLE_SEU_TOKEN_AQUI>" ] || [ -z "$TOKEN" ]; then
    echo "❌ ERRO: Você precisa editar este arquivo e inserir seu TOKEN."
    exit 1
fi

echo "🚀 Configurando glab para $HOST ($PROTOCOL)..."

glab config set -h "$HOST" api_protocol "$PROTOCOL" && \
glab config set -h "$HOST" token "$TOKEN" && \
glab auth status --hostname "$HOST"

if [ $? -eq 0 ]; then
    echo "✅ Configuração concluída com sucesso!"
else
    echo "❌ Falha na configuração. Verifique seu Host e Token."
fi
