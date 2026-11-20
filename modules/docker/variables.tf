variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_host" {
  type = string
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
