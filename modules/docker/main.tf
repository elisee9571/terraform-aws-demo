provider "docker" {
  host = "ssh://${var.ssh_user}@${var.ssh_host}"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "${path.cwd}/keys/authorized_key",
  ]
}

# === TP NGINX ===

# resource "docker_image" "nginx" {
#   name          = data.docker_registry_image.nginx.name
#   pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
# }

# resource "docker_container" "nginx" {
#   name  = "nginx"
#   image = docker_image.nginx.image_id

#   ports {
#     internal = 80
#     external = 80
#   }
# }

# === TP FINAL ===

resource "docker_network" "wordpress" {
  name = "wordpress_network"
}

resource "docker_volume" "mysql" {
  name = "mysql_data"
}

resource "docker_volume" "wordpress" {
  name = "wordpress_data"
}

resource "docker_image" "mysql" {
  name          = data.docker_registry_image.mysql.name
  pull_triggers = [data.docker_registry_image.mysql.sha256_digest]
}

resource "docker_image" "wordpress" {
  name          = data.docker_registry_image.wordpress.name
  pull_triggers = [data.docker_registry_image.wordpress.sha256_digest]
}

resource "docker_container" "mysql" {
  name    = "db_wordpress"
  image   = docker_image.mysql.image_id
  restart = "always"

  # Le port 3306 est deja EXPOSE dans l'image et reste accessible via le reseau Docker

  env = [
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}",
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}"
  ]

  networks_advanced {
    name = docker_network.wordpress.name
  }

  volumes {
    volume_name    = docker_volume.mysql.name
    container_path = "/var/lib/mysql"
  }
}

resource "docker_container" "wordpress" {
  name       = "wordpress"
  image      = docker_image.wordpress.image_id
  restart    = "always"
  depends_on = [docker_container.mysql]

  env = [
    "WORDPRESS_DB_HOST=${docker_container.mysql.name}",
    "WORDPRESS_DB_NAME=${var.db_name}",
    "WORDPRESS_DB_USER=${var.db_user}",
    "WORDPRESS_DB_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = docker_network.wordpress.name
  }

  volumes {
    volume_name    = docker_volume.wordpress.name
    container_path = "/var/www/html"
  }
}
