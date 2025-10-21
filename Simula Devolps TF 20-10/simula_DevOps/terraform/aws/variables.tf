variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_key_name" {
  description = "Nome do key pair existente na AWS para acessar a EC2"
  type = string
}

variable "repo_url" {
  description = "URL do seu fork (git) contendo a aplicacao. Ex: https://github.com/usuario/repo.git"
  type = string
}

variable "app_port" {
  type = number
  default = 3000
}
