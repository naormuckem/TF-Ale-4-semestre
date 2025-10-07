output "container_id" {
  description = "ID do contêiner Docker."
  value       = docker_container.nginx_server.id
}

output "container_url" {
  description = "URL para acessar o servidor Nginx."
  value       = "http://localhost:${var.external_port}"
}

output "redis_container_id" {
  description = "ID do contêiner Redis."
  value       = docker_container.redis_server.id
}

output "redis_port" {
  description = "Porta externa do Redis."
  value       = var.redis_external_port
}
