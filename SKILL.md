---
name: gitlab-selfhosted-pr-creator
description: Cria Merge Requests no GitLab self-hosted seguindo um workflow de 4 etapas (Contexto, Mineração, Análise e Publicação). Extrai diffs, resume alterações e usa a CLI glab para abrir o MR.
---

# GitLab Merge Request Creator

Esta skill automatiza a criação de Merge Requests (MRs) de alta qualidade em instâncias self-hosted do GitLab, analisando semântica de commits e código para gerar descrições precisas.

## Configuração (preencher antes de usar)

Substitua os placeholders abaixo pelos seus dados para evitar perguntas repetidas. Certifique-se de que a CLI `glab` está instalada e autenticada (`glab auth login`).

- **URL da Instância**: `<URL_DO_GITLAB_DA_EMPRESA>` (ex.: `https://gitlab.empresa.com.br` ou `http://192.168.1.50`)
- **Autor (assignee)**: `<SEU_USERNAME_GITLAB>`
- **Revisores**: `<REVISOR_1_USERNAME>, <REVISOR_2_USERNAME>` (ex.: `alison, vanessa`)
- **Branches bloqueadas**: `main`, `master`, `dev`, `hml`
- **Branch base padrão**: `<BRANCH_BASE>` (ex.: `main`)

## Workflow de Automação

### 1. Orquestração de Contexto (Context Manager)
Antes de qualquer análise, identifique os metadados:
- **Usuário**: Obtenha o autor atual via `git config user.name`.
- **Branch**: Se não informada, use `git branch --show-current`.
- **Bloqueio**: Se a branch for `main`, `master`, `dev` ou `hml`, pare e informe que MRs não devem ser gerados diretamente nestas branches.
- **Commits**: Obtenha as hashes exclusivas da branch atual em relação à base (ex: `main`).
- **Revisor**: Se não informado pelo usuário, você **DEVE** perguntar quem será o revisor.

### 2. Mineração de Dados (Git Ops Specialist)
Para cada hash identificada:
- Extraia a mensagem do commit (`git show -s --format=%B`).
- Obtenha o diff das alterações.
- Identifique arquivos modificados, focando no que mudou (ignore binários ou arquivos excessivamente grandes, trazendo apenas o diff nesses casos).

### 3. Análise e Decisão (Software Architect)
Digerir os dados para definir a estratégia:
- **Tipo de MR**: Decida entre `FEATURE`, `BUGFIX`, `REFACTOR`, `HOTFIX`, `TESTS`, `SECURITY`, `BUILD`, `CHORE`, `DOCS`, `PERF` ou `WIP`.
- **Sumarização**: Cruze mensagens de commit com o código para entender o "Porquê". Gere um resumo técnico em tópicos.
- **Título**: O título do MR **DEVE** seguir rigorosamente o padrão: `[NOME-DA-BRANCH] TIPO: Impacto principal`.
- **Testes**: Infira passos de teste lógicos baseados na alteração realizada.

### 4. Publicação (Technical Writer)
Gere o conteúdo final e execute:
- **Template**: Busque o template correspondente em `references/` relativo à raiz desta skill.
- **CLI**: Use `glab mr create` para abrir o MR.
- **RESTRIÇÃO**: NÃO faça `git commit`, `git push` ou crie arquivos de mensagem físicos. O MR deve ser aberto diretamente via CLI.

## Comandos Úteis
- Verificação de branch: `git branch --show-current`
- Log de commits: `git log origin/main..HEAD --format="%H"`
- Criar MR: `glab mr create --title "[BRANCH-NAME] TIPO: Impacto principal" --description "Conteúdo" --assignee "seu-user" --reviewer "username"`
