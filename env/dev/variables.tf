variable "project_name" {
  type    = string
  default = "demo-wordpress"
}

# === TP FINAL ==
variable "db_name" {
  type    = string
  default = "wordpress"
}

variable "db_user" {
  type    = string
  default = "wordpress"
}

variable "db_password" {
  type      = string
  default   = "password"
  sensitive = true
}

variable "db_root_password" {
  type      = string
  default   = "root_password"
  sensitive = true
}
