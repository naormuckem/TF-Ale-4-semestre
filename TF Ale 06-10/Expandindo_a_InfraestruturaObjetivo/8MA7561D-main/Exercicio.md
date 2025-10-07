# Exercício Prático: Expandindo a Infraestrutura

## Objetivo

O objetivo deste exercício é aplicar os conceitos da aula para expandir nossa infraestrutura como código. Você deverá adicionar um novo serviço ao nosso projeto: um contêiner com um banco de dados **Redis**.

Redis é um banco de dados em memória muito rápido, comumente usado para cache ou filas.

## Requisitos

Para concluir o exercício, você deverá realizar as seguintes alterações nos arquivos de configuração do Terraform:

1.  **Em `variables.tf`**:
    *   Adicione uma nova variável chamada `redis_container_name` com o valor padrão `"aula-terraform-redis"`.
    *   Adicione uma nova variável chamada `redis_external_port` com o valor padrão `6379`.

2.  **Em `main.tf`**:
    *   Adicione um novo recurso do tipo `docker_container` chamado `redis_server`.
    *   Este recurso deve usar a imagem oficial do Redis direto do Docker Hub. A imagem é `redis:alpine` (não é necessário criar um recurso `docker_image` desta vez).
    *   Configure o nome do contêiner e as portas para usar as novas variáveis que você criou no passo anterior.

3.  **Em `outputs.tf`**:
    *   Adicione uma nova saída chamada `redis_container_id` que mostra a ID do contêiner Redis.
    *   Adicione uma nova saída chamada `redis_port` que mostra a porta externa mapeada para o Redis.

## Passos para Realização

1.  Modifique os três arquivos (`variables.tf`, `main.tf`, `outputs.tf`) conforme os requisitos.
2.  Rode `terraform plan`. O plano deve indicar **1 recurso a ser adicionado** (o contêiner Redis) e **2 saídas a serem adicionadas**.
3.  Rode `terraform apply` para criar o novo contêiner.
4.  Verifique se o contêiner Nginx continua funcionando no navegador e se o contêiner Redis está em execução (você pode usar o comando `docker ps` no seu terminal para listar os contêineres ativos).
5.  Ao final, rode `terraform destroy` para remover toda a infraestrutura (ambos os contêineres).

---

<details>
<summary>Clique aqui para ver a solução</summary>

#### Solução para `variables.tf`

```terraform
variable "redis_container_name" {
  description = "O nome do contêiner Docker para o Redis."
  type        = string
  default     = "aula-terraform-redis"
}

variable "redis_external_port" {
  description = "A porta externa para acessar o Redis."
  type        = number
  default     = 6379
}
```

#### Solução para `main.tf` (adicionar ao final do arquivo)

```terraform
resource "docker_container" "redis_server" {
  image = "redis:alpine"
  name  = var.redis_container_name
  ports {
    internal = 6379
    external = var.redis_external_port
  }
}
```

#### Solução para `outputs.tf`

```terraform
output "redis_container_id" {
  description = "ID do contêiner Redis."
  value       = docker_container.redis_server.id
}

output "redis_port" {
  description = "Porta externa do Redis."
  value       = var.redis_external_port
}
```

</details>
