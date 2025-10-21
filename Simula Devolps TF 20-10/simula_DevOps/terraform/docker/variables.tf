variable "pg_user" {
  type    = string
  default = "devops"
}
variable "pg_password" {
  type    = string
  default = "devops_pass"
}
variable "pg_db" {
  type    = string
  default = "devops_db"
}
variable "postgres_port" {
  type    = number
  default = 5432
}
variable "api_port" {
  type    = number
  default = 3000
}
