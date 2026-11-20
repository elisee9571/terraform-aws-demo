# === TP NGINX ===
# data "docker_registry_image" "nginx" {
#   name = "elisee9571/demo-nginx-terraform:1.0"
# }

# === TP FINAL ===
data "docker_registry_image" "mysql" {
  name = "mysql:8.0"
}

data "docker_registry_image" "wordpress" {
  name = "wordpress:latest"
}
