# DevOps Exercise - CI/CD and IaC

Arquivos fornecidos:
- .github/workflows/ci.yml
- Dockerfile
- terraform/docker/*
- terraform/aws/*

## Uso rápido

### CI
O workflow `.github/workflows/ci.yml` é acionado em `push` para a branch `main` e em `pull_request` para `main`. Ele faz checkout, usa Node.js 18, cria um serviço Postgres (postgres:13), instala dependências, roda lint e testes.

### Docker local via Terraform
1. Instale Docker e Terraform.
2. Vá para `terraform/docker/`.
3. `terraform init && terraform apply`
4. A API ficará disponível em `http://localhost:3000` por padrão.

### AWS EC2 via Terraform (opção simples)
1. Configure AWS credentials.
2. Forneça `repo_url` e `ssh_key_name` como variáveis.
3. `terraform init && terraform apply -var "repo_url=https://github.com/SEU/FORK.git" -var "ssh_key_name=SEU_KEYPAIR"`
4. URL final impressa pelo Terraform em `app_url`.

> Observação: não altere arquivos em `src/` conforme exigido no enunciado do exercício.
