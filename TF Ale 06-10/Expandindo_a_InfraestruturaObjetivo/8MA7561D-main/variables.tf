variable "container_name" {
  description = "O nome do contêiner Docker."
  type        = string
  default     = "aula-terraform-nginx"
}

variable "external_port" {
  description = "A porta externa para acessar o servidor Nginx."
  type        = number
  default     = 8080
}

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
