terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "devops_app_sg"
  description = "Allow SSH and app port"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y curl gnupg build-essential
              curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
              apt-get install -y nodejs git postgresql postgresql-contrib

              sudo -u postgres psql <<SQL
              CREATE USER devops WITH PASSWORD 'devops_pass';
              CREATE DATABASE devops_db;
              GRANT ALL PRIVILEGES ON DATABASE devops_db TO devops;
              ALTER ROLE devops SET client_encoding TO 'utf8';
              ALTER ROLE devops SET default_transaction_isolation TO 'read committed';
              ALTER ROLE devops SET timezone TO 'UTC';
              SQL

              cd /opt
              git clone ${var.repo_url} app || exit 1
              cd app
              npm ci
              sudo -u postgres psql -d devops_db -f src/database/schema.sql || true

              npm install -g pm2
              pm2 start npm --name "devops_api" -- start
              pm2 save

              EOF

  tags = {
    Name = "devops-api-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.app.public_ip
}

output "app_url" {
  value = "http://${aws_instance.app.public_ip}:${var.app_port}"
}
