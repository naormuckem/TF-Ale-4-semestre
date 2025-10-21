terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.19"
    }
  }
  required_version = ">= 1.0.0"
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "devops_app_network"
}

resource "docker_volume" "pgdata" {
  name = "devops_pgdata"
}

resource "docker_image" "api_image" {
  name = "devops_node_api:local"
  build {
    context    = "${path.module}/../../"
    dockerfile = "${path.module}/../../Dockerfile"
  }
}

resource "docker_container" "postgres" {
  name  = "devops_postgres"
  image = "postgres:13"
  env = [
    "POSTGRES_USER=${var.pg_user}",
    "POSTGRES_PASSWORD=${var.pg_password}",
    "POSTGRES_DB=${var.pg_db}"
  ]

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 5432
    external = var.postgres_port
  }

  restart = "unless-stopped"
}

resource "docker_container" "api" {
  name  = "devops_node_api"
  image = docker_image.api_image.name
  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "DB_HOST=${docker_container.postgres.name}",
    "DB_PORT=5432",
    "DB_USER=${var.pg_user}",
    "DB_PASSWORD=${var.pg_password}",
    "DB_NAME=${var.pg_db}",
    "NODE_ENV=production"
  ]

  ports {
    internal = 3000
    external = var.api_port
  }

  depends_on = [
    docker_container.postgres,
    docker_image.api_image
  ]

  restart = "unless-stopped"
}
