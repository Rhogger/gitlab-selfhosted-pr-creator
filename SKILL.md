---
name: gitlab-selfhosted-pr-creator
description: Cria Merge Requests no GitLab self-hosted seguindo um workflow de 4 etapas (Contexto, Mineração, Análise e Publicação). Extrai diffs, resume alterações e usa a CLI glab para abrir o MR.
---

# GitLab Merge Request Creator

Esta skill automatiza a criação de Merge Requests (MRs) de alta qualidade em instâncias self-hosted do GitLab, analisando semântica de commits e código para gerar descrições precisas.

## 🚀 Configuração Rápida (Primeiro uso — executar apenas uma vez)

> **Importante**: Esta skill **NÃO** configura nem valida o `glab`. Ela apenas cria o MR. A configuração é responsabilidade do usuário e deve ser feita **uma única vez**, no primeiro uso, executando o script `scripts/glab_config.sh`.

Se ainda não configurou, siga estes passos:

### 1. Gerar seu Token (PAT)

1. Acesse seu GitLab -> **User Settings** (canto superior direito) -> **Access Tokens**.
2. Clique em **Add new token**.
3. **Scopes obrigatórios**: Marque `api` e `write_repository`.
4. Copie o token gerado (ele não aparecerá novamente).

### 2. Configurar via Script (Recomendado)

Existe um script pronto para facilitar a configuração. Basta editá-lo com seu host e token para então executá-lo:

1. Edite o arquivo: `scripts/glab_config.sh`
2. Execute no terminal:
   ```bash
   ./scripts/glab_config.sh
   ```

---

## ⚙️ Configuração da Skill (Metadados)

Substitua os placeholders abaixo no arquivo `SKILL.md` da sua instalação local para evitar perguntas repetidas:

- **URL da Instância**: `<URL_DO_GITLAB_DA_EMPRESA>` (ex.: `http://[IP]/[DOMINIO]`)
- **Autores (assignees)**: `<USERNAME_1_GITLAB>, <USERNAME_2_GITLAB>` (ex.: `alison, vanessa`)
- **Revisores (reviewers)**: `<REVISOR_1_USERNAME>, <REVISOR_2_USERNAME>` (ex.: `alison, vanessa`)
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
- **CLI**: Use `glab mr create` para abrir o MR. Assuma que o `glab` já está instalado e autenticado — **não execute** comandos de validação (`glab auth status`, `glab --version`, `which glab`, etc.) antes de criar o MR.
- **Falha de autenticação**: Se o `glab mr create` retornar erro de host não cadastrado, token inválido/expirado ou similar, **PARE** e oriente o usuário a executar o script `scripts/glab_config.sh` (seção "🚀 Configuração Rápida"). Não tente reconfigurar o `glab` por conta própria.
- **RESTRIÇÃO**: NÃO faça `git commit`, `git push` ou crie arquivos de mensagem físicos. O MR deve ser aberto diretamente via CLI.

## Comandos Úteis

- Verificação de branch: `git branch --show-current`
- Log de commits: `git log origin/main..HEAD --format="%H"`
- Criar MR: `glab mr create --title "[BRANCH-NAME] TIPO: Impacto principal" --description "Conteúdo" --assignee "seu-user" --reviewer "username"`
